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
  Map<String, List<PaymentModel>> groupedPaymentList = {};

  final _firebaseAuth = FirebaseAuth.instance;
  var _userId = "";

  void deletePayment(PaymentModel payment) async {
    await BlocProvider.of<PaymentCubit>(context).deletePayments(payment);
  }

  @override
  void initState() {
    BlocProvider.of<PaymentCubit>(context).getGroupedPayments();
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
          groupedPaymentList =
              state.groupedPaymentList as Map<String, List<PaymentModel>>;
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
                              child: groupedPaymentList.isEmpty
                                  ? const Text(
                                      "You do not have any payment yet")
                                  : GroupListView(
                                      sectionsCount: groupedPaymentList.keys
                                          .toList()
                                          .length,
                                      countOfItemInSection: (int section) {
                                        return groupedPaymentList.values
                                            .toList()[section]
                                            .length;
                                      },
                                      groupHeaderBuilder:
                                          (BuildContext context, int section) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Text(
                                            groupedPaymentList.keys
                                                .toList()[section],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        );
                                      },
                                      itemBuilder: (BuildContext context,
                                          IndexPath index) {
                                        return Slidable(
                                          endActionPane: ActionPane(
                                            motion: const BehindMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (_) => deletePayment(
                                                    groupedPaymentList.values
                                                                .toList()[
                                                            index.section]
                                                        [index.index]),
                                                backgroundColor: Colors.red,
                                                icon: FontAwesomeIcons.trashCan,
                                                label: "Delete",
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ],
                                          ),
                                          child: PaymentCard(
                                            payment: groupedPaymentList.values
                                                    .toList()[index.section]
                                                [index.index],
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
