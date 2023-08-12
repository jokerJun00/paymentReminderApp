part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {
  const PaymentStateInitial({required this.payments});

  final List<PaymentEntity> payments;

  @override
  List<Object> get props => [payments];
}

class PaymentStateLoadingData extends PaymentState {}

class PaymentStateEditingData extends PaymentState {}

class PaymentStateEditSuccess extends PaymentState {}

class PaymentStateError extends PaymentState {
  const PaymentStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
