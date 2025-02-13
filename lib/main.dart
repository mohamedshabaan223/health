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
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/cubits/payment_cubit/payment_cubit.dart';
import 'package:health_app/navigator_observar.dart';
import 'package:health_app/pages/Specializations_page.dart';
import 'package:health_app/pages/all_doctors_basedOn_specialization.dart';
import 'package:health_app/pages/appointment_screen.dart';
import 'package:health_app/pages/cancelled_reason_page.dart';
import 'package:health_app/pages/chat_page.dart';
import 'package:health_app/pages/create_new_password_page.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/pages/home_page.dart';
import 'package:health_app/pages/home_screen.dart';
import 'package:health_app/pages/login_page.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/pages/review_page.dart';
import 'package:health_app/pages/start_screen.dart';
import 'package:health_app/pages/payment_success_page.dart';
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
  patientId = CacheHelper().getData(key: ApiKey.id);
  print("Patient ID: $patientId");
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
        BlocProvider<DoctorCubit>(
          create: (context) => DoctorCubit(DioConsumer(dio: Dio()))
            ..getAllDoctorsByOrderType(orderType: 'ASC'),
        ),
        BlocProvider(
          create: (context) => BookingCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(DioConsumer(dio: Dio())),
        ),
        BlocProvider(
          create: (context) => ChatCubit(DioConsumer(dio: Dio())),
        ),
      ],
      child: Builder(
        builder: (context) {
          final doctorCubit = BlocProvider.of<DoctorCubit>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              MyNavigatorObserver(
                onPopNext: () {
                  doctorCubit.getAllDoctorsByOrderType(orderType: 'ASC');
                },
              ),
            ],
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
              Review.id: (_) => Review(),
              HomeScreen.id: (_) => HomeScreen(),
              CancelledReasonPage.id: (_) => CancelledReasonPage(),
              payment_success.id: (_) => payment_success(),
              SpecializationsPage.id: (_) => SpecializationsPage(),
              ChatScreen.id: (_) => ChatScreen(),
              AllDoctorsBasedOnSpecialization.id: (_) =>
                  AllDoctorsBasedOnSpecialization(),
            },
            initialRoute: token != null ? HomeScreen.id : StartScreen.id,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
