import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class UpdateTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool isPassword;

  const UpdateTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isPassword = false,
  });

  @override
  State<UpdateTextField> createState() => _UpdateTextFieldState();
}

class _UpdateTextFieldState extends State<UpdateTextField> {
  late bool isObscure = widget.isPassword;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      cursorColor: AppTheme.green,
      cursorHeight: 20,
      obscureText: isObscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
        filled: true,
        fillColor: AppTheme.gray,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.titleLarge,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(isObscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined))
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.white),
          borderRadius: BorderRadius.circular(13),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.white),
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );
  }
}
