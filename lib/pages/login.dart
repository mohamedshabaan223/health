import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/default_elvatedbutton.dart';
import 'package:health_app/widgets/default_textbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';

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
          title: const Text('login'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Text('forget password',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppTheme.green,
                                ))),
                  ],
                ),
                SizedBox(
                  height: height * 0.08,
                ),
                Center(
                    child:
                        DefaultElvatedbutton(label: 'Login', onPressed: () {})),
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                    child: Text('or sign up with',
                        style: Theme.of(context).textTheme.titleSmall)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.facebook_outlined,
                        size: 60,
                        color: AppTheme.green,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.fingerprint,
                        size: 60,
                        color: AppTheme.green,
                      )),
                ]),
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
              ]),
        ));
  }
}
