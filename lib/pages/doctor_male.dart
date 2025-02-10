import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/pages/doctor_female.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/pages/doctor_rating.dart';
import 'package:health_app/widgets/container_doctor.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/top_icon_in_home_page.dart';

class Male extends StatefulWidget {
  static const String routeName = '/male';

  @override
  State<Male> createState() => _MaleState();
}

class _MaleState extends State<Male> {
  @override
  void initState() {
    super.initState();
    // Fetch male doctors on initialization
    BlocProvider.of<DoctorCubit>(context).getDoctorsByGender(gender: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Top Bar with Back and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 25,
                      color: AppTheme.green,
                    ),
                  ),
                  Text(
                    'Male Doctors',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      TopIconInHomePage(
                        onPressed: () {},
                        icons: Icon(
                          Icons.search,
                          color: AppTheme.green,
                        ),
                        containerBackgroundColor: AppTheme.gray,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
              // Sorting and Filter Options
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Sort By',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppTheme.green),
                    ),
                    const SizedBox(width: 5),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(DoctorPage.routeName);
                      },
                      icon: const Icon(
                        Icons.sort_by_alpha,
                        size: 18,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    const SizedBox(width: 5),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Rating.routeName);
                      },
                      icon: const Icon(
                        Icons.star_border,
                        size: 17,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    const SizedBox(width: 5),
                    Defaulticon(
                      onTap: () {
                        Navigator.of(context).pushNamed(Female.routeName);
                      },
                      icon: const Icon(
                        Icons.female,
                        size: 17,
                        color: AppTheme.green,
                      ),
                      containerClolor: AppTheme.gray,
                    ),
                    const SizedBox(width: 5),
                    Defaulticon(
                      onTap: () {}, // Current page, no action needed
                      icon: const Icon(
                        Icons.male,
                        size: 17,
                        color: AppTheme.white,
                      ),
                      containerClolor: AppTheme.green,
                    ),
                  ],
                ),
              ),
              // Male Doctors List
              Expanded(
                child: BlocBuilder<DoctorCubit, DoctorState>(
                  builder: (context, state) {
                    if (state is DoctorLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DoctorFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is DoctorSuccess) {
                      final doctors = state.doctorsList;
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, index) => ContainerDoctor(
                          doctorNmae:
                              doctors[index].doctorName ?? 'Dr. Unknown',
                          descrabtion: doctors[index].specializationName ??
                              'No Specialty',
                          doctorImage: 'assets/images/male.png',
                          doctorid: doctors[index],
                        ),
                      );
                    }
                    return const Center(
                      child: Text('No doctors available.'),
                    );
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
