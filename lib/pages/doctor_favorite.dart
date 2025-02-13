import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
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
                      icon: const Icon(
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
                          onPressed: () {},
                          icons: Icon(
                            Icons.search,
                            color: AppTheme.green,
                          ),
                          containerBackgroundColor: AppTheme.gray),
                      SizedBox(
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
    );
  }
}
