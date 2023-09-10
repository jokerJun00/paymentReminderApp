part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {
  const PaymentStateInitial({required this.groupedPaymentList});

  final Map<String, List<PaymentEntity>> groupedPaymentList;

  @override
  List<Object> get props => [groupedPaymentList];
}

class PaymentStateLoadingData extends PaymentState {
  const PaymentStateLoadingData();
}

class PaymentStateLoaded extends PaymentState {
  const PaymentStateLoaded();
}

class PaymentStateEditingData extends PaymentState {
  const PaymentStateEditingData();
}

class PaymentStateEditSuccess extends PaymentState {
  const PaymentStateEditSuccess();
}

class PaymentStateError extends PaymentState {
  const PaymentStateError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
