part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {
  const PaymentStateInitial({required this.paymentList});

  final List<PaymentEntity> paymentList;

  @override
  List<Object> get props => [paymentList];
}

class PaymentStateLoadingData extends PaymentState {}

class PaymentStateLoaded extends PaymentState {}

class PaymentStateEditingData extends PaymentState {}

class PaymentStateEditSuccess extends PaymentState {}

class PaymentStateError extends PaymentState {
  const PaymentStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
