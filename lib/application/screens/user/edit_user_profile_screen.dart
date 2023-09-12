import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/user_model.dart';
import 'cubit/user_cubit.dart';
// import 'package:payment_reminder_app/data/models/user_model.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _updateProfileForm = GlobalKey<FormState>();
  String _id = "";
  String _username = "";
  String _email = "";
  String _oldEmail = "";

  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Country _country = Country(
    phoneCode: "60",
    countryCode: "MY",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Malaysia",
    example: "Malaysia",
    displayName: "Malaysia",
    displayNameNoCountryCode: "Malaysia",
    e164Key: "",
  );

  void _editProfile() {
    final isValid = _updateProfileForm.currentState!.validate();

    if (isValid) {
      _updateProfileForm.currentState!.save();

      // update user profile using firestore
      BlocProvider.of<UserCubit>(context).editUserProfile(
        _id,
        _username,
        _email,
        "${_country.phoneCode}${_contactNoController.text}",
        _oldEmail,
        _passwordController.text,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // initialize user data
    _id = widget.user.id;
    _username = widget.user.name;
    _email = widget.user.email;
    _oldEmail = widget.user.email;
    _contactNoController.text = widget.user.contactNo.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateInitial) {
          _username = state.user.name;
          _email = state.user.email;
          _contactNoController.text = state.user.contactNo;
          _oldEmail = state.user.email;
        } else if (state is UserStateEditSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Edit User Profile successfully")),
          );
        } else if (state is UserStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is UserStateEditingData || state is UserStateLoadingData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
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
                    'Edit User Profile',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 45),
                  Form(
                    key: _updateProfileForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: const Key("username-text-field"),
                          initialValue: _username,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          enableSuggestions: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.length < 4) {
                              return 'Please enter a valid username. (At least 4 character)';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: const Key("email-text-field"),
                          initialValue: _email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Phone Number',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: const Key("phoneNumber-text-field"),
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                "${_country.flagEmoji} + ${_country.phoneCode}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            suffixIcon: _contactNoController.text.length > 9
                                ? Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.lightGreen),
                                    child: const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                          initialValue: _contactNoController.text,
                          keyboardType: TextInputType.phone,
                          autocorrect: false,
                          onChanged: (value) {
                            setState(() {
                              _contactNoController.text = value;
                            });
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 9) {
                              return 'Phone number invalid';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _contactNoController.text = value!;
                          },
                        ),
                        const SizedBox(height: 100),
                        OutlinedButton(
                          onPressed: () => _dialogBuilder(context),
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
                              child: Text('Edit'),
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
            'Update User Profile',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
                'Are you sure to update your user profile?\n\nEnter your password to confirm this action'),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              key: const Key("password-text-field"),
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value) {
                _passwordController.text = value!;
              },
            )
          ]),
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
                _editProfile();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
