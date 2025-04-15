import 'package:flutter/material.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/widgets/default_textField.dart';
import 'package:health_app/widgets/image_profile.dart';
import 'package:intl/intl.dart';

class DoctorUpdateProfile extends StatefulWidget {
  const DoctorUpdateProfile({super.key});
  static const String id = '/doctor_update_profile';

  @override
  State<DoctorUpdateProfile> createState() => _DoctorUpdateProfileState();
}

class _DoctorUpdateProfileState extends State<DoctorUpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateFormat dateFormate = DateFormat('dd/MM/yyyy');

  List<String> slotsAvailable = [
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: MediaQuery.of(context).size.width * 0.2,
        title: const Column(
          children: [
            SizedBox(height: 15),
            Text(
              'My Profile',
              style: TextStyle(
                color: Color(0xFF58CFA4),
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const Center(child: DoctorImageProfile()),
              const SizedBox(height: 25),
              _buildLabel('Years of experience'),
              DoctorDefaultTextfield(
                  controller: experienceController,
                  typeKeyboard: TextInputType.number),
              const SizedBox(height: 8),
              _buildLabel('Email'),
              DoctorDefaultTextfield(
                  controller: emailController,
                  typeKeyboard: TextInputType.emailAddress),
              const SizedBox(height: 8),
              _buildLabel('Adress'),
              DoctorDefaultTextfield(
                  controller: adressController,
                  typeKeyboard: TextInputType.streetAddress),
              const SizedBox(height: 8),
              _buildLabel('About'),
              DoctorDefaultTextfield(
                  controller: aboutController,
                  typeKeyboard: TextInputType.multiline),
              const SizedBox(height: 8),
              _buildLabel('Price'),
              DoctorDefaultTextfield(
                  controller: priceController,
                  typeKeyboard: TextInputType.number),
              const SizedBox(height: 8),
              _buildLabel('Schedule'),
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: selectedDate,
                      initialEntryMode: DatePickerEntryMode.calendar,
                    );
                    if (dateTime != null) {
                      setState(() {
                        selectedDate = dateTime;
                      });
                    }
                  },
                  child: Text(dateFormate.format(selectedDate)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Slots',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.add_circle, color: Color(0xFF58CFA4)),
                    onPressed: () {
                      _showTimePicker();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 2.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(slotsAvailable.length, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    onLongPress: () {
                      _confirmDeleteSlot(index);
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: selectedIndex == index
                            ? const Color(0xFF58CFA4)
                            : AppTheme.green,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      slotsAvailable[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index
                            ? const Color.fromARGB(255, 2, 58, 37)
                            : AppTheme.white,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Text _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  void _showTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final formattedSlot = DateFormat('hh:mm a').format(dateTime);

      if (slotsAvailable.contains(formattedSlot)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This slot already exists.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          slotsAvailable.add(formattedSlot);
        });
      }
    }
  }

  void _confirmDeleteSlot(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Slot'),
        content:
            Text('Are you sure you want to delete "${slotsAvailable[index]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                slotsAvailable.removeAt(index);
                if (selectedIndex == index) selectedIndex = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
