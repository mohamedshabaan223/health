import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainerDoctor extends StatefulWidget {
  final String doctorNmae;
  final String descrabtion;
  final String doctorImage;
  final DoctorModel doctorid;
  final String doctorAddress;
  const ContainerDoctor(
      {super.key,
      required this.doctorNmae,
      required this.descrabtion,
      required this.doctorImage,
      required this.doctorid,
      required this.doctorAddress});

  @override
  State<ContainerDoctor> createState() => _ContainerDoctorState();
}

class _ContainerDoctorState extends State<ContainerDoctor> {
  late int patientId;
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    patientId = CacheHelper().getData(key: "id") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocBuilder<FavoriteDoctorCubit, FavoriteDoctorState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          width: double.infinity,
          height: height * 0.18,
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
                    backgroundImage: widget.doctorid.localImagePath != null &&
                            widget.doctorid.localImagePath!.isNotEmpty
                        ? FileImage(File(widget.doctorid.localImagePath!))
                        : const AssetImage("assets/images/doctor_image.png"),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctorNmae,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 16,
                              color: AppTheme.green,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.descrabtion,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: AppTheme.green3, size: 18),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.doctorAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontSize: 14, color: Colors.grey),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppTheme.green3, size: 18),
                          const SizedBox(width: 5),
                          Text(
                            widget.doctorid.rating.toString(),
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
              ),
              Column(
                children: [
                  SizedBox(height: height * 0.05),
                  Defaulticon(
                    onTap: () {
                      final favoriteCubit = context.read<FavoriteDoctorCubit>();
                      if (favoriteCubit
                          .isDoctorFavorite(widget.doctorid.id ?? 0)) {
                        favoriteCubit.removeFavoriteDoctor(
                          patientId: patientId,
                          doctorId: widget.doctorid.id ?? 0,
                        );
                      } else {
                        favoriteCubit.addFavoriteDoctor(
                          patientId: patientId,
                          doctorId: widget.doctorid.id ?? 0,
                        );
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      context
                              .watch<FavoriteDoctorCubit>()
                              .isDoctorFavorite(widget.doctorid.id ?? 0)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 19,
                      color: AppTheme.green,
                    ),
                    containerClolor: AppTheme.white,
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DoctorInformation.routeName,
                        arguments: widget.doctorid.id,
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
        );
      },
    );
  }
}
