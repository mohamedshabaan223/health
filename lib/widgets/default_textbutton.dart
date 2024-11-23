import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class DefaultTextbutton extends StatelessWidget {
  DefaultTextbutton({required this.label, required this.onPressed});
 
  VoidCallback onPressed;
  String label ;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(label) ,
    style: TextButton.styleFrom(
      foregroundColor: AppTheme.green,
      
    ),) ;
  }
}