part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthStateLoginedIn extends AuthState {
  const AuthStateLoginedIn({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class AuthStateLogOut extends AuthState {
  const AuthStateLogOut();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateError extends AuthState {
  const AuthStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
