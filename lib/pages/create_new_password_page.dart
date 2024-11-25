import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/default_elvatedbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:health_app/widgets/text_form_field_label.dart';

class CreateNewPasswordPage extends StatelessWidget {
  CreateNewPasswordPage({super.key});
  static const String id = '/create-new-password';
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? password;
  String? confirmPassword;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              const TextFormFieldLabel(text: 'Password'),
              SizedBox(
                height: height * 0.01,
              ),
              DefaultTextformfield(
                onChanged: (data) {
                  password = data;
                },
                hint: 'Enter New Password',
                controller: passwordController,
                isPassword: true,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              const TextFormFieldLabel(text: 'Confirm Password'),
              SizedBox(
                height: height * 0.01,
              ),
              DefaultTextformfield(
                onChanged: (data) {
                  confirmPassword = data;
                },
                hint: 'Confirm Password',
                controller: confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Center(
                child: DefaultElvatedbutton(
                  label: 'Create New Password',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (password == confirmPassword) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password does not match'),
                          ),
                        );
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
