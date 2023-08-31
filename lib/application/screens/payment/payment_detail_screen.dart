import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/bank_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/models/receiver_model.dart';
import '../../core/services/date_time_formatter.dart';
import 'category_list_screen.dart';
import 'cubit/payment_cubit.dart';

// the bank drop down cannot display selected bank
// should find a way to update value of the drop down button

enum BillingCycle { weekly, monthly, yearly }

class PaymentDetailScreen extends StatefulWidget {
  PaymentDetailScreen({super.key, required this.payment});

  PaymentModel payment;

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final _editPaymentForm = GlobalKey<FormState>();

  var receiver = ReceiverModel(
    id: "",
    name: "",
    bank_id: "",
    bank_account_no: "",
    user_id: "",
  );

  var bankList = <BankModel>[];
  var categoryList = <CategoryModel>[];
  BankModel? selectedBank;

  var paymentDateController = TextEditingController();
  var categoryController = TextEditingController();
  var receiverNameController = TextEditingController();
  var receiverBankAccountController = TextEditingController();

  void loadData() async {
    var paymentCubit = BlocProvider.of<PaymentCubit>(context);

    var bankListFromDatabase = await paymentCubit.getBankList();
    var categoryListFromDatabase = await paymentCubit.getCategoryList();
    var receiverFromDatabase =
        await paymentCubit.getReceiver(widget.payment.receiver_id);

    // use trim to avoid any whitespace
    final selectedCategory = categoryListFromDatabase.firstWhere(
        (category) => category.id.trim() == widget.payment.category_id.trim());
    final bank = bankListFromDatabase.firstWhereOrNull(
        (bank) => bank.id.trim() == receiverFromDatabase.bank_id.trim());

    setState(() {
      bankList = bankListFromDatabase;
      categoryList = categoryListFromDatabase;
      categoryController.text = selectedCategory.name;
      receiver = receiverFromDatabase;
      receiverNameController.text = receiverFromDatabase.name;
      selectedBank = bank;
      receiverBankAccountController.text = receiverFromDatabase.bank_account_no;
    });
  }

  void editPayment() {
    final isValid = _editPaymentForm.currentState!.validate();

    if (isValid) {
      _editPaymentForm.currentState!.save();

      // edit Payment info into Firebase
      BlocProvider.of<PaymentCubit>(context).editPayments(
        widget.payment,
        receiver,
      );
    }
  }

  void saveCategory(CategoryModel selectedCategory) {
    Navigator.of(context).pop();
    setState(() {
      widget.payment.category_id = selectedCategory.id;
      categoryController.text = selectedCategory.name;
    });
  }

  BillingCycle stringToEnum(String billingCycleString) {
    switch (billingCycleString) {
      case "weekly":
        return BillingCycle.weekly;
      case "monthly":
        return BillingCycle.monthly;
      case "yearly":
        return BillingCycle.yearly;
      default:
        return BillingCycle.monthly;
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {
      paymentDateController.text =
          DateTimeFormatter.formatPaymentDate(widget.payment.payment_date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateEditSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment edit successfully")),
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
                    'Update Payment',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 35),
                  Form(
                    key: _editPaymentForm,
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
                          initialValue: widget.payment.name,
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
                            widget.payment.name = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: widget.payment.description,
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
                              widget.payment.description = value.trim();
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
                              currentDate: widget.payment.payment_date,
                            );

                            if (pickedDate != null) {
                              setState(() {
                                paymentDateController.text =
                                    DateTimeFormatter.formatPaymentDate(
                                        pickedDate);
                                widget.payment.payment_date = pickedDate;
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
                          value: widget.payment.notification_period,
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
                              widget.payment.notification_period =
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
                          value: stringToEnum(widget.payment.billing_cycle),
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
                            widget.payment.billing_cycle = value
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
                            if (widget.payment.category_id == "") {
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
                          initialValue:
                              widget.payment.expected_amount.toString(),
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
                            widget.payment.expected_amount =
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
                          controller: receiverNameController,
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
                          value: selectedBank,
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
                            selectedBank = value!;
                            receiver.bank_id = value.id;
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
                          controller: receiverBankAccountController,
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
                          onPressed: editPayment,
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
                              child: Text('Update Payment'),
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
