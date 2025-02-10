import 'package:flutter/material.dart';
import 'package:health_app/pages/payment_success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.paymentUrl});
  final String paymentUrl;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController controller;
  bool isLoading = true;
  bool isPaymentCompleted = false;

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
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.contains("success")) {
            setState(() {
              isPaymentCompleted = true;
            });
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => payment_success()),
              );
            });
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Payment")),
        body: Stack(
          children: [
            WebViewWidget(controller: controller),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
        bottomNavigationBar: isPaymentCompleted
            ? null
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 150),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => payment_success()),
                    );
                  },
                  child: const Text("Done"),
                ),
              ),
      ),
    );
  }
}
