import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/models/payment_model.dart';
import 'package:health_app/cubits/payment_cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.api) : super(PaymentInitial());

  final ApiConsumer api;

  Future<void> makePayment({required int doctorId}) async {
    try {
      emit(PaymentLoading());
      debugPrint('Request Data: {"doctorId": $doctorId}');

      final response = await api.post(
        'http://10.0.2.2:5282/api/Payment/Pay',
        isFormData: true,
        data: {"doctorId": doctorId},
      );

      if (response is Map<String, dynamic> &&
          response.containsKey("paymentUrl")) {
        final paymentUrl = response['paymentUrl'];

        // Emit success state with the payment URL
        emit(PaymentSuccess(paymentUrl: paymentUrl));
      } else {
        throw Exception("Unexpected response or missing paymentUrl.");
      }
    } on ServerException catch (e) {
      emit(PaymentFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(PaymentFailure(errorMessage: "Unexpected error: ${e.toString()}"));
    }
  }

  Future<void> confirmPayment(int bookingId) async {
    try {
      emit(PaymentConfirmLoading());

      final response = await api.get(
          "http://10.0.2.2:5282/api/Payment/payment-success?bookingId=$bookingId");

      // Ensure response is a Map and contains the necessary status
      if (response != null &&
          response is Map<String, dynamic> &&
          response.containsKey('status') &&
          response['status'] == 'success') {
        emit(PaymentConfirmSuccess());
      } else {
        emit(PaymentConfirmFailure(
            errorMessage: "Payment confirmation failed."));
      }
    } on ServerException catch (e) {
      emit(PaymentConfirmFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(PaymentConfirmFailure(errorMessage: "Unexpected error: $e"));
    }
  }
}
