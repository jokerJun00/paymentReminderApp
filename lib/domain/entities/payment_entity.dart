import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  PaymentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.payment_date,
    required this.notification_period,
    required this.billing_cycle,
    required this.expected_amount,
    required this.user_id,
    required this.receiver_id,
    required this.category_id,
  });

  String id;
  String name;
  String description;
  DateTime payment_date;
  int notification_period;
  String billing_cycle;
  double expected_amount;
  String user_id;
  String receiver_id;
  String category_id;

  @override
  List<Object?> get props => [
        name,
        description,
        payment_date,
        notification_period,
        billing_cycle,
        expected_amount,
        user_id,
        receiver_id,
        category_id,
      ];
}
