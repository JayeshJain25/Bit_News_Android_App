import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {

  final String newsUrl;

  NewsWebView(this.newsUrl);

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
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          LikeButton(
            size: 25,
            circleColor:
                CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.bookmark,
                color: isLiked ? HexColor("#4E8799") : Colors.grey,
                size: 25,
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: WebView(
        initialUrl:
            newsUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
