import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';

import '../../../../data/models/payment_model.dart';
import '../../../../domain/usecases/payment_usecases.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit()
      : super(const PaymentStateInitial(payments: <PaymentEntity>[]));

  final PaymentUseCases paymentUseCases = PaymentUseCases();

  void getAllPayments() async {
    emit(PaymentStateLoadingData());

    final paymentsOrFailure = await paymentUseCases.getAllPayments();

    return paymentsOrFailure.fold(
      (payments) => emit(PaymentStateInitial(payments: payments)),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );
  }

  void addPayments(PaymentModel payment) async {
    emit(PaymentStateEditingData());

    final paymentOrFailure = await paymentUseCases.addPayment(payment);

    paymentOrFailure.fold(
      (payments) => emit(PaymentStateEditSuccess()),
      (failure) => emit(PaymentStateError(message: failure.getError)),
    );

    getAllPayments();
  }

  void editPayments(PaymentModel payment) async {
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
}
