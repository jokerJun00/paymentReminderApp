import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/bank_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/data/repositories/payment_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'payment_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PaymentDataSourceImpl>()])
void main() {
  final mockPaymentDataSource = MockPaymentDataSourceImpl();
  final paymentRepoImplTest =
      PaymentRepoImpl(paymentDataSource: mockPaymentDataSource);

  final payment = PaymentModel(
    id: "1",
    name: "New Payment",
    description: "This is new payment",
    payment_date: DateTime.now(),
    notification_period: 1,
    billing_cycle: "monthly",
    expected_amount: 400.0,
    user_id: "1",
    receiver_id: "2",
    category_id: "3",
  );
  final receiver = ReceiverModel(
    id: "2",
    name: "Lim Choon Kait",
    bank_id: "4",
    bank_account_no: "1234567890",
    user_id: "1",
  );
  final groupedPaymentList = {
    "instalment": <PaymentModel>[
      PaymentModel(
        id: "1",
        name: "Car Instalment",
        description: "Car Instalment",
        payment_date: DateTime.now(),
        notification_period: 1,
        billing_cycle: "monthly",
        expected_amount: 400.0,
        user_id: "1",
        receiver_id: "2",
        category_id: "3",
      ),
    ],
    "rental": <PaymentModel>[
      PaymentModel(
        id: "2",
        name: "Room Rental",
        description: "Room Rental",
        payment_date: DateTime.now(),
        notification_period: 2,
        billing_cycle: "monthly",
        expected_amount: 500.0,
        user_id: "1",
        receiver_id: "2",
        category_id: "3",
      ),
    ],
  };
  final categoryList = <CategoryModel>[
    CategoryModel(id: "1", name: "subscription", user_id: ""),
    CategoryModel(id: "2", name: "instalment", user_id: ""),
    CategoryModel(id: "3", name: "rental", user_id: ""),
    CategoryModel(id: "4", name: "investment", user_id: ""),
    CategoryModel(id: "5", name: "membership", user_id: ""),
  ];
  final category = CategoryModel(id: "6", name: "test", user_id: "1");
  final bankList = <BankModel>[
    BankModel(id: "1", name: "Public Bank"),
    BankModel(id: "2", name: "CIMB Bank"),
    BankModel(id: "3", name: "Maybank"),
    BankModel(id: "4", name: "HSBC Bank"),
  ];
  final paymentList = <PaymentModel>[
    PaymentModel(
      id: "1",
      name: "Car Instalment",
      description: "Car Instalment",
      payment_date: DateTime.now(),
      notification_period: 1,
      billing_cycle: "monthly",
      expected_amount: 400.0,
      user_id: "1",
      receiver_id: "2",
      category_id: "3",
    ),
    PaymentModel(
      id: "2",
      name: "Room Rental",
      description: "Room Rental",
      payment_date: DateTime.now(),
      notification_period: 2,
      billing_cycle: "monthly",
      expected_amount: 500.0,
      user_id: "1",
      receiver_id: "2",
      category_id: "3",
    ),
  ];

  final paidPaymentList = <PaidPaymentModel>[
    PaidPaymentModel(
      id: "1",
      date: DateTime.now(),
      amount_paid: 400.0,
      payment_name: "Car Instalment",
      receiver_name: "Lim Choon Kiat",
      user_id: "1",
      payment_id: "1",
      category_id: "3",
    ),
    PaidPaymentModel(
      id: "2",
      date: DateTime.now(),
      amount_paid: 500.0,
      payment_name: "Room Rental",
      receiver_name: "Lim Choon Kiat",
      user_id: "1",
      payment_id: "2",
      category_id: "3",
    ),
  ];
  final monthlyPaidPaymentAmount = {
    1: 100.0,
    2: 200.0,
    3: 300.0,
    4: 400.0,
    5: 500.0,
    6: 600.0,
  };
  final monthlySummaryGroupByCategory = {
    "subcription": 100.0,
    "instalment": 200.0,
    "rental": 300.0,
  };
  final date = DateTime.now();
  group("PaymentRepoImpl", () {
    group("Success Test Cases", () {
      test("Add Payment Success Test Case", () async {
        when(mockPaymentDataSource.addPaymentFromDataSource(payment, receiver))
            .thenAnswer((realInvocation) => Future.value());

        final result = await paymentRepoImplTest.addPaymentFromDataSource(
            payment, receiver);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentDataSource.addPaymentFromDataSource(
                payment, receiver))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Delete Payment Success Test Case", () async {
        when(mockPaymentDataSource.deletePaymentFromDataSource(payment))
            .thenAnswer((realInvocation) => Future.value());

        final result =
            await paymentRepoImplTest.deletePaymentFromDataSource(payment);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentDataSource.deletePaymentFromDataSource(payment))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Edit Payment Success Test Case", () async {
        when(mockPaymentDataSource.editPaymentFromDataSource(payment, receiver))
            .thenAnswer((realInvocation) => Future.value());

        final result = await paymentRepoImplTest.editPaymentFromDataSource(
            payment, receiver);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentDataSource.editPaymentFromDataSource(
                payment, receiver))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Grouped Payments Success Test Case", () async {
        when(mockPaymentDataSource.getGroupedPaymentsFromDataSource())
            .thenAnswer((realInvocation) => Future.value(groupedPaymentList));

        final result =
            await paymentRepoImplTest.getGroupedPaymentsFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
            result,
            Left<Map<String, List<PaymentEntity>>, Failure>(
                groupedPaymentList));
        verify(mockPaymentDataSource.getGroupedPaymentsFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get All Categories Success Test Case", () async {
        when(mockPaymentDataSource.getAllCategoriesFromDataSource())
            .thenAnswer((realInvocation) => Future.value(categoryList));

        final result =
            await paymentRepoImplTest.getAllCategoriesFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<CategoryEntity>, Failure>(categoryList));
        verify(mockPaymentDataSource.getAllCategoriesFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Add Category Success Test Case", () async {
        when(mockPaymentDataSource.addCategory("test"))
            .thenAnswer((realInvocation) => Future.value());

        final result = await paymentRepoImplTest.addCategory("test");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentDataSource.addCategory("test")).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Bank List Success Test Case", () async {
        when(mockPaymentDataSource.getBankList())
            .thenAnswer((realInvocation) => Future.value(bankList));

        final result = await paymentRepoImplTest.getBankList();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<BankModel>, Failure>(bankList));
        verify(mockPaymentDataSource.getBankList()).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Category List Success Test Case", () async {
        when(mockPaymentDataSource.getCategoryList())
            .thenAnswer((realInvocation) => Future.value(categoryList));

        final result = await paymentRepoImplTest.getCategoryList();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<CategoryModel>, Failure>(categoryList));
        verify(mockPaymentDataSource.getCategoryList()).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get Receiver Success Test Case", () async {
        when(mockPaymentDataSource.getReceiver("2"))
            .thenAnswer((realInvocation) => Future.value(receiver));

        final result = await paymentRepoImplTest.getReceiver("2");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<ReceiverModel, Failure>(receiver));
        verify(mockPaymentDataSource.getReceiver("2")).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get Upcoming Payments Success Test Case", () async {
        when(mockPaymentDataSource.getUpcomingPaymentsFromDataSource())
            .thenAnswer((realInvocation) => Future.value(paymentList));

        final result =
            await paymentRepoImplTest.getUpcomingPaymentsFromDataSource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<PaymentModel>, Failure>(paymentList));
        verify(mockPaymentDataSource.getUpcomingPaymentsFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Mark Payment As Paid Success Test Case", () async {
        when(mockPaymentDataSource.markPaymentAsPaidFromDataSource(payment))
            .thenAnswer((realInvocation) => Future.value());

        final result =
            await paymentRepoImplTest.markPaymentAsPaidFromDatasource(payment);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentDataSource.markPaymentAsPaidFromDataSource(payment))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Paid Payment List Success Test Case", () async {
        when(mockPaymentDataSource.getPaidPaymentListFromDataSource(date))
            .thenAnswer((realInvocation) => Future.value(paidPaymentList));

        final result =
            await paymentRepoImplTest.getPaidPaymentListFromDatasource(date);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, isA<Left<List<PaidPaymentModel>, Failure>>());
        verify(mockPaymentDataSource.getPaidPaymentListFromDataSource(date))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Monthly Paid Amount Success Test Case", () async {
        when(mockPaymentDataSource.getMonthlyPaidAmountFromSource()).thenAnswer(
            (realInvocation) => Future.value(monthlyPaidPaymentAmount));

        final result =
            await paymentRepoImplTest.getMonthlyPaidAmountFromDatasource();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
            result, Left<Map<int, double>, Failure>(monthlyPaidPaymentAmount));
        verify(mockPaymentDataSource.getMonthlyPaidAmountFromSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Monthly Summary Group By Category Success Test Case", () async {
        when(mockPaymentDataSource
                .getMonthlySummaryGroupByCategoryFromDatasource(date))
            .thenAnswer((realInvocation) =>
                Future.value(monthlySummaryGroupByCategory));

        final result = await paymentRepoImplTest
            .getMonthlySummaryGroupByCategoryFromDatasource(date);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, isA<Left<Map<String, double>, Failure>>());
        verify(mockPaymentDataSource
                .getMonthlySummaryGroupByCategoryFromDatasource(date))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
    });

    group("Failure Test Cases", () {
      test("Add Payment Failure Test Case", () async {
        when(mockPaymentDataSource.addPaymentFromDataSource(payment, receiver))
            .thenThrow(ServerException());

        final result = await paymentRepoImplTest.addPaymentFromDataSource(
            payment, receiver);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Add payment failed. Please check your input")));
        verify(mockPaymentDataSource.addPaymentFromDataSource(
                payment, receiver))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Delete Payment Failure Test Case", () async {
        when(mockPaymentDataSource.deletePaymentFromDataSource(payment))
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.deletePaymentFromDataSource(payment);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Delete payment failed. Please check your input")));
        verify(mockPaymentDataSource.deletePaymentFromDataSource(payment))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Edit Payment Failure Test Case", () async {
        when(mockPaymentDataSource.editPaymentFromDataSource(payment, receiver))
            .thenThrow(ServerException());

        final result = await paymentRepoImplTest.editPaymentFromDataSource(
            payment, receiver);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Edit payment failed. Please check your input")));
        verify(mockPaymentDataSource.editPaymentFromDataSource(
                payment, receiver))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Grouped Payments Failure Test Case", () async {
        when(mockPaymentDataSource.getGroupedPaymentsFromDataSource())
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.getGroupedPaymentsFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<Map<String, List<PaymentEntity>>, Failure>(
                ServerFailure(error: "Fail to retrieve payment data")));
        verify(mockPaymentDataSource.getGroupedPaymentsFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get All Categories Failure Test Case", () async {
        when(mockPaymentDataSource.getAllCategoriesFromDataSource())
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.getAllCategoriesFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<CategoryEntity>, Failure>(
                ServerFailure(error: "Fail to retrieve payment data")));
        verify(mockPaymentDataSource.getAllCategoriesFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Add Category Failure Test Case", () async {
        when(mockPaymentDataSource.addCategory("test"))
            .thenThrow(ServerException());

        final result = await paymentRepoImplTest.addCategory("test");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(
                ServerFailure(error: "Fail to add new category.")));
        verify(mockPaymentDataSource.addCategory("test")).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Bank List Failure Test Case", () async {
        when(mockPaymentDataSource.getBankList()).thenThrow(ServerException());

        final result = await paymentRepoImplTest.getBankList();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<BankModel>, Failure>(
                ServerFailure(error: "Fail to get bank list")));
        verify(mockPaymentDataSource.getBankList()).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Category List Failure Test Case", () async {
        when(mockPaymentDataSource.getCategoryList())
            .thenThrow(ServerException());

        final result = await paymentRepoImplTest.getCategoryList();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<CategoryModel>, Failure>(
                ServerFailure(error: "Fail to get category list")));
        verify(mockPaymentDataSource.getCategoryList()).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });

      test("Get Receiver Failure Test Case", () async {
        when(mockPaymentDataSource.getReceiver("2"))
            .thenThrow(ServerException());

        final result = await paymentRepoImplTest.getReceiver("2");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<ReceiverModel, Failure>(
                ServerFailure(error: "Fail to get receiver")));
        verify(mockPaymentDataSource.getReceiver("2")).called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get Upcoming Payments Failure Test Case", () async {
        when(mockPaymentDataSource.getUpcomingPaymentsFromDataSource())
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.getUpcomingPaymentsFromDataSource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<PaymentModel>, Failure>(
                ServerFailure(error: "Fail to retrieve payment data")));
        verify(mockPaymentDataSource.getUpcomingPaymentsFromDataSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Mark Payment As Paid Failure Test Case", () async {
        when(mockPaymentDataSource.markPaymentAsPaidFromDataSource(payment))
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.markPaymentAsPaidFromDatasource(payment);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(
                ServerFailure(error: "Fail to mark payment as paid")));
        verify(mockPaymentDataSource.markPaymentAsPaidFromDataSource(payment))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get Paid Payment List Failure Test Case", () async {
        when(mockPaymentDataSource.getPaidPaymentListFromDataSource(date))
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.getPaidPaymentListFromDatasource(date);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<PaidPaymentModel>, Failure>(
                ServerFailure(error: "Fail to retrieve paid payment data")));
        verify(mockPaymentDataSource.getPaidPaymentListFromDataSource(date))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get Monthly Paid Amount Failure Test Case", () async {
        when(mockPaymentDataSource.getMonthlyPaidAmountFromSource())
            .thenThrow(ServerException());

        final result =
            await paymentRepoImplTest.getMonthlyPaidAmountFromDatasource();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<Map<int, double>, Failure>(ServerFailure(
                error: "Fail to retrieve monthly summary for dashboard")));
        verify(mockPaymentDataSource.getMonthlyPaidAmountFromSource())
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
      test("Get Monthly Summary Group By Category Failure Test Case", () async {
        when(mockPaymentDataSource
                .getMonthlySummaryGroupByCategoryFromDatasource(date))
            .thenThrow(ServerException());

        final result = await paymentRepoImplTest
            .getMonthlySummaryGroupByCategoryFromDatasource(date);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<Map<String, double>, Failure>(ServerFailure(
                error: "Fail to retrieve monthly summary for dashboard")));
        verify(mockPaymentDataSource
                .getMonthlySummaryGroupByCategoryFromDatasource(date))
            .called(1);
        verifyNoMoreInteractions(mockPaymentDataSource);
      });
    });
  });
}
