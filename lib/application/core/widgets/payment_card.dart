import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';
import 'package:payment_reminder_app/application/screens/payment/payment_detail_screen.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';

import '../services/date_time_formatter.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard(
      {super.key, required this.payment, required this.deviceWidth});

  final PaymentModel payment;
  final double deviceWidth;

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
              builder: (_) => BlocProvider.value(
                value: context.read<PaymentCubit>(),
                child: PaymentDetailScreen(payment: payment),
              ),
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
                        maxLines: 1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "RM ${payment.expected_amount.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Date: ${DateTimeFormatter.formatDay(payment.payment_date)}",
                        ),
                        Text(
                            "Notify Period: ${payment.notification_period} days"),
                      ],
                    ),
                    deviceWidth > 350
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Billing Cycle:"),
                              Text(payment.billing_cycle),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
