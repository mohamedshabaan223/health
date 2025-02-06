import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/Appointment_display_doctor_data.dart';
import 'package:meta/meta.dart';

part 'booking_cubit_state.dart';

class BookingCubit extends Cubit<BookingCubitState> {
  final ApiConsumer api;
  BookingCubit(this.api) : super(BookingCubitInitial());

  Future<void> getAvailableSlots({required int doctorId}) async {
    try {
      emit(BookingCubitLoading());
      final response = await api.get(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/GetAvailableSlots?doctorId=$doctorId',
      );
      final dynamic decodedResponse;
      if (response is String) {
        decodedResponse = jsonDecode(response);
      } else {
        decodedResponse = response;
      }
      print("Decoded Response type: ${decodedResponse.runtimeType}");
      if (decodedResponse is List) {
        final List<AppointmentDisplayDoctorData> slots = decodedResponse
            .map((json) => AppointmentDisplayDoctorData.fromJson(
                json as Map<String, dynamic>))
            .toList();
        if (slots.isEmpty) {
          emit(BookingCubitError("No available slots for this date."));
        } else {
          emit(BookingCubitSuccess(slots));
        }
      } else {
        print("Unexpected response format: $decodedResponse");
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException catch (e) {
      print("JSON Decode Error: $e");
      emit(BookingCubitError("Invalid response format"));
    } on ServerException catch (e) {
      if (e.errorModel.status == 404) {
        emit(BookingCubitError("No available slots for this date."));
      } else {
        emit(BookingCubitError(e.errorModel.errorMessage));
      }
    } catch (e) {
      print("Unexpected error in getAvailableSlots: $e");
      emit(BookingCubitError("Unexpected error occurred: $e"));
    }
  }

  Future<void> getAllBookings(
      {required int patientId, required int status}) async {
    try {
      emit(BookingCubitLoading());

      final response = await api.get(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/GetAllBooking?PatientId=$patientId&Status=$status',
      );
      final dynamic decodedResponse;
      if (response is String) {
        decodedResponse = jsonDecode(response);
      } else {
        decodedResponse = response;
      }
      print("Decoded Response type: \${decodedResponse.runtimeType}");
      if (decodedResponse is List) {
        final List<AppointmentDisplayDoctorData> bookings = decodedResponse
            .map((json) => AppointmentDisplayDoctorData.fromJson(
                json as Map<String, dynamic>))
            .toList();
        if (bookings.isEmpty) {
          emit(BookingCubitError(
              "No completed or cancelled appointments found."));
        } else {
          emit(BookingCubitSuccess(bookings));
        }
      } else {
        print("Unexpected response format: \$decodedResponse");
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException catch (e) {
      print("JSON Decode Error: \$e");
      emit(BookingCubitError("Invalid response format"));
    } on ServerException catch (e) {
      emit(BookingCubitError(e.errorModel.errorMessage));
    } catch (e) {
      print("Unexpected error in getAllBookings: \$e");
      emit(BookingCubitError("Unexpected error occurred: \$e"));
    }
  }
}
