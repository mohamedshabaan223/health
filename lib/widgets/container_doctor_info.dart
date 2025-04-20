import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/pages/chat_page.dart';
import 'package:health_app/widgets/DoctorAppointmentsDropdown.dart';
import 'package:health_app/widgets/container_schdule.dart';

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
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: AppTheme.gray,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/male.png'),
                      radius: 50,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor.specialization,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('assets/images/professianol1.png',
                                    height: 20),
                                const SizedBox(width: 6),
                                Text(
                                  '${doctor.experience} experience',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),

                // عرض كل الأسعار
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...doctor.prices.map((p) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.price_change_outlined,
                                color: AppTheme.green, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${p.name}: ${p.price} EGP',
                              style: const TextStyle(
                                  color: AppTheme.green, fontSize: 15),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),

                // إضافة التقييم (Rating) تحت الأسعار
                const SizedBox(height: 15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '5 / 5', // هذا هو التقييم الافتراضي ويمكنك تغييره حسب الحاجة
                        style: const TextStyle(
                          color: AppTheme.green,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // قائمة المواعيد
                Row(
                  children: [
                    Expanded(
                      child: DoctorAppointmentsDropdown(
                        availableAppointments: doctor.availableAppointments,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // أزرار الحجز والدردشة
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
                )
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
