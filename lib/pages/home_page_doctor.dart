import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/appointment_cubit/appointment_cubit.dart';
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
    _fetchDoctorInfo();
  }

  void _fetchDoctorInfo() {
    final doctorCubit = context.read<DoctorCubit>();
    final doctorId = CacheHelper().getData(key: 'id');
    if (doctorId != null) {
      doctorCubit.getDoctorById(doctorId: doctorId);
    }
  }

  Future<void> _refreshDoctorInfo() async {
    final doctorCubit = context.read<DoctorCubit>();
    final doctorId = CacheHelper().getData(key: 'id');
    if (doctorId != null) {
      await doctorCubit.getDoctorById(doctorId: doctorId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointments updated successfully")),
      );
    }
  }

  void _removeAppointment(int appointmentId) {
    final appointmentCubit = context.read<AppointmentCubit>();
    appointmentCubit.removeAppointmentSlot(appointmentId: appointmentId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment removed successfully")),
    );
    _fetchDoctorInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshDoctorInfo,
          child: BlocBuilder<DoctorCubit, DoctorState>(
            builder: (context, state) {
              if (state is GetDoctorInfoLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetDoctorInfoFailure) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Error: ${state.errorMessage}",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
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
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    FirstScreenInDoctorAppDoctorInfo(
                      groupedByDay: groupedByDay,
                      getDoctorInfoById: doctor,
                      onRemoveAppointment: _removeAppointment,
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
