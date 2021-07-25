import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/newsSearchScreen.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widget/drawerScreen.dart';
import '../widget/following_list.dart';
import '../widget/top_news.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  late Animation gap;
  late AnimationController _animationController;
  late Animation<Offset> _storiesAnimation;
  late final reverse;
  late AnimationController controller;
  late final base;

  List<String> imageUrlList = [
    "https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png",
    "https://assets.coingecko.com/coins/images/13120/large/Logo_final-21.png?1624892810",
    "https://assets.coingecko.com/coins/images/756/large/nano-coin-logo.png?1547034501",
    "https://assets.coingecko.com/coins/images/776/large/OMG_Network.jpg?1591167168",
    "https://assets.coingecko.com/coins/images/63/large/digibyte.png?1547033717",
    "https://assets.coingecko.com/coins/images/13725/large/xsushi.png?1612538526",
    "https://assets.coingecko.com/coins/images/1060/large/icon-icx-logo.png?1547035003"
  ];

  @override
  void initState() {

    Provider.of<NewsProvider>(context, listen: false)
        .newsList();

    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    final curve =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);

    _storiesAnimation =
        Tween<Offset>(begin: const Offset(-2, 0.0), end: Offset.zero)
            .animate(curve);

    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);

    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
    _animationController.forward();
  }

  /// Dispose
  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            DrawerScreen(),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: !isDrawerOpen
                      ? BorderRadius.circular(0)
                      : BorderRadius.circular(40)),
              duration: Duration(milliseconds: 250),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isDrawerOpen
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      isDrawerOpen = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 230;
                                      yOffset = 150;
                                      scaleFactor = 0.6;
                                      isDrawerOpen = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                          AutoSizeText(
                            'News',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 20),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.to(() => NewsSearchScreen());
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: 81.h,
                      child: DefaultTabController(
                        length: 4,
                        child: NestedScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                collapsedHeight: 37.h,
                                expandedHeight: 37.h,
                                title: Container(
                                  height: 20.h,
                                  child: ListView.builder(
                                      itemCount: imageUrlList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) => Container(
                                            margin: EdgeInsets.only(
                                                left: 1.5.w, right: 1.5.w),
                                            child: SlideTransition(
                                              position: _storiesAnimation,
                                              child: Center(
                                                child: RotationTransition(
                                                  turns: base,
                                                  child: DashedCircle(
                                                    gapSize: gap.value,
                                                    dashes: 40,
                                                    color: HexColor("#4E8799"),
                                                    child: RotationTransition(
                                                        turns: reverse,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: CircleAvatar(
                                                            radius: 20,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    imageUrlList[
                                                                        index]),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                                flexibleSpace: Container(
                                  margin: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 15, top: 50),
                                  height: 37.h,
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          TopNews(),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                backgroundColor: Colors.black,
                              ),
                              SliverPersistentHeader(
                                delegate: MyDelegate(TabBar(
                                  labelColor: Colors.white,
                                  isScrollable: true,
                                  indicator: BoxDecoration(
                                      color: HexColor("#4E8799"),
                                      borderRadius: BorderRadius.circular(25),
                                      shape: BoxShape.rectangle),
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
                            margin: EdgeInsets.all(0.4.w),
                            child: TabBarView(children: <Widget>[
                              FollowingList(),
                              FollowingList(),
                              FollowingList(),
                              FollowingList(),
                            ]),
                          ),
                        ),
                      ),
                    )
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

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  MyDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
      margin: EdgeInsets.only(left: 15, right: 15),
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
