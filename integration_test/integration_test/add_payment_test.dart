import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/navigation_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/add_payment_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/category_list_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/payments_screen.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';

import 'package:payment_reminder_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Add Payment Test Case", () {
    testWidgets("add payment category", (widgetTester) async {
      // ! login input
      const email = "test@gmail.com";
      const password = "Choon@000905";

      // ! payment input
      final payment = PaymentModel(
        id: "id",
        name: "Test Payment",
        description: "Test Payment",
        payment_date: DateTime.now(),
        notification_period: 1,
        billing_cycle: "monthly",
        expected_amount: 200.0,
        user_id: "",
        receiver_id: "",
        category_id: "",
      );
      const categoryName = "test";
      final receiver = ReceiverModel(
        id: "",
        name: "Lim Choon Kiat",
        bank_id: "",
        bank_account_no: "123456789",
        user_id: "",
      );
      const bankName = "Public bank";

      // ! set up
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

      // ! go to Add Payment Screen
      // go to Payments Screen by tapping navigation bar item
      await widgetTester.tap(find.text("Payments"));
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // verify Payment Screen loaded and display
      expect(find.byType(PaymentScreen), findsOneWidget);

      // tap add button
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle();

      // verify Add Payment Screen loaded and display
      expect(find.byType(AddPaymentScreen), findsOneWidget);

      // ! payment data input
      await widgetTester.enterText(
        find.byKey(const Key("name-text-field")),
        payment.name,
      );
      await widgetTester.enterText(
        find.byKey(const Key("description-text-field")),
        payment.description,
      );

      // payment date input pass because app will automatically set today

      // ! notification period input
      await widgetTester.tap(
        find.byKey(const Key("notification-period-text-field")),
      );
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text(
        "${payment.notification_period.toString()} days before",
      ));
      await widgetTester.pumpAndSettle();

      // ! billing cycle input
      await widgetTester.tap(
        find.byKey(const Key("billing-cycle-text-field")),
      );
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text(payment.billing_cycle));
      await widgetTester.pumpAndSettle();

      // ! category input
      // scroll down to show category text field
      await widgetTester.dragUntilVisible(
        find.byKey(const Key("category-text-field")),
        find.byType(SingleChildScrollView),
        const Offset(0, 100.0),
      );
      // tap category text field
      await widgetTester.tap(find.byKey(const Key("category-text-field")));
      await widgetTester.pumpAndSettle();
      // verify category list screen loaded and display
      expect(find.byType(CategoryListScreen), findsOneWidget);
      // tap category to select category
      await widgetTester.tap(find.text(categoryName));
      await widgetTester.tap(find.text("Confirm Category"));
      await widgetTester.pumpAndSettle();
      // verify go back to add payment screen
      expect(find.byType(AddPaymentScreen), findsOneWidget);

      // ! expected amount input
      await widgetTester.enterText(
        find.byKey(const Key("expected-amount-text-field")),
        payment.expected_amount.toString(),
      );

      // ! receiver data input
      await widgetTester.enterText(
        find.byKey(const Key("receiver-name-text-field")),
        receiver.name,
      );

      // ! bank name input
      await widgetTester.tap(find.byKey(const Key("bank-name-text-field")));
      await widgetTester.pumpAndSettle();
      await widgetTester.tap(find.text(bankName));
      await widgetTester.pumpAndSettle();

      await widgetTester.enterText(
        find.byKey(const Key("bank-account-number-text-field")),
        receiver.bank_account_no,
      );

      // tap add category button
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle();

      // verify Payment Screen loaded and display, check if payment is added
      expect(find.byType(PaymentScreen), findsOneWidget);
      expect(find.textContaining(payment.name), findsOneWidget);
    });
  });
}
