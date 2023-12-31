import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/screens/budget/cubit/budget_cubit.dart';

// screen
import 'package:payment_reminder_app/application/screens/payment/payments_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/home_screen.dart';
import 'package:payment_reminder_app/application/screens/user/cubit/user_cubit.dart';
import 'package:payment_reminder_app/application/screens/user/profile_screen.dart';
import 'package:payment_reminder_app/application/screens/payment/upcoming_screen.dart';
import 'package:payment_reminder_app/application/screens/budget/budgeting_dashboard_screen.dart';

// cubit
import 'package:payment_reminder_app/application/screens/auth/cubit/auth_cubit.dart';
import 'package:payment_reminder_app/application/screens/payment/cubit/payment_cubit.dart';

import '../../injection.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedScreenIndex = 2;
  String? deviceToken = "";

  void _selectPage(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PaymentCubit paymentCubit = sl<PaymentCubit>();
    BudgetCubit budgetCubit = sl<BudgetCubit>();
    Widget activeScreen = const HomeScreen();

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
          activeScreen = BlocProvider.value(
            value: paymentCubit,
            child: const HomeScreen(),
          );
        }
        break;
      case 3:
        {
          activeScreen = BlocProvider.value(
            value: budgetCubit,
            child: const BudgetingDashboardScreen(),
          );
        }
        break;
      case 4:
        {
          activeScreen = BlocProvider(
            create: (context) => sl<UserCubit>(),
            child: const ProfileScreen(),
          );
        }
        break;
      default:
        {
          activeScreen = const HomeScreen();
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
