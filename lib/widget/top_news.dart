import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'news_web_view.dart';

class TopNews extends StatelessWidget {
  final int index;

  TopNews(this.index);

  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<NewsProvider>(
      builder: (ctx, model, _) => model.newsCompleteList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : InkWell(
              onTap: () {
                Get.to(
                  () => NewsWebView(
                    model.newsCompleteList[index].url,
                  ),
                );
              },
              child: Container(
                width: width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: <Widget>[
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8),
                        BlendMode.dstIn,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: _helper.extractImgUrl(
                            model.newsCompleteList[index].photoUrl,
                          ),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                                "https://www.translationvalley.com/wp-content/uploads/2020/03/no-iamge-placeholder.jpg",
                          ),
                          height: height * 0.5,
                          width: width * 0.8,
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.1,
                      child: Container(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        width: width * 0.81,
                        height: height * 0.23,
                        child: AutoSizeText(
                          model.newsCompleteList[index].title,
                          minFontSize: 14,
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.23,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        width: width * 0.4,
                        height: height * 0.06,
                        child: AutoSizeText(
                          model.newsCompleteList[index].source,
                          minFontSize: 14,
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.23,
                      left: width * 0.5,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        width: width * 0.25,
                        height: height * 0.06,
                        child: AutoSizeText(
                          _helper.convertToSmallerAgo(
                            model.newsCompleteList[index].publishedDate,
                          ),
                          minFontSize: 14,
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
