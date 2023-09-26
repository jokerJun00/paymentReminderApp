import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/auth/signup_screen.dart';
import 'package:payment_reminder_app/application/screens/navigation_screen.dart';

import 'package:payment_reminder_app/main.dart' as app;

bool findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan && visitor.text == text) {
    (visitor.recognizer as TapGestureRecognizer).onTap!();
    return false;
  }
  return true;
}

bool tapTextSpan(RichText richText, String text) {
  final isTapped = !richText.text.visitChildren(
    (visitor) => findTextAndTap(visitor, text),
  );
  return isTapped;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("Sign Up Test Case", () {
    testWidgets("Sign Up", (widgetTester) async {
      const userName = "Lim Jun Kiat";
      const email = "test@gmail.com";
      const phoneNumber = "176835363";
      const password = "Choon@000905";

      // set up
      app.main();

      // wait for app run and splash screen is loaded
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // check if login screen load and wait for login fully loaded
      expect(find.byType(LogInScreen), findsOneWidget);
      await widgetTester.pumpAndSettle();

      // click to button navigate to Sign Up Screen
      final signUpNavigationTextFinder = find.byWidgetPredicate(
        (widget) =>
            widget is RichText && tapTextSpan(widget, 'Sign up an account'),
      );
      await widgetTester.tap(signUpNavigationTextFinder);

      // check if signup screen load
      await widgetTester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SignUpScreen), findsOneWidget);

      // input data
      await widgetTester.enterText(
        find.byKey(const Key("username-text-field")),
        userName,
      );
      await widgetTester.enterText(
        find.byKey(const Key("email-text-field")),
        email,
      );
      await widgetTester.enterText(
        find.byKey(const Key("phoneNumber-text-field")),
        phoneNumber,
      );
      await widgetTester.enterText(
        find.byKey(const Key("password-text-field")),
        password,
      );
      await widgetTester.enterText(
        find.byKey(const Key("confirm-password-text-field")),
        password,
      );

      // click sign up button and wait for log in screen display
      await widgetTester.dragUntilVisible(
        find.byType(OutlinedButton),
        find.byType(SingleChildScrollView),
        const Offset(0, 100.0),
      );
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      // check if the application has login and display home screen
      expect(find.byType(NavigationScreen), findsOneWidget);
      expect(find.text("Dashboard"), findsOneWidget);
      sleep(const Duration(seconds: 3));
    });
  });
}
