import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "News",
          style: GoogleFonts.rubik(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl:
            "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
