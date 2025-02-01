import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:health_app/pages/your_appoinment.dart';
import 'package:health_app/widgets/CustomButtomNavigationBar.dart';
import 'package:health_app/widgets/default_textformfield.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  static const String id = '/appointment_screen';

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  int selectedDayIndex = 2; // Default selected day
  int selectedTimeIndex = 2; // Default selected time
  String selectedPatientType = 'Yourself';
  String selectedGender = 'Female';
  int? age;
  String? fullName;

  final List<String> days = ["22", "23", "24", "25", "26", "27"];
  final List<String> weekdays = ["MON", "TUE", "WED", "THU", "FRI", "SAT"];
  final List<String> times = [
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 M",
    "12:30 M",
    "1:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 25,
                      color: AppTheme.green,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildInfoContainer(
                      text: 'Dr. Alexander Bennett, Ph.D.', width: 215),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(YourAppoinment.id);
                      },
                      child: _buildInfoContainer(text: 'Done', width: 60)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: AppTheme.gray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Days"),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: days.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedDayIndex = index),
                              child: _buildDateTile(
                                day: days[index],
                                weekday: weekdays[index],
                                isSelected: selectedDayIndex == index,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Available Time"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(times.length, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedTimeIndex = index),
                    child: _buildTimeTile(
                      time: times[index],
                      isSelected: selectedTimeIndex == index,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: AppTheme.green2,
              ),
              const SizedBox(height: 10),
              _buildSectionTitle("Patient Details"),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildOptionButton(
                      'Yourself',
                      selectedPatientType == 'Yourself',
                      () => setState(() => selectedPatientType = 'Yourself')),
                  const SizedBox(width: 10),
                  _buildOptionButton(
                      'Another Person',
                      selectedPatientType == 'Another Person',
                      () => setState(
                          () => selectedPatientType = 'Another Person')),
                ],
              ),
              const SizedBox(height: 20),
              DefaultTextformfield(
                hint: 'full name',
                controller: BlocProvider.of<AuthCubit>(context).patientName,
                onChanged: (data) {
                  fullName = data;
                },
              ),
              const SizedBox(height: 15),
              DefaultTextformfield(
                hint: 'Age',
                controller: BlocProvider.of<AuthCubit>(context).age,
                onChanged: (data) {
                  fullName = data;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Gender"),
              const SizedBox(height: 8),
              Row(
                children: ['Male', 'Female']
                    .map((gender) => _buildOptionButton(
                        gender,
                        selectedGender == gender,
                        () => setState(() => selectedGender = gender)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Divider(
                color: AppTheme.green2,
              ),
              const SizedBox(height: 10),
              _buildSectionTitle("Describe Your Problem"),
              const SizedBox(height: 10),
              TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your problem here...',
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomButtomNavigationBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.green2),
    );
  }

  Widget _buildDateTile(
      {required String day,
      required String weekday,
      required bool isSelected}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 55,
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.green3 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: AppTheme.green3.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4)
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected ? AppTheme.white : AppTheme.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            weekday,
            style: TextStyle(
                color: isSelected ? AppTheme.white : Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer({
    required String text,
    required double width,
  }) {
    return Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        color: AppTheme.green3,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTile({required String time, required bool isSelected}) {
    return Container(
      width: 112,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.green3 : AppTheme.gray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isSelected ? AppTheme.green3 : Colors.grey.shade300),
      ),
      child: Text(
        time,
        style: TextStyle(
          color: isSelected ? AppTheme.white : AppTheme.black,
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
          color: isSelected ? AppTheme.green3 : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppTheme.white : AppTheme.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    int maxLines = 3,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
