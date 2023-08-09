import 'package:flutter/material.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Payment List Screen'),
      ),
    );
  }
}
