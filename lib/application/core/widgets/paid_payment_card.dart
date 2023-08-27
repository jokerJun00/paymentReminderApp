import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/data/models/paid_payment.dart';

import '../services/date_time_formatter.dart';

class PaidPaymentCard extends StatelessWidget {
  const PaidPaymentCard({super.key, required this.paidPayment});

  final PaidPaymentModel paidPayment;

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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      paidPayment.payment_name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "RM ${paidPayment.amount_paid.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                "Date: ${DateTimeFormatter.formatDateTime(paidPayment.date)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Text(
                "Receiver: ${paidPayment.receiver_name}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
