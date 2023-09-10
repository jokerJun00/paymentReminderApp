import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../repositories/auth_repo.dart';

class AuthUseCases {
  AuthUseCases({required this.authRepo});
  final AuthRepo authRepo;

  Future<Either<UserEntity, Failure>> logIn(String email, String password) {
    return authRepo.logInFromDataSource(email, password);
  }

  Future<Either<UserEntity, Failure>> signUp(
      String username, String email, String contactNo, String password) {
    return authRepo.signUpFromDataSource(
      username,
      email,
      contactNo,
      password,
    );
  }

  Future<Either<bool, Failure>> logOut() {
    return authRepo.logOutFromDataSource();
  }
}
