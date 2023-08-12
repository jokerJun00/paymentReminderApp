// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.navigateToUpcoming});

  final Function() navigateToUpcoming;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Payment> _monthlyPaymentsData = List<Payment>.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ],
          )
        ]),
      ),
    ));
  }
}
