import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/cubit/auth_cubit.dart';
import 'package:health_app/pages/home_page.dart';
import 'package:health_app/widgets/default_textbutton.dart';
import 'package:health_app/widgets/default_textformfield.dart';
import 'package:health_app/widgets/list_view_icons.dart';
import 'package:health_app/widgets/start_screen_button.dart';
import 'package:health_app/widgets/text_form_field_label.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  static const String id = '/register';
  String? email;
  String? password;
  String? fullName;
  String? phone;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Register Success'),
            ),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          isLoading = false;
        } else if (state is RegisterFailure) {
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
                child: ListView(children: [
                  const TextFormFieldLabel(text: 'Full name'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  DefaultTextformfield(
                    onChanged: (data) {
                      fullName = data;
                    },
                    hint: 'Enter Full Name',
                    controller:
                        BlocProvider.of<AuthCubit>(context).registerUserName,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const TextFormFieldLabel(text: 'Email'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  DefaultTextformfield(
                    onChanged: (data) {
                      email = data;
                    },
                    hint: 'Enter Email',
                    controller:
                        BlocProvider.of<AuthCubit>(context).registerEmail,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const TextFormFieldLabel(text: 'Password'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  DefaultTextformfield(
                    onChanged: (data) {
                      password = data;
                    },
                    hint: 'Enter Password',
                    controller:
                        BlocProvider.of<AuthCubit>(context).registerPassword,
                    isPassword: true,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const TextFormFieldLabel(text: 'Phone'),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  DefaultTextformfield(
                    onChanged: (data) {
                      phone = data;
                    },
                    hint: 'Enter Phone',
                    controller:
                        BlocProvider.of<AuthCubit>(context).registerPhoneNumber,
                  ),
                  SizedBox(
                    height: height * 0.05,
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
                      onPressed: () {
                        if (BlocProvider.of<AuthCubit>(context)
                            .registerFormKey
                            .currentState!
                            .validate()) {
                          BlocProvider.of<AuthCubit>(context).register();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter valid data"),
                            ),
                          );
                        }
                      },
                      buttonBackgroundColor: AppTheme.green,
                      buttonForegroundColor: AppTheme.white,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Center(
                      child: Text('or sign up with',
                          style: Theme.of(context).textTheme.titleSmall)),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const ListViewIcons(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'already have an account ?',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      DefaultTextbutton(
                          label: 'Log in',
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
