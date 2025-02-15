import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/update_text_field.dart';

class ChangePassword extends StatelessWidget {
  static const String id = "/change_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: AppTheme.green,
                        )),
                    const Spacer(
                      flex: 2,
                    ),
                    const Text(
                      'password manager',
                      style: TextStyle(
                          color: AppTheme.green,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Current Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              const UpdateTextField(
                isPassword: true,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        'forgot password?',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 15, color: AppTheme.green),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'New Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              const UpdateTextField(
                isPassword: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Confirm New Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 6,
              ),
              const UpdateTextField(
                isPassword: true,
              ),
              const Spacer(
                flex: 3,
              ),
              Center(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    height: 48,
                    width: 300,
                    decoration: BoxDecoration(
                        color: AppTheme.green,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
