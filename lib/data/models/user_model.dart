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

  factory UserModel.fromFirebaseAuth(UserCredential userCredential) {
    return UserModel(
      id: userCredential.user!.uid,
      name: userCredential.user!.displayName!,
      email: userCredential.user!.email!,
      contactNo: userCredential.user!.phoneNumber!,
    );
  }
}
