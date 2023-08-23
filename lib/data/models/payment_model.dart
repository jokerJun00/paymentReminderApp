import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity with EquatableMixin {
  PaymentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.payment_date,
    required super.notification_period,
    required super.billing_cycle,
    required super.expected_amount,
    required super.user_id,
    required super.receiver_id,
    required super.category_id,
  });

  factory PaymentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> paymentData) {
    final payment = paymentData.data()!;

    double expected_amount = double.tryParse(payment["expected_amount"]) ?? 0.0;
    DateTime payment_date = payment["payment_date"].toDate();

    return PaymentModel(
      id: paymentData.id,
      name: payment["name"],
      description: payment["description"],
      payment_date: payment_date,
      notification_period: payment["notification_period"],
      billing_cycle: payment["billing_cycle"],
      expected_amount: expected_amount,
      user_id: payment["user_id"],
      receiver_id: payment["receiver_id"],
      category_id: payment["category_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'payment_date': payment_date,
      'notification_period': notification_period,
      'billing_cycle': billing_cycle,
      'expected_amount': expected_amount.toString(),
      'user_id': user_id,
      'receiver_id': receiver_id,
      'category_id': category_id,
    };
  }
}
