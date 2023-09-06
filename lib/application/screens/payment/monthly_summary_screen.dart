import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../core/services/date_time_formatter.dart';
import 'cubit/payment_cubit.dart';

class MonthlySummaryScreen extends StatefulWidget {
  const MonthlySummaryScreen({super.key, required this.date});

  final DateTime date;

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  String month = "";
  Map<String, double> categorySummary = {};
  List<String> categoryNameList = [];

  void getMonthlySummaryGroupByCategory() async {
    Map<String, double> categorySummaryFromDatabase =
        await BlocProvider.of<PaymentCubit>(context)
            .getMonthlySummaryGroupByCategory(widget.date);

    setState(() {
      categorySummary = categorySummaryFromDatabase;
      categoryNameList = categorySummaryFromDatabase.keys.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      month = DateTimeFormatter.formatMonth(widget.date);
    });
    getMonthlySummaryGroupByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(builder: (context, state) {
      if (state is PaymentStateLoadingData) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
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
                          child: MonthlySummaryScreen(
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
                          child: MonthlySummaryScreen(
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
              Text(
                "Monthly Payment",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryNameList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              categoryNameList[index],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "RM ${categorySummary[categoryNameList[index]]!.toStringAsFixed(2)}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
