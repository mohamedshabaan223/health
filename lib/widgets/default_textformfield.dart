import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class DefaultTextformfield extends StatefulWidget {
  DefaultTextformfield(
      {required this.hint,
      required this.controller,
      this.isPassword = false,
      required this.onChanged,
      this.enabled = true});

  String hint;
  bool enabled;
  TextEditingController controller;
  bool isPassword;
  Function(String)? onChanged;
  @override
  State<DefaultTextformfield> createState() => _DefaultTextformfieldState();
}

class _DefaultTextformfieldState extends State<DefaultTextformfield> {
  late bool isObscure = widget.isPassword;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field is required';
        }
        // if (widget.isPassword) {
        //   if (value.length < 6) {
        //     return 'Password must be at least 6 characters';
        //   }
        // }
      },
      style: const TextStyle(
        color: Colors.green,
      ),
      controller: widget.controller,
      decoration: InputDecoration(
        fillColor: AppTheme.gray,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.gray),
            borderRadius: BorderRadius.circular(13)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.gray),
            borderRadius: BorderRadius.circular(13)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.gray),
            borderRadius: BorderRadius.circular(13)),
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppTheme.green),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                icon: Icon(isObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined))
            : null,
      ),
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
