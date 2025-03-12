import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/Appointment_display_doctor_data.dart';
import 'package:health_app/models/booking_model.dart';
import 'package:health_app/models/get_all_booking_model.dart';
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
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException catch (e) {
      emit(BookingCubitError("Invalid response format"));
    } on ServerException catch (e) {
      if (e.errorModel.status == 404) {
        emit(BookingCubitError("No available slots for this date."));
      } else {
        emit(BookingCubitError(e.errorModel.errorMessage));
      }
    } catch (e) {
      emit(BookingCubitError("Unexpected error occurred: $e"));
    }
  }

  Future<void> bookAppointment(
      BookingRequest bookingRequest, String? patientNameFromDB) async {
    try {
      emit(BookingCubitLoading());
      final finalBookingRequest = BookingRequest(
        doctorId: bookingRequest.doctorId,
        day: bookingRequest.day,
        time: bookingRequest.time,
        patientName: bookingRequest.forHimSelf
            ? (patientNameFromDB?.isNotEmpty == true
                ? patientNameFromDB!
                : "Unknown")
            : bookingRequest.patientName,
        gender: bookingRequest.gender,
        age: bookingRequest.age,
        forHimSelf: bookingRequest.forHimSelf,
        patientId: bookingRequest.patientId,
        problemDescription: bookingRequest.problemDescription,
      );

      final response = await api.post(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/BookAppointment',
        data: jsonEncode(finalBookingRequest.toJson()),
      );
      final dynamic decodedResponse =
          response is String ? jsonDecode(response) : response;

      if (decodedResponse is Map<String, dynamic> &&
          decodedResponse.containsKey("message")) {
        final bookingResponse = BookingResponse.fromJson(decodedResponse);
        emit(BookingCubitDataSuccess(bookingResponse));
      } else {
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException catch (e) {
      emit(BookingCubitDataError("Invalid response format"));
    } on ServerException catch (e) {
      emit(BookingCubitDataError(e.errorModel.errorMessage));
    } catch (e) {
      emit(BookingCubitDataError("Unexpected error occurred: $e"));
    }
  }

  Future<void> getAllBookings({required int patientId}) async {
    try {
      emit(BookingCubitLoading());

      final response = await api.get(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/GetAllBooking?patientId=$patientId',
      );

      print("Response from getAllBookings: $response");

      final dynamic decodedResponse =
          response is String ? jsonDecode(response) : response;

      if (decodedResponse is List) {
        final List<GetAllBooking> bookings = decodedResponse
            .map((json) => GetAllBooking.fromJson(json as Map<String, dynamic>))
            .toList();

        print("Parsed bookings: $bookings");

        if (bookings.isEmpty) {
          emit(BookingCubitGetAllError("No bookings found."));
        } else {
          emit(BookingCubitGetAllSuccess(bookings));
        }
      } else {
        emit(BookingCubitGetAllError("Unexpected response format."));
      }
    } on FormatException catch (e) {
      emit(BookingCubitGetAllError("Invalid response format"));
    } catch (e) {
      emit(BookingCubitGetAllError("Unexpected error occurred: $e"));
    }
  }

  Future<void> updateBooking({
    required int bookingId,
    required String day,
    required String time,
  }) async {
    try {
      emit(BookingCubitLoading());
      print("📌 Updating booking with:");
      print("   ➤ bookingId: $bookingId");
      print("   ➤ day: $day");
      print("   ➤ time: $time");

      final response = await api.put(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/UpdateBooking?bookingId=$bookingId',
        data: jsonEncode({
          "dto": {
            "day": day,
            "time": time,
          }
        }),
      );

      final String responseData = response.toString().trim();
      print("✅ Response from updateBooking: $responseData");

      if (responseData == 'Booking updated successfully') {
        emit(BookingCubitSuccessUpdate(responseData));
      } else if (responseData == 'Booking not found') {
        emit(BookingCubitError(responseData));
      } else {
        emit(BookingCubitError("Unexpected response content: $responseData"));
      }
    } on DioException catch (e) {
      emit(BookingCubitError(
          "Request failed: ${e.response?.data ?? e.message}"));
    } catch (e) {
      emit(BookingCubitError("Unexpected error: $e"));
    }
  }

  void resetState() {
    emit(BookingCubitInitial());
  }
}
