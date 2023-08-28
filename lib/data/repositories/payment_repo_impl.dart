import 'package:dartz/dartz.dart';
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart';
import 'package:payment_reminder_app/data/models/bank_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';
import 'package:payment_reminder_app/domain/entities/category_entity.dart';

import 'package:payment_reminder_app/domain/entities/payment_entity.dart';

import 'package:payment_reminder_app/domain/failures/failures.dart';

import '../../domain/repositories/payment_repo.dart';
import '../exceptions/exceptions.dart';
import '../models/payment_model.dart';
import '../models/receiver_model.dart';

class PaymentRepoImpl implements PaymentRepo {
  final PaymentDataSource paymentDataSource = PaymentDataSourceImpl();

  @override
  Future<Either<void, Failure>> addPaymentFromDataSource(
      PaymentModel newPayment, ReceiverModel receiver) async {
    try {
      return left(await paymentDataSource.addPaymentFromDataSource(
          newPayment, receiver));
    } on ServerException catch (_) {
      return right(
          ServerFailure(error: "Edit payment failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> deletePaymentFromDataSource(
      PaymentModel payment) async {
    try {
      return left(await paymentDataSource.deletePaymentFromDataSource(payment));
    } on ServerException catch (_) {
      return right(
          ServerFailure(error: "Edit payment failed. Please check your input"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> editPaymentFromDataSource(
      PaymentModel editedPaymentInfo, ReceiverModel editedReceiverInfo) async {
    try {
      return left(await paymentDataSource.editPaymentFromDataSource(
        editedPaymentInfo,
        editedReceiverInfo,
      ));
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

  @override
  Future<Either<List<CategoryEntity>, Failure>>
      getAllCategoriesFromDataSource() async {
    try {
      return left(await paymentDataSource.getAllCategoriesFromDataSource());
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to retrieve payment data"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> addCategory(String categoryName) async {
    try {
      return left(await paymentDataSource.addCategory(categoryName));
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to add new category."));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<BankModel>, Failure>> getBankList() async {
    try {
      return left(await paymentDataSource.getBankList());
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to get bank list"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<CategoryModel>, Failure>> getCategoryList() async {
    try {
      return left(await paymentDataSource.getCategoryList());
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to get category list"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<ReceiverModel, Failure>> getReceiver(String receiverId) async {
    try {
      return left(await paymentDataSource.getReceiver(receiverId));
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to get receiver"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<PaymentEntity>, Failure>>
      getUpcomingPaymentsFromDataSource() async {
    try {
      return left(await paymentDataSource.getUpcomingPaymentsFromDataSource());
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to retrieve payment data"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> markPaymentAsPaid(PaymentModel payment) async {
    try {
      return left(
          await paymentDataSource.markPaymentAsPaidFromDataSource(payment));
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to mark payment as paid"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> payViaApp(PaymentModel payment) async {
    try {
      return left(await paymentDataSource.payViaAppFromDataSource(payment));
    } on ServerException catch (_) {
      return right(ServerFailure(
          error:
              "Transaction fail, please check if your information provided is correct"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<PaidPaymentModel>, Failure>> getPaidPaymentList(
      DateTime date) async {
    try {
      return left(
          await paymentDataSource.getPaidPaymentListFromDataSource(date));
    } on ServerException catch (_) {
      return right(ServerFailure(error: "Fail to retrieve paid payment data"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }

  @override
  Future<Either<List<double>, Failure>> getMonthlyPaidAmount() async {
    try {
      return left(await paymentDataSource.getMonthlyPaidAmountFromSource());
    } on ServerException catch (_) {
      return right(ServerFailure(
          error: "Fail to retrieve monthly summary for dashboard"));
    } catch (e) {
      return right(GeneralFailure(error: e.toString()));
    }
  }
}
