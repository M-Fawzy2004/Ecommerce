import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentKey;
  final VoidCallback onSuccess;
  final Function(String) onFailure;

  const PaymentWebViewPage({
    super.key,
    required this.paymentKey,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final String iframeId = dotenv.get('PAYMOB_IFRAME_ID');
    final String url =
        'https://accept.paymob.com/api/acceptance/iframes/$iframeId?payment_token=${widget.paymentKey}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            // Paymob success detection from callback URL
            if (url.contains('success=true')) {
              widget.onSuccess();
            } else if (url.contains('success=false')) {
              widget.onFailure('Payment failed. Please try again.');
            }
          },
          onWebResourceError: (error) {
            widget.onFailure(error.description);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mastercard Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading Secure Payment...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
