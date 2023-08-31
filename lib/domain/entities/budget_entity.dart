import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  BudgetEntity({
    required this.id,
    required this.budgeting_plan_id,
    required this.category_id,
    required this.budgeting_amount,
  });

  final String id;
  final String budgeting_plan_id;
  final String category_id;
  double budgeting_amount;

  @override
  List<Object?> get props => [budgeting_plan_id, category_id];
}
