import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  final String newsUrl;

  const NewsWebView(this.newsUrl);

  @override
  _NewsWebViewState createState() => _NewsWebViewState(newsUrl);
}

class _NewsWebViewState extends State<NewsWebView> {
  final String newsUrl;

  _NewsWebViewState(this.newsUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "News",
          style: GoogleFonts.rubik(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: newsUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
