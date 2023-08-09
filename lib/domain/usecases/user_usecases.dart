import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';

import '../entities/user_entitiy.dart';
import '../failures/failures.dart';

class UserUseCases {
  final UserRepoImpl userRepoFirestore = UserRepoImpl();

  Future<Either<UserEntity, Failure>> getUser() {
    return userRepoFirestore.getUserFromDataSource();
  }

  Future<Either<UserEntity, Failure>> editUser(String id, String username,
      String email, String contactNo, String oldEmail, String password) {
    return userRepoFirestore.editUserFromDataSource(
        id, username, email, contactNo, oldEmail, password);
  }

  Future<Either<void, Failure>> editPassword(
      String email, String oldPassword, String newPassword) {
    return userRepoFirestore.editPasswordFromDataSource(
        email, oldPassword, newPassword);
  }
}
