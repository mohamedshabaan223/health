import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/pages/chat_page.dart';
import 'package:health_app/widgets/container_schdule.dart';
import 'package:health_app/models/get_doctor_info_by_id.dart';

class ContainerDoctorInfo extends StatefulWidget {
  const ContainerDoctorInfo({super.key, required this.doctorId});
  final int doctorId;

  @override
  State<ContainerDoctorInfo> createState() => _ContainerDoctorInfoState();
}

class _ContainerDoctorInfoState extends State<ContainerDoctorInfo> {
  bool isFavorite = false;
  bool isRating = false;
  int? patientId = CacheHelper().getData(key: 'id');
  AvailableSlot? selectedSlot;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<DoctorCubit, DoctorState>(
      builder: (context, state) {
        if (state is GetDoctorInfoLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetDoctorInfoFailure) {
          return Center(
            child: Text(
              "Error: ${state.errorMessage}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is GetDoctorInfoSuccess) {
          final doctor = state.doctorInfo;
          return Container(
            height: height * 0.5,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppTheme.gray,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        ClipOval(
                          child: Image(
                            image: doctor.localImagePath != null &&
                                    doctor.localImagePath!.isNotEmpty
                                ? FileImage(File(doctor.localImagePath!))
                                : const AssetImage(
                                        'assets/images/doctor_image.png')
                                    as ImageProvider,
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: height * 0.03),
                    Column(
                      children: [
                        Container(
                          height: height * 0.06,
                          width: height * 0.2,
                          decoration: BoxDecoration(
                            color: AppTheme.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: height * 0.003),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Image.asset(
                                      'assets/images/professianol1.png',
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    doctor.experience,
                                    style: const TextStyle(
                                      color: AppTheme.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                ' experience',
                                style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Container(
                          height: height * 0.22,
                          width: height * 0.2,
                          decoration: BoxDecoration(
                            color: AppTheme.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Focus : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: doctor.focus,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  height: height * 0.064,
                  width: height * 0.35,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.green,
                        ),
                      ),
                      Text(
                        doctor.specialization,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              color: AppTheme.green, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${doctor.rating}',
                            style: const TextStyle(
                              color: AppTheme.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: height * 0.04),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.money,
                              color: AppTheme.green, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            doctor.availableSlots.isNotEmpty
                                ? doctor.availableSlots[0].price
                                    .toStringAsFixed(2)
                                : "no price",
                            style: const TextStyle(
                              color: AppTheme.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ContainerSchdule(
                      doctorId: widget.doctorId,
                      doctorName: doctor.name,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ChatScreen.id,
                          arguments: {
                            'doctorId': widget.doctorId,
                            'patientId': patientId,
                            'doctorName': doctor.name,
                          },
                        );
                      },
                      child: _buildInfoContainer(
                        icon: Icons.chat,
                        text: 'Chat',
                        width: 120,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('No doctor ID provided.'));
      },
    );
  }

  Widget _buildInfoContainer({
    required IconData icon,
    required String text,
    required double width,
  }) {
    return Container(
      width: width,
      height: 35,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.green, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.green,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
