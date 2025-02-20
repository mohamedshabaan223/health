import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/models/doctor_model.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';

class ContainerDoctorFavorite extends StatefulWidget {
  const ContainerDoctorFavorite({
    required this.doctorName,
    required this.description,
    required this.doctorImage,
    required this.doctorId,
    required this.doctorAddress,
    Key? key,
  }) : super(key: key);

  final String doctorName;
  final String description;
  final String doctorImage;
  final DoctorModel doctorId;
  final String doctorAddress;

  @override
  State<ContainerDoctorFavorite> createState() =>
      _ContainerDoctorFavoriteState();
}

class _ContainerDoctorFavoriteState extends State<ContainerDoctorFavorite> {
  late int patientId;

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
        final favoriteCubit = context.read<FavoriteDoctorCubit>();
        final bool isFavorite =
            favoriteCubit.isDoctorFavorite(widget.doctorId.id ?? 0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          width: double.infinity,
          height: height * 0.16,
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
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctorName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 16,
                            color: AppTheme.green,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.description,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppTheme.green3, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          widget.doctorAddress,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DoctorInformation.routeName,
                        arguments: widget.doctorId.id,
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
