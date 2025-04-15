import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContainerCompleteAppoinementsDoctor extends StatefulWidget {
  const ContainerCompleteAppoinementsDoctor({
    super.key,
  });

  @override
  State<ContainerCompleteAppoinementsDoctor> createState() =>
      _ContainerCompleteAppoinementsDoctorState();
}

class _ContainerCompleteAppoinementsDoctorState
    extends State<ContainerCompleteAppoinementsDoctor> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: width * 0.85,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.gray,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.userDoctor,
                  color: AppTheme.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Message',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.green),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.calendar,
                  color: AppTheme.green2, size: 18),
              const SizedBox(width: 5),
              Text(
                'Day',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14),
              ),
              const SizedBox(width: 20),
              const Icon(FontAwesomeIcons.clock,
                  color: AppTheme.green2, size: 18),
              const SizedBox(width: 5),
              Text(
                'Time',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
