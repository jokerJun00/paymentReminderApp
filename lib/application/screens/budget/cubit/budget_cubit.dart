import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/budget_entity.dart';
import '../../../../domain/entities/budgeting_plan_entity.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit()
      : super(const BudgetStateInitial(
          budgetingPlan: BudgetingPlanEntity(
            id: "",
            target_amount: 0,
            starting_amount: 0,
            user_id: "",
          ),
          budgetList: [],
        ));

  Future<void> getBudgetingPlanData() async {
    emit(BudgetStateLoadingData());
  }

  Future<void> getBudgetListData() async {
    emit(BudgetStateLoadingData());

    emit(BudgetStateLoaded());
  }

  Future<void> editBudgetingPlan() async {
    emit(BudgetStateEditingData());

    emit(BudgetStateEditSuccess());
  }

  Future<void> editBudgetList() async {
    emit(BudgetStateEditingData());

    emit(BudgetStateEditSuccess());
  }
}
