import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/another_navigator_observer.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/constants.dart';
import 'package:health_app/core/api/dio_consumer.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/appointment_cubit/appointment_cubit.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/get_doctor_info_in_doctor_app_cubit/get_doctor_info_in_doctor_app_cubit.dart';
import 'package:health_app/cubits/location_cubit/location_cubit.dart';
import 'package:health_app/cubits/payment_cubit/payment_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/review_cubit/review_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_cubit.dart';
import 'package:health_app/navigator_observar.dart';
import 'package:health_app/pages/AllNearbyDoctorsPage.dart';
import 'package:health_app/pages/Specializations_page.dart';
import 'package:health_app/pages/all_appoinements_for_doctor.dart';
import 'package:health_app/pages/all_doctors_basedOn_specialization.dart';
import 'package:health_app/pages/appointment_details_doctor.dart';
import 'package:health_app/pages/appointment_screen.dart';
import 'package:health_app/pages/cancelled_reason_page.dart';
import 'package:health_app/pages/change_password.dart';
import 'package:health_app/pages/chat_page.dart';
import 'package:health_app/pages/create_new_password_page.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/doctor_profile_page.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/pages/doctor_update_profile.dart';
import 'package:health_app/pages/home_page_patient.dart';
import 'package:health_app/pages/home_screen_doctor.dart';
import 'package:health_app/pages/home_screen_patient.dart';
import 'package:health_app/pages/login_page.dart';
import 'package:health_app/pages/patient_profile_page.dart';
import 'package:health_app/pages/register_page.dart';
import 'package:health_app/pages/review_page.dart';
import 'package:health_app/pages/review_screen_doctor.dart';
import 'package:health_app/pages/start_screen.dart';
import 'package:health_app/pages/payment_success_page.dart';
import 'package:health_app/pages/update_booking_page.dart';
import 'package:health_app/pages/patient_update_profile_page.dart';
import 'package:health_app/pages/your_appoinment.dart';
import 'package:health_app/simple_bloc_observer.dart';
import 'package:health_app/tabs/chat/display_all_chat.dart';

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
  patientId = CacheHelper().getData(key: "id");
  role = CacheHelper().getData(key: "role");
  if (token == null || patientId == null) {
    token = await CacheHelper().getData(key: ApiKey.token);
    patientId = await CacheHelper().getData(key: "id");
  }
  print("User ID: $patientId");
  print("Token: $token");
  print("Role: $role");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final dioConsumer = DioConsumer(dio: Dio());
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(dioConsumer),
        ),
        BlocProvider<DoctorCubit>(
          create: (context) => DoctorCubit(dioConsumer)
            ..getAllDoctorsByOrderType(orderType: 'ASC'),
        ),
        BlocProvider(
          create: (context) => BookingCubit(dioConsumer),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(dioConsumer),
        ),
        BlocProvider(
          create: (context) => ChatCubit(dioConsumer),
        ),
        BlocProvider(
          create: (context) =>
              SpecializationsCubit(dioConsumer)..getAllSpecializations(),
        ),
        BlocProvider(
          create: (context) => UserProfileCubit(dioConsumer),
        ),
        BlocProvider(
          create: (context) => FavoriteDoctorCubit(dioConsumer),
        ),
        BlocProvider(
          create: (context) => ReviewCubit(dioConsumer),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(
            dioConsumer,
            CacheHelper(),
          ),
        ),
        BlocProvider(
          create: (context) => AppointmentCubit(dioConsumer),
        ),
        BlocProvider(
          create: (context) => GetDoctorInfoInDoctorAppCubit(dioConsumer),
        )
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
              AnotherNavigatorObserver(
                onPopNext: () {
                  final doctorId = CacheHelper().getData(key: 'id');
                  if (doctorId != null) {
                    context
                        .read<BookingCubit>()
                        .getDoctorCompletedBookings(doctorId: doctorId);
                  }
                },
              ),
            ],
            routes: {
              Login.routeName: (_) => const Login(),
              StartScreen.id: (_) => const StartScreen(),
              RegisterPage.id: (_) => const RegisterPage(),
              CreateNewPasswordPage.id: (_) => CreateNewPasswordPage(),
              HomePagePatient.id: (_) => const HomePagePatient(),
              DoctorPage.routeName: (_) => const DoctorPage(),
              DoctorInformation.routeName: (_) => const DoctorInformation(),
              Rating.routeName: (_) => const Rating(),
              Favorite.routeName: (_) => const Favorite(),
              Female.routeName: (_) => const Female(),
              Male.routeName: (_) => const Male(),
              AppointmentScreen.id: (_) => const AppointmentScreen(),
              YourAppoinment.id: (_) => const YourAppoinment(),
              ReviewPage.id: (_) => const ReviewPage(),
              HomeScreenPatient.id: (_) => const HomeScreenPatient(),
              HomeScreenDoctor.id: (_) => const HomeScreenDoctor(),
              CancelledReasonPage.id: (_) => CancelledReasonPage(),
              payment_success.id: (_) => payment_success(),
              SpecializationsPage.id: (_) => const SpecializationsPage(),
              ChatScreen.id: (_) => const ChatScreen(),
              AllDoctorsBasedOnSpecialization.id: (_) =>
                  const AllDoctorsBasedOnSpecialization(),
              ProfilePatient.id: (_) => const ProfilePatient(),
              ProfileDoctor.id: (_) => const ProfileDoctor(),
              PatientUpdateProfile.id: (_) => const PatientUpdateProfile(),
              ChangePassword.id: (_) => const ChangePassword(),
              UpdateBookingPage.id: (_) => const UpdateBookingPage(),
              DisplayAllChat.routeName: (_) => const DisplayAllChat(),
              DoctorUpdateProfile.id: (_) => const DoctorUpdateProfile(),
              AppointementPatientDetails.routeName: (_) =>
                  const AppointementPatientDetails(),
              AllAppoinementForDoctor.id: (_) =>
                  const AllAppoinementForDoctor(),
              AllNearbyDoctorsPage.id: (_) => const AllNearbyDoctorsPage(),
              ReviewScreenDoctorReview.id: (_) =>
                  const ReviewScreenDoctorReview(),
            },
            initialRoute: token == null
                ? StartScreen.id
                : (role == 'Doctor'
                    ? HomeScreenDoctor.id
                    : HomeScreenPatient.id),
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
