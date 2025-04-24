import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/cache/cache_helper.dart';

class DoctorContainerSpecialization extends StatefulWidget {
  const DoctorContainerSpecialization({
    super.key,
    required this.doctorNmae,
    required this.address,
    required this.doctorImage,
    required this.doctorid,
    required this.rating,
  });

  final String doctorNmae;
  final String address;
  final String doctorImage;
  final int doctorid;
  final int rating;

  @override
  State<DoctorContainerSpecialization> createState() =>
      _DoctorContainerSpecializationState();
}

class _DoctorContainerSpecializationState
    extends State<DoctorContainerSpecialization> {
  late int patientId;

  @override
  void initState() {
    super.initState();
    patientId = CacheHelper().getData(key: "id") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<FavoriteDoctorCubit, FavoriteDoctorState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          height: height * 0.17,
          decoration: BoxDecoration(
            color: AppTheme.gray,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(widget.doctorImage),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      widget.doctorNmae,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 17, color: AppTheme.green),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppTheme.green, size: 18),
                        Text(
                          widget.address,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppTheme.green,
                                size: 18,
                              ),
                              Text(
                                widget.rating.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: AppTheme.green, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      children: [
                        Defaulticon(
                          onTap: () {
                            final favoriteCubit =
                                context.read<FavoriteDoctorCubit>();

                            if (favoriteCubit
                                .isDoctorFavorite(widget.doctorid)) {
                              favoriteCubit.removeFavoriteDoctor(
                                patientId: patientId,
                                doctorId: widget.doctorid,
                              );
                            } else {
                              favoriteCubit.addFavoriteDoctor(
                                patientId: patientId,
                                doctorId: widget.doctorid,
                              );
                            }

                            setState(() {});
                          },
                          icon: Icon(
                            context
                                    .watch<FavoriteDoctorCubit>()
                                    .isDoctorFavorite(widget.doctorid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 19,
                            color: AppTheme.green,
                          ),
                          containerClolor: AppTheme.white,
                        ),
                        SizedBox(width: width * 0.03),
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
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                'Info',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        color: AppTheme.white, fontSize: 16),
                              ),
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
        );
      },
    );
  }
}

Widget _buildInfoContainer({
  required String text,
  required double width,
  required void Function()? onTap,
  required Color backgroundColor,
  required Color textColor,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
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
