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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      bookingId = args['bookingId'];
      doctorId = args['doctorId'];
      context.read<BookingCubit>().getAvailableSlots(doctorId: doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingCubitState>(
      listener: (context, state) {
        if (state is BookingCubitSuccess) {
          Map<String, List<String>> slotsMap = {};
          for (var slot in state.timeslots) {
            slotsMap.putIfAbsent(slot.day, () => []).add(slot.timeStart);
          }

          setState(() {
            availableSlots = slotsMap;
            allTimes = slotsMap.values
                .expand((e) => e)
                .toSet()
                .toList(); // تفادي التكرار هنا
          });
        } else if (state is BookingCubitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errormessage)),
          );
        } else if (state is BookingCubitSuccessUpdate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Booking updated successfully")),
          );
          Future.delayed(const Duration(microseconds: 1), () {
            Navigator.pop(context);
            BlocProvider.of<BookingCubit>(context).getAllBookings(
              patientId: CacheHelper().getData(key: "id"),
            );
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Column(
              children: [
                SizedBox(height: 15),
                Text("Update Booking", textAlign: TextAlign.start),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
                BlocProvider.of<BookingCubit>(context).getAllBookings(
                  patientId: CacheHelper().getData(key: "id"),
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                const Text(
                  "Select a Day:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                const Text(
                  "Select a Time:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select a Time"),
                  value: _selectedTime,
                  items: (_selectedDay == null
                          ? allTimes
                          : (availableSlots[_selectedDay!] ?? []))
                      .toSet() // ← تفادي التكرار هنا
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
                    onPressed: () {
                      if (_selectedDay != null && _selectedTime != null) {
                        context.read<BookingCubit>().updateBooking(
                              bookingId: bookingId,
                              day: _selectedDay!,
                              time: _selectedTime!,
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select day and time"),
                          ),
                        );
                      }
                    },
                    child: const Text("Update Booking"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
