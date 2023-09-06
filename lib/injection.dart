import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:payment_reminder_app/application/screens/auth/cubit/auth_cubit.dart';
import 'package:payment_reminder_app/application/screens/budget/cubit/budget_cubit.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';
import 'package:payment_reminder_app/application/screens/user/cubit/user_cubit.dart';
import 'package:payment_reminder_app/data/datasources/auth_datasource.dart';
import 'package:payment_reminder_app/data/datasources/budget_datasource.dart';
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart';
import 'package:payment_reminder_app/data/datasources/user_datasource.dart';
import 'package:payment_reminder_app/data/repositories/auth_repo_impl.dart';
import 'package:payment_reminder_app/data/repositories/budget_repo_impl.dart';
import 'package:payment_reminder_app/data/repositories/payment_repo_impl.dart';
import 'package:payment_reminder_app/data/repositories/user_repo_impl.dart';
import 'package:payment_reminder_app/domain/repositories/auth_repo.dart';
import 'package:payment_reminder_app/domain/repositories/budget_repo.dart';
import 'package:payment_reminder_app/domain/repositories/payment_repo.dart';
import 'package:payment_reminder_app/domain/repositories/user_repo.dart';
import 'package:payment_reminder_app/domain/usecases/auth_usecases.dart';
import 'package:payment_reminder_app/domain/usecases/budget_usecases.dart';
import 'package:payment_reminder_app/domain/usecases/payment_usecases.dart';
import 'package:payment_reminder_app/domain/usecases/user_usecases.dart';

final sl = GetIt.instance; // sl == Service Locator

Future<void> init() async {
  // ! application layer
  sl.registerFactory(() => UserCubit(userUseCases: sl()));
  sl.registerFactory(() => PaymentCubit(paymentUseCases: sl()));
  sl.registerFactory(() => BudgetCubit(budgetUseCases: sl()));
  sl.registerFactory(() => AuthCubit(authUseCases: sl()));

  // ! domain layer
  sl.registerFactory(() => UserUseCases(userRepo: sl()));
  sl.registerFactory(() => PaymentUseCases(paymentRepo: sl()));
  sl.registerFactory(() => BudgetUseCases(budgetRepo: sl()));
  sl.registerFactory(() => AuthUseCases(authRepo: sl()));

  // ! data layer
  sl.registerFactory<UserRepo>(() => UserRepoImpl(userDataSource: sl()));
  sl.registerFactory<UserDataSource>(
      () => UserDataSourceImpl(firebaseAuth: sl(), firestore: sl()));
  sl.registerFactory<PaymentRepo>(
      () => PaymentRepoImpl(paymentDataSource: sl()));
  sl.registerFactory<PaymentDataSource>(
      () => PaymentDataSourceImpl(firebaseAuth: sl(), firestore: sl()));
  sl.registerFactory<BudgetRepo>(() => BudgetRepoImpl(budgetDataSource: sl()));
  sl.registerFactory<BudgetDataSource>(
      () => BudgetDataSourceImpl(firestore: sl(), paymentDataSource: sl()));
  sl.registerFactory<AuthRepo>(() => AuthRepoImpl(authDataSource: sl()));
  sl.registerFactory<AuthDataSource>(
      () => AuthDataSourceImpl(firestore: sl(), firebaseAuth: sl()));

  // ! externs
  sl.registerFactory(() => FirebaseAuth.instance);
  sl.registerFactory(() => FirebaseFirestore.instance);
}
