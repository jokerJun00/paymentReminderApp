import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:payment_reminder_app/data/models/user_model.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  final _updateProfileForm = GlobalKey<FormState>();

  // final UserModel _userData;

  var _username = 'Lim Choon Kiat';
  var _email = 'junkiat54@gmail.com';

  void editProfile() {}

  @override
  void initState() {
    super.initState();

    // get user data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                    initialValue: _username,
                    decoration: const InputDecoration(labelText: 'Username'),
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
                  const SizedBox(height: 100),
                  OutlinedButton(
                    onPressed: editProfile,
                    style:
                        Theme.of(context).outlinedButtonTheme.style!.copyWith(
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
    );
  }
}
