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
  List<NewsModel> newsList2 = [];
  List<NewsModel> newsList3 = [];
  List<NewsModel> newsList4 = [];

  @override
  void initState() {
    super.initState();
    newsList =
        Provider.of<NewsProvider>(context, listen: false).newsCompleteList;
    newsList2 =
        Provider.of<NewsProvider>(context, listen: false).bitcoinNewsList;
    newsList3 =
        Provider.of<NewsProvider>(context, listen: false).ethereumNewsList;
    newsList4 = Provider.of<NewsProvider>(context, listen: false).nftNewsList;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF010101),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 22,
          ),
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: const Color(0xFF010101),
        leadingWidth: 25,
        title: AutoSizeText(
          'CryptoX',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                  delegate: MyDelegate(
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: const Color(0xFF52CAF5),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      tabs: [
                        Tab(
                          child: AutoSizeText(
                            'News Feed',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: AutoSizeText(
                            'Bitcoin',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: AutoSizeText(
                            'Ethereum',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Tab(
                          child: AutoSizeText(
                            'NFT',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floating: true,
                )
              ];
            },
            body: Container(
              margin: EdgeInsets.all(width * 0.04),
              child: TabBarView(
                children: <Widget>[
                  FollowingListAllSection(
                    newsList: newsList,
                    newsValue: "all",
                  ),
                  FollowingListAllSection(
                    newsList: newsList2,
                    newsValue: "bitcoin",
                  ),
                  FollowingListAllSection(
                    newsList: newsList3,
                    newsValue: "ethereum",
                  ),
                  FollowingListAllSection(
                    newsList: newsList4,
                    newsValue: "nft",
                  ),
                ],
              ),
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
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
