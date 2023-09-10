import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/auth_datasource.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:payment_reminder_app/data/repositories/auth_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthDataSourceImpl>()])
void main() {
  final mockAuthDataSource = MockAuthDataSourceImpl();
  final authRepoImplTest = AuthRepoImpl(authDataSource: mockAuthDataSource);

  group("AuthRepoImpl", () {
    group("Success Test Case", () {
      test("Login Success Test Case", () async {
        when(mockAuthDataSource.logInFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905"))
            .thenAnswer(
          (realInvocation) => Future.value(
            UserModel(
              id: "1",
              name: "Lim Choon Kiat",
              email: "junkiat54@gmail.com",
              contactNo: "0176835363",
            ),
          ),
        );

        final result = await authRepoImplTest.logInFromDataSource(
            "junkiat54@gmail.com", "Kiat@000905");

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

        verify(mockAuthDataSource.logInFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905"))
            .called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      });

      test("Sign Up Success Test Case", () async {
        when(mockAuthDataSource.signUpFromDataSource("Lim Choon Kiat",
                "junkiat54@gmail.com", "60176835363", "Kiat@000905"))
            .thenAnswer(
          (realInvocation) => Future.value(
            UserModel(
              id: "1",
              name: "Lim Choon Kiat",
              email: "junkiat54@gmail.com",
              contactNo: "0176835363",
            ),
          ),
        );

        final result = await authRepoImplTest.signUpFromDataSource(
          "Lim Choon Kiat",
          "junkiat54@gmail.com",
          "60176835363",
          "Kiat@000905",
        );

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

        verify(mockAuthDataSource.signUpFromDataSource(
          "Lim Choon Kiat",
          "junkiat54@gmail.com",
          "60176835363",
          "Kiat@000905",
        )).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      });

      test("Logout Success Test Case", () async {
        when(mockAuthDataSource.logOutFromDataSource())
            .thenAnswer((realInvocation) => Future.value(true));

        final result = await authRepoImplTest.logOutFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
          result,
          const Left<bool, Failure>(true),
        );

        verify(mockAuthDataSource.logOutFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      });
    });

    group("Failure Test Cases", () {
      test("Login Failure Test Case", () async {
        when(mockAuthDataSource.logInFromDataSource(
                "junkiat54@gmail.com", "Choon@000905"))
            .thenThrow(FirebaseAuthException(
                code: "wrong-password",
                message:
                    "The password is invalid or the user does not have a password."));

        final result = await authRepoImplTest.logInFromDataSource(
            "junkiat54@gmail.com", "Choon@000905");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
          result,
          Right<UserEntity, Failure>(
            FirebaseAuthFailure(
              error:
                  "The password is invalid or the user does not have a password.",
            ),
          ),
        );

        verify(mockAuthDataSource.logInFromDataSource(
          "junkiat54@gmail.com",
          "Choon@000905",
        )).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      });

      test("Sign Up Failure Test Case", () async {
        when(mockAuthDataSource.signUpFromDataSource(
          "Lim Choon Kiat",
          "",
          "60176835363",
          "Kiat@000905",
        )).thenThrow(FirebaseAuthException(
            code: "invalid-email", message: "Invalid email"));

        final result = await authRepoImplTest.signUpFromDataSource(
          "Lim Choon Kiat",
          "",
          "60176835363",
          "Kiat@000905",
        );

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
          result,
          Right<UserEntity, Failure>(
              FirebaseAuthFailure(error: "Invalid email")),
        );

        verify(mockAuthDataSource.signUpFromDataSource(
          "Lim Choon Kiat",
          "",
          "60176835363",
          "Kiat@000905",
        )).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      });

      test("Log out Failure Test Case", () async {
        when(mockAuthDataSource.logOutFromDataSource())
            .thenAnswer((realInvocation) => Future.value(false));

        final result = await authRepoImplTest.logOutFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<bool, Failure>(false));
        verify(mockAuthDataSource.logOutFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      });
    });
  });
}
