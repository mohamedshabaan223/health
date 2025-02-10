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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 25,
                        color: AppTheme.green,
                      )),
                  Text(
                    'Rating',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      TopIconInHomePage(
                          onPressed: () {},
                          icons: Icon(
                            Icons.search,
                            color: AppTheme.green,
                          ),
                          containerBackgroundColor: AppTheme.gray),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Text('Sort By',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppTheme.green,
                                )),
                    const SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(DoctorPage.routeName);
                      },
                      icon: const Icon(
                        Icons.sort_by_alpha_outlined,
                        size: 18,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {},
                      icon: const Icon(
                        Icons.star_border,
                        size: 17,
                        color: AppTheme.white,
                      ),
                      containerClolor: AppTheme.green,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: const Icon(
                        Icons.female,
                        size: 17,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Male.routeName);
                      },
                      icon: const Icon(
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
                  itemBuilder: (_, index) => const ContainrDoctorRating(),
                  itemCount: 3,
                  itemExtent: 145,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
