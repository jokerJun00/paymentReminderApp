import 'package:flutter/material.dart';
import 'package:payment_reminder_app/application/screens/payment/payment_detail_screen.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PaymentDetailScreen(),
        ),
      ),
      child: const Center(child: Text('Payment Card')),
    );
  }
}
