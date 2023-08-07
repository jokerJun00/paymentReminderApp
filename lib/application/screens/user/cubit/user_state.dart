part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserStateInitial extends UserState {}

class UserStateLoadingData extends UserState {}

class UserStateEditingData extends UserState {}

class UserStateError extends UserState {}
