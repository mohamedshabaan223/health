import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/core/api/dio_consumer.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_cubit.dart';
import 'package:health_app/cubits/specializations_cubit/specializations_state.dart';
import 'package:health_app/models/specializations_model.dart';
import 'package:health_app/pages/all_doctors_basedOn_specialization.dart';
import 'package:health_app/widgets/CustomSpecializationsContainer.dart';

class SpecializationsPage extends StatelessWidget {
  static const id = '/Specializations';

  const SpecializationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Column(
        children: [
          SizedBox(height: 15),
          Text('All Specializations'),
        ],
      )),
      body: BlocProvider(
        create: (context) => SpecializationsCubit(DioConsumer(dio: Dio()))
          ..getAllSpecializations(),
        child: BlocBuilder<SpecializationsCubit, SpecialityState>(
          builder: (context, state) {
            if (state is SpecialityLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SpecialitySuccess) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.specializations.length,
                  itemBuilder: (context, index) {
                    final SpecializationModel specialization =
                        state.specializations[index];
                    return SpecializationContainer(
                      imagePath: 'assets/images/heart.png',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AllDoctorsBasedOnSpecialization.id,
                          arguments: {
                            'specializationId': specialization.id,
                            'specializationName': specialization.name
                          },
                        );
                      },
                      title: specialization.name,
                    );
                  },
                ),
              );
            } else if (state is SpecialityFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return const Center(child: Text("No specializations available"));
          },
        ),
      ),
    );
  }
}
