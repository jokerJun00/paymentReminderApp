import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';

class BudgetModel extends BudgetEntity with EquatableMixin {
  BudgetModel({
    required super.id,
    required super.budgeting_plan_id,
    required super.category_id,
    required super.category_name,
    required super.current_amount,
    required super.budget_amount,
  });

  factory BudgetModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> budgetData) {
    final data = budgetData.data()!;

    double budgetAmount = double.tryParse(data["budget_amount"]) ?? 0.0;

    return BudgetModel(
      id: budgetData.id,
      budgeting_plan_id: data["budgeting_plan_id"],
      category_id: data["category_id"],
      category_name: "",
      current_amount: 0.0,
      budget_amount: budgetAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgeting_plan_id': budgeting_plan_id,
      'category_id': category_id,
      'budget_amount': budget_amount.toString(),
    };
  }
}
