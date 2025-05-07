import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/widgets/default_icon.dart';
import 'package:health_app/widgets/doctor_container_specialization.dart';

class AllDoctorsBasedOnSpecialization extends StatefulWidget {
  static const id = "/allDoctorsBasedOnSpecialization";

  const AllDoctorsBasedOnSpecialization({super.key});

  @override
  _AllDoctorsBasedOnSpecializationState createState() =>
      _AllDoctorsBasedOnSpecializationState();
}

class _AllDoctorsBasedOnSpecializationState
    extends State<AllDoctorsBasedOnSpecialization> {
  late int specializationId;
  late String title;
  String searchQuery = '';
  bool isSearching = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args['specializationId'] != null) {
      specializationId = args['specializationId'];
      title = args['specializationName'];
      context
          .read<DoctorCubit>()
          .getDoctorsBySpecialization(specializationId: specializationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search Doctor...',
                  border: InputBorder.none,
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    title,
                    style: const TextStyle(color: AppTheme.green),
                  ),
                ],
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Defaulticon(
              icon: const Icon(Icons.search),
              containerClolor: const Color.fromARGB(255, 245, 247, 251),
              onTap: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<DoctorCubit, DoctorState>(
        builder: (context, state) {
          if (state is GetDoctorBySpecializationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetDoctorBySpecializationFailure) {
            return Center(
              child: Text(
                "Error: ${state.errorMessage}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is GetDoctorBySpecializationSuccess) {
            final doctorsListToDisplay = isSearching
                ? state.doctorsList
                    .where((doctor) => doctor.doctorName
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .toList()
                : state.doctorsList;

            if (doctorsListToDisplay.isEmpty) {
              return const Center(child: Text("No doctors available."));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: doctorsListToDisplay.length,
                    itemBuilder: (context, index) {
                      final doctor = doctorsListToDisplay[index];
                      final patientImage = doctor.localImagePath != null &&
                              doctor.localImagePath!.isNotEmpty
                          ? FileImage(File(doctor.localImagePath!))
                          : const AssetImage("assets/images/doctor_image.png");
                      return DoctorContainerSpecialization(
                        doctorNmae: doctor.doctorName,
                        address: doctor.address,
                        doctorImage: patientImage,
                        rating: doctor.rating.toDouble(),
                        doctorid: doctor.id,
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}
