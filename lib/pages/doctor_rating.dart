import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_male.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/widgets/container_doctor_rating.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class Rating extends StatelessWidget {
  static const String routeName = '/rating';

  const Rating({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.03),
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
                        size: width * 0.05,
                        color: AppTheme.green,
                      )),
                  Text(
                    'Rating',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: width * 0.05),
                  ),
                  Row(
                    children: [
                      TopIconInHomePage(
                        onPressed: () {},
                        icons: Icon(Icons.search,
                            color: AppTheme.green, size: width * 0.045),
                        containerBackgroundColor: AppTheme.gray,
                      ),
                      SizedBox(width: width * 0.02),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.02, horizontal: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sort By',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: width * 0.04,
                            color: AppTheme.green,
                          ),
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(DoctorPage.routeName);
                      },
                      icon: Icon(Icons.sort_by_alpha_outlined,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {},
                      icon: Icon(Icons.star_border,
                          size: width * 0.045, color: AppTheme.white),
                      containerClolor: AppTheme.green,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: Icon(Icons.female,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                    SizedBox(width: width * 0.02),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Male.routeName);
                      },
                      icon: Icon(Icons.male,
                          size: width * 0.045, color: AppTheme.green),
                      containerClolor: AppTheme.gray,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (_, index) => const ContainrDoctorRating(),
                  itemCount: 3,
                  itemExtent: height * 0.18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
