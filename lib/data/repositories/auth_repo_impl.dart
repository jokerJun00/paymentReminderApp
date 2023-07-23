import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/auth_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDataSource authDataSource = AuthDataSourceImpl();

  @override
  Future<Either<UserEntity, Failure>> logInFromDataSource(
      String email, String password) async {
    try {
      // log in
      // final user = await authDataSource.logInFromDataSource(email, password);
      // return left(user);

      return left(await authDataSource.logInFromDataSource(email, password));
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return right(LogInFailedFailure());
    } catch (e) {
      return right(GeneralFailure());
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
    } on ServerException catch (_) {
      return right(ServerFailure());
    } on LogInFailedException catch (_) {
      return right(LogInFailedFailure());
    } catch (e) {
      return right(GeneralFailure());
    }
  }

  @override
  Future<Either<bool, Failure>> logOutFromDataSource() async {
    final result = await authDataSource.logOutFromDataSource();
    return left(result);
  }
}
