import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../data/models/budget_model.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.budget,
  });

  final BudgetModel budget;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            budget.category_name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.clip,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            budget.current_amount / budget.budget_amount > 1.0
                ? ">100%"
                : "${((budget.current_amount / budget.budget_amount) * 100).toStringAsFixed(0)}%",
            style: GoogleFonts.inter(
              fontSize:
                  budget.current_amount / budget.budget_amount > 1.0 ? 32 : 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          LinearPercentIndicator(
            width: 130,
            lineHeight: 20,
            percent: budget.current_amount / budget.budget_amount > 1.0
                ? 1.0
                : budget.current_amount / budget.budget_amount,
            progressColor: budget.current_amount / budget.budget_amount > 1.0
                ? Colors.red.shade400
                : const Color.fromARGB(255, 242, 223, 58),
            backgroundColor: Colors.grey.shade300,
            animation: true,
            animationDuration: 1000,
            barRadius: const Radius.circular(10),
            padding: const EdgeInsets.all(0),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
