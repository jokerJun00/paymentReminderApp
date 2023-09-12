import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/budget/add_budgeting_dashboard_screen.dart';
import 'package:payment_reminder_app/application/screens/budget/budgeting_dashboard_screen.dart';
import 'package:payment_reminder_app/application/screens/navigation_screen.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';

import 'package:payment_reminder_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Add Budgeting Plan Test Case", () {
    testWidgets("add budgeting plan", (widgetTester) async {
      // ! login input
      const email = "test@gmail.com";
      const password = "Choon@000905";

      // ! budgeting plan input
      final budgetingPlan = BudgetingPlanModel(
        id: "",
        target_amount: 2000.0,
        starting_amount: 0.0,
        current_spending_amount: 0.0,
        user_id: "",
      );
      const categoryName = "subscriptions";
      const categoryBudgetAmount = "300.0";
      final budgetAmount =
          budgetingPlan.target_amount - budgetingPlan.starting_amount;

      // set up
      app.main();

      // ! login
      // wait for app run and splash screen is loaded
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // check if login screen load and wait for login fully loaded
      expect(find.byType(LogInScreen), findsOneWidget);
      await widgetTester.pumpAndSettle();

      // enter email and password
      await widgetTester.enterText(
        find.byKey(const Key("email-text-field")),
        email,
      );
      await widgetTester.enterText(
        find.byKey(const Key("password-text-field")),
        password,
      );

      // click login button and wait for navigation screen display
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // check if the application has login and display home screen
      expect(find.byType(NavigationScreen), findsOneWidget);
      expect(find.text("Dashboard"), findsOneWidget);

      // ! go to Add Budgeting Plan Screen
      // go to Payments Screen by tapping navigation bar item
      await widgetTester.tap(find.text("Budgets"));
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // verify Payment Screen loaded and display
      expect(find.byType(BudgetingDashboardScreen), findsOneWidget);

      // tap add button
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle();

      // verify Add Payment Screen loaded and display
      expect(find.byType(AddBudgetingDashboardScreen), findsOneWidget);

      // ! input budgeting plan data
      await widgetTester.enterText(
        find.byKey(const Key("starting-amount-text-field")),
        budgetingPlan.starting_amount.toString(),
      );
      await widgetTester.enterText(
        find.byKey(const Key("target-amount-text-field")),
        budgetingPlan.target_amount.toString(),
      );
      await widgetTester.enterText(
        find.byKey(const Key("$categoryName-category-text-field")),
        categoryBudgetAmount,
      );

      // scroll to find Budget Plan Button
      await widgetTester.dragUntilVisible(
        find.byType(OutlinedButton),
        find.byType(ListView),
        const Offset(0, -100.0),
      );

      // tap Create Budget Plan Button
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // verify budgeting dashboard screen loaded and display
      expect(find.byType(BudgetingDashboardScreen), findsOneWidget);

      // verify if budgeting plan added
      expect(find.textContaining("RM $budgetAmount"), findsOneWidget);
      expect(find.textContaining(categoryName), findsOneWidget);
    });
  });
}
