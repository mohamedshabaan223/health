import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/doctors_cubit/doctor_cubit.dart';
import 'package:health_app/widgets/first_screen_in_doctor_app_doctor_info.dart';

class HomePageDoctor extends StatefulWidget {
  const HomePageDoctor({super.key});
  static const String id = '/home_page_doctor';
  @override
  State<HomePageDoctor> createState() => _HomePageDoctorState();
}

class _HomePageDoctorState extends State<HomePageDoctor> {
  @override
  void initState() {
    super.initState();
    final doctorCubit = context.read<DoctorCubit>();
    final doctorId = CacheHelper().getData(key: 'id');
    if (doctorCubit.state is! GetDoctorInfoSuccess && doctorId != null) {
      doctorCubit.getDoctorById(doctorId: doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<DoctorCubit, DoctorState>(
          builder: (context, state) {
            if (state is GetDoctorInfoLoading) {
              return SizedBox(
                height: height * 0.7,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            if (state is GetDoctorInfoFailure) {
              return Center(
                child: Text(
                  "Error: ${state.errorMessage}",
                  style: TextStyle(color: Colors.red, fontSize: width * 0.05),
                ),
              );
            }
            if (state is GetDoctorInfoSuccess) {
              final doctor = state.doctorInfo;
              List<Map<String, dynamic>> availableSlots =
                  doctor.availableSlots.map((slot) => slot.toJson()).toList();
              Map<String, List<Map<String, dynamic>>> groupedByDay = {};
              for (var slot in availableSlots) {
                String day = slot["day"];
                if (!groupedByDay.containsKey(day)) {
                  groupedByDay[day] = [];
                }
                groupedByDay[day]!.add(slot);
              }
              return first_screen_in_doctor_app_doctor_info(
                groupedByDay: groupedByDay,
                getDoctorInfoById: doctor,
              );
            }
            return SizedBox(
              height: height * 0.7,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
