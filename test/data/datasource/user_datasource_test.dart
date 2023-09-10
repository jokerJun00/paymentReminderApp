import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'user_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FirebaseAuth>(), MockSpec<FirebaseFirestore>()])
void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockFirebaseFirestore = MockFirebaseFirestore();
  final userDataSourceImplTest = UserDataSourceImpl(
      firebaseAuth: mockFirebaseAuth, firestore: mockFirebaseFirestore);

  group('AuthDataSource', () {
    group('Success Test Case', () {
      test('Register Test', () async {
        // when().thenAnswer((realInvocation) => null);

        // final result = await userDataSourceTest.getUserFromDataSource();

        // expect(result,
        //     UserModel(id: id, name: name, email: email, contactNo: contactNo));
      });
    });

    group('Fail Test Case', () {
      test('Register Test', () async {
        // when().thenAnswer((realInvocation) => null);

        // final result = await userDataSourceTest.getUserFromDataSource();

        // expect(result, throwsA(isA<ServerException>()));
      });
    });
  });
}
