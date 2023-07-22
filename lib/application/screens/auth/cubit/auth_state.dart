part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthStateLogingIn extends AuthState {}

class AuthStateLoginedIn extends AuthState {
  const AuthStateLoginedIn({required this.user});

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

class AuthStateSigningUp extends AuthState {}

class AuthStateLogingOut extends AuthState {}

class AuthStateLogOut extends AuthState {}

class AuthStateError extends AuthState {
  const AuthStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
