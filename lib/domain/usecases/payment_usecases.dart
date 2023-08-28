import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/bank_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/payment_model.dart';
import '../../data/repositories/payment_repo_impl.dart';
import '../entities/category_entity.dart';

class PaymentUseCases {
  final PaymentRepoImpl paymentRepoFirestore = PaymentRepoImpl();

  Future<Either<Map<String, List<PaymentEntity>>, Failure>>
      getGroupedPayments() {
    return paymentRepoFirestore.getGroupedPaymentsFromDataSource();
  }

  Future<Either<List<PaymentEntity>, Failure>> getUpcomingPayments() {
    return paymentRepoFirestore.getUpcomingPaymentsFromDataSource();
  }

  Future<Either<List<CategoryEntity>, Failure>> getAllCategories() {
    return paymentRepoFirestore.getAllCategoriesFromDataSource();
  }

  Future<Either<void, Failure>> addPayment(
      PaymentModel payment, ReceiverModel receiver) {
    return paymentRepoFirestore.addPaymentFromDataSource(payment, receiver);
  }

  Future<Either<void, Failure>> editPayment(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) {
    return paymentRepoFirestore.editPaymentFromDataSource(
        editedPaymentInfo, editedReceiverInfo);
  }

  Future<Either<void, Failure>> deletePayment(PaymentModel payment) {
    return paymentRepoFirestore.deletePaymentFromDataSource(payment);
  }

  Future<Either<void, Failure>> addCategory(String categoryName) {
    return paymentRepoFirestore.addCategory(categoryName);
  }

  Future<Either<List<BankModel>, Failure>> getBankList() {
    return paymentRepoFirestore.getBankList();
  }

  Future<Either<List<CategoryModel>, Failure>> getCategoryList() {
    return paymentRepoFirestore.getCategoryList();
  }

  Future<Either<ReceiverModel, Failure>> getReceiver(String receiverId) {
    return paymentRepoFirestore.getReceiver(receiverId);
  }

  Future<Either<void, Failure>> markPaymentAsPaid(PaymentModel payment) {
    return paymentRepoFirestore.markPaymentAsPaidFromDatasource(payment);
  }

  Future<Either<void, Failure>> payViaApp(PaymentModel payment) {
    return paymentRepoFirestore.payViaAppFromDatasource(payment);
  }

  Future<Either<List<PaidPaymentModel>, Failure>> getPaidPaymentList(
      DateTime date) {
    return paymentRepoFirestore.getPaidPaymentListFromDatasource(date);
  }

  Future<Either<Map<int, double>, Failure>> getMonthlyPaidAmount() {
    return paymentRepoFirestore.getMonthlyPaidAmountFromDatasource();
  }

  Future<Either<Map<String, double>, Failure>> getMonthlySummaryGroupByCategory(
      DateTime date) {
    return paymentRepoFirestore
        .getMonthlySummaryGroupByCategoryFromDatasource(date);
  }
}
