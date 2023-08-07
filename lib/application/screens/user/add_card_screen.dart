import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Credit or Debit Card',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          CardFormField(
            controller: CardFormEditController(),
            style: CardFormStyle(
              backgroundColor: Colors.white,
              borderWidth: 1,
              textColor: Colors.black,
              placeholderColor: Colors.black,
              textErrorColor: Colors.red,
              borderColor: Colors.black,
              borderRadius: 10,
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Add Card'),
          ),
        ],
      ),
    ));
  }
}
