import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

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
  AuthDataSourceImpl({required this.firebaseAuth, required this.firestore});
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<UserModel> logInFromDataSource(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String contactNo = "";

    if (firebaseAuth.currentUser == null) {
      throw ServerException();
    } else {
      await firestore
          .collection('Users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((userData) => {contactNo = userData.data()!["contactNo"]})
          .catchError((e) => throw GeneralFailure(error: e));

      return UserModel.fromFirebaseAuth(firebaseAuth.currentUser!, contactNo);
    }
  }

  @override
  Future<UserModel> signUpFromDataSource(
      String username, String email, String contactNo, String password) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (firebaseAuth.currentUser == null) {
      throw ServerException();
    } else {
      await firebaseAuth.currentUser!.updateDisplayName(username);
      await firestore
          .collection('Users')
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        'name': username,
        'email': email,
        'contactNo': contactNo,
      });
      return UserModel.fromFirebaseAuth(firebaseAuth.currentUser!, contactNo);
    }
  }

  @override
  Future<bool> logOutFromDataSource() async {
    await firebaseAuth.signOut();

    return true;
  }
}
