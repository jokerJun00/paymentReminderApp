// Mocks generated by Mockito 5.4.2 from annotations
// in payment_reminder_app/test/domain/usecases/payment_usecases_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart'
    as _i2;
import 'package:payment_reminder_app/data/models/bank_model.dart' as _i11;
import 'package:payment_reminder_app/data/models/category_model.dart' as _i12;
import 'package:payment_reminder_app/data/models/paid_payment.dart' as _i13;
import 'package:payment_reminder_app/data/models/payment_model.dart' as _i7;
import 'package:payment_reminder_app/data/models/receiver_model.dart' as _i8;
import 'package:payment_reminder_app/data/repositories/payment_repo_impl.dart'
    as _i4;
import 'package:payment_reminder_app/domain/entities/category_entity.dart'
    as _i10;
import 'package:payment_reminder_app/domain/entities/payment_entity.dart'
    as _i9;
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

class _FakePaymentDataSource_0 extends _i1.SmartFake
    implements _i2.PaymentDataSource {
  _FakePaymentDataSource_0(
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

/// A class which mocks [PaymentRepoImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockPaymentRepoImpl extends _i1.Mock implements _i4.PaymentRepoImpl {
  @override
  _i2.PaymentDataSource get paymentDataSource => (super.noSuchMethod(
        Invocation.getter(#paymentDataSource),
        returnValue: _FakePaymentDataSource_0(
          this,
          Invocation.getter(#paymentDataSource),
        ),
        returnValueForMissingStub: _FakePaymentDataSource_0(
          this,
          Invocation.getter(#paymentDataSource),
        ),
      ) as _i2.PaymentDataSource);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> addPaymentFromDataSource(
    _i7.PaymentModel? newPayment,
    _i8.ReceiverModel? receiver,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addPaymentFromDataSource,
          [
            newPayment,
            receiver,
          ],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #addPaymentFromDataSource,
            [
              newPayment,
              receiver,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #addPaymentFromDataSource,
            [
              newPayment,
              receiver,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> deletePaymentFromDataSource(
          _i7.PaymentModel? payment) =>
      (super.noSuchMethod(
        Invocation.method(
          #deletePaymentFromDataSource,
          [payment],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #deletePaymentFromDataSource,
            [payment],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #deletePaymentFromDataSource,
            [payment],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> editPaymentFromDataSource(
    _i7.PaymentModel? editedPaymentInfo,
    _i8.ReceiverModel? editedReceiverInfo,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #editPaymentFromDataSource,
          [
            editedPaymentInfo,
            editedReceiverInfo,
          ],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #editPaymentFromDataSource,
            [
              editedPaymentInfo,
              editedReceiverInfo,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #editPaymentFromDataSource,
            [
              editedPaymentInfo,
              editedReceiverInfo,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<
      _i3.Either<Map<String, List<_i9.PaymentEntity>>,
          _i6.Failure>> getGroupedPaymentsFromDataSource() =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupedPaymentsFromDataSource,
          [],
        ),
        returnValue: _i5.Future<
                _i3.Either<Map<String, List<_i9.PaymentEntity>>,
                    _i6.Failure>>.value(
            _FakeEither_1<Map<String, List<_i9.PaymentEntity>>, _i6.Failure>(
          this,
          Invocation.method(
            #getGroupedPaymentsFromDataSource,
            [],
          ),
        )),
        returnValueForMissingStub: _i5.Future<
                _i3.Either<Map<String, List<_i9.PaymentEntity>>,
                    _i6.Failure>>.value(
            _FakeEither_1<Map<String, List<_i9.PaymentEntity>>, _i6.Failure>(
          this,
          Invocation.method(
            #getGroupedPaymentsFromDataSource,
            [],
          ),
        )),
      ) as _i5.Future<
          _i3.Either<Map<String, List<_i9.PaymentEntity>>, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>
      getAllCategoriesFromDataSource() => (super.noSuchMethod(
            Invocation.method(
              #getAllCategoriesFromDataSource,
              [],
            ),
            returnValue: _i5.Future<
                    _i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i10.CategoryEntity>, _i6.Failure>(
              this,
              Invocation.method(
                #getAllCategoriesFromDataSource,
                [],
              ),
            )),
            returnValueForMissingStub: _i5.Future<
                    _i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i10.CategoryEntity>, _i6.Failure>(
              this,
              Invocation.method(
                #getAllCategoriesFromDataSource,
                [],
              ),
            )),
          ) as _i5.Future<_i3.Either<List<_i10.CategoryEntity>, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> addCategory(String? categoryName) =>
      (super.noSuchMethod(
        Invocation.method(
          #addCategory,
          [categoryName],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #addCategory,
            [categoryName],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #addCategory,
            [categoryName],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<List<_i11.BankModel>, _i6.Failure>> getBankList() =>
      (super.noSuchMethod(
        Invocation.method(
          #getBankList,
          [],
        ),
        returnValue:
            _i5.Future<_i3.Either<List<_i11.BankModel>, _i6.Failure>>.value(
                _FakeEither_1<List<_i11.BankModel>, _i6.Failure>(
          this,
          Invocation.method(
            #getBankList,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<List<_i11.BankModel>, _i6.Failure>>.value(
                _FakeEither_1<List<_i11.BankModel>, _i6.Failure>(
          this,
          Invocation.method(
            #getBankList,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Either<List<_i11.BankModel>, _i6.Failure>>);
  @override
  _i5.Future<
      _i3.Either<List<_i12.CategoryModel>,
          _i6.Failure>> getCategoryList() => (super.noSuchMethod(
        Invocation.method(
          #getCategoryList,
          [],
        ),
        returnValue:
            _i5.Future<_i3.Either<List<_i12.CategoryModel>, _i6.Failure>>.value(
                _FakeEither_1<List<_i12.CategoryModel>, _i6.Failure>(
          this,
          Invocation.method(
            #getCategoryList,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<List<_i12.CategoryModel>, _i6.Failure>>.value(
                _FakeEither_1<List<_i12.CategoryModel>, _i6.Failure>(
          this,
          Invocation.method(
            #getCategoryList,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Either<List<_i12.CategoryModel>, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<_i8.ReceiverModel, _i6.Failure>> getReceiver(
          String? receiverId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getReceiver,
          [receiverId],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i8.ReceiverModel, _i6.Failure>>.value(
                _FakeEither_1<_i8.ReceiverModel, _i6.Failure>(
          this,
          Invocation.method(
            #getReceiver,
            [receiverId],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i8.ReceiverModel, _i6.Failure>>.value(
                _FakeEither_1<_i8.ReceiverModel, _i6.Failure>(
          this,
          Invocation.method(
            #getReceiver,
            [receiverId],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i8.ReceiverModel, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<List<_i9.PaymentEntity>, _i6.Failure>>
      getUpcomingPaymentsFromDataSource() => (super.noSuchMethod(
            Invocation.method(
              #getUpcomingPaymentsFromDataSource,
              [],
            ),
            returnValue: _i5
                .Future<_i3.Either<List<_i9.PaymentEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i9.PaymentEntity>, _i6.Failure>(
              this,
              Invocation.method(
                #getUpcomingPaymentsFromDataSource,
                [],
              ),
            )),
            returnValueForMissingStub: _i5
                .Future<_i3.Either<List<_i9.PaymentEntity>, _i6.Failure>>.value(
                _FakeEither_1<List<_i9.PaymentEntity>, _i6.Failure>(
              this,
              Invocation.method(
                #getUpcomingPaymentsFromDataSource,
                [],
              ),
            )),
          ) as _i5.Future<_i3.Either<List<_i9.PaymentEntity>, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<void, _i6.Failure>> markPaymentAsPaidFromDatasource(
          _i7.PaymentModel? payment) =>
      (super.noSuchMethod(
        Invocation.method(
          #markPaymentAsPaidFromDatasource,
          [payment],
        ),
        returnValue: _i5.Future<_i3.Either<void, _i6.Failure>>.value(
            _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #markPaymentAsPaidFromDatasource,
            [payment],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<void, _i6.Failure>>.value(
                _FakeEither_1<void, _i6.Failure>(
          this,
          Invocation.method(
            #markPaymentAsPaidFromDatasource,
            [payment],
          ),
        )),
      ) as _i5.Future<_i3.Either<void, _i6.Failure>>);
  @override
  _i5.Future<
      _i3.Either<List<_i13.PaidPaymentModel>,
          _i6.Failure>> getPaidPaymentListFromDatasource(DateTime? date) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPaidPaymentListFromDatasource,
          [date],
        ),
        returnValue: _i5
            .Future<_i3.Either<List<_i13.PaidPaymentModel>, _i6.Failure>>.value(
            _FakeEither_1<List<_i13.PaidPaymentModel>, _i6.Failure>(
          this,
          Invocation.method(
            #getPaidPaymentListFromDatasource,
            [date],
          ),
        )),
        returnValueForMissingStub: _i5
            .Future<_i3.Either<List<_i13.PaidPaymentModel>, _i6.Failure>>.value(
            _FakeEither_1<List<_i13.PaidPaymentModel>, _i6.Failure>(
          this,
          Invocation.method(
            #getPaidPaymentListFromDatasource,
            [date],
          ),
        )),
      ) as _i5.Future<_i3.Either<List<_i13.PaidPaymentModel>, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<Map<int, double>, _i6.Failure>>
      getMonthlyPaidAmountFromDatasource() => (super.noSuchMethod(
            Invocation.method(
              #getMonthlyPaidAmountFromDatasource,
              [],
            ),
            returnValue:
                _i5.Future<_i3.Either<Map<int, double>, _i6.Failure>>.value(
                    _FakeEither_1<Map<int, double>, _i6.Failure>(
              this,
              Invocation.method(
                #getMonthlyPaidAmountFromDatasource,
                [],
              ),
            )),
            returnValueForMissingStub:
                _i5.Future<_i3.Either<Map<int, double>, _i6.Failure>>.value(
                    _FakeEither_1<Map<int, double>, _i6.Failure>(
              this,
              Invocation.method(
                #getMonthlyPaidAmountFromDatasource,
                [],
              ),
            )),
          ) as _i5.Future<_i3.Either<Map<int, double>, _i6.Failure>>);
  @override
  _i5.Future<_i3.Either<Map<String, double>, _i6.Failure>>
      getMonthlySummaryGroupByCategoryFromDatasource(DateTime? date) =>
          (super.noSuchMethod(
            Invocation.method(
              #getMonthlySummaryGroupByCategoryFromDatasource,
              [date],
            ),
            returnValue:
                _i5.Future<_i3.Either<Map<String, double>, _i6.Failure>>.value(
                    _FakeEither_1<Map<String, double>, _i6.Failure>(
              this,
              Invocation.method(
                #getMonthlySummaryGroupByCategoryFromDatasource,
                [date],
              ),
            )),
            returnValueForMissingStub:
                _i5.Future<_i3.Either<Map<String, double>, _i6.Failure>>.value(
                    _FakeEither_1<Map<String, double>, _i6.Failure>(
              this,
              Invocation.method(
                #getMonthlySummaryGroupByCategoryFromDatasource,
                [date],
              ),
            )),
          ) as _i5.Future<_i3.Either<Map<String, double>, _i6.Failure>>);
}
