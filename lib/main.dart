import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/constants.dart';
import 'package:health_app/core/api/dio_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/pages/appointment_screen.dart';
import 'package:health_app/pages/create_new_password_page.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/pages/home_page.dart';
import 'package:health_app/pages/login.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/pages/start_screen.dart';
import 'package:health_app/pages/your_appoinment.dart';
import 'package:health_app/simple_bloc_observer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  HttpOverrides.global = MyHttpOverrides();
  await CacheHelper().init();
  token = CacheHelper().getData(key: ApiKey.token);
  print("Token: $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(create: (context) => DoctorCubit(DioConsumer(dio: Dio()))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          Login.routeName: (_) => Login(),
          StartScreen.id: (_) => const StartScreen(),
          RegisterPage.id: (_) => RegisterPage(),
          CreateNewPasswordPage.id: (_) => CreateNewPasswordPage(),
          HomePage.id: (_) => const HomePage(),
          DoctorPage.routeName: (_) => DoctorPage(),
          DoctorInformation.routeName: (_) => DoctorInformation(),
          Rating.routeName: (_) => Rating(),
          Favorite.routeName: (_) => Favorite(),
          Female.routeName: (_) => Female(),
          Male.routeName: (_) => Male(),
          AppointmentScreen.id: (_) => const AppointmentScreen(),
          YourAppoinment.id: (_) => const YourAppoinment(),
        },
        initialRoute:
            token != null && token != "" ? HomePage.id : StartScreen.id,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
