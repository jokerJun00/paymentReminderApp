import 'package:dartz/dartz.dart';

import '../../data/models/category_model.dart';
import '../entities/budget_entity.dart';
import '../entities/budgeting_plan_entity.dart';
import '../entities/category_entity.dart';
import '../failures/failures.dart';

abstract class BudgetRepo {
  Future<Either<BudgetingPlanEntity?, Failure>>
      getBudgetingPlanFromDataSource();

  Future<Either<List<BudgetEntity>, Failure>> getBudgetListFromDataSource(
      String budgetingPlanId);

  Future<Either<void, Failure>> addBudgetingPlanFromDataSource(
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  );

  Future<Either<void, Failure>> editBudgetingPlanFromDataSource(
    String budgetingPlanId,
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  );

  Future<Either<List<CategoryEntity>, Failure>> getCategoryListFromDataSource();
}
