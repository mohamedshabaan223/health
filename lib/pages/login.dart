import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/pages/create_new_password_page.dart';
import 'package:health_app/pages/home_page.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/widgets/default_textbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/list_view_icons.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Success'),
            ),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state is LoginFailure) {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
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
                child: Form(
                  key: BlocProvider.of<AuthCubit>(context).logInFormKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: height * 0.07,
                      ),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      DefaultTextformfield(
                          onChanged: (data) {
                            email = data;
                          },
                          hint: 'Enter Email',
                          controller:
                              BlocProvider.of<AuthCubit>(context).logInEmail),
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
                        onChanged: (data) {
                          password = data;
                        },
                        hint: 'Enter Password',
                        controller:
                            BlocProvider.of<AuthCubit>(context).logInPassword,
                        isPassword: true,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CreateNewPasswordPage.id);
                              },
                              child: Text('Forget Password',
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
                        child: StartScreenButton(
                          label: 'Log In',
                          onPressed: () {
                            if (BlocProvider.of<AuthCubit>(context)
                                .logInFormKey
                                .currentState!
                                .validate()) {
                              BlocProvider.of<AuthCubit>(context).logIn();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please enter valid credentials'),
                                ),
                              );
                            }
                          },
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
                          DefaultTextbutton(
                              label: 'Sign Up',
                              onPressed: () {
                                Navigator.pushNamed(context, RegisterPage.id);
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }
}
