import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';
import 'package:payment_reminder_app/data/models/bank_model.dart';
import 'package:payment_reminder_app/data/models/receiver_model.dart';
import 'package:payment_reminder_app/application/core/services/date_time_formatter.dart';

import '../../../data/models/category_model.dart';
import '../../../data/models/payment_model.dart';
import 'category_list_screen.dart';

enum BillingCycle { weekly, monthly, yearly }

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _addPaymentForm = GlobalKey<FormState>();

  var newPayment = PaymentModel(
    id: "",
    name: "",
    description: "",
    payment_date: DateTime.now(),
    notification_period: 7,
    billing_cycle: "monthly",
    expected_amount: 0.00,
    receiver_id: "",
    category_id: "",
    user_id: "",
  );

  var receiver = ReceiverModel(
    id: "",
    name: "",
    bank_id: "",
    bank_account_no: "",
    user_id: "",
  );

  var bankList = <BankModel>[];

  var paymentDateController = TextEditingController(
    text: DateTimeFormatter.formatPaymentDate(DateTime.now()),
  );
  var categoryController = TextEditingController();

  void getBankList() async {
    var bankListFromDatabase =
        await BlocProvider.of<PaymentCubit>(context).getBankList();
    setState(() {
      bankList = bankListFromDatabase;
    });
  }

  @override
  void initState() {
    super.initState();
    getBankList();
  }

  @override
  Widget build(BuildContext context) {
    void addPayment() {
      // validate user input
      final isValid = _addPaymentForm.currentState!.validate();

      if (isValid) {
        _addPaymentForm.currentState!.save();

        // add New Payment info into Firebase
        BlocProvider.of<PaymentCubit>(context).addPayments(
          newPayment,
          receiver,
        );
      }
    }

    void saveCategory(CategoryModel selectedCategory) {
      Navigator.of(context).pop();
      setState(() {
        newPayment.category_id = selectedCategory.id;
        categoryController.text = selectedCategory.name;
      });
    }

    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateEditSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New payment added successfully")),
          );
        } else if (state is PaymentStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is PaymentStateEditingData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
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
                  const SizedBox(height: 30),
                  Text(
                    'New Payment',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 35),
                  Form(
                    key: _addPaymentForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Info',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Name',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a payment name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newPayment.name = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          minLines: 3,
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          onSaved: (value) {
                            if (value != null) {
                              newPayment.description = value.trim();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Payment Date',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: paymentDateController,
                          decoration: const InputDecoration(
                            labelText: 'Payment Date',
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(10),
                              child: FaIcon(FontAwesomeIcons.calendar),
                            ),
                          ),
                          readOnly: true,
                          keyboardType: TextInputType.datetime,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                paymentDateController.text =
                                    DateTimeFormatter.formatPaymentDate(
                                        pickedDate);
                                newPayment.payment_date = pickedDate;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Notification Period',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField(
                          value: newPayment.notification_period,
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text(
                                "1 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text(
                                "2 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text(
                                "3 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text(
                                "4 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text(
                                "5 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 6,
                              child: Text(
                                "6 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 7,
                              child: Text(
                                "7 days before",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              newPayment.notification_period =
                                  int.tryParse(value.toString())!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a notification period";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Billing Cycle',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<BillingCycle>(
                          items: BillingCycle.values
                              .map((BillingCycle billingCycle) {
                            return DropdownMenuItem<BillingCycle>(
                              value: billingCycle,
                              child: Text(
                                BillingCycle.values[billingCycle.index]
                                    .toString()
                                    .replaceFirst(
                                      "BillingCycle.",
                                      "",
                                    ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            newPayment.billing_cycle = value
                                .toString()
                                .replaceFirst("BillingCycle.", "");
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a billing cycle';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Categories',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: categoryController,
                          readOnly: true,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return BlocProvider.value(
                                  value: context.read<PaymentCubit>(),
                                  child: CategoryListScreen(
                                    saveCategory: saveCategory,
                                  ),
                                );
                              },
                            ),
                          ),
                          validator: (value) {
                            if (newPayment.category_id == "") {
                              return "Please select a category";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Expected Amount',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: newPayment.expected_amount.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Expected Amount',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final valueInDouble = double.tryParse(value!);
                            if (value.trim() == "" || valueInDouble! <= 0) {
                              return "Please provide a value more than 0";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newPayment.expected_amount =
                                double.tryParse(value!)!;
                          },
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Receiver Info',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Receiver Name',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Receiver Name'),
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a receiver name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            receiver.name = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Bank Name',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<BankModel>(
                          items: bankList
                              .map((BankModel bank) =>
                                  DropdownMenuItem<BankModel>(
                                      value: bank,
                                      child: Text(
                                        bank.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )))
                              .toList(),
                          onChanged: (value) {
                            receiver.bank_id = value!.id;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a bank for receiver";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Bank Account Number',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Bank Account Number'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 8 ||
                                value.trim().length > 12) {
                              return 'Please enter valid bank account number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            receiver.bank_account_no = value!;
                          },
                        ),
                        const SizedBox(height: 65),
                        OutlinedButton(
                          onPressed: addPayment,
                          style: Theme.of(context)
                              .outlinedButtonTheme
                              .style!
                              .copyWith(
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
                              child: Text('Add Payment'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
