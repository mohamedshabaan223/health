import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/home_screen_patient.dart';

class payment_success extends StatelessWidget {
  static const String id = "success_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/image_success.png", width: 200),
            const SizedBox(height: 20),
            const Text(
              "Congratulations",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white),
            ),
            const Text(
              "Payment is successfully",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                backgroundColor: AppTheme.white,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, HomeScreenPatient.id),
              child: const Text('Back to Home',
                  style: TextStyle(color: AppTheme.green, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
