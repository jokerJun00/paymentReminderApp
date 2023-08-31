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

  Future<void> editBudgetListFromDataSource();

  Future<List<CategoryModel>> getCategoryListFromDataSource();
}

class BudgetDataSourceImpl implements BudgetDataSource {
  final user_id = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PaymentDataSource paymentDataSource = PaymentDataSourceImpl();

  @override
  Future<void> editBudgetListFromDataSource() {
    // TODO: implement editBudgetListFromDataSource
    throw UnimplementedError();
  }

  @override
  Future<void> addBudgetingPlanFromDataSource(
    double startAmount,
    double targetAmount,
    List<double> categoryBudgetAmountList,
    List<CategoryModel> categoryList,
  ) async {
    final userExistingBudgetPlan = await _firestore
        .collection('BudgetingPlans')
        .where('user_id', isEqualTo: user_id)
        .get();

    // check if user already have dashboard
    if (userExistingBudgetPlan.docs.isNotEmpty) {
      final id = userExistingBudgetPlan.docs.first.id;
      // delete budgeting plan
      await _firestore
          .collection('BudgetingPlans')
          .doc(id.trim())
          .delete()
          .catchError((_) => throw ServerException());

      // delete all related budgets
      await _firestore
          .collection('Budgets')
          .where('budgeting_plan_id', isEqualTo: id)
          .get()
          .then((value) => value.docs.forEach((document) =>
              _firestore.collection('Budgets').doc(document.id).delete()));
    }

    final budgetingPlanJson = {
      'target_amount': targetAmount.toString(),
      'starting_amount': startAmount.toString(),
      'user_id': user_id,
    };

    // create new budgeting plan
    final budgetingPlanId = await _firestore
        .collection('BudgetingPlans')
        .add(budgetingPlanJson)
        .catchError((_) => throw ServerException());

    // create all category budget
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryBudgetAmountList[i] <= 0) {
        return;
      }

      final categoryBudgetJson = {
        'budget_amount': categoryBudgetAmountList[i].toString(),
        'budgeting_plan_id': budgetingPlanId.id,
        'category_id': categoryList[i].id,
      };

      await _firestore
          .collection('Budgets')
          .add(categoryBudgetJson)
          .catchError((_) => throw ServerException());
    }
  }

  @override
  Future<List<BudgetModel>> getBudgetListFromDataSource(
      String budgetingPlanId) async {
    final budgetListData = await _firestore
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
    final budgetingPlanData = await _firestore
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
    final defaultCategoryListData = await _firestore
        .collection('Categories')
        .where('user_id', isEqualTo: '')
        .get()
        .catchError((_) => throw ServerException());
    final userCategoryListData = await _firestore
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
