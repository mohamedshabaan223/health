import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final ApiConsumer api;
  AppointmentCubit(this.api) : super(AppointmentInitial());

  Future<void> addNewAppointmentSlot({
    required int doctorId,
    required String name,
    required String day,
    required String timeStart,
    required String timeEnd,
    required double price,
  }) async {
    try {
      emit(AppointmentLoading());
      final appointmentData = {
        'doctorId': doctorId,
        'name': name,
        'day': day,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'price': price,
      };

      final response = await api.post(
        "http://10.0.2.2:5282/Api/V1/Appointment/AddAppointment",
        data: json.encode(appointmentData),
      );

      if (response != null &&
          response['message'] == 'Appointment added successfully.') {
        emit(AppointmentSuccess('Appointment added successfully.'));
      } else {
        emit(AppointmentFailure('Failed to add appointment.'));
      }
    } on ServerException catch (e) {
      emit(AppointmentFailure('Server error: ${e.errorModel.errorMessage}'));
    } catch (e) {
      emit(AppointmentFailure('Unexpected error occurred: $e'));
    }
  }

  Future<void> removeAppointmentSlot({required int appointmentId}) async {
    try {
      emit(AppointmentLoading());
      final response = await api.delete(
        "http://10.0.2.2:5282/Api/V1/Appointment/RemoveAppointment?appointmentId=$appointmentId",
      );
      if (response != null && response == true) {
        emit(AppointmentDeleted('Appointment removed successfully.'));
      } else {
        emit(AppointmentDeleteFailure(
            'Appointment not found or failed to remove.'));
      }
    } on ServerException catch (e) {
      emit(AppointmentDeleteFailure(
          'Server error: ${e.errorModel.errorMessage}'));
    } catch (e) {
      emit(AppointmentDeleteFailure('Unexpected error occurred: $e'));
    }
  }

  void resetState() {
    emit(AppointmentInitial());
  }
}
