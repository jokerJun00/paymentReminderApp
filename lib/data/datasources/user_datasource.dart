import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exceptions/exceptions.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  /// get user data to display in profile screen
  /// return [UserModel]
  /// check authentication and get data from User collection
  Future<UserModel> getUserFromDataSource();

  /// edit user data and update in Firestore
  /// return [UserModel]
  /// update user data in User collection and get the updated data from Firestore
  Future<UserModel> editUserFromDataSource(String id, String username,
      String email, String contactNo, String oldEmail, String password);

  /// edit user password and update in Firestore
  /// return [void]
  /// update user account password in Firebase Authentication
  Future<void> editPasswordFromDataSource(
      String email, String oldPassword, String newPassword);
}

class UserDataSourceImpl implements UserDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> editPasswordFromDataSource(
      String email, String oldPassword, String newPassword) async {
    // sign in again to update firebase auth registered email

    var credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);
    await _firebaseAuth.currentUser!
        .reauthenticateWithCredential(credential)
        .catchError((e) {
      throw ServerException();
    });

    if (oldPassword != newPassword) {
      // update firebase auth password
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> editUserFromDataSource(String id, String username,
      String email, String contactNo, String oldEmail, String password) async {
    // sign in again to update firebase auth registered email
    var credential =
        EmailAuthProvider.credential(email: oldEmail, password: password);
    await _firebaseAuth.currentUser!
        .reauthenticateWithCredential(credential)
        .catchError((e) {
      throw ServerException();
    });

    // update firebase auth registered email
    await _firebaseAuth.currentUser!.updateEmail(email);

    // update firebase firestore Users collection
    await _firestore.collection('Users').doc(id).update({
      'name': username,
      'email': email,
      'contactNo': contactNo,
    }).catchError((e) => throw ServerException());

    final newUserData = await _firestore
        .collection('Users')
        .doc(id)
        .get()
        .catchError((_) => throw ServerException());

    if (newUserData.exists) {
      // return edited user data
      return UserModel.fromFirestore(newUserData);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserFromDataSource() async {
    final currentUserId = _firebaseAuth.currentUser!.uid;
    final userData = await _firestore
        .collection('Users')
        .doc(currentUserId)
        .get()
        .catchError((_) => throw ServerException());

    if (userData.exists) {
      return UserModel.fromFirestore(userData);
    } else {
      throw ServerException();
    }
  }
}
