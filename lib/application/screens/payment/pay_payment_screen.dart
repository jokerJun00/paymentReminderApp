import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/models/payment_model.dart';

class PayPaymentScreen extends StatelessWidget {
  const PayPaymentScreen({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.of(context).pop(),
                icon: const FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 40,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Pay Payment',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              CardFormField(
                controller: CardFormEditController(),
                // style: CardFormStyle(borderWidth: 3, borderRadius: 5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
