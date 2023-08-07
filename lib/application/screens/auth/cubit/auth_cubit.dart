import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/usecases/auth_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthUseCases authUseCases = AuthUseCases();

  void logIn(String email, String password) async {
    emit(AuthStateLoading());

    // firebase login authentication
    final userOrFailure = await authUseCases.logIn(email, password);
    userOrFailure.fold(
      (user) => emit(AuthStateLoginedIn(user: user)),
      (failure) => emit(AuthStateError(message: failure.getError)),
    );
  }

  void signUp(
      String username, String email, String contactNo, String password) async {
    emit(AuthStateLoading());

    // firebase signup authentication
    final userOrFailure = await authUseCases.signUp(
      username,
      email,
      contactNo,
      password,
    );

    userOrFailure.fold(
      (user) => emit(AuthStateLoginedIn(user: user)),
      (failure) => emit(AuthStateError(message: failure.getError)),
    );
  }

  void logOut() async {
    emit(AuthStateLoading());

    // logout process
    final loggedOutOrFailure = await authUseCases.logOut();
    loggedOutOrFailure.fold(
      (loggedOut) => emit(AuthStateLogOut()),
      (failure) => emit(AuthStateError(message: failure.getError)),
    );
  }

  void get UserData async {}
}
