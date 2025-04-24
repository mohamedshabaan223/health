import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';

class CardOfDoctor extends StatefulWidget {
  //final String name;
  //final String specialization;
  const CardOfDoctor({
    super.key,
    this.onTap,
  });
  final Function()? onTap;

  @override
  State<CardOfDoctor> createState() => _CardOfDoctorState();
}

class _CardOfDoctorState extends State<CardOfDoctor> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          width: double.infinity,
          height: height * 0.12,
          decoration: BoxDecoration(
            color: AppTheme.gray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 14.0),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/doctor_image.png'),
                ),
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: Column(
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
                        child: Column(
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
                                color: AppTheme.green3,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Row(
                      children: [
                        _buildInfoContainer(
                          icon: Icons.star,
                          text: '4.8',
                          width: width * 0.15,
                        ),
                        SizedBox(width: width * 0.02),
                        _buildInfoContainer(
                          icon: Icons.chat,
                          text: '90',
                          width: width * 0.15,
                        ),
                        SizedBox(width: width * 0.1),
                        Container(
                          width: width * 0.08,
                          height: height * 0.04,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.question_mark,
                              size: 16,
                              color: AppTheme.green,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Container(
                          width: width * 0.08,
                          height: height * 0.04,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            onPressed: () {
                              isFavourite = !isFavourite;
                              setState(() {});
                            },
                            icon: isFavourite
                                ? const Icon(
                                    Icons.favorite,
                                    size: 16,
                                    color: AppTheme.green,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    size: 16,
                                    color: AppTheme.green,
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer(
      {required IconData icon, required String text, required double width}) {
    return Container(
      width: width,
      height: 25,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.green, size: 15),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.green,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
