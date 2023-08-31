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

class BudgetStateLoadingData extends BudgetState {}

class BudgetStateLoaded extends BudgetState {}

class BudgetStateEditingData extends BudgetState {}

class BudgetStateEditSuccess extends BudgetState {}

class BudgetStateError extends BudgetState {
  const BudgetStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
