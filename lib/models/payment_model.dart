class PaymentModel {
  final String paymentUrl;
  final int bookingId;

  PaymentModel({required this.paymentUrl, required this.bookingId});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentUrl: json['paymentUrl'] ?? '',
      bookingId: json['bookingId'] ?? 0,
    );
  }
}
