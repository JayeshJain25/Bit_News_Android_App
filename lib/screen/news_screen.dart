import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/widget/bitcoin_news.dart';
import 'package:crypto_news/widget/ethereum_news.dart';
import 'package:crypto_news/widget/nft_news.dart';
import 'package:crypto_news/widget/top_news.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widget/news_feed.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
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
    Provider.of<NewsProvider>(context, listen: false).getNewsFeed(1);
    Provider.of<NewsProvider>(context, listen: false).getBitcoinNews(1);
    Provider.of<NewsProvider>(context, listen: false).getEthereumNews(1);
    Provider.of<NewsProvider>(context, listen: false).getNFTNews(1);

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
      backgroundColor: const Color(0xFF010101),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 90.h,
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
                          bottom: 15,
                        ),
                        height: 45.h,
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              carouselController: _controller,
                              options: CarouselOptions(
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                                height: 45.h,
                                viewportFraction: 1,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                autoPlayInterval: const Duration(seconds: 10),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1500),
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
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 5),
                              child: AutoSizeText(
                                'Discover',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: const Color(0xFF010101),
                    ),
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
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Tab(
                              child: AutoSizeText(
                                'Ethereum',
                                maxLines: 1,
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Tab(
                              child: AutoSizeText(
                                'NFT', //Trending News
                                maxLines: 1,
                                style: GoogleFonts.rubik(
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
                  margin: EdgeInsets.all(0.4.w),
                  child: TabBarView(
                    children: <Widget>[
                      NewsFeed(),
                      BitcoinNews(),
                      EthereumNews(),
                      NFTNews(),
                    ],
                  ),
                ),
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
