// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/widgets/upcoming_payment_card.dart';

import '../../../data/models/payment_model.dart';
import 'cubit/payment_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.navigateToUpcoming});

  final Function() navigateToUpcoming;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Payment> _monthlyPaymentsData = List<Payment>.empty(growable: true);
  List<PaymentModel> upcomingPaymentList = [];

  void getUpcomingPayment() async {
    final upcomingPaymentFromDatabase =
        await BlocProvider.of<PaymentCubit>(context).getUpcomingPayment();

    setState(() {
      upcomingPaymentList = upcomingPaymentFromDatabase;
    });
  }

  @override
  void initState() {
    super.initState();
    getUpcomingPayment();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        return Scaffold(
          body: (state is PaymentStateLoadingData)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 90),
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
                      Row(
                        children: [
                          Text(
                            'Upcoming Payments',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => widget.navigateToUpcoming,
                            child: Text(
                              'view all',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: upcomingPaymentList.isEmpty
                              ? const Text(
                                  "You do not have any upcoming payment now")
                              : ListView.builder(
                                  itemCount: upcomingPaymentList.length,
                                  itemBuilder: (context, index) =>
                                      UpcomingPaymentCard(
                                    payment: upcomingPaymentList[index],
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
  }
}
