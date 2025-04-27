import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/default_icon.dart';

class Favorite extends StatefulWidget {
  static const String routeName = '/favorite';

  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<dynamic> allDoctors = [];
  List<dynamic> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final favoriteCubit = context.read<FavoriteDoctorCubit>();
      int? patientId = CacheHelper().getData(key: "id");

      if (patientId != null) {
        favoriteCubit.getAllDoctorsInFavorites(patientId: patientId);
      }
    });
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      setState(() => filteredDoctors = allDoctors);
    } else {
      setState(() {
        filteredDoctors = allDoctors
            .where((doctor) =>
                doctor.doctorName.toLowerCase().contains(query.toLowerCase()) ||
                doctor.specializationName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new_outlined,
                        size: width * 0.05, color: AppTheme.green),
                  ),
                  Expanded(
                    child: isSearching
                        ? TextField(
                            controller: searchController,
                            onChanged: filterDoctors,
                            decoration: const InputDecoration(
                              hintText: "Search for doctors...",
                              border: InputBorder.none,
                            ),
                          )
                        : Center(
                            child: Text(
                              'Favorite',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: width * 0.05),
                            ),
                          ),
                  ),
                  Container(
                    height: width * 0.1,
                    width: width * 0.1,
                    decoration: const BoxDecoration(
                      color: AppTheme.gray,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isSearching ? Icons.close : Icons.search,
                        size: width * 0.045,
                        color: AppTheme.green,
                      ),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          if (!isSearching) {
                            searchController.clear();
                            filteredDoctors = allDoctors;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),
              Expanded(
                child: BlocBuilder<FavoriteDoctorCubit, FavoriteDoctorState>(
                  builder: (context, state) {
                    if (state is FavoriteDoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetAllDoctorsFavoriteSuccess) {
                      allDoctors = state.doctors;
                      if (filteredDoctors.isEmpty) {
                        filteredDoctors = allDoctors;
                      }
                      return ListView.builder(
                        itemCount: filteredDoctors.length,
                        itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
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
                                    backgroundImage: filteredDoctors[index]
                                                .localImagePath !=
                                            null
                                        ? FileImage(File(filteredDoctors[index]
                                            .localImagePath!))
                                        : AssetImage(
                                                'assets/images/doctor_image.png')
                                            as ImageProvider,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 10, bottom: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filteredDoctors[index].doctorName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontSize: 16,
                                              color: AppTheme.green,
                                            ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        filteredDoctors[index]
                                            .specializationName,
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
                                          Expanded(
                                            child: Text(
                                              filteredDoctors[index].address,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
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
                                              color: AppTheme.green, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            filteredDoctors[index]
                                                .rating
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, top: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Defaulticon(
                                      icon: const Icon(Icons.favorite,
                                          color: AppTheme.green, size: 20),
                                      containerClolor: AppTheme.white,
                                      onTap: () {
                                        final favoriteCubit =
                                            context.read<FavoriteDoctorCubit>();
                                        favoriteCubit.removeFavoriteDoctor(
                                          patientId:
                                              CacheHelper().getData(key: "id")!,
                                          doctorId: filteredDoctors[index].id,
                                        );
                                        setState(() {
                                          filteredDoctors.removeAt(index);
                                        });
                                        BlocProvider.of<FavoriteDoctorCubit>(
                                                context)
                                            .getAllDoctorsInFavorites(
                                                patientId: CacheHelper()
                                                    .getData(key: "id")!);
                                      },
                                    ),
                                    SizedBox(height: height * 0.02),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          DoctorInformation.routeName,
                                          arguments: filteredDoctors[index].id,
                                        );
                                      },
                                      child: Container(
                                        height: 29,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: AppTheme.green,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'info',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                    color: AppTheme.white,
                                                    fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Favorite Icon to remove doctor from favorites
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(0.4),
                                  BlendMode.modulate,
                                ),
                                child: Image.asset(
                                  "assets/images/no_doctors_in_favorites.png",
                                ),
                              ),
                            ),
                            const SizedBox(height: 80),
                            const Text(
                              "No doctors in favorites",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
