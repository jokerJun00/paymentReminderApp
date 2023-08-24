import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';

import '../models/bank_model.dart';
import '../models/category_model.dart';
import '../models/payment_model.dart';

abstract class PaymentDataSource {
  /// get all payments of the user and display in payment screen
  /// return [List<PaymentModel>>]
  /// get all payments that associate with userId
  Future<List<PaymentModel>> getAllPaymentsFromDataSource();

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
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiverInfo) async {
    final user_id = await _firebaseAuth.currentUser!.uid;

    receiverInfo.user_id = user_id;
    newPayment.user_id = user_id;

    // check if the receiver already created
    final receiverData = await _firestore
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
      await _firestore
          .collection('Receivers')
          .add(receiverInfo.toJson())
          .then((DocumentReference doc) => newPayment.receiver_id = doc.id)
          .catchError((e) => throw ServerException());
    }

    // store new payment to Firestore
    await _firestore
        .collection('Payments')
        .add(newPayment.toJson())
        .catchError((_) => throw ServerException());
  }

  @override
  Future<void> deletePaymentFromDataSource(PaymentModel payment) async {
    print("Operating database, received payment info : $payment");
    // delete payment from Firestore
    await _firestore
        .collection('Payments')
        .doc(payment.id.trim())
        .delete()
        .catchError((_) => throw ServerException());

    final paymentsWithSameReceiverId = await _firestore
        .collection('Payments')
        .where('receiver_id', isEqualTo: payment.receiver_id.trim())
        .get()
        .catchError((_) => throw ServerException());

    // if receiver is not in use, delete receiver
    if (paymentsWithSameReceiverId.size == 0) {
      await _firestore
          .collection('Receivers')
          .doc(payment.receiver_id.trim())
          .delete()
          .catchError((_) => throw ServerException());
    }
  }

  @override
  Future<void> editPaymentFromDataSource(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) async {
    // check if receiver info updated
    final receiverInfoInDatabase = await _firestore
        .collection('Receivers')
        .doc(editedPaymentInfo.id.trim())
        .get()
        .then((value) => ReceiverModel.fromFirestore(value))
        .catchError((_) => throw ServerException());

    print("Testing testing 321");

    // if (receiverInfoInDatabase.name != editedReceiverInfo.name ||
    //     receiverInfoInDatabase.bank_id != editedReceiverInfo.bank_id ||
    //     receiverInfoInDatabase.bank_account_no !=
    //         editedReceiverInfo.bank_account_no ||
    //     receiverInfoInDatabase.user_id != editedReceiverInfo.user_id) {
    //   print("Both are different");
    //   await _firestore
    //       .collection('Receivers')
    //       .doc(editedPaymentInfo.id.trim())
    //       .set(editedReceiverInfo.toJson())
    //       .catchError((_) => throw ServerException());
    // } else {
    //   print("Both are same");
    // }

    print("Testing testing 123");

    throw ServerException();

    // final editedPaymentInfoJson = editedPaymentInfo.toJson();
    // await _firestore
    //     .collection('Payments')
    //     .doc(editedPaymentInfo.id.trim())
    //     .set(editedPaymentInfoJson).catchError((_) => throw ServerException());
  }

  @override
  Future<List<PaymentModel>> getAllPaymentsFromDataSource() async {
    final user_id = await _firebaseAuth.currentUser!.uid;

    List<PaymentModel> paymentList = [];

    final paymentsData = await _firestore
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
    final user_id = await _firebaseAuth.currentUser!.uid;
    List<CategoryModel> categoryList = [];

    // get all default category
    final defaultCategoriesData = await _firestore
        .collection('Categories')
        .where('user_id', isEqualTo: "")
        .get()
        .catchError((_) => throw ServerException());

    defaultCategoriesData.docs.forEach((data) {
      CategoryModel category = CategoryModel.fromFirestore(data);
      categoryList.add(category);
    });

    // get all user setting category
    final userCategoriesData = await _firestore
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
    final user_id = await _firebaseAuth.currentUser!.uid;

    final newCategoryData = {
      'name': categoryName,
      'user_id': user_id,
    };

    await _firestore
        .collection('Categories')
        .add(newCategoryData)
        .catchError((e) {
      throw ServerException();
    });
  }

  @override
  Future<List<BankModel>> getBankList() async {
    List<BankModel> bankList = [];
    final bankListData = await _firestore
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
    final user_id = await _firebaseAuth.currentUser!.uid;
    List<CategoryModel> categoryList = [];

    // get all default category
    final defaultCategoriesData = await _firestore
        .collection('Categories')
        .where('user_id', isEqualTo: "")
        .get()
        .catchError((_) => throw ServerException());

    defaultCategoriesData.docs.forEach((data) {
      CategoryModel category = CategoryModel.fromFirestore(data);
      categoryList.add(category);
    });

    // get all user setting category
    final userCategoriesData = await _firestore
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
    return await _firestore
        .collection('Receivers')
        .doc(receiverId.trim())
        .get()
        .then((value) => ReceiverModel.fromFirestore(value))
        .catchError((_) => throw ServerException());
  }
}
