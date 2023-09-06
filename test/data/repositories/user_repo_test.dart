import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

class MockUserDataSourceImpl extends Mock implements UserDataSourceImpl {}

void main() {
  final mockUserDataSource = MockUserDataSourceImpl();
  // final userRepoImplTest = UserRepoImpl();
  group('UserRepoImple', () {
    group('Success Test Case', () {
      test('Register', () {});
    });
  });
}
