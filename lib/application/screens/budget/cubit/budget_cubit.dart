import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/usecases/budget_usecases.dart';

import '../../../../domain/entities/budget_entity.dart';
import '../../../../domain/entities/budgeting_plan_entity.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(const BudgetStateInitial());

  final BudgetUseCases budgetUseCases = BudgetUseCases();

  Future<BudgetingPlanEntity?> getBudgetingPlan() async {
    emit(BudgetStateLoadingData());

    final budgetingPlanOrFailure = await budgetUseCases.getBudgetingPlan();
    BudgetingPlanEntity? budgetingPlan;

    budgetingPlanOrFailure.fold(
      (budgetingPlanFromSource) {
        emit(BudgetStateLoaded());
        budgetingPlan = budgetingPlanFromSource;
      },
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );

    return budgetingPlan;
  }

  Future<List<BudgetEntity>> getBudgetList(String budgetingPlanId) async {
    emit(BudgetStateLoadingData());

    final budgetListOrFailure =
        await budgetUseCases.getBudgetList(budgetingPlanId);
    List<BudgetEntity> budgetList = [];

    budgetListOrFailure.fold(
      (budgetListFromSource) {
        emit(BudgetStateLoaded());
        budgetList = budgetListFromSource;
      },
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );

    return budgetList;
  }

  Future<void> addBudgetingPlan() async {
    emit(BudgetStateEditingData());

    final successOrFailure = await budgetUseCases.addBudgetingPlan();

    successOrFailure.fold(
      (success) => emit(BudgetStateEditSuccess()),
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );
  }

  Future<void> editBudgetList() async {
    emit(BudgetStateEditingData());

    final successOrFailure = await budgetUseCases.editBudgetList();

    successOrFailure.fold(
      (success) => emit(BudgetStateEditSuccess()),
      (failure) => emit(BudgetStateError(message: failure.getError)),
    );
  }
}
