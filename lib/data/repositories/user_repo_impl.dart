import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepo {
  UserRepoImpl({required this.userDataSource});
  final UserDataSource userDataSource;

  @override
  Future<Either<void, Failure>> editPasswordFromDataSource(
      String email, String oldPassword, String newPassword) async {
    try {
      return left(await userDataSource.editPasswordFromDataSource(
        email,
        oldPassword,
        newPassword,
      ));
    } on FirebaseAuthException catch (e) {
      return right(FirebaseAuthFailure(error: e.message!));
    } on ServerException catch (_) {
      return right(ServerFailure(
          error:
              "Edit password failed. Make sure your old password is correct and new password must not be same as old password"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> editUserFromDataSource(
    String id,
    String username,
    String email,
    String contactNo,
    String oldEmail,
    String password,
  ) async {
    try {
      final user = await userDataSource.editUserFromDataSource(
        id,
        username,
        email,
        contactNo,
        oldEmail,
        password,
      );
      return left(user);
    } on FirebaseAuthException catch (e) {
      return right(FirebaseAuthFailure(error: e.message!));
    } on ServerException catch (_) {
      return right(ServerFailure(
          error:
              "Edit User Profile failed. Make sure your password is correct"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<UserEntity, Failure>> getUserFromDataSource() async {
    try {
      final user = await userDataSource.getUserFromDataSource();
      return left(user);
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to get user data."));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }
}
