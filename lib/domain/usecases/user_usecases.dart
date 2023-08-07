import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';

import '../entities/user_entitiy.dart';
import '../failures/failures.dart';

class UserUseCases {
  final UserRepoImpl userRepoFirestore = UserRepoImpl();

  Future<Either<UserEntity, Failure>> getUser() {
    return userRepoFirestore.getUserFromDataSource();
  }

  Future<Either<UserEntity, Failure>> editUser(
      String username, String email, String contactNo) {
    return userRepoFirestore.editUserFromDataSource(username, email, contactNo);
  }

  Future<Either<void, Failure>> editPassword(String newPassword) {
    return userRepoFirestore.editPasswordFromDataSource(newPassword);
  }
}
