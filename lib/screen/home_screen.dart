import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/crypto_explainer_screen.dart';
import 'package:crypto_news/screen/market_data_screen.dart';
import 'package:crypto_news/screen/notification_screen.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:crypto_news/widget/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'news_summary_screen.dart';

class HomeScreen extends StatefulWidget {
  final TabController tabController;
  const HomeScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

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

    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .cryptoMarketDataByPagination(1);

    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .getTrendingCoins();

    Provider.of<NewsProvider>(context, listen: false).getNewsFeed(1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF010101),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height * 0.92,
            child: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: const Color(0xFF010101),
                    actions: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 20, top: 5),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => NotificationScreen());
                          },
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                    title: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          AutoSizeText(
                            'CryptoX',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                          height: 100,
                          child: Column(
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: 'Hi, ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: user!.displayName,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF52CAF5),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      'Head Over To Our News Section For the Latest News Of The ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Cryptocurrency Market',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF52CAF5),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 160,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xFF1d1d1d),
                                        border: Border.all(
                                          color: Colors.white10.withAlpha(40),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withAlpha(100),
                                            blurRadius: 7.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      height: 60,
                                      width: 160,
                                      child: Center(
                                        // child: Row(
                                        //   children: [
                                        // CachedNetworkImage(
                                        //   imageUrl:
                                        //       "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/portfolio.png?alt=media&token=0e6f0637-7ce9-4b3a-83ce-8354c7710326",
                                        //   fit: BoxFit.cover,
                                        // ),
                                        child: AutoSizeText(
                                          "Portfolio",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        // ],
                                        //),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xFF1d1d1d),
                                        border: Border.all(
                                          color: Colors.white10.withAlpha(40),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withAlpha(100),
                                            blurRadius: 7.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      height: 60,
                                      width: 160,
                                      child: Center(
                                        child: AutoSizeText(
                                          "Conversion",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xFF1d1d1d),
                                        border: Border.all(
                                          color: Colors.white10.withAlpha(40),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withAlpha(100),
                                            blurRadius: 7.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      height: 60,
                                      width: 160,
                                      child: Center(
                                        child: AutoSizeText(
                                          "Price Alert",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => CryptoExplainerScreen());
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: const Color(0xFF1d1d1d),
                                          border: Border.all(
                                            color: Colors.white10.withAlpha(0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.white.withAlpha(100),
                                              blurRadius: 7.0,
                                              spreadRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                        ),
                                        height: 60,
                                        width: 160,
                                        child: Center(
                                          child: AutoSizeText(
                                            "Watch List",
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 32),
                              child: AutoSizeText(
                                "Coins",
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                widget.tabController.index = 1;
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 32),
                                child: AutoSizeText(
                                  "See All",
                                  style: GoogleFonts.rubik(
                                    color: const Color(0xFF52CAF5),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Consumer<CryptoMarketDataProvider>(
                          builder: (ctx, model, _) => model.listModel.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    left: 5,
                                    right: 5,
                                  ),
                                  height: height * 0.15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 10,
                                    itemBuilder: (ctx, index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => MarketDataScreen(
                                                model.listModel[index]),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 5,
                                          ),
                                          height: height * 0.15,
                                          width: width * 0.42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: const Color(0xFF1d1d1d),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                  top: 10,
                                                ),
                                                width: width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                        model.listModel[index]
                                                            .image,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                          left: width * 0.06,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 3,
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: model
                                                                            .listModel[index]
                                                                            .priceChangePercentage24h >=
                                                                        0
                                                                    ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                                    : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 10,
                                                                width: 10,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.01,
                                                            ),
                                                            AutoSizeText(
                                                              model.listModel[index]
                                                                          .priceChangePercentage24h >=
                                                                      0
                                                                  ? "+${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                                  : "${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                color: model.listModel[index]
                                                                            .priceChangePercentage24h >
                                                                        0
                                                                    ? const Color(
                                                                        0xFF00a55b,
                                                                      )
                                                                    : const Color(
                                                                        0xFFd82e35,
                                                                      ),
                                                                fontSize: 17,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  bottom: height * 0.01,
                                                ),
                                                child: AutoSizeText(
                                                  model.listModel[index].name,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                  "\u{20B9} ${model.listModel[index].price.toString().startsWith("0.") ? model.listModel[index].price.toString() : _helper.removeDecimal(model.listModel[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                  maxLines: 1,
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Container(
                            margin: const EdgeInsets.only(left: 32),
                            child: AutoSizeText(
                              "Top Trending",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Consumer<CryptoMarketDataProvider>(
                          builder: (ctx, model, _) => model
                                  .trendingCoins.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    left: 5,
                                    right: 5,
                                  ),
                                  height: height * 0.15,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 7,
                                    itemBuilder: (ctx, index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => MarketDataScreen(
                                              model.trendingCoins[index],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.only(
                                            left: 20,
                                            right: 5,
                                          ),
                                          height: height * 0.15,
                                          width: width * 0.42,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: const Color(0xFF1d1d1d),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                  top: 10,
                                                ),
                                                width: width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                        model
                                                            .trendingCoins[
                                                                index]
                                                            .image,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                          left: width * 0.06,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 3,
                                                              ),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: model
                                                                            .trendingCoins[index]
                                                                            .priceChangePercentage24h >=
                                                                        0
                                                                    ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                                    : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 10,
                                                                width: 10,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  width * 0.01,
                                                            ),
                                                            AutoSizeText(
                                                              model.trendingCoins[index]
                                                                          .priceChangePercentage24h >=
                                                                      0
                                                                  ? "+${model.trendingCoins[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                                  : "${model.trendingCoins[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                                              maxLines: 1,
                                                              minFontSize: 14,
                                                              style: GoogleFonts
                                                                  .rubik(
                                                                color: model.trendingCoins[index]
                                                                            .priceChangePercentage24h >
                                                                        0
                                                                    ? const Color(
                                                                        0xFF00a55b,
                                                                      )
                                                                    : const Color(
                                                                        0xFFd82e35,
                                                                      ),
                                                                fontSize: 17,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  bottom: height * 0.01,
                                                ),
                                                child: AutoSizeText(
                                                  model.trendingCoins[index]
                                                      .name,
                                                  maxLines: 2,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: AutoSizeText(
                                                  "\u{20B9} ${model.trendingCoins[index].price.toString().startsWith("0.") ? model.trendingCoins[index].price.toString() : _helper.removeDecimal(model.trendingCoins[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                  maxLines: 1,
                                                  style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 25,
                            left: 25,
                            right: 25,
                          ),
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFF1d1d1d),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: AutoSizeText(
                              "Crypto Explainer",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
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
                                  width: 100,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: _selectedIndex == 0
                                        ? const Color(0xFF52CAF5)
                                        : const Color(0xFF010101),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      'Beginner',
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
                                  width: 100,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: _selectedIndex == 1
                                        ? const Color(0xFF52CAF5)
                                        : const Color(0xFF010101),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      'Intermediate',
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
                                  width: 100,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: _selectedIndex == 2
                                        ? const Color(0xFF52CAF5)
                                        : const Color(0xFF010101),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      'Expert',
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
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 23,
                            top: 15,
                            right: 23,
                          ),
                          width: 347,
                          height: 270,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                25,
                              ),
                            ),
                            elevation: 0,
                            color: const Color(0xFF121212),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://coindesk-coindesk-prod.cdn.arcpublishing.com/resizer/nkZ1E8g3-bBKCgOD6w5Bj5UYrpI=/400x300/filters:format(jpg):quality(70)/cloudfront-us-east-1.images.arcpublishing.com/coindesk/LTBLXH2ZPBBHZNVZAMFZDHHYHU.jpg",
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "lib/assets/logo.png",
                                      fit: BoxFit.cover,
                                    ),
                                    height: 150,
                                    width: 500,
                                  ),
                                ),
                                ListTile(
                                  title: Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 7,
                                      top: 7,
                                    ),
                                    child: AutoSizeText(
                                      "What Is Bitcoin?",
                                      maxLines: 2,
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 7,
                                        ),
                                        child: AutoSizeText(
                                          "In 2008, a pseudonymous programmer named Satoshi Nakamoto published a 9-page document outlining a new decentralized, digital currency. They called it Bitcoin.",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      AutoSizeText(
                                        "By Andrey Sergeenkov",
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Container(
                            margin: const EdgeInsets.only(left: 32),
                            child: AutoSizeText(
                              "Top News",
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: Container(
                margin: EdgeInsets.all(width * 0.04),
                child: Consumer<NewsProvider>(
                  builder: (ctx, model, _) => model.newsCompleteList.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: 9,
                          itemBuilder: (ctx, index) => index == 8
                              ? Container(
                                  margin: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => SeeAllNewsScreen());
                                    },
                                    child: Center(
                                      child: Text(
                                        "See all",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => NewsSummaryScreen(
                                        model.newsCompleteList[index],
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Hero(
                                              tag: model.newsCompleteList[index]
                                                  .title,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: _helper.extractImgUrl(
                                                  model.newsCompleteList[index]
                                                      .photoUrl,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CachedNetworkImage(
                                                  imageUrl:
                                                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                                                  fit: BoxFit.cover,
                                                ),
                                                height: height * 0.2,
                                                width: width * 0.81,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 7,
                                                top: 7,
                                              ),
                                              child: AutoSizeText(
                                                model.newsCompleteList[index]
                                                    .title,
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
                                                    bottom:
                                                        getDescriptionLength(
                                                      model
                                                          .newsCompleteList[
                                                              index]
                                                          .description
                                                          .length,
                                                    ),
                                                  ),
                                                  child: AutoSizeText(
                                                    model
                                                        .newsCompleteList[index]
                                                        .description,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                        0xFF757575,
                                                      ),
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
                                                      child: AutoSizeText(
                                                        "${_helper.convertToAgo(
                                                          model
                                                              .newsCompleteList[
                                                                  index]
                                                              .publishedDate,
                                                        )} \u2022",
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                            0xFF757575,
                                                          ),
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      model
                                                          .newsCompleteList[
                                                              index]
                                                          .source,
                                                      maxLines: 1,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: const Color(
                                                          0xFF757575,
                                                        ),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
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
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
