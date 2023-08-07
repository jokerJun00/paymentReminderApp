import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../models/user_model.dart';

abstract class UserDataSource {
  /// get user data to display in profile screen
  /// return [UserModel]
  /// check authentication and get data from User collection
  Future<UserModel> getUserFromDataSource();

  /// edit user data and update in Firestore
  /// return [UserModel]
  /// update user data in User collection and get the updated data from Firestore
  Future<UserModel> editUserFromDataSource(
      String username, String email, String contactNo);

  /// edit user password and update in Firestore
  /// return [void]
  /// update user account password in Firebase Authentication
  Future<void> editPasswordFromDataSource(String newPassword);
}

class UserDataSourceImpl implements UserDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<void> editPasswordFromDataSource(String newPassword) async {
    // TODO: implement editPasswordFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<UserModel> editUserFromDataSource(
      String username, String email, String contactNo) async {
    // TODO: implement editUserFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserFromDataSource() async {
    try {
      final currentUserId = _firebaseAuth.currentUser!.uid;
      final userData =
          await _firestore.collection('Users').doc(currentUserId).get();

      if (userData.exists) {
        Map<String, dynamic> data = userData.data()!;
        return UserModel.fromFirestore(currentUserId, data);
      } else {
        throw GeneralFailure(error: "user data not found");
      }
    } catch (e) {
      throw GeneralFailure(error: e.toString());
    }
  }
}
