import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
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
  Future<void> editPaymentFromDataSource(PaymentModel payment);

  Future<void> deletePaymentFromDataSource(String paymentId);

  Future<void> addCategory(String categoryName);

  Future<List<BankModel>> getBankList();
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiverInfo) async {
    final user_id = await _firebaseAuth.currentUser!.uid;

    receiverInfo.user_id = user_id;

    // check if the receiver already created
    final receiverData = await _firestore
        .collection('Receivers')
        .where('user_id', isEqualTo: user_id)
        .where('name', isEqualTo: receiverInfo.name)
        // .where('bank_id', isEqualTo: receiverInfo.bank_id)
        .where('bank_account_no', isEqualTo: receiverInfo.bank_account_no)
        .get()
        .catchError((_) => throw ServerException());

    // if there is same receiver in database
    if (receiverData.size > 0) {
      print("Existing receiver in database");
    } else {
      print("No existing receiver in database");
      // store new receiver data into database
    }

    // set receiver id to new payment
    // newPayment.receiver_id = receiver.id;

    throw ServerException();

    // store new payment to Firestore
  }

  @override
  Future<void> deletePaymentFromDataSource(String paymentId) {
    // delete payment from Firebase
    // check if the receiver already no use in the database
    // if not in use, delete

    // TODO: implement deletePaymentFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<void> editPaymentFromDataSource(PaymentModel payment) {
    //

    // TODO: implement editPaymentFromDataSource
    throw UnimplementedError();
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
}
