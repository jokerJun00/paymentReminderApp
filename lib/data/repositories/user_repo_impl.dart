import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final UserDataSource userDataSource = UserDataSourceImpl();

  @override
  Future<Either<void, Failure>> editPasswordFromDataSource(
      String newPassword) async {
    try {
      return left(await userDataSource.editPasswordFromDataSource(newPassword));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> editUserFromDataSource(
      String username, String email, String contactNo) async {
    try {
      final user = await userDataSource.editUserFromDataSource(
          username, email, contactNo);
      return left(user);
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> getUserFromDataSource() async {
    try {
      final user = await userDataSource.getUserFromDataSource();
      return left(user);
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }
}
