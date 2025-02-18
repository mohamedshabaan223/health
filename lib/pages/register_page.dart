import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/pages/home_screen.dart';
import 'package:health_app/widgets/default_textbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/radio_buttom_for_users.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:health_app/widgets/text_form_field_label.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String id = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  String? fullName;
  String? phone;
  bool isLoading = false;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool hasEnteredData = false;

  void validateEmail(String value) {
    setState(() {
      isEmailValid =
          RegExp(r'^[A-Z][a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value);
      hasEnteredData = true;
    });
  }

  void validatePassword(String value) {
    setState(() {
      isPasswordValid = RegExp(r'^(?=.*[A-Z])(?=.*\W).{6,}$').hasMatch(value);
      hasEnteredData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is RegisterSuccess) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Register Success')),
          );
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (state is RegisterFailure) {
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
              child: Form(
                key: BlocProvider.of<AuthCubit>(context).registerFormKey,
                child: ListView(
                  children: [
                    const TextFormFieldLabel(text: 'Full name'),
                    SizedBox(height: height * 0.01),
                    DefaultTextformfield(
                      onChanged: (data) {
                        fullName = data;
                        setState(() => hasEnteredData = true);
                      },
                      hint: 'Enter Full Name',
                      controller:
                          BlocProvider.of<AuthCubit>(context).registerUserName,
                    ),
                    SizedBox(height: height * 0.02),
                    const TextFormFieldLabel(text: 'Email'),
                    SizedBox(height: height * 0.01),
                    DefaultTextformfield(
                      onChanged: (data) {
                        email = data;
                        validateEmail(data);
                      },
                      hint: 'Enter Email',
                      controller:
                          BlocProvider.of<AuthCubit>(context).registerEmail,
                    ),
                    SizedBox(height: height * 0.02),
                    const TextFormFieldLabel(text: 'Password'),
                    SizedBox(height: height * 0.01),
                    DefaultTextformfield(
                      onChanged: (data) {
                        password = data;
                        validatePassword(data);
                      },
                      hint: 'Enter Password',
                      controller:
                          BlocProvider.of<AuthCubit>(context).registerPassword,
                      isPassword: true,
                    ),
                    SizedBox(height: height * 0.02),
                    const TextFormFieldLabel(text: 'Phone'),
                    SizedBox(height: height * 0.01),
                    DefaultTextformfield(
                      onChanged: (data) {
                        phone = data;
                        setState(() => hasEnteredData = true);
                      },
                      hint: 'Enter Phone',
                      controller: BlocProvider.of<AuthCubit>(context)
                          .registerPhoneNumber,
                    ),
                    const SizedBox(height: 60, child: RadioButtonForUsers()),
                    Column(
                      children: [
                        Text('By continuing, you agree to',
                            style: Theme.of(context).textTheme.titleSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Terms of Use',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: AppTheme.green)),
                            Text('  and  ',
                                style: Theme.of(context).textTheme.titleSmall),
                            Text('Privacy Policy',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: AppTheme.green)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Center(
                      child: StartScreenButton(
                        label: 'Sign Up',
                        onPressed: () {
                          if (BlocProvider.of<AuthCubit>(context)
                              .registerFormKey
                              .currentState!
                              .validate()) {
                            BlocProvider.of<AuthCubit>(context).register();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please enter valid data")),
                            );
                          }
                        },
                        buttonBackgroundColor: AppTheme.green,
                        buttonForegroundColor: AppTheme.white,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                            style: Theme.of(context).textTheme.titleSmall),
                        DefaultTextbutton(
                          label: 'Log in',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    if (hasEnteredData) ...[
                      SizedBox(height: height * 0.02),
                      _buildValidationText(
                          "Email must start with a capital letter",
                          isEmailValid),
                      _buildValidationText(
                          "Password must start with a capital letter",
                          password?.isNotEmpty == true &&
                              password![0] == password![0].toUpperCase()),
                      _buildValidationText(
                          "Password must contain a special character",
                          isPasswordValid),
                    ],
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
