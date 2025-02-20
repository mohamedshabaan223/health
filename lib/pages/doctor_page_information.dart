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
    final size = MediaQuery.of(context).size;
    final doctorId = ModalRoute.of(context)?.settings.arguments;

    if (doctorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No doctor ID provided.')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.02),
          child: SingleChildScrollView(
            child: BlocBuilder<DoctorCubit, DoctorState>(
              builder: (context, state) {
                if (state is GetDoctorInfoLoading) {
                  return SizedBox(
                    height: size.height * 0.7,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is GetDoctorInfoFailure) {
                  return Center(
                    child: Text(
                      "Error: ${state.errorMessage}",
                      style: TextStyle(
                          color: Colors.red, fontSize: size.width * 0.045),
                    ),
                  );
                }
                if (state is GetDoctorInfoSuccess) {
                  final doctor = state.doctorInfo;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop(DoctorPage.routeName);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: size.width * 0.06,
                              color: AppTheme.green,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Doctor Information',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontSize: size.width * 0.05,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      ContainerDoctorInfo(doctorId: doctorId as int),
                      SizedBox(height: size.height * 0.04),
                      Text(
                        'Profile',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: size.width * 0.05,
                                  color: AppTheme.green,
                                ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        doctor.focus ?? 'There is no profile.',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                    ],
                  );
                } else {
                  return SizedBox(
                    height: size.height * 0.7,
                    child: const Center(
                        child: Text('No doctor information available.')),
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
