import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainrDoctorRating extends StatefulWidget {
  const ContainrDoctorRating({super.key});

  @override
  State<ContainrDoctorRating> createState() => _ContainrDoctorRatingState();
}

class _ContainrDoctorRatingState extends State<ContainrDoctorRating> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        height: height * 0.17,
        width: width * 15,
        decoration: BoxDecoration(
          color: AppTheme.gray,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: CircleAvatar(
              radius: 37,
              backgroundImage: AssetImage('assets/images/doctor_image.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/professional.png',
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Professianol Doctor',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
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
                            style:
                                TextStyle(fontSize: 16, color: AppTheme.green),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 0.6,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 2, bottom: 2),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. Olivia Turner, M.D',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.green,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Dermato-Endocrinology',
                                  style: TextStyle(
                                    color: AppTheme.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(DoctorInformation.routeName);
                          },
                          child: Container(
                            height: 26,
                            width: 50,
                            decoration: BoxDecoration(
                                color: AppTheme.green,
                                borderRadius: BorderRadius.circular(18)),
                            child: Center(
                              child: Text(
                                'info',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: AppTheme.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.22,
                        ),
                        Defaulticon(
                          onTap: () {},
                          icon: Icon(
                            CupertinoIcons.exclamationmark,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Defaulticon(
                          onTap: () {},
                          icon: Icon(
                            Icons.question_mark,
                            size: 17,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.white,
                        ),
                        SizedBox(
                          width: 4,
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
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
