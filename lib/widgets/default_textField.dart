import 'package:flutter/material.dart';

class DoctorDefaultTextfield extends StatelessWidget {
  DoctorDefaultTextfield(
      {required this.controller, required this.typeKeyboard});
  TextEditingController controller;
  TextInputType typeKeyboard;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: typeKeyboard,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
