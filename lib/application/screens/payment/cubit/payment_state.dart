part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentStateInitial extends PaymentState {
  const PaymentStateInitial(
      {required this.paymentList, required this.categoryList});

  final List<PaymentEntity> paymentList;
  final List<CategoryEntity> categoryList;

  @override
  List<Object> get props => [paymentList, categoryList];
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
