import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/cubits/payment_cubit/payment_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_cubit.dart';
import 'package:health_app/pages/start_screen.dart';

class ShowLogout extends StatelessWidget {
  const ShowLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 242,
      decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27), topRight: Radius.circular(27))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Logout',
              style: TextStyle(
                  color: AppTheme.green,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Are you sure you want to log out?',
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
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      await _handleLogout(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 41,
                      width: 146,
                      decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        'Yes, Logout',
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: 20,
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

  Future<void> _handleLogout(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout Success...")),
    );

    await CacheHelper().removeData(key: ApiKey.token);
    await CacheHelper().removeData(key: 'id');

    BlocProvider.of<AuthCubit>(context).resetState();
    BlocProvider.of<DoctorCubit>(context).resetState();
    BlocProvider.of<BookingCubit>(context).resetState();
    BlocProvider.of<PaymentCubit>(context).resetState();
    BlocProvider.of<ChatCubit>(context).resetState();
    BlocProvider.of<SpecializationsCubit>(context).resetState();
    BlocProvider.of<UserProfileCubit>(context).resetState();

    String? tokenAfterDelete = CacheHelper().getData(key: ApiKey.token);
    print('Token after deletion: $tokenAfterDelete');

    Navigator.pushNamedAndRemoveUntil(
      context,
      StartScreen.id,
      (route) => false,
    );
  }
}
