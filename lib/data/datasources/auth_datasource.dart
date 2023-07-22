import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';

import '../models/user_model.dart';

abstract class AuthDataSource {
  /// log in user from Firebase
  ///
  Future<UserModel> logInFromDataSource(String email, String password);

  Future<UserModel> signUpFromDataSource(
      String username, String email, String contactNo, String password);

  Future<bool> logOutFromDataSource();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<UserModel> logInFromDataSource(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (_firebaseAuth.currentUser == null) {
      throw LogInFailedException();
    } else {
      return UserModel.fromFirebaseAuth(userCredential);
    }
  }

  @override
  Future<UserModel> signUpFromDataSource(
      String username, String email, String contactNo, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (_firebaseAuth.currentUser == null) {
      throw SignUpFailedException();
    } else {
      return UserModel.fromFirebaseAuth(userCredential);
    }
  }

  @override
  Future<bool> logOutFromDataSource() async {
    await _firebaseAuth.signOut();

    return true;
  }
}
