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
  group("UserUsecases", () {
    group("Success Test Cases", () {
      test("Login Success Test Cases", () async {
        when(mockUserRepoImpl.getUserFromDataSource()).thenAnswer(
          (realInvocation) => Future.value(
            const Left(
              UserEntity(
                id: "1",
                name: "Lim Choon Kiat",
                email: "junkiat54@gmail.com",
                contactNo: "0176835363",
              ),
            ),
          ),
        );

        final result = await useUseCaseTest.getUser();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
          result,
          const Left<UserEntity, Failure>(
            UserEntity(
              id: "1",
              name: "Lim Choon Kiat",
              email: "junkiat54@gmail.com",
              contactNo: "0176835363",
            ),
          ),
        );

        verify(mockUserRepoImpl.getUserFromDataSource()).called(1);
        verifyNoMoreInteractions(mockUserRepoImpl);
      });
    });

    group("Failure Test Cases", () {
      test("Login Failure Test Cases", () async {
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
    });
  });
}
