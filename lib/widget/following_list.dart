import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_news/helper/hepler.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import './news_web_view.dart';
import '../screen/seeAllNewsScreen.dart';

class FollowingList extends StatelessWidget {

  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimationLimiter(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: 11,
          itemBuilder: (BuildContext context, int index) {
            if (index == 10) {
              return Container(
                margin: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => SeeAllNewsScreen());
                  },
                  child: Center(
                    child: Text(
                      "See all",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 15),
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
                    builder: (ctx, model, _) =>
                        model.newsCompleteList.length == 0
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : InkWell(
                                onTap: () {
                                  Get.to(() => NewsWebView(
                                      model.newsCompleteList[index].url));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, top: 15, bottom: 5),
                                  child: Card(
                                    color: Color(0xFF121212),
                                    elevation: 0,
                                    child: ListTile(
                                      leading: Container(
                                        height: height,
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(model
                                                  .newsCompleteList[index]
                                                  .photoUrl),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                      title: Container(
                                          child: AutoSizeText(
                                        model.newsCompleteList[index].title,
                                        maxLines: 2,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                      subtitle: Column(
                                        children: [
                                          Container(
                                              child: AutoSizeText(
                                            model.newsCompleteList[index]
                                                .description,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: GoogleFonts.poppins(
                                              color: HexColor("#6a6a6a"),
                                              fontSize: 15,
                                            ),
                                          )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  child: AutoSizeText(
                                                _helper.convertToAgo(model.newsCompleteList[index]
                                                    .publishedDate),
                                                minFontSize: 12,
                                                maxLines: 1,
                                                style: GoogleFonts.poppins(
                                                  color: HexColor("#6a6a6a"),
                                                  fontSize: 14,
                                                ),
                                              )),
                                              Container(
                                                  child: AutoSizeText(
                                                model.newsCompleteList[index]
                                                    .source,
                                                minFontSize: 12,
                                                maxLines: 1,
                                                style: GoogleFonts.poppins(
                                                  color: HexColor("#6a6a6a"),
                                                  fontSize: 15,
                                                ),
                                              )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                  ),
                ),
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) {
        return Divider( indent: width*0.31,
        endIndent: width*0.06,color: HexColor("#404040"),thickness: 1,);
      },),
    );
  }
}
