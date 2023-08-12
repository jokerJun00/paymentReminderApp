import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/payment_model.dart';

abstract class PaymentRepo {
  Future<Either<List<PaymentEntity>, Failure>> getAllPaymentsFromDataSource();
  Future<Either<void, Failure>> addPaymentFromDataSource(
      PaymentModel newPayment);
  Future<Either<void, Failure>> editPaymentFromDataSource(PaymentModel payment);
  Future<Either<void, Failure>> deletePaymentFromDataSource(String paymentId);
}
