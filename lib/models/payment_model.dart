class PaymentModel {
  final String paymentUrl;

  PaymentModel({required this.paymentUrl});

  factory PaymentModel.fromJson(json) {
    return PaymentModel(paymentUrl: json['paymentUrl']);
  }
}
