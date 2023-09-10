import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'user_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserDataSourceImpl>()])
void main() {
  final mockUserDataSource = MockUserDataSourceImpl();
  final userRepoImplTest = UserRepoImpl(userDataSource: mockUserDataSource);

  group('UserRepoImpl', () {
    group('Success Test Case', () {
      test("Get User Success Test Case", () async {
        when(mockUserDataSource.getUserFromDataSource()).thenAnswer(
          (realInvocation) => Future.value(
            UserModel(
              id: "1",
              name: "Lim Choon Kiat",
              email: "junkiat54@gmail.com",
              contactNo: "0176835363",
            ),
          ),
        );

        final result = await userRepoImplTest.getUserFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
          result,
          Left<UserModel, Failure>(
            UserModel(
              id: "1",
              name: "Lim Choon Kiat",
              email: "junkiat54@gmail.com",
              contactNo: "0176835363",
            ),
          ),
        );

        verify(mockUserDataSource.getUserFromDataSource()).called(1);
        verifyNoMoreInteractions(mockUserDataSource);
      });

      test("Edit User Success Test Case", () async {
        when(mockUserDataSource.editUserFromDataSource(
          "1",
          "Choon Kiat",
          "junkiat45@gmail.com",
          "176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        )).thenAnswer(
          (realInvocation) => Future.value(
            UserModel(
              id: "1",
              name: "Choon Kiat",
              email: "junkiat45@gmail.com",
              contactNo: "176835363",
            ),
          ),
        );

        final result = await userRepoImplTest.editUserFromDataSource(
          "1",
          "Choon Kiat",
          "junkiat45@gmail.com",
          "176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        );

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
          result,
          Left<UserModel, Failure>(
            UserModel(
              id: "1",
              name: "Choon Kiat",
              email: "junkiat45@gmail.com",
              contactNo: "176835363",
            ),
          ),
        );

        verify(mockUserDataSource.editUserFromDataSource(
          "1",
          "Choon Kiat",
          "junkiat45@gmail.com",
          "176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        )).called(1);
        verifyNoMoreInteractions(mockUserDataSource);
      });

      test("Edit User Password Success Test Case", () async {
        when(mockUserDataSource.editPasswordFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905", "Choon@000905"))
            .thenAnswer((realInvocation) => Future.value());

        final result = mockUserDataSource.editPasswordFromDataSource(
            "junkiat54@gmail.com", "Kiat@000905", "Choon@000905");

        expect(result, isA<Future<void>>());

        verify(mockUserDataSource.editPasswordFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905", "Choon@000905"))
            .called(1);
        verifyNoMoreInteractions(mockUserDataSource);
      });
    });

    group('Failure Test Case', () {
      test('Get User Failure Test Case', () async {
        when(mockUserDataSource.getUserFromDataSource())
            .thenThrow(ServerException());

        final result = await userRepoImplTest.getUserFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<UserModel, Failure>(
                ServerFailure(error: "Fail to get user data.")));
      });

      test('Edit User Failure Test Case', () async {
        when(mockUserDataSource.editUserFromDataSource(
          "1",
          "Choon Kiat",
          "",
          "176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        )).thenThrow(ServerException());

        final result = await userRepoImplTest.editUserFromDataSource(
          "1",
          "Choon Kiat",
          "",
          "176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        );

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<UserModel, Failure>(ServerFailure(
                error:
                    "Edit User Profile failed. Make sure your password is correct")));
      });

      test('Edit Password Failure Test Case', () async {
        when(mockUserDataSource.editPasswordFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905", "Kiat@000905"))
            .thenThrow(ServerException());

        when(mockUserDataSource.editPasswordFromDataSource(
            "junkiat54@gmail.com", "Kiat@000905", "Kiat@000905"));

        final result = await userRepoImplTest.editPasswordFromDataSource(
            "junkiat54@gmail.com", "Kiat@000905", "Kiat@000905");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error:
                    "Edit password failed. Make sure your old password is correct and new password must not be same as old password")));
      });
    });
  });
}
