import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/repositories/auth_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

class AuthUseCases {
  final AuthRepoImpl authRepoFirestore = AuthRepoImpl();

  Future<Either<UserEntity, Failure>> logIn(String email, String password) {
    return authRepoFirestore.logInFromDataSource(email, password);
  }

  Future<Either<UserEntity, Failure>> signUp(
      String username, String email, String contactNo, String password) {
    authRepoFirestore.signUpFromDataSource(
      username,
      email,
      contactNo,
      password,
    );

    return authRepoFirestore.signUpFromDataSource(
      username,
      email,
      contactNo,
      password,
    );
  }

  Future<Either<bool, Failure>> logOut() {
    return authRepoFirestore.logOutFromDataSource();
  }
}
