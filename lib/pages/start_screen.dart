import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/login_page.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/widgets/start_screen_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  static const String id = "/startScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              "assets/images/logo_icon.png",
            ),
            const SizedBox(
              height: 150,
            ),
            StartScreenButton(
              buttonBackgroundColor: AppTheme.green,
              buttonForegroundColor: AppTheme.white,
              label: "Log In",
              onPressed: () {
                Navigator.pushNamed(context, Login.routeName);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            StartScreenButton(
              buttonBackgroundColor: AppTheme.gray,
              buttonForegroundColor: AppTheme.green,
              label: "Sign Up",
              onPressed: () {
                Navigator.pushNamed(context, RegisterPage.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
