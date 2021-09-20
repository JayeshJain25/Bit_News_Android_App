import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'news_web_view.dart';

class FollowingList extends StatelessWidget {
  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimationLimiter(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 11,
        itemBuilder: (BuildContext context, int index) {
          if (index == 10) {
            return Container(
              margin: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => SeeAllNewsScreen());
                },
                child: Center(
                  child: Text(
                    "See all",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            );
          }
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 150,
              child: FadeInAnimation(
                child: Consumer<NewsProvider>(
                  builder: (ctx, model, _) => model.newsCompleteList.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: CustomPaint(
                                      painter: BluePainter(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black,
                                                ),
                                                width: width * 0.32,
                                                height: height * 0.05,
                                                child: Center(
                                                  heightFactor: 1,
                                                  child: AutoSizeText(
                                                    model.newsCompleteList[index]
                                                        .source,
                                                    maxLines: 2,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color(0xFFf4f4f5),
                                                ),
                                                width: width * 0.2,
                                                height: height * 0.05,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    const Icon(
                                                      Icons.watch_later_outlined,
                                                      color: Colors.grey,
                                                      size: 17,
                                                    ),
                                                    AutoSizeText(
                                                      " ${model.newsCompleteList[index].readTime.split(" ")[0]} ${ model.newsCompleteList[index].readTime.split(" ")[1]}",
                                                      style: GoogleFonts.poppins(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color(0xFFf4f4f5),
                                                ),
                                                width: width * 0.2,
                                                height: height * 0.05,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    const Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.grey,
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
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, top: 15),
                                            child: AutoSizeText(
                                              "Summary of news",
                                              style:
                                                  GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 40.h,
                                            padding: const EdgeInsets.all(10),
                                            child: SingleChildScrollView(
                                              child: AutoSizeText(
                                                model.newsCompleteList[index]
                                                    .summary,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, bottom: 15),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(() => NewsWebView(model
                                                    .newsCompleteList[index].url));
                                              },
                                              style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(18.0),
                                                  ),
                                                ),
                                              ),
                                              child:  Text(
                                                  "View Full Article ->",style:  GoogleFonts.poppins(fontSize: 14),),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, top: 15, bottom: 5),
                            child: Card(
                              color: const Color(0xFF121212),
                              elevation: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: CachedNetworkImage(
                                      imageUrl: _helper.extractImgUrl(
                                        model.newsCompleteList[index].photoUrl,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl:
                                                  "https://www.translationvalley.com/wp-content/uploads/2020/03/no-iamge-placeholder.jpg"),
                                      height: height * 0.09,
                                      width: width * 0.21,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          AutoSizeText(
                                            model.newsCompleteList[index].title,
                                            maxLines: 2,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              AutoSizeText(
                                                model.newsCompleteList[index]
                                                    .description,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF6a6a6a),
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    _helper.convertToAgo(model
                                                        .newsCompleteList[index]
                                                        .publishedDate),
                                                    maxLines: 1,
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                          0xFF6a6a6a),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: AutoSizeText(
                                                      model
                                                          .newsCompleteList[
                                                              index]
                                                          .source,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: const Color(
                                                            0xFF6a6a6a),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            indent: width * 0.28,
            endIndent: width * 0.04,
            color: const Color(0xFF404040),
            thickness: 1,
          );
        },
      ),
    );
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final Paint paint = Paint();

    final Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.white;
    canvas.drawPath(mainBackground, paint);

    final Path ovalPath = Path();
    // Start paint from 20% height to the left
    ovalPath.moveTo(0, height * 0.2);

    // paint a curve from current position to middle of the screen
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);

    // draw remaining line to bottom left side
    ovalPath.lineTo(0, height);

    // Close line to reset it back
    ovalPath.close();

    paint.color = Colors.blue.shade600;
    canvas.drawPath(ovalPath, paint);

    final Path ovalPath1 = Path();
    // Start paint from 20% height to the left
    ovalPath1.moveTo(width, height * 0.2);

    // paint a curve from current position to middle of the screen
    ovalPath1.quadraticBezierTo(
        width * 0.3, height * 0.25, width * 0.3, height * 0.5);

    // Paint a curve from current position to bottom left of screen at width * 0.1
    ovalPath1.quadraticBezierTo(width * 0.4, height * 0.8, width, height);

    // draw remaining line to bottom left side
    ovalPath1.lineTo(width, 0);

    // Close line to reset it back
    ovalPath1.close();

    paint.color = Colors.red.shade600;
    canvas.drawPath(ovalPath1, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}