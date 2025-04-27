import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:health_app/cache/cache_helper.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/Appointment_display_doctor_data.dart';
import 'package:health_app/models/all_appointment_paient_for_doctor.dart';
import 'package:health_app/models/booking_details_model.dart';
import 'package:health_app/models/booking_model.dart';
import 'package:health_app/models/canceled_booking_model.dart';
import 'package:health_app/models/get_all_booking_model.dart';
import 'package:meta/meta.dart';
import 'dart:developer';

part 'booking_cubit_state.dart';

class BookingCubit extends Cubit<BookingCubitState> {
  final ApiConsumer api;
  BookingCubit(this.api) : super(BookingCubitInitial());
  List<GetAllBooking> bookings = [];
  List<CanceledBookingModel> canceledBookings = [];

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
          log("No available slots for this date.");
        } else {
          emit(BookingCubitSuccess(slots));
          log("Available slots: $slots");
        }
      } else {
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException {
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
    } on FormatException {
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
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/AllBookingByPatientId?patientId=$patientId',
      );

      final List<dynamic> decodedResponse =
          response is String ? jsonDecode(response) : response;

      final List<GetAllBooking> bookings = decodedResponse
          .map((item) => GetAllBooking.fromJson(item as Map<String, dynamic>))
          .toList();

      if (bookings.isEmpty) {
        emit(BookingCubitGetAllError("لا توجد حجوزات متاحة."));
      } else {
        this.bookings = bookings;
        emit(BookingCubitGetAllSuccess(bookings));
      }
    } on FormatException {
      emit(BookingCubitGetAllError("خطأ في تنسيق البيانات المستلمة."));
    } catch (e) {
      emit(BookingCubitGetAllError("حدث خطأ غير متوقع: $e"));
    }
  }

  Future<void> updateBooking({
    required int bookingId,
    required String day,
    required String time,
  }) async {
    try {
      emit(BookingCubitLoading());

      final response = await api.put(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/UpdateBooking?bookingId=$bookingId',
        data: jsonEncode({
          "dto": {
            "day": day,
            "time": time,
          }
        }),
      );

      final String responseData = response;

      if (responseData == 'Booking updated successfully') {
        emit(BookingCubitSuccessUpdate(responseData));
        final patientId = CacheHelper().getData(key: 'id');
        if (patientId != null) {
          await getAllBookings(patientId: patientId);
        }
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

  Future<void> getDoctorCompletedBookings({required int doctorId}) async {
    try {
      emit(BookingDoctorCompletedLoading());

      final response = await api.get(
        'http://10.0.2.2:5282/api/Booking/doctor/$doctorId/completed-bookings',
      );

      final dynamic decodedResponse =
          response is String ? jsonDecode(response) : response;

      if (decodedResponse is List) {
        final List<AllAppointmentsPatientForDoctor> bookings = decodedResponse
            .map((json) => AllAppointmentsPatientForDoctor.fromJson(
                json as Map<String, dynamic>))
            .toList();

        if (bookings.isEmpty) {
          emit(BookingDoctorCompletedError("No completed bookings found."));
        } else {
          emit(BookingDoctorCompletedSuccess(bookings));
        }
      } else {
        emit(BookingDoctorCompletedError("Unexpected response format."));
      }
    } on FormatException {
      emit(BookingDoctorCompletedError("Invalid response format."));
    } on ServerException catch (e) {
      emit(BookingDoctorCompletedError(e.errorModel.errorMessage));
    } catch (e) {
      emit(BookingDoctorCompletedError("Unexpected error occurred: $e"));
    }
  }

  Future<void> getBookingDetails({required int bookingId}) async {
    try {
      emit(BookingCubitLoading());

      final response = await api.get(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/GetBookingDetails?bookingId=$bookingId',
      );

      final dynamic decodedResponse =
          response is String ? jsonDecode(response) : response;

      if (decodedResponse is Map<String, dynamic>) {
        final bookingDetails = BookingDetailsModel.fromJson(decodedResponse);

        emit(BookingCubitBookingDetailsSuccess(bookingDetails));
      } else {
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException {
      emit(BookingCubitError("Invalid response format"));
    } on ServerException catch (e) {
      emit(BookingCubitError(e.errorModel.errorMessage));
    } catch (e) {
      emit(BookingCubitError("Unexpected error occurred: $e"));
    }
  }

  Future<void> cancelAppointment({required int id}) async {
    try {
      emit(BookingCubitLoading());
      final response = await api.delete(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/CancelAppointment?id=$id',
      );
      final dynamic decoded =
          response is String ? jsonDecode(response) : response;
      if (decoded is Map<String, dynamic> && decoded.containsKey('message')) {
        final message = decoded['message'] as String;
        emit(BookingCubitCancelSuccess(message));
      } else {
        emit(BookingCubitError('Unexpected response format'));
      }
    } on ServerException catch (e) {
      emit(BookingCubitError(e.errorModel.errorMessage));
    } catch (e) {
      emit(BookingCubitError('Unexpected error occurred: $e'));
    }
  }

  Future<void> getAllCanceledBookings({required int patientId}) async {
    try {
      emit(BookingCubitLoading());

      final response = await api.get(
        'http://10.0.2.2:5282/api/Booking/Api/V1/Booking/GetCanceledBookings?patientId=$patientId',
      );

      final List<dynamic> decodedResponse =
          response is String ? jsonDecode(response) : response;

      final List<CanceledBookingModel> bookings = decodedResponse
          .map((item) =>
              CanceledBookingModel.fromJson(item as Map<String, dynamic>))
          .toList();

      if (bookings.isEmpty) {
        emit(BookingCubitAllCanceledEmpty("لا توجد حجوزات ملغية."));
      } else {
        this.canceledBookings = bookings;
        emit(BookingCubitAllCanceledSuccess(bookings));
      }
    } on FormatException {
      emit(BookingCubitError("خطأ في تنسيق البيانات المستلمة."));
    } catch (e) {
      emit(BookingCubitError("حدث خطأ غير متوقع: $e"));
    }
  }

  void resetState() {
    emit(BookingCubitInitial());
  }
}
