import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/cubit/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void logout() {
    BlocProvider.of<AuthCubit>(context).logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 90,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'User Profile',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => _dialogBuilder(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 253, 138, 138),
                    ),
                    child: const Text('Logout'),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/editUserProfile"),
                    child: const Text('Edit'),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Text(
                'Username',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'Lim Choon Kiat',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Phone Number',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '+60176835363',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Email',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'junkiat54@gmail.com',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                  onPressed: () {}, child: const Text('Edit Password')),
              const SizedBox(height: 60),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Main Card',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'view all',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ready to logout',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
