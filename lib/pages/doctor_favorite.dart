import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_cubit.dart';
import 'package:health_app/cubits/favorite_cubit/favorite_state.dart';
import 'package:health_app/widgets/container_doctor_fav.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class Favorite extends StatefulWidget {
  static const String routeName = '/favorite';

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final favoriteCubit = context.read<FavoriteDoctorCubit>();
      int? patientId = CacheHelper().getData(key: "id");

      if (patientId != null) {
        favoriteCubit.getAllDoctorsInFavorites(patientId: patientId);
      } else {
        debugPrint("❌ Patient ID is null! Make sure it's stored correctly.");
      }
    });
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
              // 🔹 العنوان والأيقونات العلوية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new_outlined,
                        size: width * 0.05, color: AppTheme.green),
                  ),
                  Text(
                    'Favorite',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: width * 0.05),
                  ),
                  Row(
                    children: [
                      TopIconInHomePage(
                        onPressed: () {},
                        icons: Icon(Icons.search,
                            size: width * 0.045, color: AppTheme.green),
                        containerBackgroundColor: AppTheme.gray,
                      ),
                      SizedBox(width: width * 0.02),
                    ],
                  ),
                ],
              ),

              // 🔹 أيقونة المفضلة
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: width * 0.02),
                child: Row(
                  children: [
                    Defaulticon(
                      onTap: () {},
                      icon: Icon(Icons.favorite_border,
                          size: width * 0.045, color: AppTheme.white),
                      containerClolor: AppTheme.green,
                    ),
                    SizedBox(width: width * 0.02),
                  ],
                ),
              ),

              // 🔹 قائمة الأطباء المفضلين
              Expanded(
                child: BlocBuilder<FavoriteDoctorCubit, FavoriteDoctorState>(
                  builder: (context, state) {
                    if (state is FavoriteDoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FavoriteDoctorEmpty) {
                      return Center(child: Text("No favorite doctors found."));
                    } else if (state is GetAllDoctorsFavoriteSuccess) {
                      final doctors = state.doctors;
                      if (doctors.isEmpty) {
                        return Center(child: Text("No doctors in favorites."));
                      }
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, index) => ContainerDoctorFavorite(
                          doctorName: doctors[index].doctorName,
                          description: doctors[index].specializationName,
                          doctorImage: doctors[index].photo ??
                              'assets/images/doctor_image.png',
                          doctorId: doctors[index],
                          doctorAddress: doctors[index].address,
                        ),
                      );
                    } else if (state is FavoriteDoctorFailure) {
                      return Center(
                          child: Text('Error: ${state.errorMessage}'));
                    }
                    return const Center(
                        child: Text('No favorite doctors found.'));
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
