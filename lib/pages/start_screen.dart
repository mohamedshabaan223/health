import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/login_page.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/widgets/start_screen_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  static const String id = "/startScreen";

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? selectedRole;
  List<String> roles = ["Patient", "Doctor"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Image.asset("assets/images/logo_icon.png"),
            const SizedBox(height: 50),
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: AppTheme.green, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: AppTheme.green, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(color: AppTheme.green, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                hint: const Text("Select Your Role",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                dropdownColor: Colors.white,
                items: roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 45),
            StartScreenButton(
              buttonBackgroundColor: selectedRole == null
                  ? AppTheme.gray.withOpacity(0.5)
                  : AppTheme.green,
              buttonForegroundColor: AppTheme.white,
              label: "Log In",
              onPressed: selectedRole == null
                  ? null
                  : () {
                      Navigator.pushNamed(context, Login.routeName);
                    },
            ),
            const SizedBox(height: 40),
            if (selectedRole != "Doctor")
              StartScreenButton(
                buttonBackgroundColor: selectedRole == null
                    ? AppTheme.gray.withOpacity(0.5)
                    : AppTheme.gray,
                buttonForegroundColor: AppTheme.green,
                label: "Sign Up",
                onPressed: selectedRole == null
                    ? null
                    : () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
              ),
          ],
        ),
      ),
    );
  }
}
