part of 'budget_cubit.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

class BudgetStateInitial extends BudgetState {
  const BudgetStateInitial();

  @override
  List<Object> get props => [];
}

class BudgetStateLoadingData extends BudgetState {
  const BudgetStateLoadingData();
}

class BudgetStateLoaded extends BudgetState {
  const BudgetStateLoaded();
}

class BudgetStateEditingData extends BudgetState {
  const BudgetStateEditingData();
}

class BudgetStateEditSuccess extends BudgetState {
  const BudgetStateEditSuccess();
}

class BudgetStateError extends BudgetState {
  const BudgetStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
