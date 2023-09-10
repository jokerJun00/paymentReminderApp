import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/repositories/auth_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/auth_usecases.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepoImpl>()])
void main() {
  group("AuthUsecases", () {
    final mockAuthRepoImpl = MockAuthRepoImpl();
    final authUseCases = AuthUseCases(authRepo: mockAuthRepoImpl);

    const user = UserEntity(
      id: "1",
      name: "Lim Choon Kiat",
      email: "junkiat54@gmail.com",
      contactNo: "0176835363",
    );

    group("Success Test Cases", () {
      test("Login Success Test Case", () async {
        when(mockAuthRepoImpl.logInFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905"))
            .thenAnswer((realInvocation) => Future.value(const Left(user)));

        final result =
            await authUseCases.logIn("junkiat54@gmail.com", "Kiat@000905");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<UserEntity, Failure>(user));

        verify(mockAuthRepoImpl.logInFromDataSource(
                "junkiat54@gmail.com", "Kiat@000905"))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepoImpl);
      });

      test("Signup Success Test Case", () async {
        when(mockAuthRepoImpl.signUpFromDataSource("Lim Choon Kiat",
                "junkiat54@gmail.com", "60176835363", "Kiat@000905"))
            .thenAnswer((realInvocation) => Future.value(const Left(user)));

        final result = await authUseCases.signUp("Lim Choon Kiat",
            "junkiat54@gmail.com", "60176835363", "Kiat@000905");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<UserEntity, Failure>(user));

        verify(mockAuthRepoImpl.signUpFromDataSource("Lim Choon Kiat",
                "junkiat54@gmail.com", "60176835363", "Kiat@000905"))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepoImpl);
      });

      test("Logout Success Test Case", () async {
        when(mockAuthRepoImpl.logOutFromDataSource())
            .thenAnswer((realInvocation) => Future.value(const Left(true)));

        final result = await authUseCases.logOut();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<bool, Failure>(true));

        verify(mockAuthRepoImpl.logOutFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAuthRepoImpl);
      });
    });

    group("Failure Test Cases", () {
      test("Login Failure Test Case", () async {
        when(mockAuthRepoImpl.logInFromDataSource(
                "junkiat54@gmail.com", "Choon@000905"))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Something went wrong, please try again"))));

        final result =
            await authUseCases.logIn("junkiat54@gmail.com", "Choon@000905");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<UserEntity, Failure>(ServerFailure(
                error: "Something went wrong, please try again")));

        verify(mockAuthRepoImpl.logInFromDataSource(
                "junkiat54@gmail.com", "Choon@000905"))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepoImpl);
      });

      test("Signup Failure Test Case", () async {
        when(mockAuthRepoImpl.signUpFromDataSource(
                "Lim Choon Kiat", "junkiat54@gmail.com", "", "Kiat@000905"))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Something went wrong, please try again"))));

        final result = await authUseCases.signUp(
            "Lim Choon Kiat", "junkiat54@gmail.com", "", "Kiat@000905");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<UserEntity, Failure>(ServerFailure(
                error: "Something went wrong, please try again")));

        verify(mockAuthRepoImpl.signUpFromDataSource(
                "Lim Choon Kiat", "junkiat54@gmail.com", "", "Kiat@000905"))
            .called(1);
        verifyNoMoreInteractions(mockAuthRepoImpl);
      });

      test("Logout Failure Test Case", () async {
        when(mockAuthRepoImpl.logOutFromDataSource())
            .thenAnswer((realInvocation) => Future.value(const Left(false)));

        final result = await authUseCases.logOut();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<bool, Failure>(false));

        verify(mockAuthRepoImpl.logOutFromDataSource()).called(1);
        verifyNoMoreInteractions(mockAuthRepoImpl);
      });
    });
  });
}
