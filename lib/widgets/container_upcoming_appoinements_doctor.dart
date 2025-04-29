import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/models/all_appointment_paient_for_doctor.dart';
import 'package:health_app/pages/appointment_details_doctor.dart';

class ContainerUpComingAppoinementsDoctor extends StatefulWidget {
  final AllAppointmentsPatientForDoctor appointment;

  const ContainerUpComingAppoinementsDoctor({
    required this.appointment,
    super.key,
  });

  @override
  State<ContainerUpComingAppoinementsDoctor> createState() =>
      _ContainerUpComingAppoinementsDoctorState();
}

class _ContainerUpComingAppoinementsDoctorState
    extends State<ContainerUpComingAppoinementsDoctor> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.appointment.localImagePath != null) {
      final imageFile = File(widget.appointment.localImagePath!);
      if (imageFile.existsSync() && imageFile.lengthSync() > 0) {
        imageProvider = FileImage(imageFile);
      } else {
        imageProvider = const AssetImage('assets/images/doctor_image.png');
      }
    } else {
      imageProvider = const AssetImage('assets/images/doctor_image.png');
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppointementPatientDetails.routeName,
          arguments: {
            'bookingId': widget.appointment.bookingId,
            'patientName': widget.appointment.patientName,
          },
        ).then((result) {
          if (result == true) {
            final doctorId = CacheHelper().getData(key: 'id');
            if (doctorId != null) {
              context
                  .read<BookingCubit>()
                  .getDoctorCompletedBookings(doctorId: doctorId);
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppTheme.gray,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: CircleAvatar(
                radius: 35,
                backgroundImage: imageProvider,
                backgroundColor: AppTheme.green.withOpacity(0.2),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Patient Name: ',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 17,
                              color: AppTheme.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Expanded(
                        child: Text(
                          widget.appointment.patientName,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 17,
                                    color: AppTheme.green2,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.userDoctor,
                        color: AppTheme.green2,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Age: ${widget.appointment.age}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
