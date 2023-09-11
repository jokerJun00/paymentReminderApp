import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'user_datasource_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference>(),
  MockSpec<DocumentReference>(),
  MockSpec<DocumentSnapshot>(),
])
void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockFirestore = MockFirebaseFirestore();
  final fakeFirestore = FakeFirebaseFirestore();
  final userDataSourceImplTest = UserDataSourceImpl(
    firebaseAuth: mockFirebaseAuth,
    firestore: mockFirestore,
  );

  final documentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

  group('AuthDataSource', () {
    const userId = "3JklKkNSbCPfJrPwcKreZWDYGp52";
    const collectionName = "Users";
    const user = UserModel(
      id: "3JklKkNSbCPfJrPwcKreZWDYGp52",
      name: "Lim Choon Kiat",
      email: "junkiat54@gmail.com",
      contactNo: "60176835363",
    );

    group('Success Test Case', () {
      test('Get User Success Test Case', () async {
        final snapShot =
            await fakeFirestore.collection(collectionName).doc(userId).get();

        final userData = UserModel.fromFirestore(snapShot);
        // when(mockFirestore
        //         .collection('Users')
        //         .doc('3JklKkNSbCPfJrPwcKreZWDYGp52')
        //         .get())
        //     .thenAnswer((realInvocation) => Future.value(documentSnapshot));

        // final result = userDataSourceImplTest.getUserFromDataSource();

        expect(userData, user);
      });
      test('Edit User Success Test Case', () async {
        // when(
        //   mockFirestore
        //       .collection('Users')
        //       .doc('3JklKkNSbCPfJrPwcKreZWDYGp52')
        //       .update({
        //     'name': 'Lim Choon Kiat',
        //     'email': 'junkiat54@gmail.com',
        //     'contactNo': '60176835363',
        //   }),
        // ).thenAnswer((realInvocation) => Future.value(null));

        final result = await userDataSourceImplTest.editUserFromDataSource(
          userId,
          "Lim Choon Kiat",
          "junkiat54@gmail.com",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        );

        expect(result, user);
      });
      test('Edit Password Success Test Case', () async {});
    });

    group('Failure Test Case', () {
      test('Get User Failure Test Case', () async {});
      test('Edit User Failure Test Case', () async {});
      test('Edit Password Failure Test Case', () async {});
    });
  });
}
