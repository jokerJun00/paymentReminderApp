import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';

import '../models/user_model.dart';

abstract class AuthDataSource {
  /// log in user from Firebase
  /// return [UserModel]
  /// authenticate user log in
  Future<UserModel> logInFromDataSource(String email, String password);

  /// sign up user from Firebase
  /// return [UserModel]
  /// create an account in Firebase Authentication and an data in Users collection in Firestore database
  Future<UserModel> signUpFromDataSource(
      String username, String email, String contactNo, String password);

  /// log out user from Firebase
  /// return [UserModel]
  /// sign out from Firebase Authentication
  Future<bool> logOutFromDataSource();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      await userCredential.user!.updateDisplayName(username);
      await _firestore.collection('Users').doc(userCredential.user!.uid).set({
        'name': username,
        'email': email,
        'contactNo': contactNo,
      });
      return UserModel.fromFirebaseAuth(userCredential);
    }
  }

  @override
  Future<bool> logOutFromDataSource() async {
    await _firebaseAuth.signOut();

    return true;
  }
}
