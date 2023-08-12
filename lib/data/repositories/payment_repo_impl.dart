import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart';

import 'package:payment_reminder_app/domain/entities/payment_entity.dart';

import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../domain/repositories/payment_repo.dart';
import '../exceptions/exceptions.dart';
import '../models/payment_model.dart';

class PaymentRepoImpl implements PaymentRepo {
  final PaymentDataSource paymentDataSource = PaymentDataSourceImpl();

  @override
  Future<Either<void, Failure>> addPaymentFromDataSource(
      PaymentModel newPayment) async {
    try {
      return left(await paymentDataSource.addPaymentFromDataSource(newPayment));
    } on ServerException catch (_) {
      return right(
          ServerFailure(error: "Edit payment failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> deletePaymentFromDataSource(
      String paymentId) async {
    try {
      return left(
          await paymentDataSource.deletePaymentFromDataSource(paymentId));
    } on ServerException catch (_) {
      return right(
          ServerFailure(error: "Edit payment failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> editPaymentFromDataSource(
      PaymentModel payment) async {
    try {
      return left(await paymentDataSource.editPaymentFromDataSource(payment));
    } on ServerException catch (_) {
      return right(
          ServerFailure(error: "Edit payment failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<PaymentEntity>, Failure>>
      getAllPaymentsFromDataSource() async {
    try {
      return left(await paymentDataSource.getAllPaymentsFromDataSource());
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to retrieve payment data"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }
}
