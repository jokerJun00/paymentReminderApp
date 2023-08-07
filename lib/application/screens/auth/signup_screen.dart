import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payment_reminder_app/application/screens/auth/cubit/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signupForm = GlobalKey<FormState>();

  var _username = '';
  var _email = '';

  Country _country = Country(
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

  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signup() {
    // validate user input
    final isValid = _signupForm.currentState!.validate();

    if (isValid) {
      _signupForm.currentState!.save();

      // sign up with firebase
      BlocProvider.of<AuthCubit>(context).signUp(
        _username,
        _email,
        '${_country.phoneCode}${_contactNoController.text}',
        _passwordController.text,
      );
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      countryListTheme: const CountryListThemeData(bottomSheetHeight: 550),
      onSelect: (value) {
        setState(
          () {
            _country = value;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoginedIn) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sign up successfully")),
          );
        } else if (state is AuthStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 45,
                right: 45,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.angleLeft, size: 45),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'SignUp Account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Form(
                    key: _signupForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                        const SizedBox(height: 10),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                        const SizedBox(height: 10),
                        Text(
                          'Phone Number',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: _selectCountry,
                                child: Text(
                                  "${_country.flagEmoji} + ${_country.phoneCode}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
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
                        const SizedBox(height: 10),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
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
                            _passwordController.text = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                _passwordController.text !=
                                    _confirmPasswordController.text) {
                              return 'Confirm password not match with password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _confirmPasswordController.text = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          onPressed: _signup,
                          child: const Text('SignUp'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
