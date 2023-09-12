import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/navigation_screen.dart';
import 'package:payment_reminder_app/application/screens/user/edit_user_profile_screen.dart';
import 'package:payment_reminder_app/application/screens/user/profile_screen.dart';

import 'package:payment_reminder_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Edit User Profile Test Case", () {
    testWidgets("edit user profile", (widgetTester) async {
      // log in input
      const email = "test@gmail.com";
      const password = "Choon@000905";

      // edit input
      const username = "Choon Kiat Lim";

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
      await widgetTester.tap(find.text("Profile"));

      // verify Payment Screen loaded and display
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byType(ProfileScreen), findsOneWidget);

      // tap edit button
      await widgetTester.tap(find.text("Edit"));
      await widgetTester.pumpAndSettle();

      // verify Edit User Screen loaded and display
      expect(find.byType(EditUserProfileScreen), findsOneWidget);

      // input edited user data
      await widgetTester.enterText(
        find.byKey(const Key("username-text-field")),
        username,
      );

      // tap edit button
      await widgetTester.tap(find.byType(OutlinedButton));
      await widgetTester.pumpAndSettle();

      // type password and tap confirm to confirm edit user profile
      await widgetTester.enterText(
        find.byKey(const Key("password-text-field")),
        password,
      );
      await widgetTester.tap(find.text("Confirm"));
      await widgetTester.pumpAndSettle();

      // verify navigate back to profile screen and updated user data
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.textContaining(username), findsOneWidget);
      sleep(const Duration(seconds: 3));
    });
  });
}
