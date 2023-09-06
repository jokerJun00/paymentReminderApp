import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/budget_model.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';

abstract class BudgetDataSource {
  Future<BudgetingPlanModel?> getBudgetingPlanFromDataSource();

  Future<List<BudgetModel>> getBudgetListFromDataSource(String budgetingPlanId);

  Future<void> addBudgetingPlanFromDataSource(
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  );

  Future<void> editBudgetingPlanFromDataSource(
    String budgetingPlanId,
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  );

  Future<List<CategoryModel>> getCategoryListFromDataSource();
}

class BudgetDataSourceImpl implements BudgetDataSource {
  BudgetDataSourceImpl(
      {required this.firestore, required this.paymentDataSource});
  final user_id = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore;
  final PaymentDataSource paymentDataSource;

  @override
  Future<void> editBudgetingPlanFromDataSource(
    String budgetingPlanId,
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    // set Budgeting Plan
    final budgetingPlanJson = {
      'target_amount': targetAmount.toString(),
      'starting_amount': startAmount.toString(),
      'user_id': user_id,
    };
    await firestore
        .collection('BudgetingPlans')
        .doc(budgetingPlanId)
        .set(budgetingPlanJson)
        .catchError((_) => throw ServerException());

    // set all budget
    for (int i = 0; i < categoryList.length; i++) {
      final budgetData = await firestore
          .collection('Budgets')
          .where('budgeting_plan_id', isEqualTo: budgetingPlanId)
          .where('category_id', isEqualTo: categoryList[i].id)
          .get()
          .catchError((_) => throw ServerException());

      final categoryBudgetJson = {
        'budget_amount': categoryBudgetAmountList[i].toString(),
        'budgeting_plan_id': budgetingPlanId,
        'category_id': categoryList[i].id,
      };

      // check if budget has record in Satabase
      if (budgetData.docs.isNotEmpty) {
        // if (has record && budget amount > 0) => update
        await firestore
            .collection('Budgets')
            .doc(budgetData.docs.first.id)
            .set(categoryBudgetJson)
            .catchError((_) => throw ServerException());
        if (categoryBudgetAmountList[i] > 0) {
        } else {
          // if (has record && budget amount < 0) => delete
          await firestore
              .collection('Budgets')
              .doc(budgetData.docs.first.id)
              .delete()
              .catchError((_) => throw ServerException());
        }
      } else {
        // if (not record && budget amount > 0) => add new record
        if (categoryBudgetAmountList[i] > 0) {
          await firestore
              .collection('Budgets')
              .add(categoryBudgetJson)
              .catchError((_) => throw ServerException());
        }
        // if (no record && budget amount < 0) => do nothing
      }
    }
  }

  @override
  Future<void> addBudgetingPlanFromDataSource(
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    final userExistingBudgetPlan = await firestore
        .collection('BudgetingPlans')
        .where('user_id', isEqualTo: user_id)
        .get();

    // check if user already have dashboard
    if (userExistingBudgetPlan.docs.isNotEmpty) {
      final id = userExistingBudgetPlan.docs.first.id;
      // delete budgeting plan
      await firestore
          .collection('BudgetingPlans')
          .doc(id.trim())
          .delete()
          .catchError((_) => throw ServerException());

      // delete all related budgets
      await firestore
          .collection('Budgets')
          .where('budgeting_plan_id', isEqualTo: id)
          .get()
          .then((value) => value.docs.forEach((document) =>
              firestore.collection('Budgets').doc(document.id).delete()));
    }

    final budgetingPlanJson = {
      'target_amount': targetAmount.toString(),
      'starting_amount': startAmount.toString(),
      'user_id': user_id,
    };

    // create new budgeting plan
    final budgetingPlanId = await firestore
        .collection('BudgetingPlans')
        .add(budgetingPlanJson)
        .catchError((_) => throw ServerException());

    // create all category budget
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryBudgetAmountList[i] > 0) {
        final categoryBudgetJson = {
          'budget_amount': categoryBudgetAmountList[i].toString(),
          'budgeting_plan_id': budgetingPlanId.id,
          'category_id': categoryList[i].id,
        };

        await firestore
            .collection('Budgets')
            .add(categoryBudgetJson)
            .catchError((_) => throw ServerException());
      }
    }
  }

  @override
  Future<List<BudgetModel>> getBudgetListFromDataSource(
      String budgetingPlanId) async {
    final budgetListData = await firestore
        .collection('Budgets')
        .where('budgeting_plan_id', isEqualTo: budgetingPlanId)
        .get()
        .catchError((_) => throw ServerException());
    List<CategoryModel> categoryList =
        await paymentDataSource.getCategoryList();

    Map<String, double> paidPaymentList = await paymentDataSource
        .getMonthlySummaryGroupByCategoryFromDatasource(DateTime.now());

    List<BudgetModel> budgetList = [];

    budgetListData.docs.forEach((budgetData) {
      BudgetModel budget = BudgetModel.fromFirestore(budgetData);
      CategoryModel? category = categoryList.firstWhereOrNull(
          (category) => category.id.trim() == budget.category_id.trim());

      if (category != null) {
        budget.category_name = category.name;
        double? currentAmount = paidPaymentList[category.name];
        budget.current_amount = currentAmount ?? 0.0;

        budgetList.add(budget);
      }
    });

    return budgetList;
  }

  @override
  Future<BudgetingPlanModel?> getBudgetingPlanFromDataSource() async {
    final budgetingPlanData = await firestore
        .collection('BudgetingPlans')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());
    Map<String, double> paidPaymentList = await paymentDataSource
        .getMonthlySummaryGroupByCategoryFromDatasource(DateTime.now());
    double currentSpendingAmount = 0.0;

    paidPaymentList.forEach(
        (_, spendingOnCategory) => currentSpendingAmount += spendingOnCategory);

    // if user already created a budgeting plan
    if (budgetingPlanData.docs.isNotEmpty) {
      BudgetingPlanModel budgetingPlan = BudgetingPlanModel.fromFirestore(
        budgetingPlanData.docs.first,
        currentSpendingAmount,
      );

      return budgetingPlan;
    }

    return null;
  }

  @override
  Future<List<CategoryModel>> getCategoryListFromDataSource() async {
    List<CategoryModel> categoryList = [];
    final defaultCategoryListData = await firestore
        .collection('Categories')
        .where('user_id', isEqualTo: '')
        .get()
        .catchError((_) => throw ServerException());
    final userCategoryListData = await firestore
        .collection('Categories')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    defaultCategoryListData.docs.forEach((categoryData) {
      CategoryModel category = CategoryModel.fromFirestore(categoryData);
      categoryList.add(category);
    });

    userCategoryListData.docs.forEach((categoryData) {
      CategoryModel category = CategoryModel.fromFirestore(categoryData);
      categoryList.add(category);
    });

    return categoryList;
  }
}
