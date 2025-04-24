import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
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
        title: Column(
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
            if (state.doctorsList.isEmpty) {
              return const Center(child: Text("No doctors available."));
            }

            return ListView.builder(
              itemCount: state.doctorsList.length,
              itemBuilder: (context, index) {
                final doctor = state.doctorsList[index];
                return DoctorContainerSpecialization(
                  doctorNmae: doctor.doctorName,
                  address: doctor.address,
                  doctorImage: doctor.photo ?? 'assets/images/doctor_image.png',
                  doctorid: doctor.id,
                  rating: doctor.rating,
                );
              },
            );
          } else {
            return const Center(child: Text("Something went wrong."));
          }
        },
      ),
    );
  }
}
