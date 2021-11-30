import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:crypto_news/model/news_read_count_model.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/widget/news_web_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewsSummaryScreen extends StatefulWidget {
  final NewsModel newsData;
  final NewsReadCountModel newsReadCount;

  const NewsSummaryScreen(this.newsData, this.newsReadCount);

  @override
  _NewsSummaryScreenState createState() => _NewsSummaryScreenState();
}

class _NewsSummaryScreenState extends State<NewsSummaryScreen> {
  final _helper = Helper();
  Timer? timer;
  Timer? timer1;
  final User? user = FirebaseAuth.instance.currentUser;
  List<dynamic> dataList = [];
  bool plusOneCount = false;

  @override
  void initState() {
    super.initState();
    dataList = [...widget.newsReadCount.readCount];

    timer1 = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (plusOneCount) {
        setState(() {
          plusOneCount = false;
        });
      }
    });

    final NewsReadCountModel readCountModel;
    if (dataList.isEmpty || !dataList.contains(user!.uid)) {
      final List<dynamic> uid = [...widget.newsReadCount.readCount, user!.uid];

      readCountModel = NewsReadCountModel(
        title: widget.newsData.title,
        source: widget.newsData.source,
        readCount: uid,
        totalReadCount: uid.length,
      );

      timer = Timer.periodic(const Duration(seconds: 8), (Timer t) {
        if (dataList.isEmpty || !dataList.contains(user!.uid)) {
          Provider.of<NewsProvider>(context, listen: false)
              .updateNewsReadCount(readCountModel)
              .then((_) {
            setState(() {
              plusOneCount = true;
              dataList = [...widget.newsReadCount.readCount, user!.uid];
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timer1?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // print(widget.newsData.url);
    return Scaffold(
      backgroundColor: const Color(0xFF292f33),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 22,
              ),
              color: Colors.white,
              onPressed: () {
                Get.back();
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size(0, 60),
              child: Container(
                color: const Color(0xFF292f33),
              ),
            ),
            expandedHeight: height * 0.35,
            flexibleSpace: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CachedNetworkImage(
                    imageUrl: _helper.extractImgUrl(
                      widget.newsData.photoUrl,
                    ),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                      fit: BoxFit.cover,
                    ),
                    height: height * 0.37,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: height * 0.12,
                  child: Container(
                    width: width,
                    height: height * 0.25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7)
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF292f33),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverAppBar(
            expandedHeight: height * 0.12,
            collapsedHeight: height * 0.12,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF292f33),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: AutoSizeText(
                    widget.newsData.title,
                    maxLines: 3,
                    minFontSize: 15,
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      width: width * 0.32,
                      height: height * 0.03,
                      child: Center(
                        heightFactor: 1,
                        child: AutoSizeText(
                          widget.newsData.source,
                          maxLines: 2,
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      width: width * 0.2,
                      height: height * 0.03,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.watch_later_outlined,
                            color: Colors.white,
                            size: 17,
                          ),
                          AutoSizeText(
                            " ${widget.newsData.readTime.split(
                              " ",
                            )[0]} ${widget.newsData.readTime.split(" ")[1]}",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      width: width * 0.2,
                      height: height * 0.03,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: 17,
                          ),
                          Text(
                            " ${dataList.length}",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (plusOneCount)
                            Text(
                              "   + 1",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: const Divider(
                    indent: 15,
                    endIndent: 15,
                    thickness: 1,
                    height: 1,
                    color: Color(0xFF010101),
                  ),
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) {
                return Container(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  margin: const EdgeInsets.only(bottom: 5),
                  color: const Color(0xFF292f33),
                  child: widget.newsData.summary.length == index
                      ? Container(
                          width: width,
                          height: height * 0.06,
                          margin: const EdgeInsets.only(left: 15, bottom: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => NewsWebView(widget.newsData.url));
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF52CAF5),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Read Full Article",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : AutoSizeText(
                          "• ${widget.newsData.summary[index].toString()}",
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                );
              },
              childCount: widget.newsData.summary.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
