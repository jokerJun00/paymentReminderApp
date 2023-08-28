// import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/core/widgets/upcoming_payment_card.dart';
import 'package:payment_reminder_app/application/screens/payment/monthly_summary_screen.dart';

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
  List<BarChartGroupData> monthlySummary = [];
  double max = 0;

  void getMonthlySummary() async {
    final monthlySummaryFromDatabase =
        await BlocProvider.of<PaymentCubit>(context).getMonthlyPaidAmount();

    double maxFromMonthlySummary = 0;
    List<BarChartGroupData> barChartGroupData = [];

    monthlySummaryFromDatabase.forEach(
      (key, value) {
        if (value > maxFromMonthlySummary) {
          maxFromMonthlySummary = value;
        }
      },
    );

    monthlySummaryFromDatabase.forEach((key, value) {
      barChartGroupData.add(
        BarChartGroupData(
          x: key,
          barRods: [
            BarChartRodData(
              toY: value,
              color: const Color.fromARGB(255, 242, 223, 58),
              width: 20,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                color: Colors.white,
                toY: maxFromMonthlySummary,
              ),
            ),
          ],
        ),
      );
    });

    setState(() {
      monthlySummary = barChartGroupData.reversed.toList();
      max = maxFromMonthlySummary;
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
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    BlocProvider<PaymentCubit>.value(
                                  value: context.read<PaymentCubit>(),
                                  child: const MonthlySummaryScreen(),
                                ),
                              ),
                            ),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(1, 255, 120, 240)
                                    .withAlpha(255),
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BarChart(
                                BarChartData(
                                  maxY: max,
                                  minY: 0,
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  titlesData: const FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: getBottomTitles,
                                      ),
                                    ),
                                  ),
                                  barGroups: monthlySummary,
                                ),
                              ),
                            ),
                          ),
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

Widget getBottomTitles(double value, TitleMeta meta) {
  var style = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  Widget text;
  switch (value.toInt()) {
    case 1:
      text = Text('Jan', style: style);
      break;
    case 2:
      text = Text('Feb', style: style);
      break;
    case 3:
      text = Text('Mar', style: style);
      break;
    case 4:
      text = Text('Apr', style: style);
      break;
    case 5:
      text = Text('May', style: style);
      break;
    case 6:
      text = Text('Jun', style: style);
      break;
    case 7:
      text = Text('Jul', style: style);
      break;
    case 8:
      text = Text('Aug', style: style);
      break;
    case 9:
      text = Text('Sep', style: style);
      break;
    case 10:
      text = Text('Oct', style: style);
      break;
    case 11:
      text = Text('Nov', style: style);
      break;
    case 12:
      text = Text('Dec', style: style);
      break;
    default:
      text = Text('Err', style: style);
      break;
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
