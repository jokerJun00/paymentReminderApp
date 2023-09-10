import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/application/screens/user/cubit/user_cubit.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/user_usecases.dart';
import 'package:test/scaffolding.dart';
import 'package:mocktail/mocktail.dart';

class MockUserUseCases extends Mock implements UserUseCases {}

void main() {
  final mockUserUseCases = MockUserUseCases();
  group("UserCubit", () {
    const user = UserEntity(
      id: "1",
      name: "Lim Choon Kiat",
      email: "junkiat54@gmail.com",
      contactNo: "0176835363",
    );

    const userModel = UserModel(
      id: "1",
      name: "Lim Choon Kiat",
      email: "junkiat54@gmail.com",
      contactNo: "0176835363",
    );
    group("Success Emit Test Cases", () {
      blocTest<UserCubit, UserState>(
        'emits UserState when no method is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        expect: () => const <UserState>[],
      );

      blocTest<UserCubit, UserState>(
        'emits [ UserStateLoadingData, UserStateInitial ] when getBudgetingPlan() is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        act: (cubit) => cubit.getUser(),
        setUp: () => when(
          () => mockUserUseCases.getUser(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const Left<UserEntity, Failure>(user),
          ),
        ),
        expect: () => const <UserState>[
          UserStateLoadingData(),
          UserStateInitial(user: user),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [ UserStateEditingData, UserStateEditSuccess, UserStateInitial ] when editUserProfile() is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        act: (cubit) => cubit.editUserProfile(
          "1",
          "Lim Choon Kiat",
          "junkiat45@gmail.com",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        ),
        setUp: () => when(
          () => mockUserUseCases.editUser(
            "1",
            "Lim Choon Kiat",
            "junkiat45@gmail.com",
            "60176835363",
            "junkiat54@gmail.com",
            "Kiat@000905",
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const Left<UserEntity, Failure>(user),
          ),
        ),
        expect: () => const <UserState>[
          UserStateEditingData(),
          UserStateEditSuccess(),
          UserStateInitial(user: user),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [ UserStateEditingData, UserStateEditSuccess, UserStateInitial ] when editPassword() is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        act: (cubit) => cubit.editPassword(
          userModel,
          "junkiat54@gmail.com",
          "Kiat@000905",
          "Choon@000905",
        ),
        setUp: () => when(
          () => mockUserUseCases.editPassword(
            "junkiat54@gmail.com",
            "Kiat@000905",
            "Choon@000905",
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const Left<UserEntity, Failure>(user),
          ),
        ),
        expect: () => const <UserState>[
          UserStateEditingData(),
          UserStateEditSuccess(),
          UserStateInitial(user: userModel),
        ],
      );
    });

    group("Failure Emit Test Cases", () {
      blocTest<UserCubit, UserState>(
        'emits [ UserStateLoadingData, UserStateError ] when getBudgetingPlan() is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        act: (cubit) => cubit.getUser(),
        setUp: () => when(
          () => mockUserUseCases.getUser(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<UserEntity, Failure>(
                ServerFailure(error: "Fail to get user data.")),
          ),
        ),
        expect: () => const <UserState>[
          UserStateLoadingData(),
          UserStateError(message: "Fail to get user data."),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [ UserStateEditingData, UserStateEditSuccess, UserStateError ] when editUserProfile() is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        act: (cubit) => cubit.editUserProfile(
          "1",
          "Lim Choon Kiat",
          "",
          "60176835363",
          "junkiat54@gmail.com",
          "Kiat@000905",
        ),
        setUp: () => when(
          () => mockUserUseCases.editUser(
            "1",
            "Lim Choon Kiat",
            "",
            "60176835363",
            "junkiat54@gmail.com",
            "Kiat@000905",
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<UserEntity, Failure>(
              ServerFailure(
                error:
                    "Edit User Profile failed. Make sure your password is correct",
              ),
            ),
          ),
        ),
        expect: () => const <UserState>[
          UserStateEditingData(),
          UserStateError(
            message:
                "Edit User Profile failed. Make sure your password is correct",
          ),
        ],
      );

      blocTest<UserCubit, UserState>(
        'emits [ UserStateEditingData, UserStateEditSuccess, UserStateError ] when editPassword() is called',
        build: () => UserCubit(userUseCases: mockUserUseCases),
        act: (cubit) => cubit.editPassword(
          userModel,
          "junkiat54@gmail.com",
          "Kiat@000905",
          "Choon@000905",
        ),
        setUp: () => when(
          () => mockUserUseCases.editPassword(
            "junkiat54@gmail.com",
            "Kiat@000905",
            "Choon@000905",
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<UserEntity, Failure>(
              ServerFailure(
                error:
                    "Edit password failed. Make sure your old password is correct and new password must not be same as old password",
              ),
            ),
          ),
        ),
        expect: () => const <UserState>[
          UserStateEditingData(),
          UserStateError(
            message:
                "Edit password failed. Make sure your old password is correct and new password must not be same as old password",
          ),
        ],
      );
    });
  });
}
