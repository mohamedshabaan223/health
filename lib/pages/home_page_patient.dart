import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/profile_cubit/profile_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_state.dart';
import 'package:health_app/pages/Specializations_page.dart';
import 'package:health_app/pages/all_doctors_basedOn_specialization.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/pages/patient_profile_page.dart';
import 'package:health_app/widgets/CustomSpecializationsContainer.dart';
import 'package:health_app/widgets/card_of_doctor.dart';
import 'package:health_app/widgets/custom_user_information.dart';
import 'package:health_app/widgets/doctors_and_favourite.dart';
import 'package:health_app/widgets/search_field.dart';
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
    print("User ID from cache: $userId");
    if (userId != null) {
      context.read<UserProfileCubit>().fetchUserProfile(userId);
    } else {
      print("User ID is null!");
    }
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
                DoctorsAndFavourite(
                  icon: FontAwesomeIcons.stethoscope,
                  label: 'Doctors',
                  onTap: () {
                    Navigator.of(context).pushNamed(DoctorPage.routeName);
                  },
                ),
                SizedBox(width: width * 0.05),
                DoctorsAndFavourite(
                  icon: FontAwesomeIcons.heart,
                  label: 'Favourite',
                  onTap: () {
                    Navigator.of(context).pushNamed(Favorite.routeName);
                  },
                ),
                const SearchField(),
              ],
            ),
            SizedBox(height: height * 0.07),
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
            SizedBox(height: height * 0.03),
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
                  print("Specializations: $specializations");

                  if (specializations.isEmpty) {
                    return const Center(
                        child: Text("No specializations available."));
                  }

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
                      mainAxisSpacing: 15,
                      childAspectRatio: 1,
                    ),
                    itemCount: specializations.length,
                    itemBuilder: (context, index) {
                      final specialization = specializations[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AllDoctorsBasedOnSpecialization.id,
                            arguments: {
                              'specializationId': specialization.id,
                              'specializationName': specialization.name
                            },
                          );
                        },
                        child: SpecializationContainer(
                          imagePath: 'assets/images/Oncology.png',
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
            SizedBox(height: height * 0.03),
            SizedBox(
              height: height * (width > 600 ? 0.5 : 0.4),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: CardOfDoctor(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(DoctorInformation.routeName);
                      },
                    ),
                  );
                },
              ),
            ),
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
