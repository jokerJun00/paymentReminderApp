import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/paid_payment_entity.dart';

class PaidPaymentModel extends PaidPaymentEntity with EquatableMixin {
  const PaidPaymentModel({
    required super.id,
    required super.date,
    required super.amount_paid,
    required super.payment_name,
    required super.receiver_name,
    required super.user_id,
    required super.payment_id,
    required super.category_id,
  });

  factory PaidPaymentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> paymentData) {
    final payment = paymentData.data()!;

    double amount_paid = double.tryParse(payment["amount_paid"]) ?? 0.0;
    DateTime date = payment["date"].toDate();

    return PaidPaymentModel(
      id: paymentData.id,
      date: date,
      amount_paid: amount_paid,
      payment_name: payment["payment_name"],
      receiver_name: payment["receiver_name"],
      user_id: payment["user_id"],
      payment_id: payment["payment_id"],
      category_id: payment["category_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount_paid': amount_paid.toString(),
      'payment_name': payment_name,
      'receiver_name': receiver_name,
      'user_id': user_id,
      'payment_id': payment_id,
      'category_id': category_id,
    };
  }
}
