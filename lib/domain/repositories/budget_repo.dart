import 'package:dartz/dartz.dart';

import '../entities/budget_entity.dart';
import '../entities/budgeting_plan_entity.dart';
import '../entities/category_entity.dart';
import '../failures/failures.dart';

abstract class BudgetRepo {
  Future<Either<BudgetingPlanEntity?, Failure>>
      getBudgetingPlanFromDataSource();

  Future<Either<List<BudgetEntity>, Failure>> getBudgetListFromDataSource(
      String budgetingPlanId);

  Future<Either<void, Failure>> addBudgetingPlanFromDataSource();

  Future<Either<void, Failure>> editBudgetListFromDataSource();

  Future<Either<List<CategoryEntity>, Failure>> getCategoryListFromDataSource();
}
