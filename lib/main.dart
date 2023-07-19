import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 146, 180, 236),
  background: const Color.fromARGB(255, 146, 180, 236),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPayment Reminder',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
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
      ),
      home: const MyHomePage(title: 'MyPayment Reminder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "MyPayment Reminder",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
