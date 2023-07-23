import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
}
