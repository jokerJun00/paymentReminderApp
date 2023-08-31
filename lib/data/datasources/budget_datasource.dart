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

  Future<void> editBudgetingPlanFromDataSource();

  Future<void> editBudgetListFromDataSource();
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
  Future<void> editBudgetingPlanFromDataSource() {
    // TODO: implement editBudgetingPlanFromDataSource
    throw UnimplementedError();
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
}
