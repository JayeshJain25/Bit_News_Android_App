import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/crypto_explainer_provider.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/crypto_explainer_screen.dart';
import 'package:crypto_news/screen/market_data_screen.dart';
import 'package:crypto_news/screen/notification_screen.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:crypto_news/screen/watch_list_screen.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'conversion_tool_screen.dart';
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

  late Animation<Offset> _storiesAnimation;
  late Animation<double> reverse;
  late Animation<double> base;
  late Animation<double> gap;
  late AnimationController controller;
  late AnimationController _animationController;
  List<String> imageUrlList = [
    "https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png",
    "https://assets.coingecko.com/coins/images/13120/large/Logo_final-21.png?1624892810",
    "https://assets.coingecko.com/coins/images/756/large/nano-coin-logo.png?1547034501",
    "https://assets.coingecko.com/coins/images/776/large/OMG_Network.jpg?1591167168",
    "https://assets.coingecko.com/coins/images/63/large/digibyte.png?1547033717",
    "https://assets.coingecko.com/coins/images/13725/large/xsushi.png?1612538526",
    "https://assets.coingecko.com/coins/images/1060/large/icon-icx-logo.png?1547035003"
  ];

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

    Provider.of<CryptoExplainerProvider>(context, listen: false)
        .getcryptoExplainerByType("Bitcoin");

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

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF010101),
      body: CustomRefreshIndicator(
        onRefresh: () {
          setState(() {
            Provider.of<CryptoMarketDataProvider>(context, listen: false)
                .listModel
                .clear();

            Provider.of<CryptoMarketDataProvider>(context, listen: false)
                .cryptoMarketDataByPagination(1);

            Provider.of<CryptoMarketDataProvider>(context, listen: false)
                .getTrendingCoins();

            Provider.of<NewsProvider>(context, listen: false)
                .newsCompleteList
                .clear();
            Provider.of<NewsProvider>(context, listen: false).getNewsFeed(1);

            Provider.of<CryptoExplainerProvider>(context, listen: false)
                .getcryptoExplainerByType("Bitcoin");
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
            height: height * 0.92,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: const Color(0xFF010101),
                  actions: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 20, top: 20),
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
                    margin: const EdgeInsets.only(top: 20),
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
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    height: 75,
                    child: SizedBox(
                      height: 70,
                      child: ListView.builder(
                        itemCount: imageUrlList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) => Container(
                          margin: EdgeInsets.only(
                            left: 1.5.w,
                            right: 1.5.w,
                          ),
                          child: SlideTransition(
                            position: _storiesAnimation,
                            child: Center(
                              child: RotationTransition(
                                turns: base,
                                child: DashedCircle(
                                  gapSize: gap.value,
                                  dashes: 40,
                                  color: const Color(0xFF4E8799),
                                  child: RotationTransition(
                                    turns: reverse,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                        radius: 23,
                                        backgroundImage: NetworkImage(
                                          imageUrlList[index],
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
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF292f33),
                                ),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                height: 60,
                                width: 160,
                                child: Center(
                                  child: AutoSizeText(
                                    "Portfolio",
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
                                  Get.to(() => ConversionToolScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFF292f33),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF292f33),
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
                                  Get.to(() => WatchListScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFF292f33),
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
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          left: 32,
                        ),
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
                ),
                SliverToBoxAdapter(
                  child: Consumer<CryptoMarketDataProvider>(
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
                                        model.listModel[index],
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
                                      borderRadius: BorderRadius.circular(25),
                                      color: const Color(0xFF292f33),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  model.listModel[index].image,
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
                                                        margin: const EdgeInsets
                                                            .only(
                                                          left: 3,
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model
                                                                      .listModel[
                                                                          index]
                                                                      .priceChangePercentage24h >=
                                                                  0
                                                              ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                              : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                          fit: BoxFit.cover,
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      AutoSizeText(
                                                        model.listModel[index]
                                                                    .priceChangePercentage24h >=
                                                                0
                                                            ? "+${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                            : "${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: model
                                                                      .listModel[
                                                                          index]
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
                                                            TextAlign.center,
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
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
                ),
                SliverToBoxAdapter(
                  child: Consumer<CryptoMarketDataProvider>(
                    builder: (ctx, model, _) => model.trendingCoins.isEmpty
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
                                      borderRadius: BorderRadius.circular(25),
                                      color: const Color(0xFF292f33),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 15,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  model.trendingCoins[index]
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
                                                        margin: const EdgeInsets
                                                            .only(
                                                          left: 3,
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: model
                                                                      .trendingCoins[
                                                                          index]
                                                                      .priceChangePercentage24h >=
                                                                  0
                                                              ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                              : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                          fit: BoxFit.cover,
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.01,
                                                      ),
                                                      AutoSizeText(
                                                        model.trendingCoins[index]
                                                                    .priceChangePercentage24h >=
                                                                0
                                                            ? "+${model.trendingCoins[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                            : "${model.trendingCoins[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                                        maxLines: 1,
                                                        minFontSize: 14,
                                                        style:
                                                            GoogleFonts.rubik(
                                                          color: model
                                                                      .trendingCoins[
                                                                          index]
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
                                                            TextAlign.center,
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
                                            model.trendingCoins[index].name,
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
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.04,
                    ),
                    child: Divider(
                      indent: width * 0.037,
                      endIndent: width * 0.037,
                      thickness: 1,
                      height: 1,
                      color: const Color(0xFF292f33),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Container(
                      margin: const EdgeInsets.only(left: 32),
                      child: AutoSizeText(
                        "Crypto Explainer",
                        style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
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
                ),
                SliverToBoxAdapter(
                  child: Consumer<CryptoExplainerProvider>(
                    builder: (ctx, data, _) {
                      return data.listModel.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : InkWell(
                              onTap: () {
                                Get.to(
                                  () => CryptoExplainerScreen(
                                    _selectedIndex == 0
                                        ? data.listModel[0]
                                        : _selectedIndex == 1
                                            ? data.listModel[1]
                                            : data.listModel[2],
                                  ),
                                );
                              },
                              child: Container(
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
                                          imageUrl: _selectedIndex == 0
                                              ? data.listModel[0].imgUrl
                                              : _selectedIndex == 1
                                                  ? data.listModel[1].imgUrl
                                                  : data.listModel[2].imgUrl,
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
                                            _selectedIndex == 0
                                                ? data.listModel[0].title
                                                : _selectedIndex == 1
                                                    ? data.listModel[1].title
                                                    : data.listModel[2].title,
                                            maxLines: 2,
                                            style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontSize: 20,
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
                                                _selectedIndex == 0
                                                    ? data.listModel[0]
                                                        .description
                                                    : _selectedIndex == 1
                                                        ? data.listModel[1]
                                                            .description
                                                        : data.listModel[2]
                                                            .description,
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
                                              "By ${_selectedIndex == 0 ? data.listModel[0].author : _selectedIndex == 1 ? data.listModel[1].author : data.listModel[2].author}",
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
                            );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.02,
                    ),
                    child: Divider(
                      indent: width * 0.037,
                      endIndent: width * 0.037,
                      thickness: 1,
                      height: 1,
                      color: const Color(0xFF292f33),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
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
                ),
                Consumer<NewsProvider>(
                  builder: (ctx, model, _) => model.newsCompleteList.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, index) {
                              return index == 8
                                  ? GestureDetector(
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
                                        margin: EdgeInsets.all(width * 0.04),
                                        child: Card(
                                          elevation: 0,
                                          color: const Color(0xFF010101),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      _helper.extractImgUrl(
                                                    model
                                                        .newsCompleteList[index]
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
                                              ListTile(
                                                title: Container(
                                                  margin: const EdgeInsets.only(
                                                    bottom: 7,
                                                    top: 7,
                                                  ),
                                                  child: AutoSizeText(
                                                    model
                                                        .newsCompleteList[index]
                                                        .title,
                                                    maxLines: 2,
                                                    style: GoogleFonts.poppins(
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
                                                            .newsCompleteList[
                                                                index]
                                                            .description,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: false,
                                                        style:
                                                            GoogleFonts.poppins(
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
                                                            style: GoogleFonts
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
                                                          model
                                                              .newsCompleteList[
                                                                  index]
                                                              .source,
                                                          maxLines: 1,
                                                          style: GoogleFonts
                                                              .poppins(
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
                                    );
                            },
                            childCount: 9,
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

  @override
  bool get wantKeepAlive => true;
}
