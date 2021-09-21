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
                        Colors.black.withOpacity(0.6),
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
                      top: height * 0.12,
                      child: Container(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        width: width * 0.75,
                        height: height * 0.2,
                        child: AutoSizeText(
                          model.newsCompleteList[index].title,
                          minFontSize: 14,
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.3,
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        width: width * 0.4,
                        height: height * 0.06,
                        child: AutoSizeText(
                          model.newsCompleteList[index].source,
                          minFontSize: 11,
                          maxLines: 4,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFd9d8d9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.37,
                      left: width * 0.025,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          color: Colors.white70,
                        ),
                        width: width * 0.25,
                        height: height * 0.03,
                        child: Center(
                          heightFactor: 1,
                          child: AutoSizeText(
                            _helper.convertToSmallerAgo(
                              model.newsCompleteList[index].publishedDate,
                            ),
                            minFontSize: 10,
                            maxLines: 4,
                            style: GoogleFonts.poppins(
                              color:Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.37,
                      left: width * 0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(20),
                          color: Colors.white70,
                        ),
                        width: width * 0.3,
                        height: height * 0.03,
                        child: Center(
                          heightFactor: 1,
                          child: AutoSizeText(
                              "${model.newsCompleteList[index].readTime.split(" ")[0]} ${ model.newsCompleteList[index].readTime.split(" ")[1]} Reads",
                            minFontSize: 10,
                            maxLines: 4,
                            style: GoogleFonts.poppins(
                              color:Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
