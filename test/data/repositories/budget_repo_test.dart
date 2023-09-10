import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/budget_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/budget_model.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/repositories/budget_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/budget_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'budget_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<BudgetDataSourceImpl>()])
void main() {
  final mockBudgetDataSourceImpl = MockBudgetDataSourceImpl();
  final budgetRepoImplTest =
      BudgetRepoImpl(budgetDataSource: mockBudgetDataSourceImpl);

  group("BudgetRepoImpl", () {
    group("Success Test Case", () {
      final budgetingPlan = BudgetingPlanModel(
        id: "1",
        target_amount: 2000.0,
        starting_amount: 0.0,
        current_spending_amount: 0.0,
        user_id: "1",
      );
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
      final budgetAmountList = <double>[100.0, 200.0, 300.0, 400.0, 500.0];

      final categoryList = <CategoryModel>[
        CategoryModel(id: "1", name: "subscription", user_id: ""),
        CategoryModel(id: "2", name: "instalment", user_id: ""),
        CategoryModel(id: "3", name: "rental", user_id: ""),
        CategoryModel(id: "4", name: "investment", user_id: ""),
        CategoryModel(id: "5", name: "membership", user_id: ""),
      ];
      test("Get Budgeting Plan Success Test Case", () async {
        when(mockBudgetDataSourceImpl.getBudgetingPlanFromDataSource())
            .thenAnswer(
          (realInvocation) => Future.value(budgetingPlan),
        );

        final result =
            await budgetRepoImplTest.getBudgetingPlanFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
          result,
          Left<BudgetingPlanModel, Failure>(budgetingPlan),
        );

        verify(mockBudgetDataSourceImpl.getBudgetingPlanFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Get Budget List Success Test Case", () async {
        when(mockBudgetDataSourceImpl.getBudgetListFromDataSource("1"))
            .thenAnswer(
          (realInvocation) => Future.value(budgetModelList),
        );

        final result =
            await budgetRepoImplTest.getBudgetListFromDataSource("1");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<BudgetEntity>, Failure>(budgetModelList));

        verify(mockBudgetDataSourceImpl.getBudgetListFromDataSource("1"))
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Add Budgeting Plan Success Test Case", () async {
        when(
          mockBudgetDataSourceImpl.addBudgetingPlanFromDataSource(
              0.0, 2000.0, budgetAmountList, categoryList),
        ).thenAnswer((realInvocation) => Future.value());

        final result = await budgetRepoImplTest.addBudgetingPlanFromDataSource(
            0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));

        verify(mockBudgetDataSourceImpl.addBudgetingPlanFromDataSource(
                0.0, 2000.0, budgetAmountList, categoryList))
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Edit Budgeting Plan Success Test Case", () async {
        when(mockBudgetDataSourceImpl.editBudgetingPlanFromDataSource(
                "1", 0.0, 2000.0, budgetAmountList, categoryList))
            .thenAnswer((realInvocation) => Future.value());

        final result = await budgetRepoImplTest.editBudgetingPlanFromDataSource(
            "1", 0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));

        verify(mockBudgetDataSourceImpl.editBudgetingPlanFromDataSource(
                "1", 0.0, 2000.0, budgetAmountList, categoryList))
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Get Category List Success Test Case", () async {
        when(mockBudgetDataSourceImpl.getCategoryListFromDataSource())
            .thenAnswer((realInvocation) => Future.value(categoryList));

        final result = await budgetRepoImplTest.getCategoryListFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<CategoryModel>, Failure>(categoryList));

        verify(mockBudgetDataSourceImpl.getCategoryListFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });
    });

    group("Failure Test Case", () {
      final budgetAmountList = <double>[-100.0, -200.0, -300.0, -400.0, -500.0];
      final categoryList = <CategoryModel>[
        CategoryModel(id: "1", name: "subscription", user_id: ""),
        CategoryModel(id: "2", name: "instalment", user_id: ""),
        CategoryModel(id: "3", name: "rental", user_id: ""),
        CategoryModel(id: "4", name: "investment", user_id: ""),
        CategoryModel(id: "5", name: "membership", user_id: ""),
      ];

      test("Get Budgeting Plan Failure Test Case", () async {
        when(mockBudgetDataSourceImpl.getBudgetingPlanFromDataSource())
            .thenThrow(ServerException());

        final result =
            await budgetRepoImplTest.getBudgetingPlanFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
          result,
          Right<BudgetingPlanModel, Failure>(ServerFailure(
              error: "Fail to load budget plan. Please try again later")),
        );

        verify(mockBudgetDataSourceImpl.getBudgetingPlanFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Get Budget List Failure Test Case", () async {
        when(mockBudgetDataSourceImpl.getBudgetListFromDataSource(""))
            .thenThrow(ServerException());

        final result = await budgetRepoImplTest.getBudgetListFromDataSource("");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<BudgetEntity>, Failure>(ServerFailure(
                error: "Loading budgets data failed. Please try again later")));

        verify(mockBudgetDataSourceImpl.getBudgetListFromDataSource(""))
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });
      test("Add Budgeting Plan Failure Test Case", () async {
        when(
          mockBudgetDataSourceImpl.addBudgetingPlanFromDataSource(
              0.0, 2000.0, budgetAmountList, categoryList),
        ).thenThrow(ServerException());

        final result = await budgetRepoImplTest.addBudgetingPlanFromDataSource(
            0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Add Budgeting Plan failed. Please check your input")));

        verify(mockBudgetDataSourceImpl.addBudgetingPlanFromDataSource(
                -0.0, 2000.0, budgetAmountList, categoryList))
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Edit Budgeting Plan Failure Test Case", () async {
        when(mockBudgetDataSourceImpl.editBudgetingPlanFromDataSource(
                "1", 0.0, 2000.0, budgetAmountList, categoryList))
            .thenThrow(ServerException());

        final result = await budgetRepoImplTest.editBudgetingPlanFromDataSource(
            "1", 0.0, 2000.0, budgetAmountList, categoryList);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Edit budget failed. Please check your input")));

        verify(mockBudgetDataSourceImpl.editBudgetingPlanFromDataSource(
                "1", 0.0, 2000.0, budgetAmountList, categoryList))
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });

      test("Get Category List Failure Test Case", () async {
        when(mockBudgetDataSourceImpl.getCategoryListFromDataSource())
            .thenThrow(ServerException());

        final result = await budgetRepoImplTest.getCategoryListFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<CategoryModel>, Failure>(ServerFailure(
                error: "Fail to load data. Please try again later")));

        verify(mockBudgetDataSourceImpl.getCategoryListFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockBudgetDataSourceImpl);
      });
    });
  });
}
