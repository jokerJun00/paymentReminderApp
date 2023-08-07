import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';

class UserModel extends UserEntity with EquatableMixin {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.contactNo,
  });

  factory UserModel.fromFirebaseAuth(User user, String contactNo) {
    return UserModel(
      id: user.uid,
      name: user.displayName!,
      email: user.email!,
      contactNo: contactNo,
    );
  }
}
