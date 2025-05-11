import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cubits/location_cubit/location_cubit.dart';
import 'package:health_app/pages/doctor_page_information.dart';
import 'package:health_app/widgets/card_of_doctor.dart';

class NearbyDoctor extends StatefulWidget {
  const NearbyDoctor({super.key});
  static const String id = '/nearby_doctor';

  @override
  State<NearbyDoctor> createState() => _NearbyDoctorState();
}

class _NearbyDoctorState extends State<NearbyDoctor> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchQuery = '';
        searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search doctor...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              )
            : const Column(
                children: [
                  SizedBox(height: 15),
                  Text("Nearby Doctors"),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: toggleSearch,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NearbyDoctorsLoaded) {
              final filteredDoctors = state.doctors
                  .where((doctor) =>
                      doctor.doctorName.toLowerCase().contains(searchQuery))
                  .toList();

              if (filteredDoctors.isEmpty) {
                return const Center(
                  child: Text("No doctors match your search."),
                );
              }

              return ListView.builder(
                itemCount: filteredDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: CardOfDoctor(
                      doctor: doctor,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          DoctorInformation.routeName,
                          arguments: doctor.id,
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is LocationError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("Something went wrong."));
            }
          },
        ),
      ),
    );
  }
}
