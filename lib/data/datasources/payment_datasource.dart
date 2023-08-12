import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';

import '../models/payment_model.dart';

abstract class PaymentDataSource {
  /// get all payments of the user and display in payment screen
  /// return [List<PaymentModel>>]
  /// get all payments that associate with userId
  Future<List<PaymentModel>> getAllPaymentsFromDataSource();

  /// add a new payments
  /// return [List<PaymentModel>>]
  /// add a new payment into Firestore 'Payments' collection
  Future<void> addPaymentFromDataSource(PaymentModel newPayment);

  /// edit payments
  /// return [List<PaymentModel>>]
  /// edit the selected payment information into Firestore 'Payments' collection
  Future<void> editPaymentFromDataSource(PaymentModel payment);

  Future<void> deletePaymentFromDataSource(String paymentId);
}

class PaymentDataSourceImpl implements PaymentDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addPaymentFromDataSource(PaymentModel newPayment) {
    // TODO: implement addPaymentFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<void> deletePaymentFromDataSource(String paymentId) {
    // TODO: implement deletePaymentFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<void> editPaymentFromDataSource(PaymentModel payment) {
    // TODO: implement editPaymentFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<List<PaymentModel>> getAllPaymentsFromDataSource() async {
    final user_id = await _firebaseAuth.currentUser!.uid;

    List<PaymentModel> paymentsList = [];

    QuerySnapshot<Map<String, dynamic>> paymentsData = await _firestore
        .collection('Payments')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    paymentsData.docs.forEach((data) {
      PaymentModel payment = PaymentModel.fromFirestore(data);
      paymentsList.add(payment);
    });

    return paymentsList;
  }
}
