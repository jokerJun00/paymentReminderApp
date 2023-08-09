import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity with EquatableMixin {
  const PaymentModel({
    required super.id,
    required super.name,
    required super.description,
    required super.notification_period,
    required super.billing_cycle,
    required super.expected_amount,
    required super.user_id,
    required super.receiver_id,
    required super.category_id,
  });
}
