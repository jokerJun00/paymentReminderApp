// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/core/widgets/upcoming_payment_card.dart';

import '../../../data/models/payment_model.dart';
import 'cubit/payment_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Payment> _monthlyPaymentsData = List<Payment>.empty(growable: true);
  List<PaymentModel> upcomingPaymentList = [];
  Map<String, double> monthlySummary = {};

  void getMonthlySummary() async {
    final monthlySummaryFromDatabase =
        await BlocProvider.of<PaymentCubit>(context).getMonthlyPaidAmount();

    setState(() {
      monthlySummary = monthlySummaryFromDatabase;
    });
  }

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
    getMonthlySummary();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Scaffold(
              body: (state is PaymentStateLoadingData)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 90),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(1, 255, 120, 140),
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text('Coming soon...'),
                            ),
                          ),
                          // BarChart(
                          //   BarChartData(barTouchData: , titlesData: , )
                          // ),
                          const SizedBox(height: 50),
                          Text(
                            'Upcoming Payments',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Expanded(
                            child: Center(
                              child: upcomingPaymentList.isEmpty
                                  ? const Text(
                                      "You do not have any upcoming payment now")
                                  : ListView.builder(
                                      itemCount: upcomingPaymentList.length > 3
                                          ? 3
                                          : upcomingPaymentList.length,
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
