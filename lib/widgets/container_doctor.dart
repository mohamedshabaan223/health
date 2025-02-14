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
      required this.doctorid,
      required this.doctorAddress});
  final String doctorNmae;
  final String descrabtion;
  final String doctorImage;
  final DoctorModel doctorid;
  final String doctorAddress;

  @override
  State<ContainerDoctor> createState() => _ContainerDoctorState();
}

class _ContainerDoctorState extends State<ContainerDoctor> {
  bool isSelected = false;
  bool isFavorite = false;
  bool isRating = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: double.infinity,
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
                Row(
                  children: [
                    Text(
                      widget.descrabtion,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      width: width * 0.08,
                    ),
                    Defaulticon(
                      onTap: () {
                        isFavorite = !isFavorite;
                        setState(() {});
                      },
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 19,
                          color: AppTheme.green),
                      containerClolor: AppTheme.white,
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    _buildInfoContainer(
                      backgroundColor: AppTheme.white,
                      textColor: AppTheme.green3,
                      text: 'Price',
                      width: 70,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(
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
                        width: 70,
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
                      width: width * 0.06,
                    ),
                    _buildInfoContainer(
                      backgroundColor: AppTheme.green3,
                      textColor: AppTheme.white,
                      text: widget.doctorAddress,
                      width: 130,
                      onTap: () {},
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

Widget _buildInfoContainer(
    {required String text,
    required double width,
    required void Function()? onTap,
    required Color backgroundColor,
    required Color textColor}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
