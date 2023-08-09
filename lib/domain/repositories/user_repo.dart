import 'package:dartz/dartz.dart';
import '../entities/user_entitiy.dart';
import '../failures/failures.dart';

abstract class UserRepo {
  Future<Either<UserEntity, Failure>> getUserFromDataSource();
  Future<Either<UserEntity, Failure>> editUserFromDataSource(
    String id,
    String username,
    String email,
    String contactNo,
    String oldEmail,
    String password,
  );
  Future<Either<void, Failure>> editPasswordFromDataSource(
      String email, String oldPassword, String newPassword);
}
