abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentUrl;
  PaymentSuccess({required this.paymentUrl});
}

class PaymentFailure extends PaymentState {
  final String errorMessage;
  PaymentFailure({required this.errorMessage});
}

class PaymentConfirmLoading extends PaymentState {}

class PaymentConfirmSuccess extends PaymentState {}

class PaymentConfirmFailure extends PaymentState {
  final String errorMessage;
  PaymentConfirmFailure({required this.errorMessage});
}
