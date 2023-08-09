import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:payment_reminder_app/application/screens/user/add_card_screen.dart';
import 'package:payment_reminder_app/application/screens/auth/cubit/auth_cubit.dart';
import 'package:payment_reminder_app/application/screens/splash_screen.dart';
import 'firebase_options.dart';

import '.env';

// screen
import 'package:payment_reminder_app/application/screens/payment/payments_screen.dart';
import 'package:payment_reminder_app/application/screens/auth/login_screen.dart';
import 'package:payment_reminder_app/application/screens/auth/signup_screen.dart';
import 'package:payment_reminder_app/application/screens/auth/navigation_screen.dart';
import 'package:payment_reminder_app/application/screens/budgets_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/home_screen.dart';
import 'package:payment_reminder_app/application/screens/user/profile_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/upcoming_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 89, 180, 236),
);

var primaryColor = const Color.fromARGB(255, 183, 205, 241);
var secondaryColor = const Color.fromARGB(255, 239, 239, 239);
var hightlightColor = const Color.fromARGB(255, 242, 223, 58);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // stripe setup
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();

  // firebase setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // restrict to potrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) => {runApp(const MyPaymentReminderApp())});
}

class MyPaymentReminderApp extends StatefulWidget {
  const MyPaymentReminderApp({Key? key}) : super(key: key);

  @override
  State<MyPaymentReminderApp> createState() => _MyPaymentReminderAppState();
}

class _MyPaymentReminderAppState extends State<MyPaymentReminderApp> {
  final AuthCubit _authCubit = AuthCubit();

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'MyPayment Reminder',
        // app theme setting
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          scaffoldBackgroundColor: primaryColor,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
          ),
          textTheme: ThemeData().textTheme.copyWith(
                titleLarge: const TextStyle(
                  // font style for title
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir Next Condensed',
                  fontSize: 36,
                  color: Colors.black,
                ),
                titleMedium: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir Next Condensed',
                  fontSize: 30,
                  color: Colors.black,
                ),
                titleSmall: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir Next Condensed',
                  fontSize: 24,
                  color: Colors.black,
                ),
                labelMedium: GoogleFonts.inter(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                // font style for normal text
                bodyLarge: GoogleFonts.inter(
                  fontSize: 20,
                  color: Colors.black,
                ),
                bodyMedium: GoogleFonts.inter(
                  fontSize: 18,
                  color: Colors.black,
                ),
                bodySmall: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: hightlightColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              textStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: const Color.fromARGB(255, 253, 138, 138),
            unselectedItemColor: Colors.black,
            selectedIconTheme: const IconThemeData().copyWith(size: 25),
            unselectedIconTheme: const IconThemeData().copyWith(size: 25),
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
          inputDecorationTheme: ThemeData().inputDecorationTheme.copyWith(
                labelStyle: Theme.of(context).textTheme.bodySmall,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                errorStyle: GoogleFonts.inter(color: Colors.red, fontSize: 12),
                errorMaxLines: 3,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
              ),
        ),
        routes: {
          '/': (context) => const HomeScreen(),
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LogInScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/navigation': (context) => const NavigationScreen(),
          '/budgets': (context) => const BudgetsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/payments': (context) => const PaymentScreen(),
          '/upcomingScreen': (context) => const UpcomingScreen(),
          '/addCard': (context) => const AddCardScreen(),
        },
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? '/splash'
            : '/navigation',
      ),
    );
  }
}
