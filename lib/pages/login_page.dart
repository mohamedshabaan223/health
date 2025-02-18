import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/pages/create_new_password_page.dart';
import 'package:health_app/pages/home_screen.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email;
  String? password;
  bool isLoading = false;

  bool isEmailValid = false;
  bool isPasswordValid = false;

  void validateEmail(String value) {
    setState(() {
      isEmailValid =
          RegExp(r'^[A-Z][a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value);
    });
  }

  void validatePassword(String value) {
    setState(() {
      isPasswordValid = RegExp(r'^(?=.*[A-Z])(?=.*\W).{6,}$').hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is LoginSuccess) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Success')),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (state is LoginFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Log In'),
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
                    SizedBox(height: height * 0.07),
                    Text('Email',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: height * 0.02),
                    DefaultTextformfield(
                      onChanged: (data) {
                        email = data;
                        validateEmail(data);
                      },
                      hint: 'Enter Email',
                      controller:
                          BlocProvider.of<AuthCubit>(context).logInEmail,
                    ),
                    SizedBox(height: height * 0.03),
                    Text('Password',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: height * 0.02),
                    DefaultTextformfield(
                      onChanged: (data) {
                        password = data;
                        validatePassword(data);
                      },
                      hint: 'Enter Password',
                      controller:
                          BlocProvider.of<AuthCubit>(context).logInPassword,
                      isPassword: true,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, CreateNewPasswordPage.id);
                          },
                          child: Text(
                            'Forget Password',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppTheme.green),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.08),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      content: Text(
                                          'Please enter valid credentials')),
                                );
                              }
                            },
                            buttonBackgroundColor: AppTheme.green,
                            buttonForegroundColor: AppTheme.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (email != null && email!.isNotEmpty)
                          _buildValidationText(
                              "Email must start with a capital letter",
                              isEmailValid),
                        if (password != null && password!.isNotEmpty) ...[
                          _buildValidationText(
                              "Password must start with a capital letter",
                              password![0] == password![0].toUpperCase()),
                          _buildValidationText(
                              "Password must contain a special character",
                              isPasswordValid),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildValidationText(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            color: isValid ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isValid ? Colors.green : Colors.red,
              decoration:
                  isValid ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
