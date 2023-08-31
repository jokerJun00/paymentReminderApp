import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';

class BudgetModel extends BudgetEntity with EquatableMixin {
  BudgetModel({
    required super.id,
    required super.budgeting_plan_id,
    required super.category_id,
    required super.budgeting_amount,
  });

  factory BudgetModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> budgetData) {
    final data = budgetData.data()!;

    double budgetingAmount = double.tryParse(data["budgeting_amount"]) ?? 0.0;

    return BudgetModel(
        id: budgetData.id,
        budgeting_plan_id: data["budgeting_plan_id"],
        category_id: data["category_id"],
        budgeting_amount: budgetingAmount);
  }

  Map<String, dynamic> toJson() {
    return {
      'budgeting_plan_id': budgeting_plan_id,
      'category_id': category_id,
      'budgeting_amount': budgeting_amount.toString(),
    };
  }
}
