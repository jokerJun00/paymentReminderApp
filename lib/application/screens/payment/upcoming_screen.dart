import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';
import 'package:payment_reminder_app/application/core/widgets/upcoming_payment_card.dart';
import 'package:payment_reminder_app/application/screens/payment/payment_history_screen.dart';

import '../../../data/models/payment_model.dart';

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  List<PaymentModel> upcomingPaymentList = [];

  void getUpcomingPayment() async {
    final upcomingPaymentFromDatabase =
        await BlocProvider.of<PaymentCubit>(context).getUpcomingPayment();

    setState(() {
      upcomingPaymentList = upcomingPaymentFromDatabase;
    });
  }

  void markAsPaid(PaymentModel payment) async {
    await BlocProvider.of<PaymentCubit>(context)
        .markPaymentAsPaid(payment)
        .then((_) {
      setState(() {
        upcomingPaymentList.remove(payment);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUpcomingPayment();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Scaffold(
              body: (state is PaymentStateEditingData ||
                      state is PaymentStateLoadingData)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 90,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          width > 400
                              ? Row(
                                  children: [
                                    Text(
                                      "Upcoming Payments",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Spacer(),
                                    OutlinedButton(
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value:
                                                BlocProvider.of<PaymentCubit>(
                                                    context),
                                            child: PaymentHistoryScreen(
                                              date: DateTime.now(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      style: Theme.of(context)
                                          .outlinedButtonTheme
                                          .style!
                                          .copyWith(
                                            padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                            ),
                                          ),
                                      child: const Text("History"),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Upcoming Payments",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    Row(
                                      children: [
                                        OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                value: BlocProvider.of<
                                                    PaymentCubit>(context),
                                                child: PaymentHistoryScreen(
                                                  date: DateTime.now(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          style: Theme.of(context)
                                              .outlinedButtonTheme
                                              .style!
                                              .copyWith(
                                                padding:
                                                    MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                                ),
                                              ),
                                          child: const Text("History"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                          Expanded(
                            child: Center(
                              child: upcomingPaymentList.isEmpty
                                  ? Text(
                                      "You do not have any upcoming payment now",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            overflow: TextOverflow.clip,
                                          ),
                                    )
                                  : ListView.builder(
                                      itemCount: upcomingPaymentList.length,
                                      itemBuilder: (context, index) =>
                                          UpcomingPaymentCard(
                                        payment: upcomingPaymentList[index],
                                        markAsPaid: () => markAsPaid(
                                          upcomingPaymentList[index],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
