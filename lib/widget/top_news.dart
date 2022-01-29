import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/news_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TopNews extends StatelessWidget {
  final int index;

  TopNews(this.index);

  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double h = MediaQuery.of(context).textScaleFactor;

    return Consumer<NewsProvider>(
      builder: (ctx, model, _) => model.topHeadlineNewsList.isEmpty
          ? CachedNetworkImage(
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/animation_500_kvhmucnx.gif?alt=media&token=8321a796-0c25-433b-ae46-b1db4467a32e',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            )
          : InkWell(
              onTap: () {
                Provider.of<NewsProvider>(
                  context,
                  listen: false,
                )
                    .getNewsReadCount(
                  model.topHeadlineNewsList[index].title,
                  model.topHeadlineNewsList[index].source,
                )
                    .then((value) {
                  Get.to(
                    () => NewsSummaryScreen(
                      model.topHeadlineNewsList[index],
                      value,
                    ),
                  );
                });
              },
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: width,
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: _helper.extractImgUrl(
                              model.topHeadlineNewsList[index].photoUrl,
                            ),
                            placeholder: (ctx, _) {
                              return const BlurHash(
                                imageFit: BoxFit.fitWidth,
                                duration: Duration(seconds: 3),
                                curve: Curves.bounceInOut,
                                hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I",
                              );
                            },
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                              fit: BoxFit.cover,
                            ),
                            height: height * 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: height * 0.1,
                    child: Container(
                      width: width,
                      height: height * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: h >= 1.33 || height < 850
                        ? height * 0.2
                        : height * 0.25,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: width * 0.04,
                        right: width * 0.04,
                      ),
                      width: width,
                      height: height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: width,
                            child: FittedBox(
                              child: Container(
                                width: width,
                                margin: const EdgeInsets.only(top: 44),
                                child: AutoSizeText(
                                  model.topHeadlineNewsList[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 5,
                              top: 12,
                            ),
                            width: width,
                            child: AutoSizeText(
                              model.topHeadlineNewsList[index].description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: GoogleFonts.rubik(
                                color: Colors.white70,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.4,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  model.topHeadlineNewsList[index].source,
                                  minFontSize: 11,
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    color: Colors.white70,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.25,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  _helper.convertToSmallerAgo(
                                    model.topHeadlineNewsList[index]
                                        .publishedDate,
                                  ),
                                  minFontSize: 10,
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    color: Colors.white70,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
    );
  }
}
