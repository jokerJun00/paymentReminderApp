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
  PaymentCubit() : super(const PaymentStateInitial(paymentList: []));

  final PaymentUseCases paymentUseCases = PaymentUseCases();

  void getAllPayments() async {
    emit(PaymentStateLoadingData());

    final paymentsOrFailure = await paymentUseCases.getAllPayments();

    paymentsOrFailure.fold(
      (paymentList) => emit(PaymentStateInitial(paymentList: paymentList)),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );
  }

  Future<List<PaymentModel>> getUpcomingPayment() async {
    emit(PaymentStateLoadingData());
    List<PaymentModel> upcomingPaymentList = <PaymentModel>[];

    final paymentsOrFailure = await paymentUseCases.getUpcomingPayments();

    paymentsOrFailure.fold(
      (upcomingPaymentListFromDatabase) {
        upcomingPaymentList =
            upcomingPaymentListFromDatabase as List<PaymentModel>;
        emit(PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return upcomingPaymentList;
  }

  void addPayments(PaymentModel payment, ReceiverModel receiver) async {
    emit(PaymentStateEditingData());

    final paymentOrFailure =
        await paymentUseCases.addPayment(payment, receiver);

    paymentOrFailure.fold(
      (payments) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();
  }

  void editPayments(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) async {
    emit(PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.editPayment(
        editedPaymentInfo, editedReceiverInfo);

    paymentOrFailure.fold(
      (payments) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();
  }

  Future<void> deletePayments(PaymentModel payment) async {
    emit(PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.deletePayment(payment);

    paymentOrFailure.fold(
      (payments) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();
  }

  void addCategory(String categoryName) async {
    emit(PaymentStateEditingData());
    final categoryOrFailure = await paymentUseCases.addCategory(categoryName);

    categoryOrFailure.fold(
      (payments) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();
  }

  Future<List<BankModel>> getBankList() async {
    emit(PaymentStateLoadingData());
    final bankListOrFailure = await paymentUseCases.getBankList();
    List<BankModel> bankList = <BankModel>[];

    bankListOrFailure.fold(
      (bankListFromDatabase) {
        bankList = bankListFromDatabase;
        emit(PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return bankList;
  }

  Future<List<CategoryModel>> getCategoryList() async {
    emit(PaymentStateLoadingData());
    final categoryListOrFailure = await paymentUseCases.getCategoryList();
    List<CategoryModel> categoryList = <CategoryModel>[];

    categoryListOrFailure.fold(
      (categoryListFromDatabase) {
        categoryList = categoryListFromDatabase;
        emit(PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return categoryList;
  }

  Future<ReceiverModel> getReceiver(String receiverId) async {
    emit(PaymentStateLoadingData());
    final receiverOrFailure = await paymentUseCases.getReceiver(receiverId);

    ReceiverModel receiver = ReceiverModel(
      id: "",
      name: "",
      bank_id: "",
      bank_account_no: "",
      user_id: "",
    );

    receiverOrFailure.fold(
      (receiverFromDatabase) {
        receiver = receiverFromDatabase;
        emit(PaymentStateLoaded());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return receiver;
  }

  Future<void> markPaymentAsPaid(PaymentModel payment) async {
    emit(PaymentStateEditingData());

    final paidOrFailure = await paymentUseCases.markPaymentAsPaid(payment);

    paidOrFailure.fold(
      (paid) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );
  }

  Future<void> payViaApp(PaymentModel payment) async {
    emit(PaymentStateEditingData());

    final paidOrFailure = await paymentUseCases.payViaApp(payment);

    paidOrFailure.fold(
      (paid) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );
  }

  Future<List<PaidPaymentModel>> getPaidPaymentList(DateTime date) async {
    emit(PaymentStateLoadingData());
    List<PaidPaymentModel> paidPaymentList = [];

    final paidPaymentListOrFailure =
        await paymentUseCases.getPaidPaymentList(date);

    paidPaymentListOrFailure.fold(
      (paidPaymentListFromDatabase) {
        paidPaymentList = paidPaymentListFromDatabase;
        emit(PaymentStateEditSuccess());
      },
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    return paidPaymentList;
  }
}
