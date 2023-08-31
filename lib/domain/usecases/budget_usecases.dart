import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/repositories/budget_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';
import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart';

import '../failures/failures.dart';

class BudgetUseCases {
  final BudgetRepoImpl budgetRepoFirestore = BudgetRepoImpl();

  Future<Either<BudgetingPlanEntity?, Failure>> getBudgetingPlan() async {
    return budgetRepoFirestore.getBudgetingPlanFromDataSource();
  }

  Future<Either<List<BudgetEntity>, Failure>> getBudgetList(
      String budgetingPlanId) async {
    return budgetRepoFirestore.getBudgetListFromDataSource(budgetingPlanId);
  }

  Future<Either<void, Failure>> addBudgetingPlan() async {
    return budgetRepoFirestore.addBudgetingPlanFromDataSource();
  }

  Future<Either<void, Failure>> editBudgetList() async {
    return budgetRepoFirestore.editBudgetListFromDataSource();
  }
}
