import 'package:crypto_news/model/crypto_explainer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class CryptoExplainerScreen extends StatefulWidget {
  final CryptoExplainerModel cryptoExplainerData;

  const CryptoExplainerScreen(this.cryptoExplainerData);

  @override
  State<CryptoExplainerScreen> createState() => _CryptoExplainerScreenState();
}

class _CryptoExplainerScreenState extends State<CryptoExplainerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Html(data: widget.cryptoExplainerData.content),
          ),
        ),
      ),
    );
  }
}
