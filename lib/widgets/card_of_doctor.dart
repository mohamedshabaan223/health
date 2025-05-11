import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/models/doctor_model_for_nearby_doctor.dart';

class CardOfDoctor extends StatefulWidget {
  final DoctorModelForNearByDoctor doctor;
  const CardOfDoctor({
    super.key,
    this.onTap,
    required this.doctor,
  });
  final Function()? onTap;

  @override
  State<CardOfDoctor> createState() => _CardOfDoctorState();
}

class _CardOfDoctorState extends State<CardOfDoctor> {
  late int patientId;

  @override
  void initState() {
    super.initState();
    patientId = CacheHelper().getData(key: "id");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<FavoriteDoctorCubit, FavoriteDoctorState>(
      builder: (context, state) {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        width: 72,
                        height: 75,
                        image: _buildDoctorImage(
                            widget.doctor.photo, widget.doctor.localImagePath),
                        fit: BoxFit.contain,
                      ),
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 2, bottom: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.doctor.doctorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.green,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  widget.doctor.specializationName,
                                  style: const TextStyle(
                                    color: AppTheme.black,
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
                              text: widget.doctor.rating.toString(),
                              width: width * 0.15,
                            ),
                            SizedBox(width: width * 0.02),
                            _buildInfoContainer(
                              icon: Icons.money,
                              text: widget.doctor.availableSlots[0].price == 0
                                  ? 'مجاني'
                                  : widget.doctor.availableSlots[0].price
                                      .toString(),
                              width: width * 0.15,
                            ),
                            SizedBox(
                              width: width * 0.2,
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
                                  final favoriteCubit =
                                      context.read<FavoriteDoctorCubit>();
                                  if (favoriteCubit.isDoctorFavorite(
                                      widget.doctor.id ?? 0)) {
                                    favoriteCubit.removeFavoriteDoctor(
                                      patientId: patientId,
                                      doctorId: widget.doctor.id ?? 0,
                                    );
                                  } else {
                                    favoriteCubit.addFavoriteDoctor(
                                      patientId: patientId,
                                      doctorId: widget.doctor.id ?? 0,
                                    );
                                  }
                                  setState(() {}); // لتحديث الواجهة
                                },
                                icon: context
                                        .watch<FavoriteDoctorCubit>()
                                        .isDoctorFavorite(widget.doctor.id ?? 0)
                                    ? const Icon(
                                        Icons.favorite,
                                        size: 18,
                                        color: AppTheme.green,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        size: 18,
                                        color: AppTheme.green,
                                      ),
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
          ),
        );
      },
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
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _buildDoctorImage(String? photo, String? localImagePath) {
    if (localImagePath != null && localImagePath.isNotEmpty) {
      final file = File(localImagePath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    if (photo != null && photo.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(photo));
      } catch (_) {
        return const AssetImage('assets/images/male.png');
      }
    }
    return const AssetImage('assets/images/male.png');
  }
}
