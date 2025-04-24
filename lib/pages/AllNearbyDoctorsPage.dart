import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/location_cubit/location_cubit.dart';
import 'package:health_app/widgets/card_of_doctor.dart';

class AllNearbyDoctorsPage extends StatelessWidget {
  const AllNearbyDoctorsPage({super.key});
  static const String id = '/all_nearby_doctors';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Nearby Doctors"),
        backgroundColor: AppTheme.white,
      ),
      body: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NearbyDoctorsLoaded) {
            final doctors = state.doctors;
            if (doctors.isEmpty) {
              return const Center(child: Text("No nearby doctors found."));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final doc = doctors[index];
                return CardOfDoctor(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/doctor_information',
                      arguments: doc,
                    );
                  },
                );
              },
            );
          }
          if (state is LocationError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
