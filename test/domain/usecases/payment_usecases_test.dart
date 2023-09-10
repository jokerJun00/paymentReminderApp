import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/bank_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/data/repositories/payment_repo_impl.dart';
import 'package:payment_reminder_app/domain/entities/bank_entity.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/entities/paid_payment_entity.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/entities/receiver_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/payment_usecases.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'payment_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PaymentRepoImpl>()])
void main() {
  final mockPaymentRepoImpl = MockPaymentRepoImpl();
  final paymentUseCasesTest = PaymentUseCases(paymentRepo: mockPaymentRepoImpl);
  group("PaymentUseCases", () {
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

    group("Success Test Cases", () {
      test("Add Payment Success Test Case", () async {
        when(mockPaymentRepoImpl.addPaymentFromDataSource(payment, receiver))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await paymentUseCasesTest.addPayment(payment, receiver);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentRepoImpl.addPaymentFromDataSource(payment, receiver));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Delete Payment Success Test Case", () async {
        when(mockPaymentRepoImpl.deletePaymentFromDataSource(payment))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await paymentUseCasesTest.deletePayment(payment);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentRepoImpl.deletePaymentFromDataSource(payment));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Edit Payment Success Test Case", () async {
        when(mockPaymentRepoImpl.editPaymentFromDataSource(payment, receiver))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await paymentUseCasesTest.editPayment(payment, receiver);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(
            mockPaymentRepoImpl.editPaymentFromDataSource(payment, receiver));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Grouped Payments Success Test Case", () async {
        when(mockPaymentRepoImpl.getGroupedPaymentsFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(Left(groupedPaymentList)));

        final result = await paymentUseCasesTest.getGroupedPayments();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
            result,
            Left<Map<String, List<PaymentEntity>>, Failure>(
                groupedPaymentList));
        verify(mockPaymentRepoImpl.getGroupedPaymentsFromDataSource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get All Categories Success Test Case", () async {
        when(mockPaymentRepoImpl.getAllCategoriesFromDataSource())
            .thenAnswer((realInvocation) => Future.value(Left(categoryList)));

        final result = await paymentUseCasesTest.getAllCategories();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<CategoryEntity>, Failure>(categoryList));
        verify(mockPaymentRepoImpl.getAllCategoriesFromDataSource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Add Category Success Test Case", () async {
        when(mockPaymentRepoImpl.addCategory("test"))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await paymentUseCasesTest.addCategory("test");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentRepoImpl.addCategory("test"));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Bank List Success Test Case", () async {
        when(mockPaymentRepoImpl.getBankList())
            .thenAnswer((realInvocation) => Future.value(Left(bankList)));

        final result = await paymentUseCasesTest.getBankList();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<BankEntity>, Failure>(bankList));
        verify(mockPaymentRepoImpl.getBankList());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Category List Success Test Case", () async {
        when(mockPaymentRepoImpl.getCategoryList())
            .thenAnswer((realInvocation) => Future.value(Left(categoryList)));

        final result = await paymentUseCasesTest.getCategoryList();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<CategoryEntity>, Failure>(categoryList));
        verify(mockPaymentRepoImpl.getCategoryList());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Receiver Success Test Case", () async {
        when(mockPaymentRepoImpl.getReceiver("1"))
            .thenAnswer((realInvocation) => Future.value(Left(receiver)));

        final result = await paymentUseCasesTest.getReceiver("1");

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<ReceiverEntity, Failure>(receiver));
        verify(mockPaymentRepoImpl.getReceiver("1"));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Upcoming Payments Success Test Case", () async {
        when(mockPaymentRepoImpl.getUpcomingPaymentsFromDataSource())
            .thenAnswer((realInvocation) => Future.value(Left(paymentList)));

        final result = await paymentUseCasesTest.getUpcomingPayments();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<PaymentEntity>, Failure>(paymentList));
        verify(mockPaymentRepoImpl.getUpcomingPaymentsFromDataSource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Mark Payment As Paid Success Test Case", () async {
        when(mockPaymentRepoImpl.markPaymentAsPaidFromDatasource(payment))
            .thenAnswer((realInvocation) => Future.value(const Left(null)));

        final result = await paymentUseCasesTest.markPaymentAsPaid(payment);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, const Left<void, Failure>(null));
        verify(mockPaymentRepoImpl.markPaymentAsPaidFromDatasource(payment));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Paid Payment List Success Test Case", () async {
        when(mockPaymentRepoImpl.getPaidPaymentListFromDatasource(date))
            .thenAnswer(
                (realInvocation) => Future.value(Left(paidPaymentList)));

        final result = await paymentUseCasesTest.getPaidPaymentList(date);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<List<PaidPaymentEntity>, Failure>(paidPaymentList));
        verify(mockPaymentRepoImpl.getPaidPaymentListFromDatasource(date));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Monthly Paid Amount Success Test Case", () async {
        when(mockPaymentRepoImpl.getMonthlyPaidAmountFromDatasource())
            .thenAnswer((realInvocation) =>
                Future.value(Left(monthlyPaidPaymentAmount)));

        final result = await paymentUseCasesTest.getMonthlyPaidAmount();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(
            result, Left<Map<int, double>, Failure>(monthlyPaidPaymentAmount));
        verify(mockPaymentRepoImpl.getMonthlyPaidAmountFromDatasource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Monthly Summary Group By Category Success Test Case", () async {
        when(mockPaymentRepoImpl
                .getMonthlySummaryGroupByCategoryFromDatasource(date))
            .thenAnswer((realInvocation) =>
                Future.value(Left(monthlySummaryGroupByCategory)));

        final result =
            await paymentUseCasesTest.getMonthlySummaryGroupByCategory(date);

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result,
            Left<Map<String, double>, Failure>(monthlySummaryGroupByCategory));
        verify(mockPaymentRepoImpl
            .getMonthlySummaryGroupByCategoryFromDatasource(date));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
    });
    group("Failure Test Cases", () {
      test("Add Payment Failure Test Case", () async {
        when(mockPaymentRepoImpl.addPaymentFromDataSource(payment, receiver))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Add payment failed. Please check your input"))));

        final result = await paymentUseCasesTest.addPayment(payment, receiver);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Add payment failed. Please check your input")));
        verify(mockPaymentRepoImpl.addPaymentFromDataSource(payment, receiver));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Delete Payment Failure Test Case", () async {
        when(mockPaymentRepoImpl.deletePaymentFromDataSource(payment))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Delete payment failed. Please check your input"))));

        final result = await paymentUseCasesTest.deletePayment(payment);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Delete payment failed. Please check your input")));
        verify(mockPaymentRepoImpl.deletePaymentFromDataSource(payment));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Edit Payment Failure Test Case", () async {
        when(mockPaymentRepoImpl.editPaymentFromDataSource(payment, receiver))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Edit payment failed. Please check your input"))));

        final result = await paymentUseCasesTest.editPayment(payment, receiver);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(ServerFailure(
                error: "Edit payment failed. Please check your input")));
        verify(
            mockPaymentRepoImpl.editPaymentFromDataSource(payment, receiver));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Grouped Payments Failure Test Case", () async {
        when(mockPaymentRepoImpl.getGroupedPaymentsFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to retrieve payment data"))));

        final result = await paymentUseCasesTest.getGroupedPayments();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<Map<String, List<PaymentEntity>>, Failure>(
                ServerFailure(error: "Fail to retrieve payment data")));
        verify(mockPaymentRepoImpl.getGroupedPaymentsFromDataSource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get All Categories Failure Test Case", () async {
        when(mockPaymentRepoImpl.getAllCategoriesFromDataSource()).thenAnswer(
            (realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to retrieve payment data"))));

        final result = await paymentUseCasesTest.getAllCategories();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<CategoryEntity>, Failure>(
                ServerFailure(error: "Fail to retrieve payment data")));
        verify(mockPaymentRepoImpl.getAllCategoriesFromDataSource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Add Category Failure Test Case", () async {
        when(mockPaymentRepoImpl.addCategory("test")).thenAnswer(
            (realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to add new category."))));

        final result = await paymentUseCasesTest.addCategory("test");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(
                ServerFailure(error: "Fail to add new category.")));
        verify(mockPaymentRepoImpl.addCategory("test"));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Bank List Failure Test Case", () async {
        when(mockPaymentRepoImpl.getBankList()).thenAnswer((realInvocation) =>
            Future.value(Right(ServerFailure(error: "Fail to get bank list"))));

        final result = await paymentUseCasesTest.getBankList();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<BankEntity>, Failure>(
                ServerFailure(error: "Fail to get bank list")));
        verify(mockPaymentRepoImpl.getBankList());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Category List Failure Test Case", () async {
        when(mockPaymentRepoImpl.getCategoryList()).thenAnswer(
            (realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to get category list"))));

        final result = await paymentUseCasesTest.getCategoryList();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<CategoryEntity>, Failure>(
                ServerFailure(error: "Fail to get category list")));
        verify(mockPaymentRepoImpl.getCategoryList());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Receiver Failure Test Case", () async {
        when(mockPaymentRepoImpl.getReceiver("1")).thenAnswer(
            (realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to get receiver"))));

        final result = await paymentUseCasesTest.getReceiver("1");

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<ReceiverEntity, Failure>(
                ServerFailure(error: "Fail to get receiver")));
        verify(mockPaymentRepoImpl.getReceiver("1"));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Upcoming Payments Failure Test Case", () async {
        when(mockPaymentRepoImpl.getUpcomingPaymentsFromDataSource())
            .thenAnswer((realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to retrieve payment data"))));

        final result = await paymentUseCasesTest.getUpcomingPayments();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<PaymentEntity>, Failure>(
                ServerFailure(error: "Fail to retrieve payment data")));
        verify(mockPaymentRepoImpl.getUpcomingPaymentsFromDataSource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Mark Payment As Paid Failure Test Case", () async {
        when(mockPaymentRepoImpl.markPaymentAsPaidFromDatasource(payment))
            .thenAnswer((realInvocation) => Future.value(
                Right(ServerFailure(error: "Fail to mark payment as paid"))));

        final result = await paymentUseCasesTest.markPaymentAsPaid(payment);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<void, Failure>(
                ServerFailure(error: "Fail to mark payment as paid")));
        verify(mockPaymentRepoImpl.markPaymentAsPaidFromDatasource(payment));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Paid Payment List Failure Test Case", () async {
        when(mockPaymentRepoImpl.getPaidPaymentListFromDatasource(date))
            .thenAnswer((realInvocation) => Future.value(Right(
                ServerFailure(error: "Fail to retrieve paid payment data"))));

        final result = await paymentUseCasesTest.getPaidPaymentList(date);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<List<PaidPaymentEntity>, Failure>(
                ServerFailure(error: "Fail to retrieve paid payment data")));
        verify(mockPaymentRepoImpl.getPaidPaymentListFromDatasource(date));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Monthly Paid Amount Failure Test Case", () async {
        when(mockPaymentRepoImpl.getMonthlyPaidAmountFromDatasource())
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Fail to retrieve monthly summary for dashboard"))));

        final result = await paymentUseCasesTest.getMonthlyPaidAmount();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<Map<int, double>, Failure>(ServerFailure(
                error: "Fail to retrieve monthly summary for dashboard")));
        verify(mockPaymentRepoImpl.getMonthlyPaidAmountFromDatasource());
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
      test("Get Monthly Summary Group By Category Failure Test Case", () async {
        when(mockPaymentRepoImpl
                .getMonthlySummaryGroupByCategoryFromDatasource(date))
            .thenAnswer((realInvocation) => Future.value(Right(ServerFailure(
                error: "Fail to retrieve monthly summary for dashboard"))));

        final result =
            await paymentUseCasesTest.getMonthlySummaryGroupByCategory(date);

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            Right<Map<String, double>, Failure>(ServerFailure(
                error: "Fail to retrieve monthly summary for dashboard")));
        verify(mockPaymentRepoImpl
            .getMonthlySummaryGroupByCategoryFromDatasource(date));
        verifyNoMoreInteractions(mockPaymentRepoImpl);
      });
    });
  });
}
