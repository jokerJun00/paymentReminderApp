import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
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
    // final categoriesOrFailure = await paymentUseCases.getAllCategories();

    // paymentsOrFailure.fold(
    //   (paymentList) {
    //     categoriesOrFailure.fold(
    //       (categoryList) => emit(PaymentStateInitial(
    //           paymentList: paymentList, categoryList: categoryList)),
    //       (failure) => emit(PaymentStateError(message: failure.getError)),
    //     );
    //   },
    //   (failure) => emit(PaymentStateError(message: failure.getError)),
    // );
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

  void editPayments(PaymentModel payment, ReceiverModel receiver) async {
    emit(PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.editPayment(payment);

    paymentOrFailure.fold(
      (payments) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();
  }

  void deletePayments(String paymentId) async {
    emit(PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.deletePayment(paymentId);

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
      (bankListFromDatabase) => bankList = bankListFromDatabase,
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();

    return bankList;
  }

  Future<List<CategoryModel>> getCategoryList() async {
    emit(PaymentStateLoadingData());
    final categoryListOrFailure = await paymentUseCases.getCategoryList();
    List<CategoryModel> categoryList = <CategoryModel>[];

    categoryListOrFailure.fold(
      (categoryListFromDatabase) => categoryList = categoryListFromDatabase,
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();

    return categoryList;
  }
}
