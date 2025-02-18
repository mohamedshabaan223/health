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
        'http://10.0.2.2:5282/api/Payment/Pay',
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

      final response = await api.get(
        "http://10.0.2.2:5282/api/Payment/payment-success?bookingId=$bookingId",
      );

      if (response is String) {
        if (response.contains("Payment successful")) {
          emit(PaymentConfirmSuccess());
        } else {
          emit(PaymentConfirmFailure(
              errorMessage: "Payment not successful: $response"));
        }
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('status')) {
          if (response['status'] == 'success') {
            emit(PaymentConfirmSuccess());
          } else {
            emit(PaymentConfirmFailure(
                errorMessage:
                    "Payment failed with status: ${response['status']}"));
          }
        } else {
          emit(PaymentConfirmFailure(
              errorMessage: "Invalid response structure."));
        }
      } else {
        emit(PaymentConfirmFailure(errorMessage: "Invalid response format."));
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
