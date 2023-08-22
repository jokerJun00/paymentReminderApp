import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/domain/entities/payment_entity.dart';
import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../data/models/bank_model.dart';
import '../../data/models/payment_model.dart';
import '../../data/repositories/payment_repo_impl.dart';
import '../entities/category_entity.dart';

class PaymentUseCases {
  final PaymentRepoImpl paymentRepoFirestore = PaymentRepoImpl();

  Future<Either<List<PaymentEntity>, Failure>> getAllPayments() {
    return paymentRepoFirestore.getAllPaymentsFromDataSource();
  }

  Future<Either<List<CategoryEntity>, Failure>> getAllCategories() {
    return paymentRepoFirestore.getAllCategoriesFromDataSource();
  }

  Future<Either<void, Failure>> addPayment(
      PaymentModel payment, ReceiverModel receiver) {
    return paymentRepoFirestore.addPaymentFromDataSource(payment, receiver);
  }

  Future<Either<void, Failure>> editPayment(PaymentModel payment) {
    return paymentRepoFirestore.editPaymentFromDataSource(payment);
  }

  Future<Either<void, Failure>> deletePayment(String paymentId) {
    return paymentRepoFirestore.deletePaymentFromDataSource(paymentId);
  }

  Future<Either<void, Failure>> addCategory(String categoryName) {
    return paymentRepoFirestore.addCategory(categoryName);
  }

  Future<Either<List<BankModel>, Failure>> getBankList() {
    return paymentRepoFirestore.getBankList();
  }
}
