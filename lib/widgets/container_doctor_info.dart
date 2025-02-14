import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/pages/chat_page.dart';
import 'package:health_app/widgets/DoctorAppointmentsDropdown.dart';
import 'package:health_app/widgets/container_schdule.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainerDoctorInfo extends StatefulWidget {
  const ContainerDoctorInfo({super.key, this.doctorId});
  final int? doctorId;

  @override
  State<ContainerDoctorInfo> createState() => _ContainerDoctorInfoState();
}

class _ContainerDoctorInfoState extends State<ContainerDoctorInfo> {
  bool isFavorite = false;
  bool isRating = false;
  int? patientId = CacheHelper().getData(key: ApiKey.id);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
            height: height * 0.45,
            width: width * 0.98,
            decoration: BoxDecoration(
                color: AppTheme.gray, borderRadius: BorderRadius.circular(17)),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/male.png'),
                          radius: 75,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 7, top: 3),
                            height: height * 0.05,
                            width: width * 0.36,
                            decoration: BoxDecoration(
                                color: AppTheme.green,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/professianol1.png',
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  '${doctor.experience}\nexperience',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: AppTheme.white,
                                        fontSize: 14,
                                      ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: width * 0.34,
                            height: height * 0.18,
                            decoration: BoxDecoration(
                                color: AppTheme.green,
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Foucs: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: AppTheme.white,
                                              fontSize: 15,
                                            ),
                                      ),
                                      Text(
                                        '${doctor.focus}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                color: AppTheme.white,
                                                fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: width * 0.84,
                    height: height * 0.07,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 2, bottom: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${doctor.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.green,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Specialization: ${doctor.specialization}',
                            style: const TextStyle(
                              color: AppTheme.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width * 0.89,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: width * 0.02),
                        InkWell(
                          onTap: () {},
                          child: _buildInfoContainer(
                            icon: Icons.star,
                            text: '5',
                            width: width * 0.12,
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        InkWell(
                          onTap: () {},
                          child: _buildInfoContainer(
                            icon: Icons.chat,
                            text: '40',
                            width: width * 0.14,
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        DoctorAppointmentsDropdown(
                            availableAppointments: doctor.availableAppointments)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      ContainerSchdule(doctorId: widget.doctorId),
                      SizedBox(
                        width: width * 0.2,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatScreen.id,
                            arguments: {
                              'doctorId': widget.doctorId,
                              'patientId': patientId,
                              'doctorName': doctor.name
                            },
                          );
                        },
                        child: _buildInfoContainer(
                          icon: Icons.chat,
                          text: 'Chat',
                          width: 80,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Defaulticon(
                        onTap: () {
                          isRating = !isRating;
                          setState(() {});
                        },
                        icon: Icon(
                          isRating ? Icons.star : Icons.star_border,
                          size: 20,
                          color: AppTheme.green,
                        ),
                        containerClolor: AppTheme.white,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Defaulticon(
                        onTap: () {
                          isFavorite = !isFavorite;
                          setState(() {});
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: AppTheme.green,
                        ),
                        containerClolor: AppTheme.white,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No doctor ID provided.'));
        }
      },
    );
  }
}

Widget _buildInfoContainer({
  required IconData icon,
  required String text,
  required double width,
}) {
  return Container(
    width: width,
    height: 30,
    decoration: BoxDecoration(
      color: AppTheme.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppTheme.green, size: 20),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.green,
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}
