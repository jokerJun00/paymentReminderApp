import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/application/screens/budget/cubit/budget_cubit.dart';
import 'package:payment_reminder_app/data/models/budget_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';
import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/budget_usecases.dart';
import 'package:test/test.dart';
import 'package:test/scaffolding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockBudgetUseCases extends Mock implements BudgetUseCases {}

void main() {
  final mockBudgetUseCases = MockBudgetUseCases();

  const budgetingPlan = BudgetingPlanEntity(
    id: "1",
    target_amount: 2000.0,
    starting_amount: 0.0,
    current_spending_amount: 0.0,
    user_id: "1",
  );

  final budgetAmountList = <double>[100.0, 200.0, 300.0, 400.0, 500.0];

  final categoryList = <CategoryModel>[
    CategoryModel(id: "1", name: "subscription", user_id: ""),
    CategoryModel(id: "2", name: "instalment", user_id: ""),
    CategoryModel(id: "3", name: "rental", user_id: ""),
    CategoryModel(id: "4", name: "investment", user_id: ""),
    CategoryModel(id: "5", name: "membership", user_id: ""),
  ];
  final budgetModelList = <BudgetModel>[
    BudgetModel(
      id: "1",
      budgeting_plan_id: "1",
      category_id: "1",
      category_name: "Membership",
      current_amount: 200,
      budget_amount: 2000,
    ),
    BudgetModel(
      id: "2",
      budgeting_plan_id: "1",
      category_id: "2",
      category_name: "Rental",
      current_amount: 100,
      budget_amount: 4000,
    ),
    BudgetModel(
      id: "3",
      budgeting_plan_id: "1",
      category_id: "3",
      category_name: "Investment",
      current_amount: 0,
      budget_amount: 800,
    ),
  ];
  group("BudgetCubit", () {
    group("Success Emit Test Cases", () {
      blocTest<BudgetCubit, BudgetState>(
        'emits BudgetState when no method is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        expect: () => const <BudgetState>[],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateLoadingData, BudgetStateLoaded ] when getBudgetingPlan() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.getBudgetingPlan(),
        setUp: () => when(
          () => mockBudgetUseCases.getBudgetingPlan(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            const Left<BudgetingPlanEntity, Failure>(budgetingPlan),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateLoadingData(),
          BudgetStateLoaded(),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateLoadingData, BudgetStateLoaded ] when getBudgetList() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.getBudgetList("1"),
        setUp: () => when(
          () => mockBudgetUseCases.getBudgetList("1"),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<List<BudgetEntity>, Failure>(budgetModelList),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateLoadingData(),
          BudgetStateLoaded(),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateEditingData, BudgetStateEditSuccess ] when addBudgetingPlan() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.addBudgetingPlan(
          0.0,
          2000.0,
          budgetAmountList,
          categoryList,
        ),
        setUp: () => when(
          () => mockBudgetUseCases.addBudgetingPlan(
            0.0,
            2000.0,
            budgetAmountList,
            categoryList,
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => const <BudgetState>[
          BudgetStateEditingData(),
          BudgetStateEditSuccess(),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateEditingData, BudgetStateEditSuccess ] when editBudgetingPlan() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.editBudgetingPlan(
          "1",
          0.0,
          2000.0,
          budgetAmountList,
          categoryList,
        ),
        setUp: () => when(
          () => mockBudgetUseCases.editBudgetingPlan(
            "1",
            0.0,
            2000.0,
            budgetAmountList,
            categoryList,
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => const <BudgetState>[
          BudgetStateEditingData(),
          BudgetStateEditSuccess(),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateLoadingData, BudgetStateLoaded ] when getCategoryList() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.getCategoryList(),
        setUp: () => when(
          () => mockBudgetUseCases.getCategoryList(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<List<CategoryEntity>, Failure>(categoryList),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateLoadingData(),
          BudgetStateLoaded(),
        ],
      );
    });

    group("Failure Emit Test Cases", () {
      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateLoadingData, BudgetStateError ] when getBudgetingPlan() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.getBudgetingPlan(),
        setUp: () => when(
          () => mockBudgetUseCases.getBudgetingPlan(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<BudgetingPlanEntity, Failure>(
              ServerFailure(
                error: "Fail to load budget plan. Please try again later",
              ),
            ),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateLoadingData(),
          BudgetStateError(
            message: "Fail to load budget plan. Please try again later",
          ),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateLoadingData, BudgetStateError ] when getBudgetList() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.getBudgetList("1"),
        setUp: () => when(
          () => mockBudgetUseCases.getBudgetList("1"),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<List<BudgetEntity>, Failure>(
              ServerFailure(
                error: "Loading budgets data failed. Please try again later",
              ),
            ),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateLoadingData(),
          BudgetStateError(
            message: "Loading budgets data failed. Please try again later",
          ),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateEditingData, BudgetStateError ] when addBudgetingPlan() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.addBudgetingPlan(
          0.0,
          2000.0,
          budgetAmountList,
          categoryList,
        ),
        setUp: () => when(
          () => mockBudgetUseCases.addBudgetingPlan(
            0.0,
            2000.0,
            budgetAmountList,
            categoryList,
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(
                error: "Add Budgeting Plan failed. Please check your input",
              ),
            ),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateEditingData(),
          BudgetStateError(
            message: "Add Budgeting Plan failed. Please check your input",
          ),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateEditingData, BudgetStateError ] when editBudgetingPlan() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.editBudgetingPlan(
          "1",
          0.0,
          2000.0,
          budgetAmountList,
          categoryList,
        ),
        setUp: () => when(
          () => mockBudgetUseCases.editBudgetingPlan(
            "1",
            0.0,
            2000.0,
            budgetAmountList,
            categoryList,
          ),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(
                error: "Edit budget failed. Please check your input",
              ),
            ),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateEditingData(),
          BudgetStateError(
            message: "Edit budget failed. Please check your input",
          ),
        ],
      );

      blocTest<BudgetCubit, BudgetState>(
        'emits [ BudgetStateLoadingData, BudgetStateError ] when getCategoryList() is called',
        build: () => BudgetCubit(budgetUseCases: mockBudgetUseCases),
        act: (cubit) => cubit.getCategoryList(),
        setUp: () => when(
          () => mockBudgetUseCases.getCategoryList(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<List<CategoryEntity>, Failure>(
              ServerFailure(
                error: "Fail to load data. Please try again later",
              ),
            ),
          ),
        ),
        expect: () => const <BudgetState>[
          BudgetStateLoadingData(),
          BudgetStateError(
            message: "Fail to load data. Please try again later",
          ),
        ],
      );
    });
  });
}
