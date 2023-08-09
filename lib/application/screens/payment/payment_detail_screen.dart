import 'package:flutter/material.dart';

import '../../../data/models/payment_model.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({super.key, required this.payment});

  final PaymentModel payment;

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Payment Detail Screen'),
    );
  }
}
