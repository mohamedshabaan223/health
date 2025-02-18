import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/cubits/payment_cubit/payment_cubit.dart';
import 'package:health_app/cubits/payment_cubit/payment_state.dart';
import 'package:health_app/pages/payment_success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage(
      {super.key, required this.paymentUrl, required this.bookingId});
  final String paymentUrl;
  final int bookingId; // تمرير الـ bookingId لتأكيد الدفع

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _confirmPayment() {
    final paymentCubit = context.read<PaymentCubit>();
    paymentCubit.confirmPayment(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentConfirmSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => payment_success()),
          );
        } else if (state is PaymentConfirmFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Payment Confirmation Failed: ${state.errorMessage}")),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("Payment")),
          body: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 150),
              ),
              onPressed: () {
                _confirmPayment();
              },
              child: const Text("Done"),
            ),
          ),
        ),
      ),
    );
  }
}
