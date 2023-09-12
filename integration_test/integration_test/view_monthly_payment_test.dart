import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/navigation_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/monthly_summary_screen.dart';

import 'package:payment_reminder_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("View Monthly Payment Test Case", () {
    testWidgets("view monthly payment", (widgetTester) async {
      // ! login input
      const email = "test@gmail.com";
      const password = "Choon@000905";

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

      // ! view monthly payment
      // tap Bar Chart container
      final barChartPosition =
          widgetTester.getTopLeft(find.byKey(const Key("bar-chart")));
      final tapPosition = Offset(
        barChartPosition.dx + 5,
        barChartPosition.dy + 25,
      );
      await widgetTester.tapAt(tapPosition);
      await widgetTester.pumpAndSettle();

      // verify monthly summary screen loaded and display
      expect(find.byType(MonthlySummaryScreen), findsOneWidget);
      expect(find.textContaining("Monthly Payment"), findsOneWidget);
      sleep(const Duration(seconds: 3));
    });
  });
}
