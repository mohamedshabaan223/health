import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainerDoctor extends StatefulWidget {
  ContainerDoctor(
      {required this.doctorNmae,
      required this.descrabtion,
      required this.doctorImage,
      required this.doctorid});
  final String doctorNmae;
  final String descrabtion;
  final String doctorImage;
  final DoctorModel doctorid; // استخدم DoctorModel بدلاً من الحقول الفردية

  @override
  State<ContainerDoctor> createState() => _ContainerDoctorState();
}

class _ContainerDoctorState extends State<ContainerDoctor> {
  bool isSelected = false;
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: width * 0.17,
      height: height * 0.17,
      decoration: BoxDecoration(
          color: AppTheme.gray, borderRadius: BorderRadius.circular(17)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(widget.doctorImage),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctorNmae,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 16, color: AppTheme.green),
                ),
                Text(
                  widget.descrabtion,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 14),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          DoctorInformation.routeName,
                          arguments: widget.doctorid.id,
                        );
                      },
                      child: Container(
                        height: 29,
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
                                ?.copyWith(color: AppTheme.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.13,
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
                          color: AppTheme.green),
                      containerClolor: AppTheme.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
