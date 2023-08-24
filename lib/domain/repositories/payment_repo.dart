import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/bank_model.dart';
import '../../data/models/payment_model.dart';

abstract class PaymentRepo {
  Future<Either<List<PaymentEntity>, Failure>> getAllPaymentsFromDataSource();
  Future<Either<List<CategoryEntity>, Failure>>
      getAllCategoriesFromDataSource();
  Future<Either<void, Failure>> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiver);
  Future<Either<void, Failure>> editPaymentFromDataSource(PaymentModel payment);
  Future<Either<void, Failure>> deletePaymentFromDataSource(String paymentId);
  Future<Either<void, Failure>> addCategory(String categoryName);
  Future<Either<List<BankModel>, Failure>> getBankList();
  Future<Either<List<CategoryModel>, Failure>> getCategoryList();
  Future<Either<ReceiverModel, Failure>> getReceiver(String reciverId);
}
