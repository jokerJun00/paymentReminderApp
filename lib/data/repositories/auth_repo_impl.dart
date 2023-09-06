import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/auth_datasource.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({required this.authDataSource});
  final AuthDataSource authDataSource;

  @override
  Future<Either<UserEntity, Failure>> logInFromDataSource(
      String email, String password) async {
    try {
      // log in
      final user = await authDataSource.logInFromDataSource(email, password);
      return left(user);
    } on FirebaseAuthException catch (e) {
      return right(FirebaseAuthFailure(error: e.message!));
    } catch (e) {
      return right(
          GeneralFailure(error: "Something went wrong, please try again"));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> signUpFromDataSource(
      String username, String email, String contactNo, String password) async {
    try {
      // sign up
      final user = await authDataSource.signUpFromDataSource(
          username, email, contactNo, password);

      return left(user);
    } on FirebaseAuthException catch (e) {
      return right(FirebaseAuthFailure(error: e.message!));
    } catch (e) {
      return right(
          GeneralFailure(error: "Something went wrong, please try again"));
    }
  }

  @override
  Future<Either<bool, Failure>> logOutFromDataSource() async {
    final result = await authDataSource.logOutFromDataSource();
    return left(result);
  }
}
