import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widget/following_list_all_section.dart';

class SeeAllNewsScreen extends StatefulWidget {
  @override
  _SeeAllNewsScreenState createState() => _SeeAllNewsScreenState();
}

class _SeeAllNewsScreenState extends State<SeeAllNewsScreen> {
  List<NewsModel> newsList = [];

  @override
  void initState() {
    super.initState();
    newsList =
        Provider.of<NewsProvider>(context, listen: false).newsCompleteList;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.black,
        title: AutoSizeText('Latest',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20, fontWeight: FontWeight.bold
            )),
        centerTitle: true,
      ),
      body: SizedBox(
        height: height,
        child: DefaultTabController(
          length: 4,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  delegate: MyDelegate(TabBar(
                    labelColor: Colors.white,
                    isScrollable: true,
                    indicator: BoxDecoration(
                        color: const Color(0xFF4E8799),
                        borderRadius: BorderRadius.circular(25)),
                    tabs: [
                      Tab(
                          child: AutoSizeText(
                        'Following',
                        maxLines: 1,
                        style: GoogleFonts.rubik(),
                      )),
                      Tab(
                          child: AutoSizeText(
                        'Recommended',
                        maxLines: 1,
                        style: GoogleFonts.rubik(),
                      )),
                      Tab(
                          child: AutoSizeText(
                        'Everything',
                        maxLines: 1,
                        style: GoogleFonts.rubik(),
                      )),
                      Tab(
                          child: AutoSizeText(
                        'Hot News', //Trending News
                        maxLines: 1,
                        style: GoogleFonts.rubik(),
                      )),
                    ],
                  )),
                  floating: true,
                )
              ];
            },
            body: Container(
              margin: EdgeInsets.all(width * 0.04),
              child: TabBarView(children: <Widget>[
                FollowingListAllSection(
                  newsList: newsList,
                ),
                FollowingListAllSection(
                  newsList: newsList,
                ),
                FollowingListAllSection(
                  newsList: newsList,
                ),
                FollowingListAllSection(
                  newsList: newsList,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  MyDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
