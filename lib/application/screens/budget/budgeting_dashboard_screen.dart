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
  List<BudgetModel> budgetList = [];

  void getData() async {
    final budgetCubit = BlocProvider.of<BudgetCubit>(context);
    BudgetingPlanModel? budgetingPlanFromDatabase =
        await budgetCubit.getBudgetingPlan() as BudgetingPlanModel?;
    List<BudgetModel> budgetListFromDatabase = [];

    if (budgetingPlanFromDatabase != null) {
      budgetListFromDatabase = await budgetCubit
          .getBudgetList(budgetingPlanFromDatabase.id) as List<BudgetModel>;
    }

    setState(() {
      budgetingPlan = budgetingPlanFromDatabase;
      budgetList = budgetListFromDatabase;
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
                  child: Center(
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
                        budgetingPlan != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BudgetingPlanCard(
                                      budgetingPlan: budgetingPlan!),
                                  const SizedBox(height: 35),
                                  Row(
                                    children: [
                                      Text(
                                        "Budget Progress",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value:
                                                  BlocProvider.of<BudgetCubit>(
                                                      context),
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
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.white,
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: height * 0.8,
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 160,
                                        crossAxisSpacing: 30,
                                        mainAxisSpacing: 25,
                                      ),
                                      itemCount: budgetList!.length,
                                      itemBuilder: (_, index) {
                                        return BudgetProgressCard(
                                          budget: budgetList![index],
                                          currentAmount: 750,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "You do no have any Budgeting Plan",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            overflow: TextOverflow.clip,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
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
