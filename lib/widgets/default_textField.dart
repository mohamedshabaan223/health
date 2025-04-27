import 'package:flutter/material.dart';

class DoctorDefaultTextfield extends StatelessWidget {
  DoctorDefaultTextfield(
      {super.key,
      required this.controller,
      required this.typeKeyboard,
      required this.hintText});
  TextEditingController controller;
  TextInputType typeKeyboard;
  String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: typeKeyboard,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
