import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/user_usecases.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'user_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepoImpl>()])
void main() {
  final mockUserRepoImpl = MockUserRepoImpl();
  final useUseCaseTest = UserUseCases(userRepo: mockUserRepoImpl);

  const user = UserEntity(
    id: "1",
    name: "Lim Choon Kiat",
    email: "junkiat54@gmail.com",
    contactNo: "0176835363",
  );
  group("UserUsecases", () {
    group("Success Test Cases", () {
      test("Get User Success Test Case", () async {
        when(mockUserRepoImpl.getUserFromDataSource())
            .thenAnswer((realInvocation) => Future.value(const Left(user)));

        final result = await useUseCaseTest.getUser();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<UserEntity, Failure>(user));

        verify(mockUserRepoImpl.getUserFromDataSource()).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });

      test("Edit User Success Test Case", () async {
        when(
          mockUserRepoImpl.editUserFromDataSource(
            "1",
            "Lim Choon Kiat",
            "junkiat45@gmail.com",
            "60176835363",
            "junkiat54@gmail.com",
            "Kiat@000905",
          ),
        ).thenAnswer((realInvocation) => Future.value(const Left(user)));

        final result = await useUseCaseTest.editUser(
          "1",
          "Lim Choon Kiat",
          "junkiat45@gmail.com",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        );

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<UserEntity, Failure>(user));

        verify(mockUserRepoImpl.editUserFromDataSource(
          "1",
          "Lim Choon Kiat",
          "junkiat45@gmail.com",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        )).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });

      test("Edit Password Success Test Case", () async {
        when(
          mockUserRepoImpl.editPasswordFromDataSource(
            "junkiat54@gmail.com",
            "Kiat@000905",
            "Choon@000905",
          ),
        ).thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await useUseCaseTest.editPassword(
          "junkiat54@gmail.com",
          "Kiat@000905",
          "Choon@000905",
        );

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));

        verify(mockUserRepoImpl.editPasswordFromDataSource(
          "junkiat54@gmail.com",
          "Kiat@000905",
          "Choon@000905",
        )).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });
    });

    group("Failure Test Cases", () {
      test("Get User Failure Test Case", () async {
        when(mockUserRepoImpl.getUserFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to get user data."))));

        final result = await useUseCaseTest.getUser();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
          result,
          Right<UserEntity, Failure>(
              ServerFailure(error: "Fail to get user data.")),
        );

        verify(mockUserRepoImpl.getUserFromDataSource()).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });

      test("Edit User Failure Test Case", () async {
        when(
          mockUserRepoImpl.editUserFromDataSource(
            "1",
            "Lim Choon Kiat",
            "junkiat45@gmail.com",
            "60176835363",
            "junkiat54@gmail.com",
            "Kiat@000905",
          ),
        ).thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
            error:
                "Edit User Profile failed. Make sure your password is correct"))));

        final result = await useUseCaseTest.editUser(
          "1",
          "Lim Choon Kiat",
          "junkiat45@gmail.com",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        );

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<UserEntity, Failure>(ServerFailure(
                error:
                    "Edit User Profile failed. Make sure your password is correct")));

        verify(mockUserRepoImpl.editUserFromDataSource(
          "1",
          "Lim Choon Kiat",
          "junkiat45@gmail.com",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        )).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });
      test("Edit Password Failure Test Case", () async {
        when(
          mockUserRepoImpl.editPasswordFromDataSource(
            "junkiat54@gmail.com",
            "Kiat@000905",
            "Choon@000905",
          ),
        ).thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
            error:
                "Edit password failed. Make sure your old password is correct and new password must not be same as old password"))));

        final result = await useUseCaseTest.editPassword(
          "junkiat54@gmail.com",
          "Kiat@000905",
          "Choon@000905",
        );

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error:
                    "Edit password failed. Make sure your old password is correct and new password must not be same as old password")));

        verify(mockUserRepoImpl.editPasswordFromDataSource(
          "junkiat54@gmail.com",
          "Kiat@000905",
          "Choon@000905",
        )).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });
    });
  });
}
