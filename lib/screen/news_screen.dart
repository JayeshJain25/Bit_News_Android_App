import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:crypto_news/widget/top_news.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:octo_image/octo_image.dart';
import 'news_summary_screen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();

  final TabController tabController;
  const NewsScreen({Key? key, required this.tabController}) : super(key: key);
}

class _NewsScreenState extends State<NewsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;
  final _helper = Helper();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          widget.tabController.index = 0;
          return true as Future<bool>;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF010101),
          body: CustomRefreshIndicator(
            onRefresh: () {
              setState(() {
                Provider.of<NewsProvider>(context, listen: false)
                    .newsCompleteList
                    .clear();
                Provider.of<NewsProvider>(context, listen: false)
                    .bitcoinNewsList
                    .clear();
                Provider.of<NewsProvider>(context, listen: false)
                    .ethereumNewsList
                    .clear();
                Provider.of<NewsProvider>(context, listen: false)
                    .nftNewsList
                    .clear();

                Provider.of<NewsProvider>(context, listen: false)
                    .getNewsFeed(1);
                Provider.of<NewsProvider>(context, listen: false)
                    .getBitcoinNews(1);
                Provider.of<NewsProvider>(context, listen: false)
                    .getEthereumNews(1);
                Provider.of<NewsProvider>(context, listen: false).getNFTNews(1);
                Provider.of<NewsProvider>(context, listen: false)
                    .getMetaverseNews(1);
              });
              return Future.delayed(const Duration(seconds: 2));
            },
            builder: (
              BuildContext context,
              Widget child,
              IndicatorController controller,
            ) {
              return AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, _) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      if (!controller.isIdle)
                        Positioned(
                          top: 10.0 * controller.value,
                          child: SizedBox(
                            height: 75,
                            width: width,
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/refresh_animation.gif?alt=media&token=5ad2f404-13a0-4493-9764-1e6eecafee52',
                              height: 35,
                              width: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(0, 70.0 * controller.value),
                        child: child,
                      ),
                    ],
                  );
                },
              );
            },
            child: SafeArea(
              child: SizedBox(
                height: height * 0.92,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        color: const Color(0xFF010101),
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        height: 45.h,
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 45.h,
                                viewportFraction: 1,
                                autoPlay: false,
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
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        height: height * 0.0415,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: AutoSizeText(
                                      'News Feed',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: _selectedIndex == 0
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                    ),
                                    width: 35,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 0
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: AutoSizeText(
                                      'Bitcoin',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: _selectedIndex == 1
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                    ),
                                    width: 35,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 1
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: AutoSizeText(
                                      'Ethereum',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: _selectedIndex == 2
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                    ),
                                    width: 35,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 2
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 3;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: AutoSizeText(
                                      'NFT',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: _selectedIndex == 3
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                    ),
                                    width: 35,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 3
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 4;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: AutoSizeText(
                                      'Metaverse',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: _selectedIndex == 4
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                    ),
                                    width: 35,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == 4
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<NewsProvider>(
                      builder: (ctx, model, _) => (_selectedIndex == 0
                              ? model.newsCompleteList.isEmpty
                              : _selectedIndex == 1
                                  ? model.bitcoinNewsList.isEmpty
                                  : _selectedIndex == 2
                                      ? model.ethereumNewsList.isEmpty
                                      : _selectedIndex == 3
                                          ? model.nftNewsList.isEmpty
                                          : model.metaverseNewsList.isEmpty)
                          ? SliverFillRemaining(
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/animation_500_kvhmucnx.gif?alt=media&token=8321a796-0c25-433b-ae46-b1db4467a32e',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (ctx, index) {
                                  return Container(
                                    margin: EdgeInsets.all(0.4.w),
                                    child: Column(
                                      children: [
                                        AnimationLimiter(
                                          child: index == 10
                                              ? Container(
                                                  margin: EdgeInsets.all(0.4.w),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        () =>
                                                            SeeAllNewsScreen(),
                                                      );
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "See all",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : AnimationConfiguration
                                                  .staggeredList(
                                                  position: index,
                                                  duration: const Duration(
                                                    milliseconds: 375,
                                                  ),
                                                  child: SlideAnimation(
                                                    horizontalOffset: 150,
                                                    child: FadeInAnimation(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Provider.of<
                                                                  NewsProvider>(
                                                            context,
                                                            listen: false,
                                                          )
                                                              .getNewsReadCount(
                                                            _selectedIndex == 0
                                                                ? model
                                                                    .newsCompleteList[
                                                                        index]
                                                                    .title
                                                                : _selectedIndex ==
                                                                        1
                                                                    ? model
                                                                        .bitcoinNewsList[
                                                                            index]
                                                                        .title
                                                                    : _selectedIndex ==
                                                                            2
                                                                        ? model
                                                                            .ethereumNewsList[
                                                                                index]
                                                                            .title
                                                                        : _selectedIndex ==
                                                                                3
                                                                            ? model.nftNewsList[index].title
                                                                            : model.metaverseNewsList[index].title,
                                                            _selectedIndex == 0
                                                                ? model
                                                                    .newsCompleteList[
                                                                        index]
                                                                    .source
                                                                : _selectedIndex ==
                                                                        1
                                                                    ? model
                                                                        .bitcoinNewsList[
                                                                            index]
                                                                        .source
                                                                    : _selectedIndex ==
                                                                            2
                                                                        ? model
                                                                            .ethereumNewsList[
                                                                                index]
                                                                            .source
                                                                        : _selectedIndex ==
                                                                                3
                                                                            ? model.nftNewsList[index].source
                                                                            : model.metaverseNewsList[index].source,
                                                          )
                                                              .then((value) {
                                                            Get.to(
                                                              () =>
                                                                  NewsSummaryScreen(
                                                                _selectedIndex ==
                                                                        0
                                                                    ? model.newsCompleteList[
                                                                        index]
                                                                    : _selectedIndex ==
                                                                            1
                                                                        ? model.bitcoinNewsList[
                                                                            index]
                                                                        : _selectedIndex ==
                                                                                2
                                                                            ? model.ethereumNewsList[index]
                                                                            : _selectedIndex == 3
                                                                                ? model.nftNewsList[index]
                                                                                : model.metaverseNewsList[index],
                                                                value,
                                                              ),
                                                            );
                                                          });
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 15,
                                                            bottom: 10,
                                                          ),
                                                          child: Card(
                                                            color: const Color(
                                                              0xFF010101,
                                                            ),
                                                            elevation: 0,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    15.0,
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        _helper
                                                                            .extractImgUrl(
                                                                      _selectedIndex ==
                                                                              0
                                                                          ? model
                                                                              .newsCompleteList[index]
                                                                              .photoUrl
                                                                          : _selectedIndex == 1
                                                                              ? model.bitcoinNewsList[index].photoUrl
                                                                              : _selectedIndex == 2
                                                                                  ? model.ethereumNewsList[index].photoUrl
                                                                                  : _selectedIndex == 3
                                                                                      ? model.nftNewsList[index].photoUrl
                                                                                      : model.metaverseNewsList[index].photoUrl,
                                                                    ),
                                                                    placeholder:
                                                                        (
                                                                      ctx,
                                                                      _,
                                                                    ) {
                                                                      return const BlurHash(
                                                                        imageFit:
                                                                            BoxFit.fitWidth,
                                                                        duration:
                                                                            Duration(seconds: 3),
                                                                        curve: Curves
                                                                            .bounceInOut,
                                                                        hash:
                                                                            "L5H2EC=PM+yV0g-mq.wG9c010J}I",
                                                                      );
                                                                    },
                                                                    errorWidget: (
                                                                      context,
                                                                      url,
                                                                      error,
                                                                    ) =>
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    height:
                                                                        height *
                                                                            0.09,
                                                                    width:
                                                                        width *
                                                                            0.21,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 15,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(
                                                                            bottom:
                                                                                7,
                                                                          ),
                                                                          child:
                                                                              AutoSizeText(
                                                                            _selectedIndex == 0
                                                                                ? model.newsCompleteList[index].title
                                                                                : _selectedIndex == 1
                                                                                    ? model.bitcoinNewsList[index].title
                                                                                    : _selectedIndex == 2
                                                                                        ? model.ethereumNewsList[index].title
                                                                                        : _selectedIndex == 3
                                                                                            ? model.nftNewsList[index].title
                                                                                            : model.metaverseNewsList[index].title,
                                                                            maxLines:
                                                                                2,
                                                                            style:
                                                                                GoogleFonts.poppins(
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
                                                                                _selectedIndex == 0
                                                                                    ? model.newsCompleteList[index].description
                                                                                    : _selectedIndex == 1
                                                                                        ? model.bitcoinNewsList[index].description
                                                                                        : _selectedIndex == 2
                                                                                            ? model.ethereumNewsList[index].description
                                                                                            : _selectedIndex == 3
                                                                                                ? model.nftNewsList[index].description
                                                                                                : model.metaverseNewsList[index].description,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                softWrap: false,
                                                                                style: GoogleFonts.rubik(
                                                                                  color: const Color(0xFF757575),
                                                                                  fontSize: 15,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: <Widget>[
                                                                                AutoSizeText(
                                                                                  "${_helper.convertToAgo(
                                                                                    _selectedIndex == 0
                                                                                        ? model.newsCompleteList[index].publishedDate
                                                                                        : _selectedIndex == 1
                                                                                            ? model.bitcoinNewsList[index].publishedDate
                                                                                            : _selectedIndex == 2
                                                                                                ? model.ethereumNewsList[index].publishedDate
                                                                                                : _selectedIndex == 3
                                                                                                    ? model.nftNewsList[index].publishedDate
                                                                                                    : model.metaverseNewsList[index].publishedDate,
                                                                                  )}  \u2022",
                                                                                  maxLines: 1,
                                                                                  style: GoogleFonts.poppins(
                                                                                    color: const Color(
                                                                                      0xFF757575,
                                                                                    ),
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                                Flexible(
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.only(
                                                                                      left: 5,
                                                                                    ),
                                                                                    child: AutoSizeText(
                                                                                      _selectedIndex == 0
                                                                                          ? model.newsCompleteList[index].source
                                                                                          : _selectedIndex == 1
                                                                                              ? model.bitcoinNewsList[index].source
                                                                                              : _selectedIndex == 2
                                                                                                  ? model.ethereumNewsList[index].source
                                                                                                  : _selectedIndex == 3
                                                                                                      ? model.nftNewsList[index].source
                                                                                                      : model.metaverseNewsList[index].source,
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: GoogleFonts.poppins(
                                                                                        color: const Color(
                                                                                          0xFF757575,
                                                                                        ),
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w500,
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
                                                ),
                                        ),
                                        Divider(
                                          indent: width * 0.28,
                                          endIndent: width * 0.04,
                                          thickness: 1,
                                          height: 1,
                                          color: index == 10
                                              ? Colors.transparent
                                              : const Color(0xFF404040),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                childCount: 11,
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
  }

  @override
  bool get wantKeepAlive => true;
}
