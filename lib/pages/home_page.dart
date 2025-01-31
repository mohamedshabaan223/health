import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/CustomButtomNavigationBar.dart';
import 'package:health_app/widgets/card_of_doctor.dart';
import 'package:health_app/widgets/custom_user_information.dart';
import 'package:health_app/widgets/doctors_and_favourite.dart';
import 'package:health_app/widgets/search_field.dart';
import 'package:health_app/widgets/specialties_item.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String id = '/home_page';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                // User info and top icons
                Row(
                  children: [
                    const CustomUserInformation(),
                    const Spacer(),
                    const TopIconInHomePage(
                      containerBackgroundColor: AppTheme.gray,
                      icons: Icon(
                        Icons.notifications_outlined,
                        size: 22,
                        color: AppTheme.green,
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    const TopIconInHomePage(
                      containerBackgroundColor: AppTheme.gray,
                      icons: Icon(
                        Icons.settings_outlined,
                        size: 22,
                        color: AppTheme.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),

                // Doctors and favourites with search field
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

                // Specialties section header
                Row(
                  children: [
                    Text(
                      'Specialties',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppTheme.green3,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: AppTheme.green,
                                decoration: TextDecoration.underline,
                                decorationColor: AppTheme.green),
                      ),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.gray, thickness: 2),
                SizedBox(height: height * 0.03),

                // Specialties items (row 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpecialtiesItem(
                      onTap: () {},
                      image: 'assets/images/Cardiology Specialties Button.png',
                    ),
                    SizedBox(width: width * 0.03),
                    SpecialtiesItem(
                      onTap: () {},
                      image: 'assets/images/Dermatology Specialties Button.png',
                    ),
                    SizedBox(width: width * 0.03),
                    SpecialtiesItem(
                      onTap: () {},
                      image: 'assets/images/General Medicane Button.png',
                    ),
                  ],
                ),
                SizedBox(height: height * 0.014),

                // Specialties items (row 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpecialtiesItem(
                      onTap: () {},
                      image: 'assets/images/Gynecology Specialties Button.png',
                    ),
                    SizedBox(width: width * 0.03),
                    SpecialtiesItem(
                      onTap: () {},
                      image: 'assets/images/Odontology Specialties Button.png',
                    ),
                    SizedBox(width: width * 0.03),
                    SpecialtiesItem(
                      onTap: () {},
                      image: 'assets/images/Oncology Specialties Button.png',
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),

                // Doctors list with constrained height
                SizedBox(
                  height: height * 0.4, // Adjust height as needed
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
        ),
      ),
      //bottomNavigationBar: const CustomButtomNavigationBar(),
    );
  }
}
