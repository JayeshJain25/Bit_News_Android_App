import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import './news_web_view.dart';

class FollowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return AnimationLimiter(
      child: ListView.builder(
          itemCount: 11,
          itemBuilder: (BuildContext context, int index) {
            if (index == 10) {
              return Container(
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "See all",
                    style:
                    GoogleFonts.poppins(color: Colors.white, fontSize: 15),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewsWebView()));
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.black,
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: height * 0.04,
                                width: width * 0.1,
                                child: Image(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                        'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.027, top: width * 0.015),
                                width: width * 0.1,
                                height: height * 0.025,
                                child: AutoSizeText(
                                  'BTC',
                                  style: GoogleFonts.rubik(
                                      fontSize: 14, color: HexColor("#6a6a6a")),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: height * 0.04),
                                  width: width * 0.72,
                                  height: height * 0.055,
                                  child: AutoSizeText(
                                    "Bitcoin Ransomware Payments Set 'Dangerous Precedent': House Oversight Chair",
                                    maxLines: 2,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Container(
                                  width: width * 0.72,
                                  height: height * 0.03,
                                  child: AutoSizeText(
                                    "Bitcoin Ransomware Payments Set 'Dangerous Precedent': House Oversight Chair",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: GoogleFonts.poppins(
                                      color: HexColor("#6a6a6a"),
                                      fontSize: 15,
                                    ),
                                  )),
                              Container(
                                  width: width * 0.5,
                                  height: height * 0.03,
                                  child: AutoSizeText(
                                    "- 3 hours ago",
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
                ),
              ),
            );
          }),
    );
  }
}
