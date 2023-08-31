import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart';

class BudgetingPlanModel extends BudgetingPlanEntity with EquatableMixin {
  BudgetingPlanModel({
    required super.id,
    required super.target_amount,
    required super.starting_amount,
    required super.current_spending_amount,
    required super.user_id,
  });

  factory BudgetingPlanModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> budgetingPlanData,
      double currentSpendingAmount) {
    final data = budgetingPlanData.data()!;

    double target_amount = double.tryParse(data["target_amount"]) ?? 0.0;
    double spend_amount = double.tryParse(data["starting_amount"]) ?? 0.0;

    return BudgetingPlanModel(
      id: budgetingPlanData.id,
      target_amount: target_amount,
      starting_amount: spend_amount,
      current_spending_amount: currentSpendingAmount,
      user_id: data["user_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'target_amount': target_amount.toString(),
      'starting_amount': starting_amount.toString(),
      'user_id': user_id,
    };
  }
}
