import 'package:equatable/equatable.dart';

class PaidPaymentEntity extends Equatable {
  const PaidPaymentEntity({
    required this.id,
    required this.date,
    required this.amount_paid,
    required this.payment_name,
    required this.receiver_name,
    required this.user_id,
    required this.payment_id,
    required this.category_id,
  });

  final String id;
  final DateTime date;
  final double amount_paid;
  final String payment_name;
  final String receiver_name;
  final String user_id;
  final String payment_id;
  final String category_id;

  @override
  List<Object?> get props => [
        date,
        amount_paid,
        payment_name,
        receiver_name,
        user_id,
        payment_id,
        category_id,
      ];
}
