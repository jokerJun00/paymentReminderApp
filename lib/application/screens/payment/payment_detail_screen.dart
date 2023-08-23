import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/models/bank_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/models/receiver_model.dart';
import '../../../date_time_formatter.dart';
import 'cubit/payment_cubit.dart';

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
    void editPayment() {
      final isValid = _editPaymentForm.currentState!.validate();

      if (isValid) {
        _editPaymentForm.currentState!.save();

        // // add New Payment info into Firebase
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
            ],
          ),
        ),
      ),
    );
  }
}
