import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/news_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './news_web_view.dart';

class FollowingListAllSection extends StatefulWidget {
  final List<NewsModel> newsList;
  final String newsValue;

  const FollowingListAllSection({
    required this.newsList,
    required this.newsValue,
  });

  @override
  State<FollowingListAllSection> createState() =>
      _FollowingListAllSectionState();
}

class _FollowingListAllSectionState extends State<FollowingListAllSection> {
  final _scrollController = ScrollController();

  late int page = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(pagination);
  }

  void pagination() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
        if (widget.newsValue == "all") {
          Provider.of<NewsProvider>(context, listen: false)
              .getNewsFeed(page + 1)
              .then(
                (value) => {isLoading = false},
              );
        } else if (widget.newsValue == "bitcoin") {
          Provider.of<NewsProvider>(context, listen: false)
              .getBitcoinNews(page + 1)
              .then(
                (value) => {isLoading = false},
              );
        } else if (widget.newsValue == "ethereum") {
          Provider.of<NewsProvider>(context, listen: false)
              .getEthereumNews(page + 1)
              .then(
                (value) => {isLoading = false},
              );
        } else if (widget.newsValue == "nft") {
          Provider.of<NewsProvider>(context, listen: false)
              .getNFTNews(page + 1)
              .then(
                (value) => {isLoading = false},
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _TodayNewsList(index: 0, newsList: widget.newsList),
        // const _RecentNewsList(index: 1),
      ],
    );
  }
}

class _TodayNewsList extends StatelessWidget {
  _TodayNewsList({Key? key, this.index, required this.newsList})
      : super(key: key);

  final int? index;
  final List<NewsModel> newsList;
  final _helper = Helper();

  double getDescriptionLength(int lengthOfDesc) {
    if (lengthOfDesc > 100) {
      return 7;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SliverStickyHeader.builder(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 150,
              child: FadeInAnimation(
                child: Consumer<NewsProvider>(
                  builder: (ctx, model, _) => InkWell(
                    onTap: () {
                      Get.to(
                        () => NewsSummaryScreen(
                          newsList[i],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFF010101),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _helper.extractImgUrl(
                                  newsList[i].photoUrl,
                                ),
                                errorWidget: (context, url, error) =>
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
                                margin: const EdgeInsets.only(
                                  bottom: 7,
                                  top: 7,
                                ),
                                child: AutoSizeText(
                                  newsList[i].title,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: getDescriptionLength(
                                        newsList[i].description.length,
                                      ),
                                    ),
                                    child: AutoSizeText(
                                      newsList[i].description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: AutoSizeText(
                                          "${_helper.convertToAgo(
                                            newsList[i].publishedDate,
                                          )} \u2022",
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      AutoSizeText(
                                        newsList[i].source,
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
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
          childCount: newsList.length,
        ),
      ),
      builder: (BuildContext context, SliverStickyHeaderState state) =>
          Container(
        height: 40.0,
        color:
            const Color(0xFF010101).withOpacity(1.0 - state.scrollPercentage),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'TODAY',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SliverStickyHeader.builder(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 150,
              child: FadeInAnimation(
                child: Consumer<NewsProvider>(
                  builder: (ctx, model, _) => InkWell(
                    onTap: () {
                      Get.to(() => NewsWebView(model.newsCompleteList[i].url));
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.black,
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: height * 0.04,
                                width: width * 0.1,
                                child: const Image(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: width * 0.027,
                                  top: width * 0.015,
                                ),
                                width: width * 0.1,
                                height: height * 0.025,
                                child: AutoSizeText(
                                  'BTC',
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: const Color(0xFF6a6a6a),
                                  ),
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
                                ),
                              ),
                              SizedBox(
                                width: width * 0.72,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  "Bitcoin Ransomware Payments Set 'Dangerous Precedent': House Oversight Chair",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6a6a6a),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  "- 3 hours ago",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6a6a6a),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
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
        color:
            const Color(0xFF010101).withOpacity(1.0 - state.scrollPercentage),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'RECENT',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
