import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';

import '../entities/user_entitiy.dart';
import '../failures/failures.dart';
import '../repositories/user_repo.dart';

class UserUseCases {
  UserUseCases({required this.userRepo});
  final UserRepo userRepo;

  Future<Either<UserEntity, Failure>> getUser() {
    return userRepo.getUserFromDataSource();
  }

  Future<Either<UserEntity, Failure>> editUser(String id, String username,
      String email, String contactNo, String oldEmail, String password) {
    return userRepo.editUserFromDataSource(
        id, username, email, contactNo, oldEmail, password);
  }

  Future<Either<void, Failure>> editPassword(
      String email, String oldPassword, String newPassword) {
    return userRepo.editPasswordFromDataSource(email, oldPassword, newPassword);
  }
}
