import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';

class ShowDeleteAccount extends StatelessWidget {
  const ShowDeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 242,
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27),
          topRight: Radius.circular(27),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Delete Account',
              style: TextStyle(
                  color: AppTheme.green,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Are you sure you want to delete your account?',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 41,
                      width: 143,
                      decoration: BoxDecoration(
                          color: AppTheme.gray,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppTheme.green,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.deleteAccount();
                      authCubit.stream.listen((state) {
                        if (state is DeleteAccountSuccess) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('تم حذف الحساب بنجاح')),
                            );
                            Navigator.pop(context);
                          }
                        } else if (state is DeleteAccountFailure) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'فشل حذف الحساب: ${state.errorMessage}')),
                            );
                          }
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 41,
                      width: 166,
                      decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        'Yes, Delete Account',
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
