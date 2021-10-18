import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/news_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
                  () => NewsSummaryScreen(
                    model.newsCompleteList[index],
                  ),
                );
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    width: width,
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
                            child: Hero(
                              tag: model.newsCompleteList[index].title,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _helper.extractImgUrl(
                                  model.newsCompleteList[index].photoUrl,
                                ),
                                errorWidget: (context, url, error) =>
                                    CachedNetworkImage(
                                  imageUrl:
                                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                                  fit: BoxFit.cover,
                                ),
                                height: height * 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: height * 0.243,
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 15,
                        right: 15,
                        bottom: 10,
                      ),
                      width: width * 0.875,
                      height: height * 0.16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 0.5,
                                right: 0.5,
                                bottom: 5,
                              ),
                              width: width * 0.75,
                              height: height * 0.1,
                              child: AutoSizeText(
                                model.newsCompleteList[index].title,
                                minFontSize: 14,
                                maxLines: 3,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                  model.newsCompleteList[index].source,
                                  minFontSize: 11,
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    color: const Color(0xFFd9d8d9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.25,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  _helper.convertToSmallerAgo(
                                    model.newsCompleteList[index].publishedDate,
                                  ),
                                  minFontSize: 10,
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    color: const Color(0xFFd9d8d9),
                                    fontSize: 15,
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
