import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/core/widgets/budget_progress_card.dart';
import 'package:payment_reminder_app/application/core/widgets/budgeting_plan_card.dart';
import 'package:payment_reminder_app/application/screens/budget/add_budgeting_dashboard_screen.dart';
import 'package:payment_reminder_app/application/screens/budget/cubit/budget_cubit.dart';
import 'package:payment_reminder_app/application/screens/budget/edit_budget_screen.dart';
import 'package:payment_reminder_app/data/models/budgeting_plan_model.dart';

import '../../../data/models/budget_model.dart';

class BudgetingDashboardScreen extends StatefulWidget {
  const BudgetingDashboardScreen({super.key});

  @override
  State<BudgetingDashboardScreen> createState() =>
      _BudgetingDashboardScreenState();
}

class _BudgetingDashboardScreenState extends State<BudgetingDashboardScreen> {
  BudgetingPlanModel? budgetingPlan;
  List<BudgetModel> budgetList = <BudgetModel>[
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
    BudgetModel(
        id: "1",
        budgeting_plan_id: "1",
        category_id: "1",
        budgeting_amount: 1000),
  ];

  void getData() {
    setState(() {
      budgetingPlan = BudgetingPlanModel(
        id: "1",
        target_amount: 3300.0,
        starting_amount: 2475.0,
        user_id: "2",
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetCubit, BudgetState>(
      listener: (context, state) {
        if (state is BudgetStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is BudgetStateLoadingData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 90, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      width > 400
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Budget Dashboard',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Spacer(),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<BudgetCubit>(
                                            context),
                                        child:
                                            const AddBudgetingDashboardScreen(),
                                      ),
                                    ),
                                  ),
                                  child: const Text('New'),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Budget Dashboard',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: BlocProvider.of<BudgetCubit>(
                                            context),
                                        child:
                                            const AddBudgetingDashboardScreen(),
                                      ),
                                    ),
                                  ),
                                  child: const Text('New'),
                                ),
                              ],
                            ),
                      const SizedBox(height: 25),
                      BudgetingPlanCard(budgetingPlan: budgetingPlan!),
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          Text(
                            "Budget Progress",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<BudgetCubit>(context),
                                  child: const EditBudgetScreen(),
                                ),
                              ),
                            ),
                            child: Text(
                              "Edit",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                  ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: height * 0.8,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 160,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 25,
                          ),
                          itemCount: budgetList.length,
                          itemBuilder: (_, index) {
                            return BudgetProgressCard(
                              categoryName: "Instalment",
                              budget: budgetList[index],
                              currentAmount: 750,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
