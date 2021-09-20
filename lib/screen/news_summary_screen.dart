import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:crypto_news/widget/news_web_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class NewsSummaryScreen extends StatefulWidget {
  final NewsModel newsData;

  const NewsSummaryScreen(this.newsData);

  @override
  _NewsSummaryScreenState createState() => _NewsSummaryScreenState();
}

class _NewsSummaryScreenState extends State<NewsSummaryScreen> {
  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: height * 0.33,
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: _helper.extractImgUrl(widget.newsData.photoUrl),
                    errorWidget: (context, url, error) => CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl:
                            "https://www.translationvalley.com/wp-content/uploads/2020/03/no-iamge-placeholder.jpg"),
                    height: height * 0.37,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: height * 0.3,
                    child: SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            width: width * 0.32,
                            height: height * 0.05,
                            child: Center(
                              heightFactor: 1,
                              child: AutoSizeText(
                                widget.newsData.source,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            width: width * 0.2,
                            height: height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                AutoSizeText(
                                  " ${widget.newsData.readTime.split(" ")[0]} ${widget.newsData.readTime.split(" ")[1]}",
                                  style: GoogleFonts.poppins(),
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            width: width * 0.2,
                            height: height * 0.05,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                Text(
                                  " 376",
                                  style: GoogleFonts.poppins(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: const EdgeInsets.all(15),
              height: height,
              width: width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color(0xFF121212),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 15),
                    child: AutoSizeText(
                      widget.newsData.title,
                      style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: AutoSizeText(
                        widget.newsData.summary,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, bottom: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => NewsWebView(widget.newsData.url));
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "View Full Article ->",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ],
    ));
  }
}
