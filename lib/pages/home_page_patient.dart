import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/location_cubit/location_cubit.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_state.dart';
import 'package:health_app/pages/Specializations_page.dart';
import 'package:health_app/pages/all_doctors_basedOn_specialization.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/nearby_doctor.dart';
import 'package:health_app/pages/patient_profile_page.dart';
import 'package:health_app/widgets/CustomSpecializationsContainer.dart';
import 'package:health_app/widgets/card_of_doctor.dart';
import 'package:health_app/widgets/custom_user_information.dart';
import 'package:health_app/widgets/doctors_and_favourite.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class HomePagePatient extends StatefulWidget {
  const HomePagePatient({super.key});
  static const String id = '/home_page_patient';

  @override
  State<HomePagePatient> createState() => _HomePagePatientState();
}

class _HomePagePatientState extends State<HomePagePatient> {
  @override
  void initState() {
    super.initState();
    int? userId = CacheHelper().getData(key: 'id');
    if (userId != null) {
      context.read<UserProfileCubit>().fetchUserProfile(userId);
    }
    context.read<LocationCubit>().fetchNearbyDoctors(distanceInKm: 5);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Row(
              children: [
                const CustomUserInformation(),
                const Spacer(),
                SizedBox(width: width * 0.02),
                TopIconInHomePage(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProfilePatient.id);
                  },
                  containerBackgroundColor: AppTheme.gray,
                  icons: const Icon(
                    Icons.settings_outlined,
                    size: 22,
                    color: AppTheme.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),
            Row(
              children: [
                SizedBox(width: width * 0.02),
                DoctorsAndFavourite(
                  icon: FontAwesomeIcons.stethoscope,
                  label: 'Doctors',
                  onTap: () {
                    Navigator.of(context).pushNamed(DoctorPage.routeName);
                  },
                ),
                SizedBox(width: width * 0.04),
                DoctorsAndFavourite(
                  icon: FontAwesomeIcons.heart,
                  label: 'Favourite',
                  onTap: () {
                    Navigator.of(context).pushNamed(Favorite.routeName);
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.04),
            Row(
              children: [
                Text(
                  'Specializations',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppTheme.green3,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(_createRoute());
                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.green,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.green),
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.gray, thickness: 2),
            BlocBuilder<SpecializationsCubit, SpecialityState>(
              builder: (context, state) {
                if (state is SpecialityLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SpecialityFailure) {
                  return Center(
                    child: Text(
                      "Error: ${state.errorMessage}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is SpecialitySuccess) {
                  final specializations =
                      state.specializations.take(6).toList();

                  if (specializations.isEmpty) {
                    return const Center(
                        child: Text("No specializations available."));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: specializations.length,
                    itemBuilder: (context, index) {
                      final specialization = specializations[index];
                      return GestureDetector(
                        child: SpecializationContainer(
                          imagePath: specialization.imagePath ?? '',
                          title: specialization.name,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AllDoctorsBasedOnSpecialization.id,
                              arguments: {
                                'specializationId': specialization.id,
                                'specializationName': specialization.name
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Something went wrong."));
                }
              },
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  'Nearby Doctors',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppTheme.green3,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(NearbyDoctor.id);
                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppTheme.green,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.green),
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.gray, thickness: 2),
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NearbyDoctorsLoaded) {
                  final doctors = state.doctors.take(3).toList();
                  if (doctors.isEmpty) {
                    return const Center(
                        child: Text("No doctors Nearby available."));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: CardOfDoctor(
                          doctor: doctor,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              DoctorInformation.routeName,
                              arguments: doctor.id,
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is LocationError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SpecializationsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
