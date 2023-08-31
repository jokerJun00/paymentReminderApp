import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../data/models/budget_model.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.categoryName,
    required this.budget,
    required this.currentAmount,
  });

  final String categoryName;
  final BudgetModel budget;
  final double currentAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "${((currentAmount / budget.budgeting_amount) * 100).toStringAsFixed(0)}%",
            style: GoogleFonts.inter(fontSize: 55, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            width: 130,
            lineHeight: 20,
            percent: currentAmount / budget.budgeting_amount,
            progressColor: const Color.fromARGB(255, 242, 223, 58),
            backgroundColor: Colors.grey.shade300,
            animation: true,
            animationDuration: 1000,
            barRadius: const Radius.circular(10),
            padding: const EdgeInsets.all(0),
          )
        ],
      ),
    );
  }
}
