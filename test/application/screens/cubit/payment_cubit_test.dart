import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';
import 'package:payment_reminder_app/data/models/bank_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/bank_entity.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/entities/paid_payment_entity.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/entities/receiver_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';
import 'package:payment_reminder_app/domain/usecases/payment_usecases.dart';
import 'package:test/scaffolding.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentUseCases extends Mock implements PaymentUseCases {}

void main() {
  final mockPaymentUseCases = MockPaymentUseCases();
  group("PaymentCubit", () {
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
    group("Success Emit Test Cases", () {
      blocTest<PaymentCubit, PaymentState>(
        'emits BudgetState when no method is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        expect: () => const <PaymentState>[],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateInitial ] when getGroupedPayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getGroupedPayments(),
        setUp: () => when(
          () => mockPaymentUseCases.getGroupedPayments(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<Map<String, List<PaymentEntity>>, Failure>(groupedPaymentList),
          ),
        ),
        expect: () => <PaymentState>[
          const PaymentStateLoadingData(),
          PaymentStateInitial(groupedPaymentList: groupedPaymentList),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getUpcomingPayment() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getUpcomingPayment(),
        setUp: () => when(
          () => mockPaymentUseCases.getUpcomingPayments(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<List<PaymentEntity>, Failure>(paymentList),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateEditSuccess, PaymentStateLoadingData, PaymentStateInitial ] when addPayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.addPayments(payment, receiver),
        setUp: () => when(
          () => mockPaymentUseCases.addPayment(payment, receiver),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => <PaymentState>[
          const PaymentStateEditingData(),
          const PaymentStateEditSuccess(),
          const PaymentStateLoadingData(),
          PaymentStateInitial(groupedPaymentList: groupedPaymentList)
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateEditSuccess, PaymentStateLoadingData, PaymentStateInitial ] when editPayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.editPayments(payment, receiver),
        setUp: () => when(
          () => mockPaymentUseCases.editPayment(payment, receiver),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => <PaymentState>[
          const PaymentStateEditingData(),
          const PaymentStateEditSuccess(),
          const PaymentStateLoadingData(),
          PaymentStateInitial(groupedPaymentList: groupedPaymentList)
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateEditSuccess, PaymentStateLoadingData, PaymentStateInitial ] when deletePayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.deletePayments(payment),
        setUp: () => when(
          () => mockPaymentUseCases.deletePayment(payment),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => <PaymentState>[
          const PaymentStateEditingData(),
          const PaymentStateEditSuccess(),
          const PaymentStateLoadingData(),
          PaymentStateInitial(groupedPaymentList: groupedPaymentList)
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateEditSuccess, PaymentStateLoadingData, PaymentStateInitial ] when addCategory() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.addCategory("test"),
        setUp: () => when(
          () => mockPaymentUseCases.addCategory("test"),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => <PaymentState>[
          const PaymentStateEditingData(),
          const PaymentStateEditSuccess(),
          const PaymentStateLoadingData(),
          PaymentStateInitial(groupedPaymentList: groupedPaymentList)
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getBankList() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getBankList(),
        setUp: () => when(
          () => mockPaymentUseCases.getBankList(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<List<BankEntity>, Failure>(bankList),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getCategoryList() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getCategoryList(),
        setUp: () => when(
          () => mockPaymentUseCases.getCategoryList(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<List<CategoryEntity>, Failure>(categoryList),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getReceiver() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getReceiver("1"),
        setUp: () => when(
          () => mockPaymentUseCases.getReceiver("1"),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<ReceiverEntity, Failure>(receiver),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateEditSuccess ] when addCategory() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.markPaymentAsPaid(payment),
        setUp: () => when(
          () => mockPaymentUseCases.markPaymentAsPaid(payment),
        ).thenAnswer(
          (realInvocation) => Future.value(const Left<void, Failure>(null)),
        ),
        expect: () => const <PaymentState>[
          PaymentStateEditingData(),
          PaymentStateEditSuccess(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getPaidPaymentList() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getPaidPaymentList(date),
        setUp: () => when(
          () => mockPaymentUseCases.getPaidPaymentList(date),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<List<PaidPaymentEntity>, Failure>(paidPaymentList),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getMonthlyPaidAmount() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getMonthlyPaidAmount(),
        setUp: () => when(
          () => mockPaymentUseCases.getMonthlyPaidAmount(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<Map<int, double>, Failure>(monthlyPaidPaymentAmount),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateLoaded ] when getMonthlySummaryGroupByCategory() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getMonthlySummaryGroupByCategory(date),
        setUp: () => when(
          () => mockPaymentUseCases.getMonthlySummaryGroupByCategory(date),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Left<Map<String, double>, Failure>(monthlySummaryGroupByCategory),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateLoaded(),
        ],
      );
    });

    group("Failure Emit Test Cases", () {
      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getGroupedPayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getGroupedPayments(),
        setUp: () => when(
          () => mockPaymentUseCases.getGroupedPayments(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<Map<String, List<PaymentEntity>>, Failure>(
              ServerFailure(
                error: "Fail to retrieve payment data",
              ),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve payment data"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getUpcomingPayment() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getUpcomingPayment(),
        setUp: () => when(
          () => mockPaymentUseCases.getUpcomingPayments(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<List<PaymentEntity>, Failure>(
              ServerFailure(error: "Fail to retrieve payment data"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve payment data"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateError, PaymentStateLoadingData, PaymentStateInitial ] when addPayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.addPayments(payment, receiver),
        setUp: () => when(
          () => mockPaymentUseCases.addPayment(payment, receiver),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(
                error: "Add payment failed. Please check your input",
              ),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateEditingData(),
          PaymentStateError(
              message: "Add payment failed. Please check your input"),
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve payment data")
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateError, PaymentStateLoadingData, PaymentStateInitial ] when editPayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.editPayments(payment, receiver),
        setUp: () => when(
          () => mockPaymentUseCases.editPayment(payment, receiver),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(
                  error: "Edit payment failed. Please check your input"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateEditingData(),
          PaymentStateError(
              message: "Edit payment failed. Please check your input"),
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve payment data")
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateError, PaymentStateLoadingData, PaymentStateInitial ] when deletePayments() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.deletePayments(payment),
        setUp: () => when(
          () => mockPaymentUseCases.deletePayment(payment),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(
                error: "Delete payment failed. Please check your input",
              ),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateEditingData(),
          PaymentStateError(
              message: "Delete payment failed. Please check your input"),
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve payment data")
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateError, PaymentStateLoadingData, PaymentStateInitial ] when addCategory() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.addCategory("test"),
        setUp: () => when(
          () => mockPaymentUseCases.addCategory("test"),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(error: "Fail to add new category."),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateEditingData(),
          PaymentStateError(message: "Fail to add new category."),
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve payment data")
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getBankList() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getBankList(),
        setUp: () => when(
          () => mockPaymentUseCases.getBankList(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<List<BankEntity>, Failure>(
              ServerFailure(error: "Fail to get bank list"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to get bank list"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getCategoryList() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getCategoryList(),
        setUp: () => when(
          () => mockPaymentUseCases.getCategoryList(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<List<CategoryEntity>, Failure>(
              ServerFailure(error: "Fail to get category list"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to get category list"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getReceiver() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getReceiver("1"),
        setUp: () => when(
          () => mockPaymentUseCases.getReceiver("1"),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<ReceiverEntity, Failure>(
              ServerFailure(error: "Fail to get receiver"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to get receiver"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateEditingData, PaymentStateError ] when addCategory() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.markPaymentAsPaid(payment),
        setUp: () => when(
          () => mockPaymentUseCases.markPaymentAsPaid(payment),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<void, Failure>(
              ServerFailure(error: "Fail to mark payment as paid"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateEditingData(),
          PaymentStateError(message: "Fail to mark payment as paid"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getPaidPaymentList() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getPaidPaymentList(date),
        setUp: () => when(
          () => mockPaymentUseCases.getPaidPaymentList(date),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<List<PaidPaymentEntity>, Failure>(
              ServerFailure(error: "Fail to retrieve paid payment data"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(message: "Fail to retrieve paid payment data"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getMonthlyPaidAmount() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getMonthlyPaidAmount(),
        setUp: () => when(
          () => mockPaymentUseCases.getMonthlyPaidAmount(),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<Map<int, double>, Failure>(
              ServerFailure(
                  error: "Fail to retrieve monthly summary for dashboard"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(
              message: "Fail to retrieve monthly summary for dashboard"),
        ],
      );

      blocTest<PaymentCubit, PaymentState>(
        'emits [ PaymentStateLoadingData, PaymentStateError ] when getMonthlySummaryGroupByCategory() is called',
        build: () => PaymentCubit(paymentUseCases: mockPaymentUseCases),
        act: (cubit) => cubit.getMonthlySummaryGroupByCategory(date),
        setUp: () => when(
          () => mockPaymentUseCases.getMonthlySummaryGroupByCategory(date),
        ).thenAnswer(
          (realInvocation) => Future.value(
            Right<Map<String, double>, Failure>(
              ServerFailure(
                  error: "Fail to retrieve monthly summary for dashboard"),
            ),
          ),
        ),
        expect: () => const <PaymentState>[
          PaymentStateLoadingData(),
          PaymentStateError(
              message: "Fail to retrieve monthly summary for dashboard"),
        ],
      );
    });
  });
}
