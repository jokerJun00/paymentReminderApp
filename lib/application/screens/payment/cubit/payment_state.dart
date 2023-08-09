part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {}

class PaymentStateLoadingData extends PaymentState {}

class PaymentStateError extends PaymentState {}
