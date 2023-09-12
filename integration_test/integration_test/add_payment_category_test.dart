import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/navigation_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/add_payment_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/category_list_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/payments_screen.dart';

import 'package:payment_reminder_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Add Payment Category Test Case", () {
    testWidgets("add payment category", (widgetTester) async {
      // login input
      const email = "test@gmail.com";
      const password = "Choon@000905";

      // add category input
      const categoryName = "test";

      // set up
      app.main();

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

      // tap add button
      await widgetTester.tap(find.text("Add"));
      await widgetTester.pumpAndSettle();

      // enter category name input
      await widgetTester.enterText(
        find.byKey(const Key("category-name-text-field")),
        categoryName,
      );

      // tap Add Category button
      await widgetTester.tap(find.text("Add Category"));
      await widgetTester.pumpAndSettle();

      // verify category added
      expect(find.textContaining(categoryName), findsOneWidget);
    });
  });
}
