import 'package:equatable/equatable.dart';

class BudgetingPlanEntity extends Equatable {
  const BudgetingPlanEntity({
    required this.id,
    required this.target_amount,
    required this.starting_amount,
    required this.user_id,
  });

  final String id;
  final double target_amount;
  final double starting_amount;
  final String user_id;

  @override
  List<Object?> get props => [target_amount, starting_amount, user_id];
}
