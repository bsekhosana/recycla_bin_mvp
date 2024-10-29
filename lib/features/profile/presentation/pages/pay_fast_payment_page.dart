import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PayFastPaymentPage extends StatefulWidget {
  final String paymentUrl;

  const PayFastPaymentPage({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  _PayFastPaymentPageState createState() => _PayFastPaymentPageState();
}

class _PayFastPaymentPageState extends State<PayFastPaymentPage> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complete Payment"),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.paymentUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useOnLoadResource: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
              print("Loading URL: $url");
            },
            onLoadStop: (controller, url) async {
              setState(() {
                _isLoading = false;
              });
              print("Finished loading: $url");

              // Check if the URL indicates a success, cancel, or error
              if (url != null) {
                if (url.toString().contains("success")) {
                  Navigator.pop(context, 'success');
                } else if (url.toString().contains("cancel")) {
                  Navigator.pop(context, 'cancel');
                } else if (url.toString().contains("error")) {
                  Navigator.pop(context, 'error');
                }
              }
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
              });
              Navigator.pop(context, 'error');
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
