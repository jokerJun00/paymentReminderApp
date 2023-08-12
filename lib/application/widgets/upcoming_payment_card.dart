import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/screens/payment/pay_payment_screen.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';

import '../../date_time_formatter.dart';

class UpcomingPaymentCard extends StatelessWidget {
  const UpcomingPaymentCard({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
            side: BorderSide(width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: InkWell(
          splashColor: Colors.grey.withAlpha(30),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PayPaymentScreen(payment: payment),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Text(
                        payment.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 4,
                      child: Text(
                        "RM ${payment.expected_amount.toStringAsFixed(2)}",
                        style: GoogleFonts.inter(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  "Due on: ${DateTimeFormatter.formatDateTime(payment.payment_date)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
