import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';

class DoctorContainerSpecialization extends StatefulWidget {
  DoctorContainerSpecialization(
      {required this.doctorNmae,
      required this.address,
      required this.doctorImage,
      required this.doctorid});
  final String doctorNmae;
  final String address;
  final String doctorImage;
  final int doctorid;

  @override
  State<DoctorContainerSpecialization> createState() =>
      _DoctorContainerSpecializationState();
}

class _DoctorContainerSpecializationState
    extends State<DoctorContainerSpecialization> {
  bool isSelected = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
            padding: const EdgeInsets.only(top: 10, left: 10, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.doctorNmae,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 17, color: AppTheme.green),
                ),
                SizedBox(
                  width: width * 0.01,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
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
                      width: width * 0.26,
                    ),
                    _buildInfoContainer(
                      textColor: AppTheme.green,
                      backgroundColor: AppTheme.white,
                      text: 'Price ${50} \$',
                      width: 100,
                      onTap: () {},
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          DoctorInformation.routeName,
                          arguments: widget.doctorid,
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
                      width: width * 0.12,
                    ),
                    _buildInfoContainer(
                      textColor: AppTheme.white,
                      backgroundColor: AppTheme.green,
                      text: widget.address,
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
