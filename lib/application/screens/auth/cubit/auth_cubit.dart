import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/usecases/auth_usecases.dart';

import '../../../../domain/failures/failures.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthUseCases authUseCases = AuthUseCases();

  void logIn(String email, String password) async {
    emit(AuthStateLogingIn());

    // firebase login authentication
    final userOrFailure = await authUseCases.logIn(email, password);
    userOrFailure.fold(
      (user) => emit(AuthStateLoginedIn(user: user)),
      (failure) => emit(AuthStateError(message: _mapFailureMessage(failure))),
    );
  }

  void signUp(
      String username, String email, String contactNo, String password) async {
    emit(AuthStateSigningUp());

    // firebase signup authentication
    final userOrFailure = await authUseCases.signUp(
      username,
      email,
      contactNo,
      password,
    );

    userOrFailure.fold(
      (user) => emit(AuthStateLoginedIn(user: user)),
      (failure) => emit(AuthStateError(message: _mapFailureMessage(failure))),
    );
  }

  void logOut() async {
    emit(AuthStateLogingOut());

    // logout process
    final loggedOutOrFailure = await authUseCases.logOut();
    loggedOutOrFailure.fold(
      (loggedOut) => emit(AuthStateLogOut()),
      (failure) => emit(AuthStateError(message: _mapFailureMessage(failure))),
    );
  }

  String _mapFailureMessage(Failure failure) {
    // check failure type
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error connecting to server. Please try again later.';
      case CacheFailure:
        return 'Cache failed. Please try again later.';
      case LogInFailedFailure:
        return 'Login failed. Please check your email and password';
      case SignUpFailedFailure:
        return 'Signup failed. Please check your phone number and password';
      default:
        return 'Something went wrong. Please try again later.';
    }
  }
}
