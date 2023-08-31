import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';

class BudgetingPlanCard extends StatelessWidget {
  const BudgetingPlanCard({super.key, required this.budgetingPlan});

  final BudgetingPlanModel budgetingPlan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(1, 157, 241, 223).withAlpha(255),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Budget", style: GoogleFonts.inter(fontSize: 24)),
          Text(
            "RM ${budgetingPlan.target_amount.toStringAsFixed(2)}",
            style: GoogleFonts.inter(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text("Current Spending", style: GoogleFonts.inter(fontSize: 24)),
          Text(
            "RM ${budgetingPlan.spend_amount.toStringAsFixed(2)}",
            style: GoogleFonts.inter(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
