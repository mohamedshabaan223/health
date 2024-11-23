import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/login.dart';

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
        Login.routeName:(_) => Login(),
      }, 
      initialRoute: Login.routeName,
      theme: AppTheme.lightTheme ,
      themeMode: ThemeMode.light,
    );}}
    