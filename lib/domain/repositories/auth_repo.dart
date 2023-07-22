import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

abstract class AuthRepo {
  Future<Either<UserEntity, Failure>> logInFromDataSource(
      String email, String password);
  Future<Either<UserEntity, Failure>> signUpFromDataSource(
      String username, String email, String phoneNumber, String password);
  Future<Either<bool, Failure>> logOutFromDataSource();
}
