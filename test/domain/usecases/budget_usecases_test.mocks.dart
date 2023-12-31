// Mocks generated by Mockito 5.4.2 from annotations
// in payment_reminder_app/test/domain/usecases/budget_usecases_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:payment_reminder_app/data/datasources/budget_datasource.dart'
    as _i2;
import 'package:payment_reminder_app/data/models/category_model.dart' as _i7;
import 'package:payment_reminder_app/data/repositories/budget_repo_impl.dart'
    as _i4;
import 'package:payment_reminder_app/domain/entities/budget_entity.dart' as _i8;
import 'package:payment_reminder_app/domain/entities/budgeting_plan_entity.dart'
    as _i9;
import 'package:payment_reminder_app/domain/entities/category_entity.dart'
    as _i10;
import 'package:payment_reminder_app/domain/failures/failures.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBudgetDataSource_0 extends _i1.SmartFake
    implements _i2.BudgetDataSource {
  _FakeBudgetDataSource_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BudgetRepoImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockBudgetRepoImpl extends _i1.Mock implements _i4.BudgetRepoImpl {
  @override
  _i2.BudgetDataSource get budgetDataSource => (super.noSuchMethod(
        Invocation.getter(#budgetDataSource),
        returnValue: _FakeBudgetDataSource_0(
          this,
          Invocation.getter(#budgetDataSource),
        ),
        returnValueForMissingStub: _FakeBudgetDataSource_0(
          this,
          Invocation.getter(#budgetDataSource),
        ),
      ) as _i2.BudgetDataSource);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> editBudgetingPlanFromDataSource(
    String? budgetingPlanId,
    double? startAmount,
    double? targetAmount,
    List<double>? categoryBudgetAmountList,
    List<_i7.CategoryModel>? categoryList,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #editBudgetingPlanFromDataSource,
          [
            budgetingPlanId,
            startAmount,
            targetAmount,
            categoryBudgetAmountList,
            categoryList,
          ],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #editBudgetingPlanFromDataSource,
            [
              budgetingPlanId,
              startAmount,
              targetAmount,
              categoryBudgetAmountList,
              categoryList,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #editBudgetingPlanFromDataSource,
            [
              budgetingPlanId,
              startAmount,
              targetAmount,
              categoryBudgetAmountList,
              categoryList,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> addBudgetingPlanFromDataSource(
    double? startAmount,
    double? targetAmount,
    List<double>? categoryBudgetAmountList,
    List<_i7.CategoryModel>? categoryList,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addBudgetingPlanFromDataSource,
          [
            startAmount,
            targetAmount,
            categoryBudgetAmountList,
            categoryList,
          ],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #addBudgetingPlanFromDataSource,
            [
              startAmount,
              targetAmount,
              categoryBudgetAmountList,
              categoryList,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #addBudgetingPlanFromDataSource,
            [
              startAmount,
              targetAmount,
              categoryBudgetAmountList,
              categoryList,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<
      _i3
      .Either<List<_i8.BudgetEntity>, _i6.Failure>> getBudgetListFromDataSource(
          String? budgetingPlanId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBudgetListFromDataSource,
          [budgetingPlanId],
        ),
        returnValue:
            _i5.Future<_i3.Either<List<_i8.BudgetEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i8.BudgetEntity>, _i6.Failure>(
          this,
          Invocation.method(
            #getBudgetListFromDataSource,
            [budgetingPlanId],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<List<_i8.BudgetEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i8.BudgetEntity>, _i6.Failure>(
          this,
          Invocation.method(
            #getBudgetListFromDataSource,
            [budgetingPlanId],
          ),
        )),
      ) as _i5.Future<_i3.Either<List<_i8.BudgetEntity>, _i6.Failure>>);
  @override
  _i5.Future<
      _i3.Either<_i9.BudgetingPlanEntity?,
          _i6.Failure>> getBudgetingPlanFromDataSource() => (super.noSuchMethod(
        Invocation.method(
          #getBudgetingPlanFromDataSource,
          [],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i9.BudgetingPlanEntity?, _i6.Failure>>.value(
                _FakeEither_1<_i9.BudgetingPlanEntity?, _i6.Failure>(
          this,
          Invocation.method(
            #getBudgetingPlanFromDataSource,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i9.BudgetingPlanEntity?, _i6.Failure>>.value(
                _FakeEither_1<_i9.BudgetingPlanEntity?, _i6.Failure>(
          this,
          Invocation.method(
            #getBudgetingPlanFromDataSource,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i9.BudgetingPlanEntity?, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>
      getCategoryListFromDataSource() => (super.noSuchMethod(
            Invocation.method(
              #getCategoryListFromDataSource,
              [],
            ),
            returnValue: _i5.Future<
                    _i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i10.CategoryEntity>, _i6.Failure>(
              this,
              Invocation.method(
                #getCategoryListFromDataSource,
                [],
              ),
            )),
            returnValueForMissingStub: _i5.Future<
                    _i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i10.CategoryEntity>, _i6.Failure>(
              this,
              Invocation.method(
                #getCategoryListFromDataSource,
                [],
              ),
            )),
          ) as _i5.Future<_i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>);
}
