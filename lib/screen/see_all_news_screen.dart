import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'news_summary_screen.dart';

class SeeAllNewsScreen extends StatefulWidget {
  @override
  _SeeAllNewsScreenState createState() => _SeeAllNewsScreenState();
}

class _SeeAllNewsScreenState extends State<SeeAllNewsScreen> {
  int _selectedIndex = 0;

  final _scrollController = ScrollController();

  late int page = 0;
  final _helper = Helper();

  double getDescriptionLength(int lengthOfDesc) {
    if (lengthOfDesc > 100) {
      return 7;
    } else {
      return 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void pagination() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
        if (_selectedIndex == 0) {
          Provider.of<NewsProvider>(context, listen: false)
              .getNewsFeed(page + 1);
        } else if (_selectedIndex == 1) {
          Provider.of<NewsProvider>(context, listen: false)
              .getBitcoinNews(page + 1);
        } else if (_selectedIndex == 2) {
          Provider.of<NewsProvider>(context, listen: false)
              .getEthereumNews(page + 1);
        } else if (_selectedIndex == 3) {
          Provider.of<NewsProvider>(context, listen: false)
              .getNFTNews(page + 1);
        } else if (_selectedIndex == 4) {
          Provider.of<NewsProvider>(context, listen: false)
              .getMetaverseNews(page + 1);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(pagination);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF010101),
      body: CustomRefreshIndicator(
        onRefresh: () {
          setState(() {
            page = 0;
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

            Provider.of<NewsProvider>(context, listen: false).getNewsFeed(1);
            Provider.of<NewsProvider>(context, listen: false).getBitcoinNews(1);
            Provider.of<NewsProvider>(context, listen: false)
                .getEthereumNews(1);
            Provider.of<NewsProvider>(context, listen: false).getNFTNews(1);
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
            height: height,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: const Color(0xFF0c090a),
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
                SliverAppBar(
                  backgroundColor: const Color(0xFF0c090a),
                  automaticallyImplyLeading: false,
                  floating: true,
                  pinned: true,
                  flexibleSpace: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
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
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                width: 35,
                                height: 3,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _selectedIndex == 0
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                      blurRadius: 45.0, // soften the shadow
                                      spreadRadius: 3.0, //extend the shadow
                                      offset: const Offset(
                                        17.0,
                                        30.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
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
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                width: 35,
                                height: 3,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _selectedIndex == 1
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                      blurRadius: 45.0, // soften the shadow
                                      spreadRadius: 3.0, //extend the shadow
                                      offset: const Offset(
                                        17.0,
                                        30.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
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
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                width: 35,
                                height: 3,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _selectedIndex == 2
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                      blurRadius: 45.0, // soften the shadow
                                      spreadRadius: 3.0, //extend the shadow
                                      offset: const Offset(
                                        17.0,
                                        30.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
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
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                width: 35,
                                height: 3,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: _selectedIndex == 3
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                      blurRadius: 45.0, // soften the shadow
                                      spreadRadius: 3.0, //extend the shadow
                                      offset: const Offset(
                                        17.0,
                                        30.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                  color: _selectedIndex == 3
                                      ? const Color(0xFF52CAF5)
                                      : Colors.transparent,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
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
                              return AnimationLimiter(
                                child: Consumer<NewsProvider>(
                                  builder: (ctx, model, _) => (_selectedIndex ==
                                              0
                                          ? index ==
                                              model.newsCompleteList.length
                                          : _selectedIndex == 1
                                              ? index ==
                                                  model.bitcoinNewsList.length
                                              : _selectedIndex == 2
                                                  ? index ==
                                                      model.ethereumNewsList
                                                          .length
                                                  : _selectedIndex == 3
                                                      ? index ==
                                                          model.nftNewsList
                                                              .length
                                                      : index ==
                                                          model
                                                              .metaverseNewsList
                                                              .length)
                                      ? Center(
                                          child: Container(
                                            margin: EdgeInsets.all(
                                              width * 0.04,
                                            ),
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                        )
                                      : AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(
                                            milliseconds: 375,
                                          ),
                                          child: SlideAnimation(
                                            horizontalOffset: 150,
                                            child: FadeInAnimation(
                                              child: InkWell(
                                                onTap: () {
                                                  Provider.of<NewsProvider>(
                                                    context,
                                                    listen: false,
                                                  )
                                                      .getNewsReadCount(
                                                    _selectedIndex == 0
                                                        ? model
                                                            .newsCompleteList[
                                                                index]
                                                            .title
                                                        : _selectedIndex == 1
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
                                                                    ? model
                                                                        .nftNewsList[
                                                                            index]
                                                                        .title
                                                                    : model
                                                                        .metaverseNewsList[
                                                                            index]
                                                                        .title,
                                                    _selectedIndex == 0
                                                        ? model
                                                            .newsCompleteList[
                                                                index]
                                                            .source
                                                        : _selectedIndex == 1
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
                                                                    ? model
                                                                        .nftNewsList[
                                                                            index]
                                                                        .source
                                                                    : model
                                                                        .metaverseNewsList[
                                                                            index]
                                                                        .source,
                                                  )
                                                      .then((value) {
                                                    Get.to(
                                                      () => NewsSummaryScreen(
                                                        _selectedIndex == 0
                                                            ? model.newsCompleteList[
                                                                index]
                                                            : _selectedIndex ==
                                                                    1
                                                                ? model.bitcoinNewsList[
                                                                    index]
                                                                : _selectedIndex ==
                                                                        2
                                                                    ? model.ethereumNewsList[
                                                                        index]
                                                                    : _selectedIndex ==
                                                                            3
                                                                        ? model.nftNewsList[
                                                                            index]
                                                                        : model.metaverseNewsList[
                                                                            index],
                                                        value,
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                    width * 0.04,
                                                  ),
                                                  child: Card(
                                                    elevation: 0,
                                                    color: const Color(
                                                      0xFF010101,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            15.0,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: _helper
                                                                .extractImgUrl(
                                                              _selectedIndex ==
                                                                      0
                                                                  ? model
                                                                      .newsCompleteList[
                                                                          index]
                                                                      .photoUrl
                                                                  : _selectedIndex ==
                                                                          1
                                                                      ? model
                                                                          .bitcoinNewsList[
                                                                              index]
                                                                          .photoUrl
                                                                      : _selectedIndex ==
                                                                              2
                                                                          ? model
                                                                              .ethereumNewsList[index]
                                                                              .photoUrl
                                                                          : _selectedIndex == 3
                                                                              ? model.nftNewsList[index].photoUrl
                                                                              : model.metaverseNewsList[index].photoUrl,
                                                            ),
                                                            errorWidget: (
                                                              context,
                                                              url,
                                                              error,
                                                            ) =>
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                                                              fit: BoxFit.cover,
                                                            ),
                                                            height:
                                                                height * 0.2,
                                                            width: width * 0.81,
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                              bottom: 7,
                                                              top: 7,
                                                            ),
                                                            child: AutoSizeText(
                                                              _selectedIndex ==
                                                                      0
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
                                                                              .ethereumNewsList[index]
                                                                              .title
                                                                          : _selectedIndex == 3
                                                                              ? model.nftNewsList[index].title
                                                                              : model.metaverseNewsList[index].title,
                                                              maxLines: 2,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                          subtitle: Column(
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom:
                                                                      getDescriptionLength(
                                                                    _selectedIndex ==
                                                                            0
                                                                        ? model
                                                                            .newsCompleteList[
                                                                                index]
                                                                            .description
                                                                            .length
                                                                        : _selectedIndex ==
                                                                                1
                                                                            ? model.bitcoinNewsList[index].description.length
                                                                            : _selectedIndex == 2
                                                                                ? model.ethereumNewsList[index].description.length
                                                                                : _selectedIndex == 3
                                                                                    ? model.nftNewsList[index].description.length
                                                                                    : model.metaverseNewsList[index].description.length,
                                                                  ),
                                                                ),
                                                                child:
                                                                    AutoSizeText(
                                                                  _selectedIndex ==
                                                                          0
                                                                      ? model
                                                                          .newsCompleteList[
                                                                              index]
                                                                          .description
                                                                      : _selectedIndex ==
                                                                              1
                                                                          ? model
                                                                              .bitcoinNewsList[index]
                                                                              .description
                                                                          : _selectedIndex == 2
                                                                              ? model.ethereumNewsList[index].description
                                                                              : _selectedIndex == 3
                                                                                  ? model.nftNewsList[index].description
                                                                                  : model.metaverseNewsList[index].description,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color:
                                                                        const Color(
                                                                      0xFF757575,
                                                                    ),
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        AutoSizeText(
                                                                      "${_helper.convertToAgo(
                                                                        _selectedIndex ==
                                                                                0
                                                                            ? model.newsCompleteList[index].publishedDate
                                                                            : _selectedIndex == 1
                                                                                ? model.bitcoinNewsList[index].publishedDate
                                                                                : _selectedIndex == 2
                                                                                    ? model.ethereumNewsList[index].publishedDate
                                                                                    : _selectedIndex == 3
                                                                                        ? model.nftNewsList[index].publishedDate
                                                                                        : model.metaverseNewsList[index].publishedDate,
                                                                      )} \u2022",
                                                                      maxLines:
                                                                          1,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color:
                                                                            const Color(
                                                                          0xFF757575,
                                                                        ),
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  AutoSizeText(
                                                                    _selectedIndex ==
                                                                            0
                                                                        ? model
                                                                            .newsCompleteList[
                                                                                index]
                                                                            .source
                                                                        : _selectedIndex ==
                                                                                1
                                                                            ? model.bitcoinNewsList[index].source
                                                                            : _selectedIndex == 2
                                                                                ? model.ethereumNewsList[index].source
                                                                                : _selectedIndex == 3
                                                                                    ? model.nftNewsList[index].source
                                                                                    : model.metaverseNewsList[index].source,
                                                                    maxLines: 1,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      color:
                                                                          const Color(
                                                                        0xFF757575,
                                                                      ),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
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
                              );
                            },
                            childCount: _selectedIndex == 0
                                ? model.newsCompleteList.length + 1
                                : _selectedIndex == 1
                                    ? model.bitcoinNewsList.length + 1
                                    : _selectedIndex == 2
                                        ? model.ethereumNewsList.length + 1
                                        : _selectedIndex == 3
                                            ? model.nftNewsList.length + 1
                                            : model.metaverseNewsList.length +
                                                1,
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
