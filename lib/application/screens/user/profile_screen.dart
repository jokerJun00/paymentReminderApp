import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_reminder_app/application/screens/user/cubit/user_cubit.dart';
import 'package:payment_reminder_app/application/screens/user/edit_password_screen.dart';
import 'package:payment_reminder_app/application/screens/user/edit_user_profile_screen.dart';
import 'package:payment_reminder_app/data/models/user_model.dart';

import '../auth/cubit/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _id = "";
  String _username = "";
  String _email = "";
  String _contactNo = "";

  void _logout() {
    BlocProvider.of<AuthCubit>(context).logOut();
  }

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateInitial) {
          _id = state.user.id;
          _username = state.user.name;
          _email = state.user.email;
          _contactNo = state.user.contactNo;
        } else if (state is UserStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is UserStateLoadingData) {
          return const Center(child: CircularProgressIndicator());
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      width > 350
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'User Profile',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const Spacer(),
                                OutlinedButton(
                                  onPressed: () =>
                                      _logoutDialogBuilder(context),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 253, 138, 138),
                                  ),
                                  child: const Text('Logout'),
                                ),
                                const SizedBox(width: 5),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value:
                                            BlocProvider.of<UserCubit>(context),
                                        child: EditUserProfileScreen(
                                          user: UserModel(
                                            id: _id,
                                            name: _username,
                                            email: _email,
                                            contactNo: _contactNo,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Edit'),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Profile',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () =>
                                          _logoutDialogBuilder(context),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 253, 138, 138),
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                    const SizedBox(width: 5),
                                    OutlinedButton(
                                      onPressed: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: BlocProvider.of<UserCubit>(
                                                context),
                                            child: EditUserProfileScreen(
                                              user: UserModel(
                                                id: _id,
                                                name: _username,
                                                email: _email,
                                                contactNo: _contactNo,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                      const SizedBox(height: 35),
                      Text(
                        'Username',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _username,
                        style: Theme.of(context).textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Phone Number',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "+$_contactNo",
                        style: Theme.of(context).textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _email,
                        style: Theme.of(context).textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<UserCubit>(context),
                                    child: EditPasswordScreen(
                                      user: UserModel(
                                        id: _id,
                                        name: _username,
                                        email: _email,
                                        contactNo: _contactNo,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          child: const Text('Edit Password')),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
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
          },
        );
      },
    );
  }

  Future<void> _logoutDialogBuilder(BuildContext context) {
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
                _logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
