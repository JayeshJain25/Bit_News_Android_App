import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/news_summary_screen.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BitcoinNews extends StatelessWidget {
  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<NewsProvider>(
      builder: (ctx, model, _) => model.bitcoinNewsList.isNotEmpty
          ? AnimationLimiter(
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
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                            ),
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
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => NewsSummaryScreen(
                                model.bitcoinNewsList[index],
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: 15,
                              bottom: 5,
                            ),
                            child: Card(
                              color: const Color(0xFF010101),
                              elevation: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: CachedNetworkImage(
                                      imageUrl: _helper.extractImgUrl(
                                        model.bitcoinNewsList[index].photoUrl,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CachedNetworkImage(
                                        imageUrl:
                                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                                        fit: BoxFit.cover,
                                      ),
                                      height: height * 0.09,
                                      width: width * 0.21,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 7,
                                            ),
                                            child: AutoSizeText(
                                              model
                                                  .bitcoinNewsList[index].title,
                                              maxLines: 2,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 7,
                                                ),
                                                child: AutoSizeText(
                                                  model.bitcoinNewsList[index]
                                                      .description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: GoogleFonts.rubik(
                                                    color:
                                                        const Color(0xFF757575),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  AutoSizeText(
                                                    "${_helper.convertToAgo(
                                                      model
                                                          .bitcoinNewsList[
                                                              index]
                                                          .publishedDate,
                                                    )}  \u2022",
                                                    maxLines: 1,
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                        0xFF757575,
                                                      ),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: AutoSizeText(
                                                        model
                                                            .bitcoinNewsList[
                                                                index]
                                                            .source,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                            0xFF757575,
                                                          ),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
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
                          ),
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
            )
          : Center(
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/57735-crypto-coins.gif?alt=media&token=a696da3c-4285-4479-aade-1d65ee4ec2ad',
                height: 35,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
//https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/animation_500_kvhmucnx.gif?alt=media&token=8321a796-0c25-433b-ae46-b1db4467a32e