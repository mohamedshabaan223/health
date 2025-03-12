import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/widgets/container_doctor_fav.dart';

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
                        itemBuilder: (_, index) => ContainerDoctorFavorite(
                          doctorName: filteredDoctors[index].doctorName,
                          description:
                              filteredDoctors[index].specializationName,
                          doctorImage: filteredDoctors[index].photo ??
                              'assets/images/doctor_image.png',
                          doctorId: filteredDoctors[index],
                          doctorAddress: filteredDoctors[index].address,
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
