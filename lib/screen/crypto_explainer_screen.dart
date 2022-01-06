import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class CryptoExplainerScreen extends StatefulWidget {
  final String htmlContent;

  const CryptoExplainerScreen(this.htmlContent);

  @override
  State<CryptoExplainerScreen> createState() => _CryptoExplainerScreenState();
}

class _CryptoExplainerScreenState extends State<CryptoExplainerScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: height,
          child: WebViewPlus(
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              controller.loadString(widget.htmlContent);
            },
          ),
        ),
      ),
    );
  }
}
