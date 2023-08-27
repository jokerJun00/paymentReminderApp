import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payment_reminder_app/application/core/services/date_time_formatter.dart';
import 'package:payment_reminder_app/application/core/widgets/paid_payment_card.dart';

import '../../../data/models/paid_payment.dart';
import 'cubit/payment_cubit.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key, required this.date});

  final DateTime date;

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  String month = "";
  List<PaidPaymentModel> paidPaymentList = [];

  void getPaymentHistory() async {
    final paidPaymentListFromDatabase =
        await BlocProvider.of<PaymentCubit>(context)
            .getPaidPaymentList(widget.date);

    setState(() {
      paidPaymentList = paidPaymentListFromDatabase;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      month = DateTimeFormatter.formatMonth(widget.date);
    });
    getPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: BlocProvider.value(
                        value: context.read<PaymentCubit>(),
                        child: PaymentHistoryScreen(
                          date: DateTime(
                            widget.date.year,
                            widget.date.month - 1,
                            widget.date.day,
                          ),
                        ),
                      ),
                      type: PageTransitionType.leftToRight,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.angleLeft,
                    size: 12,
                  ),
                ),
                Text("$month ${widget.date.year}",
                    style: Theme.of(context).textTheme.bodySmall),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: BlocProvider.value(
                        value: context.read<PaymentCubit>(),
                        child: PaymentHistoryScreen(
                          date: DateTime(
                            widget.date.year,
                            widget.date.month + 1,
                            widget.date.day,
                          ),
                        ),
                      ),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.angleRight,
                    size: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("Payment History",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: paidPaymentList.length,
                itemBuilder: (context, index) {
                  return PaidPaymentCard(paidPayment: paidPaymentList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
