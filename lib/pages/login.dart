import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/create_icons.dart';
import 'package:health_app/widgets/default_elvatedbutton.dart';
import 'package:health_app/widgets/default_textbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/list_view_icons.dart';
import 'package:health_app/widgets/start_screen_button.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text('log In'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: ListView(
            children: [
              Text(
                'Email',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              DefaultTextformfield(
                  hint: 'Enter Email', controller: emailController),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                'Password',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              DefaultTextformfield(
                hint: 'Enter Password',
                controller: passwordController,
                isPassword: true,
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                      onPressed: () {},
                      child: Text('Forget Password',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppTheme.green,
                                  ))),
                ],
              ),
              SizedBox(
                height: height * 0.08,
              ),
              Center(
                child: StartScreenButton(
                  label: 'Log In',
                  onPressed: () {},
                  buttonBackgroundColor: AppTheme.green,
                  buttonForegroundColor: AppTheme.white,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                child: Text('or sign up with',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              ListViewIcons(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Donot have an account ?',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  DefaultTextbutton(label: 'Sign Up', onPressed: () {}),
                ],
              )
            ],
          ),
        ));
  }
}
