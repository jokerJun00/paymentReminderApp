import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements UserModel {}

final MockUser _mockUser = MockUser();

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

  group('AuthDataSource', () {
    group('Success Test Case', () {
      test('Register Test', () {});
    });

    group('Fail Test Case', () {
      test('Register Test', () {});
    });
  });
}
