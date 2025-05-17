import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_page_information_for_rating.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainrDoctorRating extends StatefulWidget {
  const ContainrDoctorRating({super.key, required this.doctor});
  final DoctorModel doctor;

  @override
  State<ContainrDoctorRating> createState() => _ContainrDoctorRatingState();
}

class _ContainrDoctorRatingState extends State<ContainrDoctorRating> {
  late int patientId;

  @override
  void initState() {
    super.initState();
    patientId = CacheHelper().getData(key: "id") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ImageProvider doctorImage;
    if (widget.doctor.localImagePath != null &&
        widget.doctor.localImagePath!.isNotEmpty) {
      doctorImage = FileImage(File(widget.doctor.localImagePath!));
    } else {
      doctorImage = const AssetImage('assets/images/doctor_image.png');
    }

    return BlocBuilder<FavoriteDoctorCubit, FavoriteDoctorState>(
      builder: (context, state) {
        final isFavorite = context
            .watch<FavoriteDoctorCubit>()
            .isDoctorFavorite(widget.doctor.id ?? 0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.gray,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: doctorImage,
                      width: 80,
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor.doctorName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 15,
                              color: AppTheme.green,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.doctor.specializationName,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppTheme.green3, size: 18),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 100,
                            child: Text(
                              widget.doctor.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 14, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppTheme.green3, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            widget.doctor.rating.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          const Icon(Icons.money,
                              color: AppTheme.green3, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            widget.doctor.availableSlots.isNotEmpty
                                ? widget.doctor.availableSlots[0].price!
                                    .toStringAsFixed(2)
                                : 'no price',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(height: height * 0.05),
                    Defaulticon(
                      onTap: () {
                        final favoriteCubit =
                            context.read<FavoriteDoctorCubit>();
                        if (isFavorite) {
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
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 19,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.white,
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          DoctorPageInformationForRating.routeName,
                          arguments: widget.doctor.id,
                        );
                      },
                      child: Container(
                        height: 29,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.green,
                          borderRadius: BorderRadius.circular(18),
                        ),
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
                  ],
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
