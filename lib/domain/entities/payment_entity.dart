import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  const PaymentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.notification_period,
    required this.billing_cycle,
    required this.expected_amount,
    required this.user_id,
    required this.receiver_id,
    required this.category_id,
  });

  final String id;
  final String name;
  final String description;
  final DateTime notification_period;
  final DateTime billing_cycle;
  final double expected_amount;
  final String user_id;
  final String receiver_id;
  final String category_id;

  @override
  List<Object?> get props => [
        name,
        description,
        notification_period,
        billing_cycle,
        expected_amount,
        user_id,
        receiver_id,
        category_id,
      ];
}
