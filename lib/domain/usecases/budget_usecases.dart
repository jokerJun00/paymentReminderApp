import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';
import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart';

import '../../data/models/category_model.dart';
import '../entities/category_entity.dart';
import '../failures/failures.dart';
import '../repositories/budget_repo.dart';

class BudgetUseCases {
  BudgetUseCases({required this.budgetRepo});
  final BudgetRepo budgetRepo;

  Future<Either<BudgetingPlanEntity?, Failure>> getBudgetingPlan() async {
    return budgetRepo.getBudgetingPlanFromDataSource();
  }

  Future<Either<List<BudgetEntity>, Failure>> getBudgetList(
      String budgetingPlanId) async {
    return budgetRepo.getBudgetListFromDataSource(budgetingPlanId);
  }

  Future<Either<void, Failure>> addBudgetingPlan(
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    return budgetRepo.addBudgetingPlanFromDataSource(
      startAmount,
      targetAmount,
      categoryBudgetAmountList,
      categoryList,
    );
  }

  Future<Either<void, Failure>> editBudgetingPlan(
    String budgetingPlanId,
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    return budgetRepo.editBudgetingPlanFromDataSource(
      budgetingPlanId,
      startAmount,
      targetAmount,
      categoryBudgetAmountList,
      categoryList,
    );
  }

  Future<Either<List<CategoryEntity>, Failure>> getCategoryList() async {
    return budgetRepo.getCategoryListFromDataSource();
  }
}
