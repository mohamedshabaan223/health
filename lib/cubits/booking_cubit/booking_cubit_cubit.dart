import 'dart:convert'; // ✅ لتحليل JSON
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

      print("Raw Response: $response"); // ✅ طباعة الاستجابة الخام للتحقق
      print("Response type: ${response.runtimeType}");

      // ✅ تحويل الاستجابة إلى JSON
      final dynamic decodedResponse;
      if (response is String) {
        decodedResponse = jsonDecode(response);
      } else {
        decodedResponse = response;
      }

      print("Decoded Response type: ${decodedResponse.runtimeType}");

      // ✅ التأكد من أن `decodedResponse` قائمة
      if (decodedResponse is List) {
        final List<AppointmentDisplayDoctorData> slots = decodedResponse
            .map((json) => AppointmentDisplayDoctorData.fromJson(
                json as Map<String, dynamic>))
            .toList();

        if (slots.isEmpty) {
          emit(BookingCubitError("No available slots for this date."));
        } else {
          emit(BookingCubitSuccess(slots)); // ✅ البيانات تم تحميلها بنجاح
        }
      } else {
        print(
            "Unexpected response format: $decodedResponse"); // 🔹 طباعة الاستجابة لمزيد من التحقيق
        emit(BookingCubitError("Unexpected response format"));
      }
    } on FormatException catch (e) {
      print("JSON Decode Error: $e"); // 🔹 طباعة أي خطأ في تحليل JSON
      emit(BookingCubitError("Invalid response format"));
    } on ServerException catch (e) {
      if (e.errorModel.status == 404) {
        emit(BookingCubitError("No available slots for this date."));
      } else {
        emit(BookingCubitError(e.errorModel.errorMessage));
      }
    } catch (e) {
      print(
          "Unexpected error in getAvailableSlots: $e"); // 🔹 طباعة الخطأ الحقيقي
      emit(BookingCubitError("Unexpected error occurred: $e"));
    }
  }
}
