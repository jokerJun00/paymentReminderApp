part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserStateInitial extends UserState {
  const UserStateInitial({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class UserStateLoadingData extends UserState {
  const UserStateLoadingData();
}

class UserStateEditingData extends UserState {
  const UserStateEditingData();
}

class UserStateEditSuccess extends UserState {
  const UserStateEditSuccess();
}

class UserStateError extends UserState {
  const UserStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
