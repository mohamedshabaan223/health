import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:health_app/core/api/api_consumer.dart';
import 'package:health_app/core/errors/exceptions.dart';
import 'package:health_app/cubits/payment_cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.api) : super(PaymentInitial());

  final ApiConsumer api;

  Future<void> makePayment(
      {required int doctorId, required int bookingId}) async {
    try {
      emit(PaymentLoading());
      debugPrint(
          'Request Data: {"doctorId": $doctorId, "bookingId": $bookingId}');

      final response = await api.post(
        'http://medicalservicesproject.runasp.net/api/Payment/Pay',
        data: {"doctorId": doctorId, "bookingId": bookingId},
        isFormData: true,
      );

      if (response is Map<String, dynamic> &&
          response.containsKey("paymentUrl")) {
        final paymentUrl = response['paymentUrl'];
        debugPrint('Payment URL: $paymentUrl');

        emit(PaymentSuccess(paymentUrl: paymentUrl));
      } else {
        throw Exception("Unexpected response format or missing paymentUrl.");
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

      final response = await api.post(
        "http://medicalservicesproject.runasp.net/api/Payment/confirmPay?bookingId=$bookingId",
      );

      if (response is Map<String, dynamic>) {
        if (response.containsKey('message')) {
          final message = response['message'];
          if (message.toString().toLowerCase().contains('confirmed')) {
            emit(PaymentConfirmSuccess());
          } else {
            emit(PaymentConfirmFailure(
                errorMessage: "Payment not successful: $message"));
          }
        } else {
          emit(PaymentConfirmFailure(
              errorMessage: "Invalid response structure: $response"));
        }
      } else {
        emit(PaymentConfirmFailure(
            errorMessage: "Unexpected response format: $response"));
      }
    } on ServerException catch (e) {
      emit(PaymentConfirmFailure(errorMessage: e.errorModel.errorMessage));
    } catch (e) {
      emit(PaymentConfirmFailure(errorMessage: "Unexpected error: $e"));
    }
  }

  void resetState() {
    emit(PaymentInitial());
  }
}
