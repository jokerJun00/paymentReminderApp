import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  BudgetEntity({
    required this.id,
    required this.budgeting_plan_id,
    required this.category_id,
    required this.category_name,
    required this.current_amount,
    required this.budget_amount,
  });

  final String id;
  final String budgeting_plan_id;
  final String category_id;
  String category_name;
  double current_amount;
  double budget_amount;

  @override
  List<Object?> get props => [budgeting_plan_id, category_id];
}
