import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/login.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/pages/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        Login.routeName: (_) => Login(),
        StartScreen.id: (_) => const StartScreen(),
        RegisterPage.id: (_) => RegisterPage(),
      },
      initialRoute: StartScreen.id,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
    );
  }
}
