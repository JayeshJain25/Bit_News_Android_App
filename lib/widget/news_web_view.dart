import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  final String newsUrl;
  final bool showAppBar;
  final String type;

  const NewsWebView(this.newsUrl, this.showAppBar, this.type);

  @override
  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                centerTitle: widget.type == "explainer" ? false : true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                title: Text(
                  widget.type == "explainer"
                      ? "CryptoX > Coin Explainer"
                      : "News",
                  style: GoogleFonts.rubik(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          : null,
      body: WebView(
        initialUrl: widget.newsUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
