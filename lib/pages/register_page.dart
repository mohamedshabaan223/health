import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/default_textbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:health_app/widgets/text_form_field_label.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  static const String id = '/register';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(children: [
          const TextFormFieldLabel(text: 'Full name'),
          SizedBox(
            height: height * 0.01,
          ),
          DefaultTextformfield(
            hint: 'Enter Full Name',
            controller: emailController,
          ),
          SizedBox(
            height: height * 0.04,
          ),
          const TextFormFieldLabel(text: 'Email'),
          SizedBox(
            height: height * 0.01,
          ),
          DefaultTextformfield(
            hint: 'Enter Email',
            controller: emailController,
          ),
          SizedBox(
            height: height * 0.04,
          ),
          const TextFormFieldLabel(text: 'Password'),
          SizedBox(
            height: height * 0.01,
          ),
          DefaultTextformfield(
            hint: 'Enter Password',
            controller: passwordController,
            isPassword: true,
          ),
          SizedBox(
            height: height * 0.08,
          ),
          Column(
            children: [
              Text(
                'By continuing, you agree to',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Terms of Use',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppTheme.green),
                  ),
                  Text(
                    '  and  ',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    'Privacy Policy',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppTheme.green),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Center(
              child: StartScreenButton(
            label: 'Sign Up',
            onPressed: () {},
            buttonBackgroundColor: AppTheme.green,
            buttonForegroundColor: AppTheme.white,
          )),
          SizedBox(
            height: height * 0.02,
          ),
          Center(
              child: Text('or sign up with',
                  style: Theme.of(context).textTheme.titleSmall)),
          const SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.facebook_outlined,
                  size: 60,
                  color: AppTheme.green,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.fingerprint,
                  size: 60,
                  color: AppTheme.green,
                )),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'already have an account ?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              DefaultTextbutton(label: 'Log in', onPressed: () {}),
            ],
          )
        ]),
      ),
    );
  }
}