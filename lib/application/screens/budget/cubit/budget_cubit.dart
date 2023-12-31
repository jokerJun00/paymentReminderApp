import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/usecases/budget_usecases.dart';

import '../../../../data/models/category_model.dart';
import '../../../../domain/entities/budget_entity.dart';
import '../../../../domain/entities/budgeting_plan_entity.dart';
import '../../../../domain/entities/category_entity.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit({required this.budgetUseCases})
      : super(const BudgetStateInitial());

  final BudgetUseCases budgetUseCases;

  Future<BudgetingPlanEntity?> getBudgetingPlan() async {
    emit(const BudgetStateLoadingData());

    final budgetingPlanOrFailure = await budgetUseCases.getBudgetingPlan();
    BudgetingPlanEntity? budgetingPlan;

    budgetingPlanOrFailure.fold(
      (budgetingPlanFromSource) {
        emit(const BudgetStateLoaded());
        budgetingPlan = budgetingPlanFromSource;
      },
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );

    return budgetingPlan;
  }

  Future<List<BudgetEntity>> getBudgetList(String budgetingPlanId) async {
    emit(const BudgetStateLoadingData());

    final budgetListOrFailure =
        await budgetUseCases.getBudgetList(budgetingPlanId);
    List<BudgetEntity> budgetList = [];

    budgetListOrFailure.fold(
      (budgetListFromSource) {
        emit(const BudgetStateLoaded());
        budgetList = budgetListFromSource;
      },
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );

    return budgetList;
  }

  Future<void> addBudgetingPlan(
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    emit(const BudgetStateEditingData());

    final successOrFailure = await budgetUseCases.addBudgetingPlan(
        startAmount, targetAmount, categoryBudgetAmountList, categoryList);

    successOrFailure.fold(
      (success) => emit(const BudgetStateEditSuccess()),
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );
  }

  Future<void> editBudgetingPlan(
    String budgetingPlanId,
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    emit(const BudgetStateEditingData());

    final successOrFailure = await budgetUseCases.editBudgetingPlan(
      budgetingPlanId,
      startAmount,
      targetAmount,
      categoryBudgetAmountList,
      categoryList,
    );

    successOrFailure.fold(
      (success) => emit(const BudgetStateEditSuccess()),
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );
  }

  Future<List<CategoryEntity>> getCategoryList() async {
    emit(const BudgetStateLoadingData());

    final categoryListOrFailure = await budgetUseCases.getCategoryList();
    List<CategoryEntity> categoryList = [];

    categoryListOrFailure.fold(
      (categoryListFromDatabase) {
        emit(const BudgetStateLoaded());
        categoryList = categoryListFromDatabase;
      },
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );

    return categoryList;
  }
}
