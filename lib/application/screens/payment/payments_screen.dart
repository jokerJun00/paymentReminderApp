import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:payment_reminder_app/application/screens/payment/add_payment_screen.dart';

import '../../../data/models/payment_model.dart';
import '../../core/widgets/payment_card.dart';
import 'cubit/payment_cubit.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentModel> paymentList = [];
  // Map<String, PaymentModel> groupedPaymentList = {};

  final _firebaseAuth = FirebaseAuth.instance;
  var _userId = "";

  void deletePayment(PaymentModel payment) async {
    await BlocProvider.of<PaymentCubit>(context)
        .deletePayments(payment)
        .then((value) {
      // remove payment and update state
      final removedPayment = paymentList
          .firstWhere((element) => element.id.trim() == payment.id.trim());
      final index = paymentList.indexOf(removedPayment);

      setState(() {
        paymentList.removeAt(index);
      });
    });
  }

  @override
  void initState() {
    BlocProvider.of<PaymentCubit>(context).getAllPayments();
    super.initState();

    setState(() {
      _userId = _firebaseAuth.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateInitial) {
          List<PaymentModel> paymentList =
              state.paymentList as List<PaymentModel>;
        } else if (state is PaymentStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraint) {
            final width = constraint.maxWidth;
            return Scaffold(
              body: (state is PaymentStateEditingData ||
                      state is PaymentStateLoadingData)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 90),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Payment List",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<PaymentCubit>(),
                                      child: AddPaymentScreen(
                                        userId: _userId,
                                      ),
                                    ),
                                  ),
                                ),
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: paymentList.isEmpty
                                  ? const Text(
                                      "You do not have any payment yet")
                                  : ListView.builder(
                                      itemCount: paymentList.length,
                                      itemBuilder: (context, index) {
                                        return Slidable(
                                          endActionPane: ActionPane(
                                              motion: const BehindMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (_) =>
                                                      deletePayment(
                                                          paymentList[index]),
                                                  backgroundColor: Colors.red,
                                                  icon:
                                                      FontAwesomeIcons.trashCan,
                                                  label: "Delete",
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                )
                                              ]),
                                          child: PaymentCard(
                                            payment: paymentList[index],
                                            deviceWidth: width,
                                          ),
                                        );
                                      },
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
