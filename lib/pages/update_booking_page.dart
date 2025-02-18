import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/cubits/booking_cubit/booking_cubit_cubit.dart';

class UpdateBookingPage extends StatefulWidget {
  static const String id = '/update-booking';

  const UpdateBookingPage({super.key});

  @override
  _UpdateBookingPageState createState() => _UpdateBookingPageState();
}

class _UpdateBookingPageState extends State<UpdateBookingPage> {
  late int bookingId;
  late int doctorId;
  String? _selectedDay;
  String? _selectedTime;
  Map<String, List<String>> availableSlots = {};
  List<String> allTimes = [];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final Object? args = ModalRoute.of(context)?.settings.arguments;
      final Map<String, dynamic> arguments =
          (args is Map<String, dynamic>) ? args : {};

      bookingId = arguments["bookingId"] ?? 0;
      doctorId = arguments["doctorId"] ?? 0;

      _fetchAvailableSlots();
    });
  }

  void _fetchAvailableSlots() {
    context.read<BookingCubit>().getAvailableSlots(doctorId: doctorId);
  }

  void _updateBooking() {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a day")),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a time")),
      );
      return;
    }

    context.read<BookingCubit>().updateBooking(
          bookingId: bookingId,
          day: _selectedDay!,
          time: _selectedTime!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Booking"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            BlocProvider.of<BookingCubit>(context)
                .getAllBookings(patientId: CacheHelper().getData(key: "id"));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocConsumer<BookingCubit, BookingCubitState>(
              listener: (context, state) {
                if (state is BookingCubitSuccessUpdate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  Navigator.pop(context);
                  BlocProvider.of<BookingCubit>(context).getAllBookings(
                      patientId: CacheHelper().getData(key: "id"));
                } else if (state is BookingCubitError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errormessage)),
                  );
                } else if (state is BookingCubitSuccess) {
                  setState(() {
                    availableSlots.clear();
                    allTimes.clear();

                    for (var slot in state.timeslots) {
                      if (availableSlots.containsKey(slot.day)) {
                        availableSlots[slot.day]!.add(slot.formattedTime);
                      } else {
                        availableSlots[slot.day] = [slot.formattedTime];
                      }
                      allTimes.add(slot.formattedTime);
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is BookingCubitLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select a Day:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select a Day"),
                      value: _selectedDay,
                      items: availableSlots.keys.map((String day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDay = newValue;
                          _selectedTime = null;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text("Select a Time:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Select a Time"),
                      value: _selectedTime,
                      items: (_selectedDay == null
                              ? allTimes
                              : availableSlots[_selectedDay!] ?? [])
                          .map((String time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTime = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 35),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateBooking,
                        child: const Text("Update Booking"),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
