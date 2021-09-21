import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/news_search_screen.dart';
import 'package:crypto_news/widget/top_news.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widget/drawer_screen.dart';
import '../widget/following_list.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  late Animation<double> gap;
  late AnimationController _animationController;
  late Animation<Offset> _storiesAnimation;
  late Animation<double> reverse;
  late AnimationController controller;
  late Animation<double> base;

  List<String> imageUrlList = [
    "https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png",
    "https://assets.coingecko.com/coins/images/13120/large/Logo_final-21.png?1624892810",
    "https://assets.coingecko.com/coins/images/756/large/nano-coin-logo.png?1547034501",
    "https://assets.coingecko.com/coins/images/776/large/OMG_Network.jpg?1591167168",
    "https://assets.coingecko.com/coins/images/63/large/digibyte.png?1547033717",
    "https://assets.coingecko.com/coins/images/13725/large/xsushi.png?1612538526",
    "https://assets.coingecko.com/coins/images/1060/large/icon-icx-logo.png?1547035003"
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    Provider.of<NewsProvider>(context, listen: false).newsList();

    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

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

  // Dispose
  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            DrawerScreen(),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: !isDrawerOpen
                    ? BorderRadius.circular(0)
                    : BorderRadius.circular(40),
              ),
              duration: const Duration(milliseconds: 250),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                      // Row(
                      //   children: <Widget>[
                          // if (isDrawerOpen)
                          //   IconButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         xOffset = 0;
                          //         yOffset = 0;
                          //         scaleFactor = 1;
                          //         isDrawerOpen = false;
                          //       });
                          //     },
                          //     icon: const Icon(
                          //       Icons.arrow_back_ios,
                          //       color: Colors.white,
                          //     ),
                          //   )
                          // else
                          //   IconButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         xOffset = 230;
                          //         yOffset = 150;
                          //         scaleFactor = 0.6;
                          //         isDrawerOpen = true;
                          //       });
                          //     },
                          //     icon: const Icon(
                          //       Icons.menu_rounded,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          AutoSizeText(
                            'CryptoX',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                            )
                          ,),
                          // IconButton(
                          //   onPressed: () {
                          //     Get.to(() => NewsSearchScreen());
                          //   },
                          //   icon: const Icon(
                          //     Icons.search,
                          //     color: Colors.white,
                          //   ),
                          // )
                      //  ],
                    //  ),
                    ),
                    SizedBox(
                      height: 81.h,
                      child: DefaultTabController(
                        length: 4,
                        child: NestedScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                automaticallyImplyLeading: false,
                                collapsedHeight: 45.h,
                                expandedHeight: 45.h,
                                // title: SizedBox(
                                //   height: 20.h,
                                //   child: ListView.builder(
                                //       itemCount: imageUrlList.length,
                                //       scrollDirection: Axis.horizontal,
                                //       itemBuilder: (ctx, index) => Container(
                                //             margin: EdgeInsets.only(
                                //                 left: 1.5.w, right: 1.5.w),
                                //             child: SlideTransition(
                                //               position: _storiesAnimation,
                                //               child: Center(
                                //                 child: RotationTransition(
                                //                   turns: base,
                                //                   child: DashedCircle(
                                //                     gapSize: gap.value,
                                //                     dashes: 40,
                                //                     color:
                                //                         const Color(0xFF4E8799),
                                //                     child: RotationTransition(
                                //                         turns: reverse,
                                //                         child: Padding(
                                //                           padding:
                                //                               const EdgeInsets
                                //                                   .all(5.0),
                                //                           child: CircleAvatar(
                                //                             radius: 20,
                                //                             backgroundImage:
                                //                                 NetworkImage(
                                //                                     imageUrlList[
                                //                                         index]),
                                //                           ),
                                //                         )),
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           )),
                                // ),
                                flexibleSpace: Container(
                                  margin: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    bottom: 15,
                                    top: 15,
                                  ),
                                  height: 45.h,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CarouselSlider.builder(
                                          carouselController: _controller,
                                          options: CarouselOptions(
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _current = index;
                                              });
                                            },
                                            height: 45.h,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval:
                                                const Duration(seconds: 10),
                                            autoPlayAnimationDuration:
                                                const Duration(milliseconds: 1500),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          itemCount: 5,
                                          itemBuilder: (
                                            BuildContext context,
                                            int index,
                                            int realIndex,
                                          ) {
                                            return TopNews(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                backgroundColor: const Color(0xFF121212),
                              ),
                              SliverPersistentHeader(
                                delegate: MyDelegate(
                                  TabBar(
                                    labelColor: Colors.white,
                                    isScrollable: true,
                                    indicator: BoxDecoration(
                                      color: const Color(0xFF4E8799),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    tabs: [
                                      Tab(
                                        child: AutoSizeText(
                                          'Following',
                                          maxLines: 1,
                                          style: GoogleFonts.rubik(),
                                        ),
                                      ),
                                      Tab(
                                        child: AutoSizeText(
                                          'Recommended',
                                          maxLines: 1,
                                          style: GoogleFonts.rubik(),
                                        ),
                                      ),
                                      Tab(
                                        child: AutoSizeText(
                                          'Everything',
                                          maxLines: 1,
                                          style: GoogleFonts.rubik(),
                                        ),
                                      ),
                                      Tab(
                                        child: AutoSizeText(
                                          'Hot News', //Trending News
                                          maxLines: 1,
                                          style: GoogleFonts.rubik(),
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
                            margin: EdgeInsets.all(0.4.w),
                            child: TabBarView(
                              children: <Widget>[
                                FollowingList(),
                                FollowingList(),
                                FollowingList(),
                                FollowingList(),
                              ],
                            ),
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
