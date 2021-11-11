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
                      top: 20.0 * controller.value,
                      child: SizedBox(
                        height: 80,
                        width: width,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/57735-crypto-coins.gif?alt=media&token=a696da3c-4285-4479-aade-1d65ee4ec2ad',
                          height: 35,
                          width: 40,
                          fit: BoxFit.cover,
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
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
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
                SliverAppBar(
                  backgroundColor: const Color(0xFF010101),
                  automaticallyImplyLeading: false,
                  floating: true,
                  pinned: true,
                  flexibleSpace: Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                            child: Container(
                              width: 90,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: _selectedIndex == 0
                                    ? const Color(0xFF52CAF5)
                                    : const Color(0xFF010101),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  'News Feed',
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedIndex == 0
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                            child: Container(
                              width: 75,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: _selectedIndex == 1
                                    ? const Color(0xFF52CAF5)
                                    : const Color(0xFF010101),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  'Bitcoin',
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedIndex == 1
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 2;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: _selectedIndex == 2
                                    ? const Color(0xFF52CAF5)
                                    : const Color(0xFF010101),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  'Ethereum',
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedIndex == 2
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            },
                            child: Container(
                              width: 55,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: _selectedIndex == 3
                                    ? const Color(0xFF52CAF5)
                                    : const Color(0xFF010101),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  'NFT',
                                  maxLines: 1,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w600,
                                    color: _selectedIndex == 3
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                  : model.nftNewsList.isEmpty)
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
                                  builder: (ctx, model, _) =>
                                      AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(
                                      milliseconds: 375,
                                    ),
                                    child: SlideAnimation(
                                      horizontalOffset: 150,
                                      child: FadeInAnimation(
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                              () => NewsSummaryScreen(
                                                _selectedIndex == 0
                                                    ? model
                                                        .newsCompleteList[index]
                                                    : _selectedIndex == 1
                                                        ? model.bitcoinNewsList[
                                                            index]
                                                        : _selectedIndex == 2
                                                            ? model.ethereumNewsList[
                                                                index]
                                                            : model.nftNewsList[
                                                                index],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.all(width * 0.04),
                                            child: Card(
                                              elevation: 0,
                                              color: const Color(0xFF010101),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          _helper.extractImgUrl(
                                                        _selectedIndex == 0
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
                                                                        .ethereumNewsList[
                                                                            index]
                                                                        .photoUrl
                                                                    : model
                                                                        .nftNewsList[
                                                                            index]
                                                                        .photoUrl,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      height: height * 0.2,
                                                      width: width * 0.81,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        bottom: 7,
                                                        top: 7,
                                                      ),
                                                      child: AutoSizeText(
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
                                                                    : model
                                                                        .nftNewsList[
                                                                            index]
                                                                        .title,
                                                        maxLines: 2,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
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
                                                                      ? model
                                                                          .bitcoinNewsList[
                                                                              index]
                                                                          .description
                                                                          .length
                                                                      : _selectedIndex ==
                                                                              2
                                                                          ? model
                                                                              .ethereumNewsList[
                                                                                  index]
                                                                              .description
                                                                              .length
                                                                          : model
                                                                              .nftNewsList[index]
                                                                              .description
                                                                              .length,
                                                            ),
                                                          ),
                                                          child: AutoSizeText(
                                                            _selectedIndex == 0
                                                                ? model
                                                                    .newsCompleteList[
                                                                        index]
                                                                    .description
                                                                : _selectedIndex ==
                                                                        1
                                                                    ? model
                                                                        .bitcoinNewsList[
                                                                            index]
                                                                        .description
                                                                    : _selectedIndex ==
                                                                            2
                                                                        ? model
                                                                            .ethereumNewsList[
                                                                                index]
                                                                            .description
                                                                        : model
                                                                            .nftNewsList[index]
                                                                            .description,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color: const Color(
                                                                  0xFF757575),
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                "${_helper.convertToAgo(
                                                                  _selectedIndex ==
                                                                          0
                                                                      ? model
                                                                          .newsCompleteList[
                                                                              index]
                                                                          .publishedDate
                                                                      : _selectedIndex ==
                                                                              1
                                                                          ? model
                                                                              .bitcoinNewsList[index]
                                                                              .publishedDate
                                                                          : _selectedIndex == 2
                                                                              ? model.ethereumNewsList[index].publishedDate
                                                                              : model.nftNewsList[index].publishedDate,
                                                                )} \u2022",
                                                                maxLines: 1,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color:
                                                                      const Color(
                                                                    0xFF757575,
                                                                  ),
                                                                  fontSize: 15,
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
                                                                          : model
                                                                              .nftNewsList[index]
                                                                              .source,
                                                              maxLines: 1,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color:
                                                                    const Color(
                                                                  0xFF757575,
                                                                ),
                                                                fontSize: 15,
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
                                ? model.newsCompleteList.length
                                : _selectedIndex == 1
                                    ? model.bitcoinNewsList.length
                                    : _selectedIndex == 2
                                        ? model.ethereumNewsList.length
                                        : model.nftNewsList.length,
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
