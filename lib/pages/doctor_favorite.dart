import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/widgets/CustomButtomNavigationBar.dart';
import 'package:health_app/widgets/container_doctor_fav.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class Favorite extends StatelessWidget {
  static const String routeName = '/favorite';
  bool isFavorite = false;

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
                    'Favorite',
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
                        Icons.sort_by_alpha_outlined,
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
                        Icons.favorite_border,
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
                        Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: Icon(
                        Icons.female,
                        size: 17,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
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
                  itemBuilder: (_, index) => ContainerDoctorFavorite(),
                  itemExtent: 150,
                  itemCount: 4,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomButtomNavigationBar(),
    );
  }
}
