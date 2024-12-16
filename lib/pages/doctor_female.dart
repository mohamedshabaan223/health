import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_favorite.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/widgets/CustomButtomNavigationBar.dart';
import 'package:health_app/widgets/container_doctor.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class Female extends StatefulWidget {
  static const String routeName = '/female';

  @override
  State<Female> createState() => _FemaleState();
}

class _FemaleState extends State<Female> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 25,
                        color: AppTheme.green,
                      )),
                  Text(
                    'Female',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      TopIconInHomePage(
                          icons: Icon(
                            Icons.search,
                            color: AppTheme.green,
                          ),
                          containerBackgroundColor: AppTheme.gray),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {},
                          child: Image.asset('assets/images/filter1.png')),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Sort By',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppTheme.green),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(DoctorPage.routeName);
                      },
                      icon: Icon(
                        Icons.sort_by_alpha,
                        size: 18,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Rating.routeName);
                      },
                      icon: Icon(
                        Icons.star_border,
                        size: 17,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {},
                      icon: Icon(
                        Icons.female,
                        size: 17,
                        color: AppTheme.white,
                      ),
                      containerClolor: AppTheme.green,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Male.routeName);
                      },
                      icon: Icon(
                        Icons.male,
                        size: 17,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) => ContainerDoctor(
                    doctorNmae: 'Dr. Olivia Turner ,M.D.',
                    descrabtion: 'Dermato-Endocrinology',
                    doctorImage: 'assets/images/doctor_image.png',
                  ),
                  itemCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomButtomNavigationBar(),
    );
  }
}
