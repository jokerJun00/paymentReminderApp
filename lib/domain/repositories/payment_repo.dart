import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/bank_model.dart';
import '../../data/models/payment_model.dart';

abstract class PaymentRepo {
  Future<Either<Map<String, List<PaymentEntity>>, Failure>>
      getGroupedPaymentsFromDataSource();
  Future<Either<List<PaymentEntity>, Failure>>
      getUpcomingPaymentsFromDataSource();
  Future<Either<List<CategoryEntity>, Failure>>
      getAllCategoriesFromDataSource();
  Future<Either<void, Failure>> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiver);
  Future<Either<void, Failure>> editPaymentFromDataSource(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo);
  Future<Either<void, Failure>> deletePaymentFromDataSource(
      PaymentModel payment);
  Future<Either<void, Failure>> addCategory(String categoryName);
  Future<Either<List<BankModel>, Failure>> getBankList();
  Future<Either<List<CategoryModel>, Failure>> getCategoryList();
  Future<Either<ReceiverModel, Failure>> getReceiver(String receiverId);
  Future<Either<void, Failure>> markPaymentAsPaidFromDatasource(
      PaymentModel payment);
  Future<Either<void, Failure>> payViaAppFromDatasource(PaymentModel payment);
  Future<Either<List<PaidPaymentModel>, Failure>>
      getPaidPaymentListFromDatasource(DateTime date);
  Future<Either<Map<int, double>, Failure>>
      getMonthlyPaidAmountFromDatasource();
  Future<Either<Map<String, double>, Failure>>
      getMonthlySummaryGroupByCategoryFromDatasource(DateTime date);
}
