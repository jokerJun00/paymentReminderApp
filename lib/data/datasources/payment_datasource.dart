import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/bank_model.dart';
import '../models/category_model.dart';
import '../models/payment_model.dart';

abstract class PaymentDataSource {
  /// get all payments of the user and display in payment screen
  /// return [List<PaymentModel>>]
  /// get all payments that associate with userId
  Future<List<PaymentModel>> getAllPaymentsFromDataSource();

  Future<Map<String, List<PaymentModel>>> getGroupedPaymentsFromDataSource();

  Future<List<PaymentModel>> getUpcomingPaymentsFromDataSource();

  Future<List<CategoryModel>> getAllCategoriesFromDataSource();

  /// add a new payments
  /// return [List<PaymentModel>>]
  /// add a new payment into Firestore 'Payments' collection
  Future<void> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiver);

  /// edit payments
  /// return [List<PaymentModel>>]
  /// edit the selected payment information into Firestore 'Payments' collection
  Future<void> editPaymentFromDataSource(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo);

  Future<void> deletePaymentFromDataSource(PaymentModel payment);

  Future<void> addCategory(String categoryName);

  Future<List<BankModel>> getBankList();

  Future<List<CategoryModel>> getCategoryList();

  Future<ReceiverModel> getReceiver(String receiverId);

  Future<void> markPaymentAsPaidFromDataSource(PaymentModel payment);

  Future<List<PaidPaymentModel>> getPaidPaymentListFromDataSource(
      DateTime date);

  Future<Map<int, double>> getMonthlyPaidAmountFromSource();

  Future<Map<String, double>> getMonthlySummaryGroupByCategoryFromDatasource(
      DateTime date);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  PaymentDataSourceImpl({required this.firebaseAuth, required this.firestore});
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<void> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiverInfo) async {
    final user_id = firebaseAuth.currentUser!.uid;

    receiverInfo.user_id = user_id;
    newPayment.user_id = user_id;

    // check if the receiver already created
    final receiverData = await firestore
        .collection('Receivers')
        .where('user_id', isEqualTo: user_id)
        .where('name', isEqualTo: receiverInfo.name)
        .where('bank_account_no', isEqualTo: receiverInfo.bank_account_no)
        .get()
        .catchError((_) => throw ServerException());

    // if there is same receiver in database
    if (receiverData.size > 0) {
      ReceiverModel receiver =
          ReceiverModel.fromFirestore(receiverData.docs.first);
      newPayment.receiver_id = receiver.id;
    } else {
      // store new receiver data into database and set new payment receiver_id
      await firestore
          .collection('Receivers')
          .add(receiverInfo.toJson())
          .then((DocumentReference doc) => newPayment.receiver_id = doc.id)
          .catchError((e) => throw ServerException());
    }

    // store new payment to Firestore
    await firestore
        .collection('Payments')
        .add(newPayment.toJson())
        .then((value) {
      newPayment.id = value.id;
    }).catchError((_) => throw ServerException());

    showAddNewPaymentNotification(newPayment);
    setPaymentReminder(newPayment);
  }

  @override
  Future<void> deletePaymentFromDataSource(PaymentModel payment) async {
    print("Operating database, received payment info : $payment");
    // delete payment from Firestore
    await firestore
        .collection('Payments')
        .doc(payment.id.trim())
        .delete()
        .catchError((_) => throw ServerException());

    final paymentsWithSameReceiverId = await firestore
        .collection('Payments')
        .where('receiver_id', isEqualTo: payment.receiver_id.trim())
        .get()
        .catchError((_) => throw ServerException());

    // if receiver is not in use, delete receiver
    if (paymentsWithSameReceiverId.size == 0) {
      await firestore
          .collection('Receivers')
          .doc(payment.receiver_id.trim())
          .delete()
          .catchError((_) => throw ServerException());
    }
  }

  @override
  Future<void> editPaymentFromDataSource(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) async {
    final receiverInfoData = await firestore
        .collection('Receivers')
        .doc(editedReceiverInfo.id)
        .get()
        .catchError((_) => throw ServerException());

    if (receiverInfoData.data() == null) {
      throw ServerException();
    }

    ReceiverModel receiverInfoInDatabase =
        ReceiverModel.fromFirestore(receiverInfoData);

    // check if receiver info has any changes
    if (receiverInfoInDatabase.name != editedReceiverInfo.name ||
        receiverInfoInDatabase.bank_id != editedReceiverInfo.bank_id ||
        receiverInfoInDatabase.bank_account_no !=
            editedReceiverInfo.bank_account_no) {
      await firestore
          .collection('Receivers')
          .doc(editedPaymentInfo.id)
          .set(editedReceiverInfo.toJson())
          .catchError((_) => throw ServerException());
    }

    await firestore
        .collection('Payments')
        .doc(editedPaymentInfo.id)
        .set(editedPaymentInfo.toJson())
        .catchError((_) => throw ServerException());

    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    showAddNewPaymentNotification(editedPaymentInfo);
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    for (var _pendingRequest in pendingNotificationRequests) {
      // _flutterLocalNotificationsPlugin.cancel(_pendingRequest.id);
      print("Body: ${_pendingRequest.body}");
      print("Body: ${_pendingRequest.title}");
      print("Body: ${_pendingRequest.payload}");
      print("Body: ${_pendingRequest.id}");
    }
    setPaymentReminder(editedPaymentInfo);
  }

  @override
  Future<List<PaymentModel>> getAllPaymentsFromDataSource() async {
    final user_id = firebaseAuth.currentUser!.uid;

    List<PaymentModel> paymentList = [];

    final paymentsData = await firestore
        .collection('Payments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    paymentsData.docs.forEach((data) {
      PaymentModel payment = PaymentModel.fromFirestore(data);
      paymentList.add(payment);
    });

    return paymentList;
  }

  @override
  Future<List<CategoryModel>> getAllCategoriesFromDataSource() async {
    final user_id = firebaseAuth.currentUser!.uid;
    List<CategoryModel> categoryList = [];

    // get all default category
    final defaultCategoriesData = await firestore
        .collection('Categories')
        .where('user_id', isEqualTo: "")
        .get()
        .catchError((_) => throw ServerException());

    defaultCategoriesData.docs.forEach((data) {
      CategoryModel category = CategoryModel.fromFirestore(data);
      categoryList.add(category);
    });

    // get all user setting category
    final userCategoriesData = await firestore
        .collection('Categories')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    userCategoriesData.docs.forEach((data) {
      CategoryModel category = CategoryModel.fromFirestore(data);
      categoryList.add(category);
    });

    return categoryList;
  }

  @override
  Future<void> addCategory(String categoryName) async {
    final user_id = firebaseAuth.currentUser!.uid;

    final newCategoryData = {
      'name': categoryName,
      'user_id': user_id,
    };

    await firestore
        .collection('Categories')
        .add(newCategoryData)
        .catchError((e) => throw ServerException());
  }

  @override
  Future<List<BankModel>> getBankList() async {
    List<BankModel> bankList = [];
    final bankListData = await firestore
        .collection('Banks')
        .get()
        .catchError((_) => throw ServerException());

    bankListData.docs.forEach((data) {
      BankModel category = BankModel.fromFirestore(data);
      bankList.add(category);
    });

    return bankList;
  }

  @override
  Future<List<CategoryModel>> getCategoryList() async {
    final user_id = firebaseAuth.currentUser!.uid;
    List<CategoryModel> categoryList = [];

    // get all default category
    final defaultCategoriesData = await firestore
        .collection('Categories')
        .where('user_id', isEqualTo: "")
        .get()
        .catchError((_) => throw ServerException());

    defaultCategoriesData.docs.forEach((data) {
      CategoryModel category = CategoryModel.fromFirestore(data);
      categoryList.add(category);
    });

    // get all user setting category
    final userCategoriesData = await firestore
        .collection('Categories')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    userCategoriesData.docs.forEach((data) {
      CategoryModel category = CategoryModel.fromFirestore(data);
      categoryList.add(category);
    });

    return categoryList;
  }

  @override
  Future<ReceiverModel> getReceiver(String receiverId) async {
    final receiverData = await firestore
        .collection('Receivers')
        .doc(receiverId.trim())
        .get()
        .catchError((_) => throw ServerException());

    if (receiverData.data() != null) {
      ReceiverModel receiver = ReceiverModel.fromFirestore(receiverData);
      return receiver;
    }

    throw ServerException;
  }

  @override
  Future<List<PaymentModel>> getUpcomingPaymentsFromDataSource() async {
    final user_id = firebaseAuth.currentUser!.uid;
    List<PaymentModel> upcomingPaymentList = [];
    List<PaidPaymentModel> paidPaymentList =
        await getPaidPaymentListFromDataSource(DateTime.now());

    final upcomingPaymentData = await firestore
        .collection('Payments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    upcomingPaymentData.docs.forEach((data) {
      PaymentModel payment = PaymentModel.fromFirestore(data);

      final currentDate = DateTime.now();
      final paymentDate = payment.payment_date;
      final difference = paymentDate.difference(currentDate).inDays;

      if (difference >= 0) {
        DateTime? upcomingPaymentDate;

        if (difference <= 7) {
          upcomingPaymentDate = paymentDate;
        } else if (payment.billing_cycle == 'weekly' && difference <= 14) {
          upcomingPaymentDate = paymentDate.add(const Duration(days: 7));
        } else if (payment.billing_cycle == 'monthly' &&
            currentDate.day <= paymentDate.day &&
            difference <= 30) {
          final nextMonth =
              currentDate.month + 1 <= 12 ? currentDate.month + 1 : 1;
          final nextYear =
              nextMonth == 1 ? currentDate.year + 1 : currentDate.year;
          upcomingPaymentDate = DateTime(nextYear, nextMonth, paymentDate.day);
        } else if (payment.billing_cycle == 'yearly' &&
            currentDate.month <= paymentDate.month &&
            currentDate.day <= paymentDate.day &&
            difference <= 365) {
          upcomingPaymentDate = DateTime(
              currentDate.year + 1, paymentDate.month, paymentDate.day);
        }

        if (upcomingPaymentDate != null) {
          payment.payment_date = upcomingPaymentDate;

          // check if the payment already paid, if not paid then only add into list
          final paid = paidPaymentList.firstWhereOrNull((paidPayment) =>
              paidPayment.payment_name == payment.name &&
              payment.payment_date.difference(paidPayment.date).inDays < 7);

          if (paid == null) {
            upcomingPaymentList.add(payment);
          }
        }
      }
    });

    return upcomingPaymentList;
  }

  void showAddNewPaymentNotification(PaymentModel payment) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '1',
      "Set Payment Reminder",
      channelDescription: 'A new reminder has set to this account',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    int notification_id = 1;
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      notification_id,
      "${payment.name} reminder has set",
      "A reminder will be sent ${payment.notification_period} days before the due date",
      notificationDetails,
      payload: 'Not present',
    );
  }

  void setPaymentReminder(PaymentModel payment) async {
    final notificationDate = payment.payment_date
        .subtract(Duration(days: payment.notification_period));

    if (payment.billing_cycle == 'weekly') {
      _scheduleNotification(
        notificationDate,
        DateTimeComponents.dayOfWeekAndTime,
      );
    } else if (payment.billing_cycle == 'monthly') {
      _scheduleNotification(
        notificationDate,
        DateTimeComponents.dayOfMonthAndTime,
      );
    } else if (payment.billing_cycle == 'yearly') {
      _scheduleNotification(
        notificationDate,
        DateTimeComponents.dateAndTime,
      );
    }
  }

  Future<void> _scheduleNotification(
      DateTime notificationDate, DateTimeComponents cycle) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '2',
      'Payment Reminder',
      channelDescription: 'Payment Reminder Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Payment Reminder',
      'Your payment is due soon.',
      tz.TZDateTime.from(notificationDate, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: cycle,
    );
  }

  @override
  Future<void> markPaymentAsPaidFromDataSource(PaymentModel payment) async {
    final user_id = firebaseAuth.currentUser!.uid;
    ReceiverModel receiver = await getReceiver(payment.receiver_id);

    PaidPaymentModel paidPaymentRecord = PaidPaymentModel(
      id: "",
      date: DateTime.now(),
      amount_paid: payment.expected_amount,
      payment_name: payment.name,
      receiver_name: receiver.name,
      user_id: user_id,
      payment_id: payment.id,
      category_id: payment.category_id,
    );

    await firestore
        .collection('PaidPayments')
        .add(paidPaymentRecord.toJson())
        .catchError((_) => throw ServerException());
  }

  @override
  Future<List<PaidPaymentModel>> getPaidPaymentListFromDataSource(
      DateTime date) async {
    final user_id = firebaseAuth.currentUser!.uid;

    List<PaidPaymentModel> paidPaymentList = [];

    final paidPaymentListData = await firestore
        .collection('PaidPayments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    paidPaymentListData.docs.forEach((data) {
      PaidPaymentModel paidPayment = PaidPaymentModel.fromFirestore(data);
      if (paidPayment.date.month == date.month) {
        paidPaymentList.add(paidPayment);
      }
    });

    return paidPaymentList;
  }

  @override
  Future<Map<int, double>> getMonthlyPaidAmountFromSource() async {
    final user_id = firebaseAuth.currentUser!.uid;
    List<PaidPaymentModel> paidPaymentList = [];
    Map<int, double> monthlySummary = {};

    final paidPaymentListData = await firestore
        .collection('PaidPayments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    paidPaymentListData.docs.forEach((data) {
      PaidPaymentModel paidPayment = PaidPaymentModel.fromFirestore(data);
      paidPaymentList.add(paidPayment);
    });

    // database has record
    if (paidPaymentList.isNotEmpty) {
      // sort records by latest date to oldest date (descending order)
      paidPaymentList.sort((a, b) => b.date.compareTo(a.date));

      // group records into years of records
      var yearGroupPaidPaymentList = groupBy(
        paidPaymentList,
        (PaidPaymentModel paidPayment) => paidPayment.date.year,
      );

      List<int> yearKeyList = yearGroupPaidPaymentList.keys.toList();
      // loop through each year
      for (int i = 0; i < yearGroupPaidPaymentList.length; i++) {
        int currentYear = yearKeyList[i];
        List<PaidPaymentModel>? yearPaidPaymentList =
            yearGroupPaidPaymentList[currentYear];

        // if this year has record
        if (paidPaymentList.isNotEmpty) {
          // group records into months of records
          var groupPaidPaymentList = groupBy(
            yearPaidPaymentList!,
            (PaidPaymentModel paidPayment) => paidPayment.date.month,
          );

          List<int> month = groupPaidPaymentList.keys.toList();
          int index = 0; // to point the current paid payment list
          int currentMonth = month[index];

          // while the loop still in current year and monthlySummary don't have 6 records
          while (currentMonth > 0 && monthlySummary.length < 6) {
            // if still got records
            if (index < month.length) {
              currentMonth = month[index];
            } else {
              currentMonth -= 1;
            }

            double sum = 0;

            // paidPaymentList will be null if the currentMonth is not present in the list
            List<PaidPaymentModel>? paidPaymentList =
                groupPaidPaymentList[currentMonth];

            // if paidPaymentList has records sum up amount paid, else sum = 0
            if (paidPaymentList != null) {
              for (var i = 0; i < paidPaymentList.length; i++) {
                sum += paidPaymentList[i].amount_paid;
              }
            }

            // add sum record to monthly summary
            monthlySummary[currentMonth] = sum;

            // if currentMonth has record move to next index
            if (sum != 0 && index < month.length) {
              index++;
            }
          }
        }

        if (monthlySummary.length >= 6) {
          break;
        }
      }
    } else {
      DateTime currentMonth = DateTime.now();
      while (monthlySummary.length < 6) {
        monthlySummary[currentMonth.month] = 0;

        currentMonth = currentMonth.subtract(const Duration(days: 30));
      }
    }

    return monthlySummary;
  }

  @override
  Future<Map<String, double>> getMonthlySummaryGroupByCategoryFromDatasource(
      DateTime date) async {
    final user_id = firebaseAuth.currentUser!.uid;
    List<PaidPaymentModel> paidPaymentList = [];
    final categoryList = await getCategoryList();
    Map<String, double> categorySummary = {};

    final paidPaymentListData = await firestore
        .collection('PaidPayments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    paidPaymentListData.docs.forEach((data) {
      PaidPaymentModel paidPayment = PaidPaymentModel.fromFirestore(data);
      if (paidPayment.date.month == date.month &&
          paidPayment.date.year == date.year) {
        paidPaymentList.add(paidPayment);
      }
    });

    var groupPaidPaymentList =
        groupBy(paidPaymentList, (PaidPaymentModel paidPayment) {
      CategoryModel? category = categoryList.firstWhereOrNull(
        (category) =>
            category.id.toString().trim() == paidPayment.category_id.trim(),
      );

      if (category != null) {
        return category.name;
      }
    });

    groupPaidPaymentList.forEach((categoryName, paidPaymentList) {
      double sum = 0;
      paidPaymentList.forEach((paidPayment) => sum += paidPayment.amount_paid);
      categorySummary[categoryName!] = sum;
    });

    return categorySummary;
  }

  @override
  Future<Map<String, List<PaymentModel>>>
      getGroupedPaymentsFromDataSource() async {
    final user_id = firebaseAuth.currentUser!.uid;
    final categoryList = await getCategoryList();
    List<PaymentModel> paymentList = [];

    final paymentsData = await firestore
        .collection('Payments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    paymentsData.docs.forEach((data) {
      PaymentModel payment = PaymentModel.fromFirestore(data);
      paymentList.add(payment);
    });

    Map<String, List<PaymentModel>> groupedPaymentList =
        groupBy(paymentList, (PaymentModel payment) {
      CategoryModel? category = categoryList.firstWhereOrNull(
          (category) => category.id.trim() == payment.category_id.trim());

      return category != null ? category.name : "No Category";
    });

    return groupedPaymentList;
  }
}
