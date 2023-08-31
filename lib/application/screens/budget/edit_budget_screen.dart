import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/screens/budget/cubit/budget_cubit.dart';

import '../../../data/models/budget_model.dart';
import '../../../data/models/budgeting_plan_model.dart';
import '../../../data/models/category_model.dart';

class EditBudgetScreen extends StatefulWidget {
  const EditBudgetScreen({
    super.key,
    required this.budgetingPlan,
    required this.budgetList,
  });

  final BudgetingPlanModel budgetingPlan;
  final List<BudgetModel> budgetList;

  @override
  State<EditBudgetScreen> createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends State<EditBudgetScreen> {
  final _addBudgetingPlanForm = GlobalKey<FormState>();

  List<CategoryModel> categoryList = [];

  TextEditingController startAmountController = TextEditingController();
  TextEditingController targetAmountController = TextEditingController();
  List<TextEditingController> categoryBudgetController = [];

  void loadData() async {
    List<CategoryModel> categoryListFromDatabase =
        await BlocProvider.of<BudgetCubit>(context).getCategoryList()
            as List<CategoryModel>;
    setState(() {
      startAmountController.text =
          widget.budgetingPlan.starting_amount.toString();
      targetAmountController.text =
          widget.budgetingPlan.target_amount.toString();
      categoryList = categoryListFromDatabase;
      categoryList.forEach((category) {
        final categoryBudget = widget.budgetList
            .firstWhereOrNull((budget) => budget.category_id == category.id);

        categoryBudgetController.add(
          TextEditingController(
            text: categoryBudget != null
                ? categoryBudget.budget_amount.toString()
                : "0.0",
          ),
        );
      });
    });
  }

  void editBugdetingPlan() async {
    final isValid = _addBudgetingPlanForm.currentState!.validate();

    if (isValid) {
      double startAmount = double.parse(startAmountController.text);
      double targetAmount = double.parse(targetAmountController.text);
      _addBudgetingPlanForm.currentState!.save();

      List<double> categoryBudgetAmountList = [];

      categoryBudgetController.forEach((controller) =>
          categoryBudgetAmountList.add(double.parse(controller.text)));
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    startAmountController.dispose();
    targetAmountController.dispose();
    categoryBudgetController.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetCubit, BudgetState>(
      listener: (context, state) {
        if (state is BudgetStateEditSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("New budgeting plan has set up successfully"),
            ),
          );
        } else if (state is BudgetStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is BudgetStateEditingData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'New Budget Plan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 35),
                Form(
                  key: _addBudgetingPlanForm,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Starting Amount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: startAmountController,
                        decoration:
                            const InputDecoration(labelText: 'Starting Amount'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a starting amount';
                          }
                          double? valueDouble = double.tryParse(value);
                          return valueDouble == null
                              ? 'Please enter a valid number'
                              : null;
                        },
                        onSaved: (value) {
                          startAmountController.text = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Target Amount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: targetAmountController,
                        decoration:
                            const InputDecoration(labelText: 'Target Amount'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a target amount';
                          }

                          double? valueDouble = double.tryParse(value);
                          return valueDouble == null
                              ? 'Please enter a valid number'
                              : null;
                        },
                        onSaved: (value) {
                          targetAmountController.text = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      for (int index = 0; index < categoryList.length; index++)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryList[index].name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: categoryBudgetController[index],
                              decoration: InputDecoration(
                                  labelText: categoryList[index].name),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.trim().isNotEmpty) {
                                  // check if input is string
                                  final doubleValue = double.tryParse(value);
                                  return doubleValue == null
                                      ? 'Please enter a valid'
                                      : null;
                                }
                                return null;
                              },
                              onSaved: (value) {
                                categoryBudgetController[index].text = value!;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 65),
                OutlinedButton(
                  onPressed: editBugdetingPlan,
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                        textStyle: MaterialStatePropertyAll(
                          GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Center(
                      child: Text('Create Budget Plan'),
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
