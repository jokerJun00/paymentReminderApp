import 'package:dartz/dartz.dart';
import '../entities/user_entitiy.dart';
import '../failures/failures.dart';

abstract class UserRepo {
  Future<Either<UserEntity, Failure>> getUserFromDataSource();
  Future<Either<UserEntity, Failure>> editUserFromDataSource(
      String username, String email, String contactNo);
  Future<Either<void, Failure>> editPasswordFromDataSource(String newPassword);
}
