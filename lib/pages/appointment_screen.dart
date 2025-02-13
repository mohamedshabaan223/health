import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/end_points.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/models/Appointment_display_doctor_data.dart';
import 'package:health_app/models/booking_model.dart';
import 'package:health_app/pages/your_appoinment.dart';
import 'package:health_app/widgets/default_textformfield.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  static const String id = '/appointment_screen';

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int selectedDayIndex = 0;
  int selectedTimeIndex = -1;
  String selectedPatientType = 'Yourself';
  String selectedGender = 'Female';
  String? fullName;
  int? age;
  int? doctorId;
  int? patientId = CacheHelper().getData(key: ApiKey.id);
  String? problemDescription;
  List<AppointmentDisplayDoctorData> availableSlots = [];

  final TextEditingController ageController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fullNameController.text =
        BlocProvider.of<AuthCubit>(context).patientName.text;
  }

  void _updatePatientName() {
    if (selectedPatientType == 'Yourself') {
      setState(() {
        fullNameController.text =
            BlocProvider.of<AuthCubit>(context).patientName.text;
      });
    } else {
      setState(() {
        fullNameController.clear();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      doctorId = args;
      if (doctorId != null) {
        BlocProvider.of<BookingCubit>(context)
            .getAvailableSlots(doctorId: doctorId!);
      }
    }
  }

  void _onBookingPressed() {
    if (selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an available time!')),
      );
      return;
    }
    if (ageController.text.isEmpty || problemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both Age and Problem Description!')),
      );
      return;
    }
    final bookingRequest = BookingRequest(
      doctorId: doctorId!,
      day: availableSlots[selectedDayIndex].day,
      time: availableSlots[selectedTimeIndex].time,
      patientName: selectedPatientType == 'Yourself'
          ? BlocProvider.of<AuthCubit>(context).patientName.text
          : fullNameController.text ?? "Unknown",
      gender: selectedGender,
      age: int.tryParse(ageController.text) ?? 0,
      forHimSelf: selectedPatientType == 'Yourself',
      patientId: patientId ?? 0,
      problemDescription: problemController.text,
    );

    BlocProvider.of<BookingCubit>(context).bookAppointment(
      bookingRequest,
      BlocProvider.of<AuthCubit>(context).patientName.text,
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingCubitState>(
      listener: (context, state) {
        if (state is BookingCubitDataSuccess) {
          Navigator.of(context).pushNamed(
            YourAppoinment.id,
            arguments: {
              "bookingId": state.bookingResponse.bookingId,
              "doctorId": doctorId,
              "day": availableSlots[selectedDayIndex].day,
              "time": availableSlots[selectedTimeIndex].time,
              "patientName": selectedPatientType == 'Yourself'
                  ? BlocProvider.of<AuthCubit>(context).registerUserName.text
                  : fullNameController.text ?? "Unknown",
              "gender": selectedGender,
              "age": int.tryParse(ageController.text) ?? 0,
              "forHimSelf": selectedPatientType == 'Yourself',
              "patientId": patientId ?? 0,
              "problemDescription": problemController.text,
            },
          );
        } else if (state is BookingCubitDataError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.green),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Booking',
                style: TextStyle(color: AppTheme.green),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Select Day"),
                const SizedBox(height: 10),
                _buildDaysSection(),
                const SizedBox(height: 20),
                _buildSectionTitle("Available Time"),
                const SizedBox(height: 10),
                _buildTimesSection(),
                const SizedBox(height: 20),
                const Divider(color: AppTheme.green2),
                const SizedBox(height: 10),
                _buildSectionTitle("Patient Details"),
                const SizedBox(height: 15),
                _buildPatientDetailsSection(),
                const SizedBox(height: 20),
                const Divider(color: AppTheme.green2),
                const SizedBox(height: 10),
                _buildSectionTitle("Describe Your Problem"),
                const SizedBox(height: 10),
                _buildProblemDescriptionField(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysSection() {
    return BlocBuilder<BookingCubit, BookingCubitState>(
      builder: (context, state) {
        if (state is BookingCubitLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookingCubitError) {
          return Center(child: Text(state.errormessage));
        } else if (state is BookingCubitSuccess) {
          availableSlots = state.timeslots;
          return SizedBox(
            height: 85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final slot = availableSlots[index];
                return GestureDetector(
                  onTap: () => setState(() {
                    selectedDayIndex = index;
                    selectedTimeIndex = -1;
                  }),
                  child: _buildDateTile(
                    day: slot.day,
                    weekday: slot.weekday,
                    isSelected: selectedDayIndex == index,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildTimesSection() {
    return BlocBuilder<BookingCubit, BookingCubitState>(
      builder: (context, state) {
        if (state is BookingCubitSuccess) {
          final times = state.timeslots;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(times.length, (index) {
              return GestureDetector(
                onTap: () => setState(() => selectedTimeIndex = index),
                child: _buildTimeTile(
                  time: times[index].formattedTime,
                  isSelected: selectedTimeIndex == index,
                ),
              );
            }),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildPatientDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildOptionButton(
              'Yourself',
              selectedPatientType == 'Yourself',
              () {
                setState(() {
                  selectedPatientType = 'Yourself';
                  _updatePatientName();
                });
              },
            ),
            const SizedBox(width: 10),
            _buildOptionButton(
              'Another Person',
              selectedPatientType == 'Another Person',
              () {
                setState(() {
                  selectedPatientType = 'Another Person';
                  _updatePatientName();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        DefaultTextformfield(
          hint: 'Full Name',
          controller: fullNameController,
          enabled: selectedPatientType != 'Yourself',
          onChanged: (value) => fullName = value,
        ),
        const SizedBox(height: 15),
        DefaultTextformfield(
          hint: 'Age',
          controller: ageController,
          onChanged: (value) => age = int.tryParse(value),
        ),
        const SizedBox(height: 15),
        _buildSectionTitle("Gender"),
        const SizedBox(height: 10),
        Row(
          children: ['Male', 'Female']
              .map((gender) => _buildOptionButton(
                    gender,
                    selectedGender == gender,
                    () => setState(() => selectedGender = gender),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildProblemDescriptionField() {
    return TextField(
      controller: problemController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Describe your problem...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: AppTheme.green,
        ),
        onPressed: _onBookingPressed,
        child: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppTheme.green2,
    ),
  );
}

Widget _buildDateTile({
  required String day,
  required String weekday,
  required bool isSelected,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    width: 60,
    decoration: BoxDecoration(
      color: isSelected ? AppTheme.green3 : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: AppTheme.green3.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ]
          : [],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          weekday,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTimeTile({required String time, required bool isSelected}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: isSelected ? AppTheme.green3 : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected ? AppTheme.green3 : Colors.grey.shade300,
      ),
    ),
    child: Text(
      time,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildOptionButton(String text, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.green3 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
