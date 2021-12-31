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
                  model.newsCompleteList[index].title,
                  model.newsCompleteList[index].source,
                )
                    .then((value) {
                  Get.to(
                    () => NewsSummaryScreen(
                      model.newsCompleteList[index],
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
                    top: height * 0.223,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      width: width,
                      height: height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              left: 0.5,
                              right: 0.5,
                            ),
                            width: width,
                            height: height * 0.1,
                            child: Container(
                              margin: const EdgeInsets.only(top: 44),
                              child: AutoSizeText(
                                model.newsCompleteList[index].title,
                                minFontSize: 15,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 0.5,
                              right: 0.5,
                              bottom: 5,
                              top: 20,
                            ),
                            width: width,
                            height: height * 0.05,
                            child: AutoSizeText(
                              model.newsCompleteList[index].description,
                              minFontSize: 14,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: GoogleFonts.rubik(
                                color: Colors.white70,
                                fontSize: 16,
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
                                  model.newsCompleteList[index].source,
                                  minFontSize: 11,
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    color: Colors.white70,
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
                                    color: Colors.white70,
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
