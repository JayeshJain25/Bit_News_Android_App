import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/news_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  final _helper = Helper();

  double getDescriptionLength(int lengthOfDesc) {
    if (lengthOfDesc > 100) {
      return 7;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(pagination);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.newsList.length,
      itemBuilder: (ctx, index) => AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          horizontalOffset: 150,
          child: FadeInAnimation(
            child: Consumer<NewsProvider>(
              builder: (ctx, model, _) => InkWell(
                onTap: () {
                  Get.to(
                    () => NewsSummaryScreen(
                      widget.newsList[index],
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
                              widget.newsList[index].photoUrl,
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
                              widget.newsList[index].title,
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
                                    widget.newsList[index].description.length,
                                  ),
                                ),
                                child: AutoSizeText(
                                  widget.newsList[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF757575),
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
                                        widget.newsList[index].publishedDate,
                                      )} \u2022",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF757575),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  AutoSizeText(
                                    widget.newsList[index].source,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF757575),
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
    );
  }
}
