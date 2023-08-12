import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';

// screen
import 'package:payment_reminder_app/application/screens/payment/payments_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/home_screen.dart';
import 'package:payment_reminder_app/application/screens/user/cubit/user_cubit.dart';
import 'package:payment_reminder_app/application/screens/user/profile_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/upcoming_screen.dart';
import 'package:payment_reminder_app/application/screens/budgets_screen.dart';

import 'cubit/auth_cubit.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedScreenIndex = 2;

  void _selectPage(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  void goToUpcoming() {
    setState(() {
      _selectedScreenIndex = 1;
    });
  }

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.subscribeToTopic('setPaymentReminder');
    await fcm.subscribeToTopic('resetPaymentReminder');
  }

  @override
  void initState() {
    super.initState();

    // push notification setup
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    PaymentCubit paymentCubit = PaymentCubit();
    Widget activeScreen = HomeScreen(navigateToUpcoming: goToUpcoming);

    switch (_selectedScreenIndex) {
      case 0:
        {
          activeScreen = BlocProvider.value(
            value: paymentCubit,
            child: const PaymentScreen(),
          );
        }
        break;
      case 1:
        {
          activeScreen = BlocProvider.value(
            value: paymentCubit,
            child: const UpcomingScreen(),
          );
        }
        break;
      case 2:
        {
          activeScreen = HomeScreen(
            navigateToUpcoming: goToUpcoming,
          );
        }
        break;
      case 3:
        {
          activeScreen = const BudgetsScreen();
        }
        break;
      case 4:
        {
          activeScreen = BlocProvider(
            create: (context) => UserCubit(),
            child: const ProfileScreen(),
          );
        }
        break;
      default:
        {
          activeScreen = HomeScreen(
            navigateToUpcoming: goToUpcoming,
          );
        }
        break;
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLogOut) {
          Navigator.of(context).pushReplacementNamed('/login');
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout successfully"),
            ),
          );
        }
      },
      child: Scaffold(
        body: activeScreen,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            onTap: _selectPage,
            currentIndex: _selectedScreenIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Payments",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.payments),
                label: "Upcoming",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart),
                label: "Budgets",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
