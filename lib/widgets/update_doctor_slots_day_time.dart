import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:intl/intl.dart';

class UpdateDoctorSlotsDayTime extends StatefulWidget {
  final String doctorName;
  static const String id = "/update_doctor_slot_day_time";
  const UpdateDoctorSlotsDayTime({super.key, required this.doctorName});

  @override
  State<UpdateDoctorSlotsDayTime> createState() =>
      _UpdateDoctorSlotsDayTimeState();
}

class _UpdateDoctorSlotsDayTimeState extends State<UpdateDoctorSlotsDayTime> {
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormate = DateFormat('dd/MM/yyyy');
  Map<String, List<Map<String, String>>> daysSlots = {};
  int? selectedIndex;
  String? selectedStartTime;
  String? selectedEndTime;

  @override
  void initState() {
    super.initState();
    daysSlots[dateFormate.format(selectedDate)] = [];
    _getAvailableSlots();
  }

  void _getAvailableSlots() {
    final doctorId = CacheHelper().getData(key: 'id');
    context.read<BookingCubit>().getAvailableSlots(doctorId: doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingCubitState>(
      listener: (context, state) {
        if (state is BookingCubitSuccess) {
          setState(() {
            String formattedDate = dateFormate.format(selectedDate);
            List<Map<String, String>> availableSlots = state.timeslots
                .where((slot) =>
                    dateFormate.format(DateTime.parse(slot.day)) ==
                    formattedDate)
                .map((slot) => {
                      'timeStart': slot.timeStart,
                      'timeEnd': slot.timeEnd,
                      'appointmentId': slot.appointmentId.toString(),
                    })
                .toList();

            if (availableSlots.isNotEmpty) {
              daysSlots[formattedDate] = availableSlots;
            } else {
              daysSlots[formattedDate] = [];
            }
          });
        }
        if (state is BookingCubitError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errormessage),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: Column(
        children: [
          const Row(children: [
            Text('Schedule',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black))
          ]),
          Container(
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 219, 253, 239),
              border: Border.all(color: Colors.grey.shade300),
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
                    String formattedDate = dateFormate.format(selectedDate);
                    if (!daysSlots.containsKey(formattedDate)) {
                      daysSlots[formattedDate] = [];
                    }
                  });
                  _getAvailableSlots();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: AppTheme.green),
                  const SizedBox(width: 10),
                  Text(
                    dateFormate.format(selectedDate),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Slots for ${dateFormate.format(selectedDate)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFF58CFA4)),
                onPressed: () {
                  _showTimePicker();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (daysSlots[dateFormate.format(selectedDate)] != null &&
              daysSlots[dateFormate.format(selectedDate)]!.isNotEmpty)
            GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                daysSlots[dateFormate.format(selectedDate)]?.length ?? 0,
                (index) {
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
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: selectedIndex == index
                          ? AppTheme.white
                          : AppTheme.green,
                    ),
                    child: Text(
                      '${daysSlots[dateFormate.format(selectedDate)]![index]['timeStart']} - ${daysSlots[dateFormate.format(selectedDate)]![index]['timeEnd']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index
                            ? const Color.fromARGB(255, 2, 58, 37)
                            : AppTheme.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (daysSlots[dateFormate.format(selectedDate)] == null ||
              daysSlots[dateFormate.format(selectedDate)]!.isEmpty)
            Center(
              child: Text(
                'No available slots for ${dateFormate.format(selectedDate)}. Please add new slots.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 170, 39, 36),
                ),
              ),
            ),
          const SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.red.shade600, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'To delete a slot, long-press on it.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTimePicker() async {
    TextEditingController startTimeController =
        TextEditingController(text: selectedStartTime);
    TextEditingController endTimeController =
        TextEditingController(text: selectedEndTime);
    TextEditingController priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Edit Slot Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.green,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Start Time', style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: startTimeController,
                onTap: () async {
                  TimeOfDay? pickedStartTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedStartTime != null) {
                    final now = DateTime.now();
                    final startDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedStartTime.hour,
                      pickedStartTime.minute,
                    );
                    setState(() {
                      selectedStartTime =
                          DateFormat('hh:mm a').format(startDateTime);
                      startTimeController.text = selectedStartTime!;
                    });
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                  hintText: selectedStartTime ?? 'Select Start Time',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('End Time', style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: endTimeController,
                onTap: () async {
                  TimeOfDay? pickedEndTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedEndTime != null) {
                    final now = DateTime.now();
                    final endDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedEndTime.hour,
                      pickedEndTime.minute,
                    );
                    setState(() {
                      selectedEndTime =
                          DateFormat('hh:mm a').format(endDateTime);
                      endTimeController.text = selectedEndTime!;
                    });
                  }
                },
                readOnly: true,
                decoration: InputDecoration(
                  hintText: selectedEndTime ?? 'Select End Time',
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                  suffixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Price Field
              const Text('Price', style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: 'Enter Price',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (selectedStartTime != null &&
                      selectedEndTime != null &&
                      priceController.text.isNotEmpty) {
                    String formattedDate = dateFormate.format(selectedDate);

                    if (daysSlots[formattedDate]!.any(
                        (slot) => slot['timeStart'] == selectedStartTime)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This slot already exists.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      setState(() {
                        daysSlots[formattedDate]!.add({
                          'timeStart': selectedStartTime!,
                          'timeEnd': selectedEndTime!,
                          'appointmentId': priceController.text,
                        });
                      });
                      Navigator.of(context).pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(double.infinity, 40),
                ),
                child: const Text('Add Slot'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteSlot(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Slot'),
          content: const Text('Are you sure you want to delete this slot?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  daysSlots[dateFormate.format(selectedDate)]!.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
