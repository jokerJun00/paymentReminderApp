import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_reminder_app/application/screens/auth/cubit/auth_cubit.dart';
import 'package:payment_reminder_app/main.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _loginForm = GlobalKey<FormState>();

  var _email = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    void login() {
      // validate user input
      final isValid = _loginForm.currentState!.validate();

      if (isValid) {
        _loginForm.currentState!.save();

        // login with firebase
        BlocProvider.of<AuthCubit>(context).logIn(_email, _password);
      }
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoginedIn) {
          Navigator.of(context).pushReplacementNamed("/navigation");
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successfully")),
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
              padding: const EdgeInsets.only(left: 45, right: 45),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LogIn Account",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // Login From
                  Form(
                    key: _loginForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: const Key("email-text-field"),
                          decoration: const InputDecoration(labelText: 'Email'),
                          style: Theme.of(context).textTheme.bodySmall,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please etner a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: const Key("password-text-field"),
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          style: Theme.of(context).textTheme.bodySmall,
                          obscureText: true, // hide text
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 8) {
                              return 'Password must be at least 8 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          onPressed: login,
                          child: const Text('Login'),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Do not have an account yet? ',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign up an account',
                                style: GoogleFonts.inter(
                                  color: hightlightColor,
                                  fontSize: 12,
                                ),
                                // signup navigation
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Navigator.pushNamed(context, '/signup'),
                              ),
                            ],
                          ),
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
