import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';

import '../../../../data/models/bank_model.dart';
import '../../../../data/models/payment_model.dart';
import '../../../../domain/usecases/payment_usecases.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({required this.paymentUseCases})
      : super(const PaymentStateInitial(groupedPaymentList: {}));

  final PaymentUseCases paymentUseCases;

  void getGroupedPayments() async {
    emit(const PaymentStateLoadingData());

    final paymentsOrFailure = await paymentUseCases.getGroupedPayments();

    paymentsOrFailure.fold(
      (groupedPaymentList) =>
          emit(PaymentStateInitial(groupedPaymentList: groupedPaymentList)),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );
  }

  Future<List<PaymentModel>> getUpcomingPayment() async {
    emit(const PaymentStateLoadingData());
    List<PaymentModel> upcomingPaymentList = <PaymentModel>[];

    final paymentsOrFailure = await paymentUseCases.getUpcomingPayments();

    paymentsOrFailure.fold(
      (upcomingPaymentListFromDatabase) {
        upcomingPaymentList =
            upcomingPaymentListFromDatabase as List<PaymentModel>;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return upcomingPaymentList;
  }

  void addPayments(PaymentModel payment, ReceiverModel receiver) async {
    emit(const PaymentStateEditingData());

    final paymentOrFailure =
        await paymentUseCases.addPayment(payment, receiver);

    paymentOrFailure.fold(
      (payments) => emit(const PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getGroupedPayments();
  }

  void editPayments(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) async {
    emit(const PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.editPayment(
        editedPaymentInfo, editedReceiverInfo);

    paymentOrFailure.fold(
      (payments) => emit(const PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getGroupedPayments();
  }

  Future<void> deletePayments(PaymentModel payment) async {
    emit(const PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.deletePayment(payment);

    paymentOrFailure.fold(
      (payments) => emit(const PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getGroupedPayments();
  }

  void addCategory(String categoryName) async {
    emit(const PaymentStateEditingData());
    final categoryOrFailure = await paymentUseCases.addCategory(categoryName);

    categoryOrFailure.fold(
      (payments) => emit(const PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getGroupedPayments();
  }

  Future<List<BankModel>> getBankList() async {
    emit(const PaymentStateLoadingData());
    final bankListOrFailure = await paymentUseCases.getBankList();
    List<BankModel> bankList = <BankModel>[];

    bankListOrFailure.fold(
      (bankListFromDatabase) {
        bankList = bankListFromDatabase as List<BankModel>;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return bankList;
  }

  Future<List<CategoryModel>> getCategoryList() async {
    emit(const PaymentStateLoadingData());
    final categoryListOrFailure = await paymentUseCases.getCategoryList();
    List<CategoryModel> categoryList = <CategoryModel>[];

    categoryListOrFailure.fold(
      (categoryListFromDatabase) {
        categoryList = categoryListFromDatabase as List<CategoryModel>;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return categoryList;
  }

  Future<ReceiverModel> getReceiver(String receiverId) async {
    emit(const PaymentStateLoadingData());
    final receiverOrFailure = await paymentUseCases.getReceiver(receiverId);

    var receiver = ReceiverModel(
      id: "",
      name: "",
      bank_id: "",
      bank_account_no: "",
      user_id: "",
    );

    receiverOrFailure.fold(
      (receiverFromDatabase) {
        receiver = receiverFromDatabase as ReceiverModel;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return receiver;
  }

  Future<void> markPaymentAsPaid(PaymentModel payment) async {
    emit(const PaymentStateEditingData());

    final paidOrFailure = await paymentUseCases.markPaymentAsPaid(payment);

    paidOrFailure.fold(
      (paid) => emit(const PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );
  }

  Future<List<PaidPaymentModel>> getPaidPaymentList(DateTime date) async {
    emit(const PaymentStateLoadingData());
    List<PaidPaymentModel> paidPaymentList = [];

    final paidPaymentListOrFailure =
        await paymentUseCases.getPaidPaymentList(date);

    paidPaymentListOrFailure.fold(
      (paidPaymentListFromDatabase) {
        paidPaymentList = paidPaymentListFromDatabase as List<PaidPaymentModel>;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return paidPaymentList;
  }

  Future<Map<int, double>> getMonthlyPaidAmount() async {
    emit(const PaymentStateLoadingData());
    Map<int, double> monthlySummary = {};

    final monthlySummaryOrFailure =
        await paymentUseCases.getMonthlyPaidAmount();

    monthlySummaryOrFailure.fold(
      (monthlySummaryFromDatabase) {
        monthlySummary = monthlySummaryFromDatabase;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return monthlySummary;
  }

  Future<Map<String, double>> getMonthlySummaryGroupByCategory(
      DateTime date) async {
    emit(const PaymentStateLoadingData());

    Map<String, double> categorySummary = {};

    final categorySummaryOrFailure =
        await paymentUseCases.getMonthlySummaryGroupByCategory(date);

    categorySummaryOrFailure.fold(
      (categorySummaryFromDatabase) {
        categorySummary = categorySummaryFromDatabase;
        emit(const PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return categorySummary;
  }
}
