import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/screens/payment/add_payment_screen.dart';

import '../../../data/models/payment_model.dart';
import '../../widgets/payment_card.dart';
import 'cubit/payment_cubit.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentModel> payments = <PaymentModel>[];

  @override
  void initState() {
    BlocProvider.of<PaymentCubit>(context).getAllPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateInitial) {
          payments = state.payments as List<PaymentModel>;
        } else if (state is PaymentStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is PaymentStateLoadingData ||
            state is PaymentStateLoadingData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PaymentStateInitial && payments.length == 0) {
          return const Scaffold(
            body: Center(child: Text("You do not have any payment yet")),
          );
        }

        return Scaffold(
          body: (state is PaymentStateEditingData ||
                  state is PaymentStateLoadingData)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Payment List",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AddPaymentScreen(),
                              ),
                            ),
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                      (payments.isEmpty)
                          ? const Center(
                              child: Text("You do not have any payment yet"),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: payments.length,
                                itemBuilder: (context, index) {
                                  return PaymentCard(payment: payments[index]);
                                },
                              ),
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
