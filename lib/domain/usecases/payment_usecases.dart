import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/bank_entity.dart';
import 'package:payment_reminder_app/domain/entities/paid_payment_entity.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/entities/receiver_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/bank_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/payment_model.dart';
import '../entities/category_entity.dart';
import '../repositories/payment_repo.dart';

class PaymentUseCases {
  PaymentUseCases({required this.paymentRepo});
  final PaymentRepo paymentRepo;

  Future<Either<Map<String, List<PaymentEntity>>, Failure>>
      getGroupedPayments() {
    return paymentRepo.getGroupedPaymentsFromDataSource();
  }

  Future<Either<List<PaymentEntity>, Failure>> getUpcomingPayments() {
    return paymentRepo.getUpcomingPaymentsFromDataSource();
  }

  Future<Either<List<CategoryEntity>, Failure>> getAllCategories() {
    return paymentRepo.getAllCategoriesFromDataSource();
  }

  Future<Either<void, Failure>> addPayment(
      PaymentModel payment, ReceiverModel receiver) {
    return paymentRepo.addPaymentFromDataSource(payment, receiver);
  }

  Future<Either<void, Failure>> editPayment(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) {
    return paymentRepo.editPaymentFromDataSource(
        editedPaymentInfo, editedReceiverInfo);
  }

  Future<Either<void, Failure>> deletePayment(PaymentModel payment) {
    return paymentRepo.deletePaymentFromDataSource(payment);
  }

  Future<Either<void, Failure>> addCategory(String categoryName) {
    return paymentRepo.addCategory(categoryName);
  }

  Future<Either<List<BankEntity>, Failure>> getBankList() {
    return paymentRepo.getBankList();
  }

  Future<Either<List<CategoryEntity>, Failure>> getCategoryList() {
    return paymentRepo.getCategoryList();
  }

  Future<Either<ReceiverEntity, Failure>> getReceiver(String receiverId) {
    return paymentRepo.getReceiver(receiverId);
  }

  Future<Either<void, Failure>> markPaymentAsPaid(PaymentModel payment) {
    return paymentRepo.markPaymentAsPaidFromDatasource(payment);
  }

  Future<Either<List<PaidPaymentEntity>, Failure>> getPaidPaymentList(
      DateTime date) {
    return paymentRepo.getPaidPaymentListFromDatasource(date);
  }

  Future<Either<Map<int, double>, Failure>> getMonthlyPaidAmount() {
    return paymentRepo.getMonthlyPaidAmountFromDatasource();
  }

  Future<Either<Map<String, double>, Failure>> getMonthlySummaryGroupByCategory(
      DateTime date) {
    return paymentRepo.getMonthlySummaryGroupByCategoryFromDatasource(date);
  }
}
