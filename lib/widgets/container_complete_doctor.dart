import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/appointment_screen.dart';
import 'package:health_app/pages/review_page.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainerCompleteDoctor extends StatefulWidget {
  const ContainerCompleteDoctor({super.key});

  @override
  State<ContainerCompleteDoctor> createState() =>
      _ContainerCompleteDoctorState();
}

class _ContainerCompleteDoctorState extends State<ContainerCompleteDoctor> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: width * 0.15,
      height: height * 0.20,
      decoration: BoxDecoration(
          color: AppTheme.gray, borderRadius: BorderRadius.circular(17)),
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 14.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/male.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr . Alexander Bennett Ph.D.',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 16, color: AppTheme.green),
                    ),
                    Text(
                      'Dermato-Genetics',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          height: 20,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppTheme.green,
                                size: 19,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                '5',
                                style: TextStyle(
                                    fontSize: 16, color: AppTheme.green),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.28,
                        ),
                        Defaulticon(
                          onTap: () {
                            isFavorite = !isFavorite;
                            setState(() {});
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.white,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.01,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AppointmentScreen.id);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 27,
                  width: 116,
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: Text(
                    'Re-Book',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppTheme.green),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ReviewPage.id);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 28,
                  width: 124,
                  decoration: BoxDecoration(
                      color: AppTheme.green,
                      borderRadius: BorderRadius.circular(18)),
                  child: Text(
                    'Add Review',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppTheme.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
