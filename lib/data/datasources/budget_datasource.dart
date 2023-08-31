import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_reminder_app/application/core/widgets/paid_payment_card.dart';
import 'package:payment_reminder_app/data/datasources/payment_datasource.dart';
import 'package:payment_reminder_app/data/exceptions/exceptions.dart';
import 'package:payment_reminder_app/data/models/budget_model.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';
import 'package:payment_reminder_app/data/models/category_model.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';

import '../../domain/failures/failures.dart';

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

    Map<String, double> paidPaymentList =
        await paymentDataSource.getMonthlySummaryGroupByCategoryFromDatasource(
            DateTime.now().subtract(const Duration(days: 30)));
    print("Paid Payment List ====> $paidPaymentList");

    List<BudgetModel> budgetList = [];

    budgetListData.docs.forEach((budgetData) {
      BudgetModel budget = BudgetModel.fromFirestore(budgetData);
      CategoryModel? category = categoryList.firstWhereOrNull(
          (category) => category.id.trim() == budget.category_id.trim());

      if (category != null) {
        double? currentAmount = paidPaymentList[category.name];
        print("Current Amount =====> $currentAmount");
        if (currentAmount != null) {
          budget.category_name = category.name;
          budget.current_amount = paidPaymentList[category.name]!;
          budgetList.add(budget);
        }
      }
    });

    print("budgetList ======> $budgetList");

    return budgetList;
  }

  @override
  Future<BudgetingPlanModel?> getBudgetingPlanFromDataSource() async {
    final budgetingPlanData = await _firestore
        .collection('BudgetingPlans')
        .where('user_id', isEqualTo: user_id)
        .get()
        .catchError((_) => throw ServerException());

    // if user already created a budgeting plan
    if (budgetingPlanData.docs.isNotEmpty) {
      BudgetingPlanModel budgetingPlan =
          BudgetingPlanModel.fromFirestore(budgetingPlanData.docs.first);

      return budgetingPlan;
    }

    return null;
  }
}
