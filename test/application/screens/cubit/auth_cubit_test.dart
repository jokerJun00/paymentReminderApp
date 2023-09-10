import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:payment_reminder_app/application/screens/auth/cubit/auth_cubit.dart';
import 'package:payment_reminder_app/domain/entities/user_entitiy.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/auth_usecases.dart';
import 'package:test/scaffolding.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAuthUseCases extends Mock implements AuthUseCases {}

void main() {
  final mockAuthUseCases = MockAuthUseCases();

  group("AuthCubit", () {
    const user = UserEntity(
      id: "1",
      name: "Lim Choon Kiat",
      email: "junkiat54@gmail.com",
      contactNo: "0176835363",
    );

    group("Success Emit Test Cases", () {
      blocTest<AuthCubit, AuthState>(
        'emits AuthState when no method is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        expect: () => const <AuthState>[],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [ AuthStateLoading, AuthStateLoginedIn ] when logIn() is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        act: (cubit) => cubit.logIn("junkiat54@gmail.com", "Kiat@000905"),
        setUp: () => when(
          () => mockAuthUseCases.logIn("junkiat54@gmail.com", "Kiat@000905"),
        ).thenAnswer(
          (realInvocation) =>
              Future.value(const Left<UserEntity, Failure>(user)),
        ),
        expect: () => const <AuthState>[
          AuthStateLoading(),
          AuthStateLoginedIn(user: user),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [ AuthStateLoading, AuthStateLoginedIn ] when signUp() is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        act: (cubit) => cubit.signUp(
          "Lim Choon Kiat",
          "junkiat54@gmail.com",
          "60176835363",
          "Kiat@000905",
        ),
        setUp: () => when(
          () => mockAuthUseCases.signUp(
            "Lim Choon Kiat",
            "junkiat54@gmail.com",
            "60176835363",
            "Kiat@000905",
          ),
        ).thenAnswer(
          (realInvocation) =>
              Future.value(const Left<UserEntity, Failure>(user)),
        ),
        expect: () => const <AuthState>[
          AuthStateLoading(),
          AuthStateLoginedIn(user: user),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [ AuthStateLoading, AuthStateLogOut ] when signUp() is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        act: (cubit) => cubit.logOut(),
        setUp: () => when(
          () => mockAuthUseCases.logOut(),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<bool, Failure>(true)),
        ),
        expect: () => const <AuthState>[AuthStateLoading(), AuthStateLogOut()],
      );
    });

    group("Error Emit Test Cases", () {
      blocTest<AuthCubit, AuthState>(
        'emits [ AuthStateLoading, AuthStateError ] when logIn() is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        act: (cubit) => cubit.logIn("junkiat54@gmail.com", "Kiat@000905"),
        setUp: () => when(
          () => mockAuthUseCases.logIn("junkiat54@gmail.com", "Kiat@000905"),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<UserEntity, Failure>(
              ServerFailure(error: "Something went wrong, please try again"),
            ),
          ),
        ),
        expect: () => const <AuthState>[
          AuthStateLoading(),
          AuthStateError(message: "Something went wrong, please try again"),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [ AuthStateLoading, AuthStateError ] when signUp() is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        act: (cubit) => cubit.signUp(
          "Lim Choon Kiat",
          "",
          "60176835363",
          "Kiat@000905",
        ),
        setUp: () => when(
          () => mockAuthUseCases.signUp(
            "Lim Choon Kiat",
            "",
            "60176835363",
            "Kiat@000905",
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<UserEntity, Failure>(
              ServerFailure(error: "Something went wrong, please try again"),
            ),
          ),
        ),
        expect: () => const <AuthState>[
          AuthStateLoading(),
          AuthStateError(message: "Something went wrong, please try again"),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [ AuthStateLoading, AuthStateError ] when logOut() is called',
        build: () => AuthCubit(authUseCases: mockAuthUseCases),
        act: (cubit) => cubit.logOut(),
        setUp: () => when(
          () => mockAuthUseCases.logOut(),
        ).thenAnswer(
          (realInvocation) =>
              Future.value(Right<bool, Failure>(ServerFailure(error: ""))),
        ),
        expect: () => const <AuthState>[
          AuthStateLoading(),
          AuthStateError(message: ""),
        ],
      );
    });
  });
}
