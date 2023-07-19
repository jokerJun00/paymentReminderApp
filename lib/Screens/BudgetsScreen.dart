import 'package:flutter/material.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "This is Budget Screen",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
