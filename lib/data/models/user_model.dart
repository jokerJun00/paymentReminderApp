import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> userData) {
    final data = userData.data()!;

    return UserModel(
      id: userData.id,
      name: data["name"],
      email: data["email"],
      contactNo: data["contactNo"],
    );
  }
}
