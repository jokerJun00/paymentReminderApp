import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';

import '../services/date_time_formatter.dart';

class UpcomingPaymentCard extends StatelessWidget {
  const UpcomingPaymentCard(
      {super.key, required this.payment, required this.markAsPaid});

  final PaymentModel payment;
  final Function markAsPaid;

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
          onTap: () => _dialogBuilder(context, markAsPaid),
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
                        payment.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "RM ${payment.expected_amount.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.bold),
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

  Future<void> _dialogBuilder(BuildContext context, Function markAsPaid) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Mark your payment as paid',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text(
            "This payment will mark as paid and store your payment history",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Mark as Paid'),
              onPressed: () {
                markAsPaid();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
