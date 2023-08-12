import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/payment_model.dart';
import '../../data/repositories/payment_repo_impl.dart';

class PaymentUseCases {
  final PaymentRepoImpl paymentRepoFirestore = PaymentRepoImpl();

  Future<Either<List<PaymentEntity>, Failure>> getAllPayments() {
    return paymentRepoFirestore.getAllPaymentsFromDataSource();
  }

  Future<Either<void, Failure>> addPayment(PaymentModel payment) {
    return paymentRepoFirestore.addPaymentFromDataSource(payment);
  }

  Future<Either<void, Failure>> editPayment(PaymentModel payment) {
    return paymentRepoFirestore.editPaymentFromDataSource(payment);
  }

  Future<Either<void, Failure>> deletePayment(String paymentId) {
    return paymentRepoFirestore.deletePaymentFromDataSource(paymentId);
  }
}
