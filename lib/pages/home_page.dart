import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/Specializations_page.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/CustomSpecializationsContainer.dart';
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

    return SafeArea(
      child: SingleChildScrollView(
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

            // Specialties items (row 1)
            // استبدال الصفوف الحالية بهذه الـ GridView
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // منع التمرير الداخلي
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // عدد العناصر في كل صف
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: 6, // عدد التخصصات
              itemBuilder: (context, index) {
                List<String> images = [
                  'assets/images/heart.png',
                  'assets/images/hair.png',
                  'assets/images/general.png',
                  'assets/images/Gynecology.png',
                  'assets/images/Odontology.png',
                  'assets/images/Oncology.png',
                ];
                List<String> specializationsTitles = [
                  'Cardiology',
                  'Dermatology',
                  'General',
                  'Gynecology',
                  'Odontology',
                  'Oncology',
                ];

                return GestureDetector(
                    onTap: () {},
                    child: SpecializationContainer(
                      imagePath: images[index],
                      title: specializationsTitles[index],
                      onTap: () {},
                    ));
              },
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
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SpecializationsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // يبدأ من اليمين
      const end = Offset.zero; // ينتهي في مكانه الطبيعي
      const curve = Curves.easeInOut; // تسهيل الحركة

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
