import 'package:flutter/material.dart';
import 'package:payment_reminder_app/application/screens/payment/payment_detail_screen.dart';
import 'package:payment_reminder_app/data/models/payment_model.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentDetailScreen(payment: payment),
        ),
      ),
      child: const Center(child: Text('Payment Card')),
    );
  }
}
