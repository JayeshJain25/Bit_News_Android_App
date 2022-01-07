import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

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
          child: Html(
            data: widget.htmlContent,
          ),
        ),
      ),
    );
  }
}
