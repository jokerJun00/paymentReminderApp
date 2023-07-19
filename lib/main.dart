import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// screen
import 'Screens/NavigationScreen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 146, 180, 236),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // restrict to potrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) => {runApp(const MyPaymentReminderApp())});
}

class MyPaymentReminderApp extends StatelessWidget {
  const MyPaymentReminderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPayment Reminder',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        scaffoldBackgroundColor: kColorScheme.primaryContainer,
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
            backgroundColor: const Color.fromARGB(255, 242, 223, 58),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            textStyle: const TextStyle(
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
      ),
      home: const NavigationScreen(),
    );
  }
}
