import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/screens/user/cubit/user_cubit.dart';

import '../../../data/models/user_model.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _changePasswordForm = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _editPassword() {
    BlocProvider.of<UserCubit>(context).editPassword(
      widget.user,
      widget.user.email,
      _oldPasswordController.text,
      _newPasswordController.text,
    );
  }

  void _saveForm() {
    final isValid = _changePasswordForm.currentState!.validate();

    if (isValid) {
      _changePasswordForm.currentState!.save();

      _dialogBuilder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateInitial) {
        } else if (state is UserStateEditSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Change Password successfully")),
          );
        } else if (state is UserStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is UserStateEditingData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
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
                    'Change Password',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 45),
                  Form(
                    key: _changePasswordForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Old Password',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _oldPasswordController,
                          decoration:
                              const InputDecoration(labelText: 'Old Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 8) {
                              return 'Password value invalid';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _oldPasswordController.text = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'New Password',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration:
                              const InputDecoration(labelText: 'New Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 8) {
                              return 'Password must be at least 8 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _newPasswordController.text = value!;
                          },
                        ),
                        const SizedBox(height: 100),
                        OutlinedButton(
                          onPressed: () => _saveForm(),
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
                              child: Text('Change Password'),
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

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change Password',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          content: const Text('Are you sure to change password?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Confirm'),
              onPressed: () {
                _editPassword();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
