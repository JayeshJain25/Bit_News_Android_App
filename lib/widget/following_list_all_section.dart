import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import './news_web_view.dart';
import '../provider/newsModel.dart';

class FollowingListAllSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsModel(),
      child: CustomScrollView(
        slivers: [
          _TodayNewsList(index: 0),
          _RecentNewsList(index: 1),
        ],
      ),
    );
  }
}

class _TodayNewsList extends StatelessWidget {
  const _TodayNewsList({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SliverStickyHeader.builder(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 150,
              child: FadeInAnimation(
                child: Consumer<NewsModel>(
                  builder: (ctx, model, _) => InkWell(
                    onTap: () {
                      Get.to(() =>
                              NewsWebView(model.suggestions[i].newsUrl));
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.black,
                      child: Column(
                        children: [
                          Container(
                            child: Image.network(
                                "https://www.tbstat.com/cdn-cgi/image/q=80/wp/uploads/2019/05/london-streets-filter-1200x675.jpg"),
                          ),
                          Row(
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
                                        left: width * 0.027,
                                        top: width * 0.015),
                                    width: width * 0.1,
                                    height: height * 0.025,
                                    child: AutoSizeText(
                                      'BTC',
                                      style: GoogleFonts.rubik(
                                          fontSize: 14,
                                          color: HexColor("#6a6a6a")),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.02),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          childCount: 10,
        ),
      ),
      builder: (BuildContext context, SliverStickyHeaderState state) =>
          Container(
        height: 40.0,
        color: (Colors.black).withOpacity(1.0 - state.scrollPercentage),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'TODAY',
          style: GoogleFonts.poppins(color: HexColor("#6a6a6a")),
        ),
      ),
    );
  }
}

class _RecentNewsList extends StatelessWidget {
  const _RecentNewsList({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SliverStickyHeader.builder(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 150,
              child: FadeInAnimation(
                child: Consumer<NewsModel>(
                  builder: (ctx, model, _) => InkWell(
                    onTap: () {
                      Get.to(() =>
                              NewsWebView(model.suggestions[i].newsUrl));
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
            ),
          ),
          childCount: 10,
        ),
      ),
      builder: (BuildContext context, SliverStickyHeaderState state) =>
          Container(
        height: 40.0,
        color: (Colors.black).withOpacity(1.0 - state.scrollPercentage),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'RECENT',
          style: GoogleFonts.poppins(color: HexColor("#6a6a6a")),
        ),
      ),
    );
  }
}
