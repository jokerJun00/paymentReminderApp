import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/budget_datasource.dart';

import 'package:payment_reminder_app/domain/entities/budget_entity.dart';

import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart';

import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../domain/repositories/budget_repo.dart';
import '../exceptions/exceptions.dart';

class BudgetRepoImpl implements BudgetRepo {
  final BudgetDataSource budgetDataSource = BudgetDataSourceImpl();

  @override
  Future<Either<void, Failure>> editBudgetListFromDataSource() async {
    try {
      return left(await budgetDataSource.editBudgetListFromDataSource());
    } on ServerException catch (_) {
      return right(
          ServerFailure(error: "Edit budget failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> addBudgetingPlanFromDataSource() async {
    try {
      return left(await budgetDataSource.editBudgetingPlanFromDataSource());
    } on ServerException catch (_) {
      return right(ServerFailure(
          error: "Add Budgeting Plan failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<BudgetEntity>, Failure>> getBudgetListFromDataSource(
      String budgetingPlanId) async {
    try {
      return left(
          await budgetDataSource.getBudgetListFromDataSource(budgetingPlanId));
    } on ServerException catch (_) {
      return right(ServerFailure(
          error: "Loading budgets data failed. Please try again later"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<BudgetingPlanEntity?, Failure>>
      getBudgetingPlanFromDataSource() async {
    try {
      return left(await budgetDataSource.getBudgetingPlanFromDataSource());
    } on ServerException catch (_) {
      return right(ServerFailure(
          error: "Loading budgeting plan failed. Please try again later"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }
}
