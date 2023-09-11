import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/auth_datasource.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<UserCredential>()
])
void main() {
  group("AuthDataSource", () {
    final mockFirebaseAuth = MockFirebaseAuth();
    final mockFirestore = MockFirebaseFirestore();
    final mockUserCredential = MockUserCredential();
    final authDataSourceImplTest = AuthDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );

    const userId = "3JklKkNSbCPfJrPwcKreZWDYGp52";
    const user = UserModel(
      id: "3JklKkNSbCPfJrPwcKreZWDYGp52",
      name: "Lim Choon Kiat",
      email: "junkiat54@gmail.com",
      contactNo: "60176835363",
    );

    group("Sucess Test Cases", () {
      test("Log In Success Test Case", () async {
        // when(mockFirebaseAuth.signInWithEmailAndPassword(
        //         email: "junkiat54@gmail.com", password: "Kiat@000905"))
        //     .thenAnswer((realInvocation) => Future.value(MockUserCredential()));

        final result = await authDataSourceImplTest.logInFromDataSource(
            "junkiat54@gmail.com", "Kiat@000905");

        expect(result, user);
      });
      test("Sign Up Success Test Case", () async {
        // when(mockFirebaseAuth.currentUser!.uid).thenReturn(userId);
      });
      test("Log Out Success Test Case", () async {
        when(mockFirebaseAuth.signOut())
            .thenAnswer((realInvocation) => Future.value(null));

        final result = await authDataSourceImplTest.logOutFromDataSource();

        expect(result, true);
      });
    });
    group("Failure Test Cases", () {
      test("Log In Failure Test Case", () async {});
      test("Sign Up Failure Test Case", () async {});
    });
  });
}
