import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/pages/doctor_page.dart';
import 'package:health_app/widgets/container_doctor_info.dart';

class DoctorInformation extends StatefulWidget {
  static const String routeName = '/doctor-info';

  @override
  State<DoctorInformation> createState() => _DoctorInformationState();
}

class _DoctorInformationState extends State<DoctorInformation> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final doctorId = ModalRoute.of(context)?.settings.arguments as int?;
      if (doctorId != null) {
        context.read<DoctorCubit>().getDoctorById(doctorId: doctorId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final doctorId = ModalRoute.of(context)?.settings.arguments as int?;
    if (doctorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No doctor ID provided.')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                if (state is GetDoctorInfoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GetDoctorInfoFailure) {
                  return Center(
                    child: Text(
                      "Error: ${state.errorMessage}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (state is GetDoctorInfoSuccess) {
                  final doctor = state.doctorInfo;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(DoctorPage.routeName);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 25,
                                color: AppTheme.green,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.15,
                            ),
                            Text(
                              'Doctor Information',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ContainerDoctorInfo(doctorId: doctorId),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Text(
                        'Profile',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 20, color: AppTheme.green),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        doctor.focus ?? 'There is no profile.',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                    ],
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text('No doctor information available.'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
