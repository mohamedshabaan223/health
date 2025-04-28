import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/app_theme.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';
import 'package:health_app/cubits/appointment_cubit/appointment_cubit.dart';
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
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  Map<String, List<Map<String, String>>> daysSlots = {};
  int? selectedIndex;
  String? selectedStartTime;
  String? selectedEndTime;
  int? selectedAppointmentId;

  @override
  void initState() {
    super.initState();
    daysSlots[dateFormat.format(selectedDate)] = [];
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
            String formattedDate = dateFormat.format(selectedDate);
            List<Map<String, String>> availableSlots = state.timeslots
                .where((slot) =>
                    dateFormat.format(DateTime.parse(slot.day)) ==
                    formattedDate)
                .map((slot) => {
                      'timeStart': slot.timeStart,
                      'timeEnd': slot.timeEnd,
                      'appointmentId': slot.appointmentId.toString(),
                    })
                .toList();
            daysSlots[formattedDate] = availableSlots;
          });
        }
        if (state is BookingCubitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errormessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocListener<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentSuccess) {
            setState(() {
              _getAvailableSlots();
            });
          }
          if (state is AppointmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Row(children: [
                Text(
                  'Schedule',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                )
              ]),
              const SizedBox(height: 10),
              _buildDatePicker(context),
              const SizedBox(height: 20),
              _buildSlotsSection(),
              const SizedBox(height: 20),
              _buildDeleteInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
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
              String formattedDate = dateFormat.format(selectedDate);
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
              dateFormat.format(selectedDate),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotsSection() {
    String formattedDate = dateFormat.format(selectedDate);
    List<Map<String, String>> slots = daysSlots[formattedDate] ?? [];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Slots for $formattedDate',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF58CFA4)),
              onPressed: _showTimePicker,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (slots.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            itemCount: slots.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = index;
                    selectedAppointmentId =
                        int.tryParse(slots[index]['appointmentId'] ?? '0');
                    print('Selected Appointment ID: $selectedAppointmentId');
                  });
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Slot'),
                        content: const Text(
                            'Are you sure you want to delete this slot?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final appointmentId =
                                  slots[index]['appointmentId']!;
                              context
                                  .read<AppointmentCubit>()
                                  .removeAppointmentSlot(
                                    appointmentId: int.parse(appointmentId),
                                  )
                                  .then((_) {
                                // تحديث المواعيد بعد الحذف
                                _getAvailableSlots();
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Slot deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
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
                  backgroundColor:
                      selectedIndex == index ? AppTheme.white : AppTheme.green,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${slots[index]['timeStart']} ------------ ${slots[index]['timeEnd']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index
                            ? const Color.fromARGB(255, 2, 58, 37)
                            : AppTheme.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        else
          Center(
            child: Text(
              'No available slots for $formattedDate. Please add new slots.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 170, 39, 36),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteInfo() {
    return Row(
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
    );
  }

  void _showTimePicker() {
    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Add New Slot',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.green),
                ),
              ),
              const SizedBox(height: 10),
              _buildTimeField('Start Time', startTimeController, (pickedTime) {
                selectedStartTime = pickedTime;
              }),
              const SizedBox(height: 10),
              _buildTimeField('End Time', endTimeController, (pickedTime) {
                selectedEndTime = pickedTime;
              }),
              const SizedBox(height: 10),
              const Text('Price', style: TextStyle(fontSize: 17)),
              TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter Price',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15))))),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedStartTime != null &&
                      selectedEndTime != null &&
                      priceController.text.isNotEmpty) {
                    final doctorId = CacheHelper().getData(key: 'id');
                    final appointmentCubit = context.read<AppointmentCubit>();
                    String selectedDateString =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                    List<Map<String, String>> slots =
                        daysSlots[selectedDateString] ?? [];
                    bool slotExists = slots.any((slot) =>
                        slot['timeStart'] == selectedStartTime &&
                        slot['timeEnd'] == selectedEndTime);

                    if (slotExists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('The selected time slot already exists.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    } else {
                      try {
                        double price = double.parse(priceController.text);
                        appointmentCubit.addNewAppointmentSlot(
                          doctorId: doctorId,
                          name: CacheHelper().getData(key: 'name'),
                          day: selectedDateString,
                          timeStart: selectedStartTime!,
                          timeEnd: selectedEndTime!,
                          price: price,
                        );
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          _getAvailableSlots();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid price entered.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please complete all fields.'),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Slot'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller,
      Function(String) onPicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 17)),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            hintText: 'Enter time in HH:mm:ss format',
            suffixIcon: const Icon(Icons.access_time),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onChanged: (value) {
            final timePattern = RegExp(r'^[0-2]?[0-9]:[0-5][0-9]:[0-5][0-9]$');
            if (timePattern.hasMatch(value)) {
              onPicked(value);
            }
          },
        ),
      ],
    );
  }
}
