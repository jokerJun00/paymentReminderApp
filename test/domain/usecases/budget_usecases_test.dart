import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/budget_model.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/repositories/budget_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';
import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/budget_usecases.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'budget_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BudgetRepoImpl>()])
void main() {
  final mockBudgetRepoImpl = MockBudgetRepoImpl();
  final budgetUseCasesTest = BudgetUseCases(budgetRepo: mockBudgetRepoImpl);
  group("BudgetUseCases", () {
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
    final budgetingPlan = BudgetingPlanModel(
      id: "1",
      target_amount: 2000.0,
      starting_amount: 0.0,
      current_spending_amount: 0.0,
      user_id: "1",
    );
    group("Success Test Cases", () {
      test("Edit Budgeting Plan Success Test Case", () async {
        when(mockBudgetRepoImpl.editBudgetingPlanFromDataSource(
                "1", 0.0, 2000.0, budgetAmountList, categoryList))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await budgetUseCasesTest.editBudgetingPlan(
            "1", 0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockBudgetRepoImpl.editBudgetingPlanFromDataSource(
            "1", 0.0, 2000.0, budgetAmountList, categoryList));
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });

      test("Add Budgeting Plan Success Test Case", () async {
        when(mockBudgetRepoImpl.addBudgetingPlanFromDataSource(
                0.0, 2000.0, budgetAmountList, categoryList))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await budgetUseCasesTest.addBudgetingPlan(
            0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockBudgetRepoImpl.addBudgetingPlanFromDataSource(
            0.0, 2000.0, budgetAmountList, categoryList));
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
      test("Get Budget List Success Test Case", () async {
        when(mockBudgetRepoImpl.getBudgetListFromDataSource("1")).thenAnswer(
            (realInvocation) => Future.value(Left(budgetModelList)));

        final result = await budgetUseCasesTest.getBudgetList("1");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<BudgetEntity>, Failure>(budgetModelList));
        verify(mockBudgetRepoImpl.getBudgetListFromDataSource("1"));
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
      test("Get Budgeting Plan Success Test Case", () async {
        when(mockBudgetRepoImpl.getBudgetingPlanFromDataSource())
            .thenAnswer((realInvocation) => Future.value(Left(budgetingPlan)));

        final result = await budgetUseCasesTest.getBudgetingPlan();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<BudgetingPlanEntity, Failure>(budgetingPlan));
        verify(mockBudgetRepoImpl.getBudgetingPlanFromDataSource());
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
      test("Get Category List Success Test Case", () async {
        when(mockBudgetRepoImpl.getCategoryListFromDataSource())
            .thenAnswer((realInvocation) => Future.value(Left(categoryList)));

        final result = await budgetUseCasesTest.getCategoryList();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<CategoryEntity>, Failure>(categoryList));
        verify(mockBudgetRepoImpl.getCategoryListFromDataSource());
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
    });
    group("Failure Test Cases", () {
      test("Edit Budgeting Plan Failure Test Case", () async {
        when(mockBudgetRepoImpl.editBudgetingPlanFromDataSource(
                "1", 0.0, 2000.0, budgetAmountList, categoryList))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Edit budget failed. Please check your input"))));

        final result = await budgetUseCasesTest.editBudgetingPlan(
            "1", 0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Edit budget failed. Please check your input")));
        verify(mockBudgetRepoImpl.editBudgetingPlanFromDataSource(
            "1", 0.0, 2000.0, budgetAmountList, categoryList));
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
      test("Add Budgeting Plan Failure Test Case", () async {
        when(mockBudgetRepoImpl.addBudgetingPlanFromDataSource(
                0.0, 2000.0, budgetAmountList, categoryList))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Add Budgeting Plan failed. Please check your input"))));

        final result = await budgetUseCasesTest.addBudgetingPlan(
            0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Add Budgeting Plan failed. Please check your input")));
        verify(mockBudgetRepoImpl.addBudgetingPlanFromDataSource(
            0.0, 2000.0, budgetAmountList, categoryList));
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });

      test("Get Budget List Failure Test Case", () async {
        when(mockBudgetRepoImpl.getBudgetListFromDataSource("1")).thenAnswer(
            (realInvocation) => Future.value(Right(ServerFailure(
                error:
                    "Loading budgets data failed. Please try again later"))));

        final result = await budgetUseCasesTest.getBudgetList("1");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<BudgetEntity>, Failure>(ServerFailure(
                error: "Loading budgets data failed. Please try again later")));
        verify(mockBudgetRepoImpl.getBudgetListFromDataSource("1"));
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });

      test("Get Budgeting Plan Failure Test Case", () async {
        when(mockBudgetRepoImpl.getBudgetingPlanFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(Right(ServerFailure(
                error: "Fail to load budget plan. Please try again later"))));

        final result = await budgetUseCasesTest.getBudgetingPlan();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<BudgetingPlanEntity, Failure>(ServerFailure(
                error: "Fail to load budget plan. Please try again later")));
        verify(mockBudgetRepoImpl.getBudgetingPlanFromDataSource());
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
      test("Get Category List Failure Test Case", () async {
        when(mockBudgetRepoImpl.getCategoryListFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(Right(ServerFailure(
                error: "Fail to load data. Please try again later"))));

        final result = await budgetUseCasesTest.getCategoryList();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<CategoryEntity>, Failure>(ServerFailure(
                error: "Fail to load data. Please try again later")));
        verify(mockBudgetRepoImpl.getCategoryListFromDataSource());
        verifyNoMoreInteractions(mockBudgetRepoImpl);
      });
    });
  });
}
