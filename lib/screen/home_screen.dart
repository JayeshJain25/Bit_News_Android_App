import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/helper/notification.dart';
import 'package:crypto_news/provider/crypto_explainer_provider.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/market_data_screen.dart';
import 'package:crypto_news/screen/notification_screen.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:crypto_news/screen/watch_list_screen.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'conversion_tool_screen.dart';
import 'crypto_explainer_home_screen.dart';
import 'news_summary_screen.dart';

class HomeScreen extends StatefulWidget {
  final TabController tabController;
  const HomeScreen({Key? key, required this.tabController}) : super(key: key);

  static const routeName = '/homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _helper = Helper();

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  void _changeData(String msg) => setState(() => notificationData = msg);
  void _changeBody(String msg) => setState(() => notificationBody = msg);
  void _changeTitle(String msg) => setState(() => notificationTitle = msg);

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

  Future<bool?> showExitPopup(double width, double height, User? user) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1110),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          content: SizedBox(
            height: height * 0.15,
            child: Column(
              children: [
                Text(
                  "Hey, ${user!.displayName}",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Are you sure ?",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade800,
                        ),
                        child: Text(
                          "Exit",
                          style: GoogleFonts.rubik(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF52CAF5),
                        ),
                        child: Text(
                          "Stay",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .cryptoMarketDataByPagination(1);

    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .getTrendingCoins();

    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .getCryptoCoinsByCount();

    Provider.of<NewsProvider>(context, listen: false).getNewsByReadCount();

    Provider.of<CryptoExplainerProvider>(context, listen: false)
        .getcryptoExplainerByType("Bitcoin");

    Provider.of<NewsProvider>(context, listen: false).getTopHeadlinesNews();

    Provider.of<NewsProvider>(context, listen: false).getNewsFeed(1);
    Provider.of<NewsProvider>(context, listen: false).getBitcoinNews(1);
    Provider.of<NewsProvider>(context, listen: false).getEthereumNews(1);
    Provider.of<NewsProvider>(context, listen: false).getNFTNews(1);
    Provider.of<NewsProvider>(context, listen: false).getMetaverseNews(1);

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
    final double h = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () {
        showExitPopup(width, height, user);
        return false as Future<bool>;
      },
      child: Scaffold(
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
                  .newsByReadCount
                  .clear();
              Provider.of<NewsProvider>(context, listen: false)
                  .getNewsByReadCount();
            });
            return Future.delayed(const Duration(seconds: 3));
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
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                backgroundColor: const Color(0xFF1B1B1B),
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
                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo_without_bg.png?alt=media&token=f03f5a0b-b15e-4314-bd26-20468e6f4fb1",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      AutoSizeText(
                        'CryptoX',
                        maxFontSize: 23,
                        minFontSize: 23,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size(0, 60),
                  child: Container(
                    color: const Color(0xFF010101),
                  ),
                ),
                expandedHeight: h >= 1.33
                    ? height * 0.5
                    : (((1 < h) && (h < 1.29)) && height < 850)
                        ? height * 0.4
                        : height * 0.36,
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned(
                      top: height * 0.13,
                      left: width * 0.1,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            child: SizedBox(
                              width: width * 0.55,
                              child: user != null
                                  ? RichText(
                                      text: TextSpan(
                                        text: 'Hi, ',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: user.displayName,
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF429bb8),
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : AutoSizeText(
                                      "Hey There,",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: width * 0.55,
                            child: AutoSizeText(
                              "Join our Discord for NFT giveaway's",
                              maxLines: 2,
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(100, 50),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFF738ADB),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              launch(
                                "https://discord.gg/v8HPFsV4jQ",
                              );
                            },
                            child: FittedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/discord.png?alt=media&token=ab6626d5-931e-4a03-bffb-8df4e0949ff9",
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AutoSizeText(
                                    "Discord",
                                    maxFontSize: 17,
                                    minFontSize: 17,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: width * 0.57,
                      top: height * 0.1,
                      child: FittedBox(
                        child: SizedBox(
                          width: width * 0.4,
                          height: height * 0.25,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/homepage_aniamtion.png?alt=media&token=7e646e96-de69-422d-a4bc-1cad39404f04",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height * 0.00004,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: height * 0.04,
                        decoration: const BoxDecoration(
                          color: Color(0xFF010101),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
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
                            InkWell(
                              onTap: () {
                                Get.to(
                                  () => const CryptoExplainerHomeScreen(),
                                );
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF1b1b1b),
                                ),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/explainer.png?alt=media&token=8f56b930-9549-4f6d-9cc3-2362e9943964",
                                          color: Colors.white,
                                          width: width * 0.06,
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        AutoSizeText(
                                          "Explainer",
                                          maxFontSize: 17,
                                          minFontSize: 17,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ConversionToolScreen());
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF1b1b1b),
                                ),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/conversion.png?alt=media&token=448c4d3f-a9b3-439f-ac45-e8912dd59eef",
                                          color: Colors.white,
                                          width: width * 0.06,
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        AutoSizeText(
                                          "Convert",
                                          maxFontSize: 17,
                                          minFontSize: 17,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
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
                            InkWell(
                              onTap: () {
                                showToast(
                                  "Coming Soon",
                                  context: context,
                                  textStyle: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: const Color(0xFF343434),
                                  borderRadius: BorderRadius.circular(
                                    5.0,
                                  ),
                                  textPadding: const EdgeInsets.symmetric(
                                    horizontal: 17.0,
                                    vertical: 10.0,
                                  ),
                                );
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF1b1b1b),
                                ),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/nft.png?alt=media&token=b479f6e4-5f14-470f-be77-5a31ed262556",
                                          color: Colors.white,
                                          width: width * 0.06,
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        AutoSizeText(
                                          "NFT's",
                                          maxFontSize: 17,
                                          minFontSize: 17,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (user == null) {
                                  showToast(
                                    "Login to proceed",
                                    context: context,
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: const Color(0xFF343434),
                                    borderRadius: BorderRadius.circular(
                                      5.0,
                                    ),
                                    textPadding: const EdgeInsets.symmetric(
                                      horizontal: 17.0,
                                      vertical: 10.0,
                                    ),
                                  );
                                } else {
                                  if (Provider.of<GoogleSignInProvider>(
                                    context,
                                    listen: false,
                                  ).userModel.favoriteCoins.isNotEmpty) {
                                    Provider.of<CryptoMarketDataProvider>(
                                      context,
                                      listen: false,
                                    ).getFavouriteCoinList(
                                      Provider.of<GoogleSignInProvider>(
                                        context,
                                        listen: false,
                                      ).userModel.favoriteCoins,
                                    );
                                  }

                                  Get.to(() => WatchListScreen());
                                }
                              },
                              child: Container(
                                height: height * 0.07,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: const Color(0xFF1b1b1b),
                                ),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/watchlist.png?alt=media&token=e4fea05d-fe35-4ab8-9558-11c0c5e485f9",
                                          color: Colors.white,
                                          width: width * 0.06,
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        AutoSizeText(
                                          "Watchlist",
                                          maxFontSize: 17,
                                          minFontSize: 17,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
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
                        maxFontSize: 20,
                        minFontSize: 20,
                        style: GoogleFonts.rubik(
                          color: Colors.white,
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
                  builder: (ctx, model, _) {
                    return model.listModel.isEmpty || model.listModel.length < 6
                        ? Center(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/animation_500_kvhmucnx.gif?alt=media&token=8321a796-0c25-433b-ae46-b1db4467a32e',
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          )
                        : FutureBuilder(
                            builder: (context, s) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  top: 15,
                                  left: 5,
                                  right: 5,
                                ),
                                height: height * 0.27,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        Provider.of<CryptoMarketDataProvider>(
                                          context,
                                          listen: false,
                                        )
                                            .getCryptocurrencyCountByNameSymbol(
                                          model.listModel[index].name,
                                          model.listModel[index].symbol,
                                        )
                                            .then(
                                          (value) {
                                            Get.to(
                                              () => MarketDataScreen(
                                                model.listModel[index],
                                                model.graphDataList[index],
                                                model.dailyGraphDataList[index],
                                                value,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 20,
                                          right: 5,
                                        ),
                                        height: height * 0.27,
                                        width: width * 0.5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: const Color(0xFF1b1b1b),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              child: ListTile(
                                                minLeadingWidth: 1,
                                                contentPadding: EdgeInsets.zero,
                                                leading: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    model
                                                        .listModel[index].image,
                                                  ),
                                                ),
                                                title: AutoSizeText(
                                                  model.listModel[index].symbol
                                                      .toUpperCase(),
                                                  maxFontSize: 16,
                                                  minFontSize: 16,
                                                  maxLines: 1,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: AutoSizeText(
                                                  model.listModel[index].name,
                                                  maxFontSize: 15,
                                                  maxLines: 1,
                                                  minFontSize: 15,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                trailing: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: model
                                                              .listModel[index]
                                                              .priceChangePercentage24h >
                                                          0
                                                      ? const Color(
                                                          0xFF00a55b,
                                                        ).withOpacity(
                                                          0.3,
                                                        )
                                                      : const Color(
                                                          0xFFd82e35,
                                                        ).withOpacity(
                                                          0.3,
                                                        ),
                                                  child: CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                      model.listModel[index]
                                                                  .priceChangePercentage24h >=
                                                              0
                                                          ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                          : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (model.dailyGraphDataList[index]
                                                .graphData.isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                height: height * 0.08,
                                                child:
                                                    model
                                                            .dailyGraphDataList[
                                                                index]
                                                            .graphData
                                                            .isEmpty
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : LineChart(
                                                            LineChartData(
                                                              lineTouchData:
                                                                  LineTouchData(
                                                                enabled: false,
                                                              ),
                                                              gridData:
                                                                  FlGridData(
                                                                show: true,
                                                                drawVerticalLine:
                                                                    false,
                                                                drawHorizontalLine:
                                                                    false,
                                                                horizontalInterval:
                                                                    4,
                                                                getDrawingHorizontalLine:
                                                                    (value) {
                                                                  return FlLine(
                                                                    color: model.listModel[index].priceChangePercentage24h >
                                                                            0
                                                                        ? const Color(
                                                                            0xFF00a55b,
                                                                          ).withOpacity(
                                                                            0.3,
                                                                          )
                                                                        : const Color(
                                                                            0xFFd82e35,
                                                                          ).withOpacity(
                                                                            0.3,
                                                                          ),
                                                                    strokeWidth:
                                                                        1,
                                                                  );
                                                                },
                                                                getDrawingVerticalLine:
                                                                    (value) {
                                                                  return FlLine(
                                                                    color: model.listModel[index].priceChangePercentage24h >
                                                                            0
                                                                        ? const Color(
                                                                            0xFF00a55b,
                                                                          ).withOpacity(
                                                                            0.3,
                                                                          )
                                                                        : const Color(
                                                                            0xFFd82e35,
                                                                          ).withOpacity(
                                                                            0.3,
                                                                          ),
                                                                    strokeWidth:
                                                                        1,
                                                                  );
                                                                },
                                                              ),
                                                              titlesData:
                                                                  FlTitlesData(
                                                                show: false,
                                                              ),
                                                              borderData:
                                                                  FlBorderData(
                                                                show: false,
                                                              ),
                                                              minX: 0,
                                                              maxX: model
                                                                      .dailyGraphDataList[
                                                                          index]
                                                                      .graphData
                                                                      .length
                                                                      .toDouble() -
                                                                  1,
                                                              minY: _helper
                                                                  .extractPriceFromGraph(
                                                                    model
                                                                        .dailyGraphDataList[
                                                                            index]
                                                                        .graphData,
                                                                  )
                                                                  .reduce(min)
                                                                  .toDouble(),
                                                              maxY: _helper
                                                                  .extractPriceFromGraph(
                                                                    model
                                                                        .dailyGraphDataList[
                                                                            index]
                                                                        .graphData,
                                                                  )
                                                                  .reduce(max)
                                                                  .toDouble(),
                                                              lineBarsData: [
                                                                LineChartBarData(
                                                                  spots:
                                                                      listData(
                                                                    _helper
                                                                        .extractPriceFromGraph(
                                                                      model
                                                                          .dailyGraphDataList[
                                                                              index]
                                                                          .graphData,
                                                                    ),
                                                                  ),
                                                                  colors: [
                                                                    if (model
                                                                            .listModel[index]
                                                                            .priceChangePercentage24h >
                                                                        0)
                                                                      const Color(
                                                                        0xFF00a55b,
                                                                      ).withOpacity(
                                                                        0.3,
                                                                      )
                                                                    else
                                                                      const Color(
                                                                        0xFFd82e35,
                                                                      ).withOpacity(
                                                                        0.3,
                                                                      ),
                                                                  ],
                                                                  barWidth: 3,
                                                                  isStrokeCapRound:
                                                                      true,
                                                                  dotData:
                                                                      FlDotData(
                                                                    show: false,
                                                                  ),
                                                                  belowBarData:
                                                                      BarAreaData(
                                                                    show: true,
                                                                    gradientFrom:
                                                                        const Offset(
                                                                      0,
                                                                      .9,
                                                                    ),
                                                                    gradientTo:
                                                                        const Offset(
                                                                      0,
                                                                      0.5,
                                                                    ),
                                                                    colors: [
                                                                      if (model
                                                                              .listModel[index]
                                                                              .priceChangePercentage24h >
                                                                          0)
                                                                        const Color(
                                                                          0xFF00a55b,
                                                                        ).withOpacity(
                                                                          0.3,
                                                                        )
                                                                      else
                                                                        const Color(
                                                                          0xFFd82e35,
                                                                        ).withOpacity(
                                                                          0.3,
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            swapAnimationDuration:
                                                                Duration.zero,
                                                          ),
                                              )
                                            else
                                              Container(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: model
                                                              .listModel[index]
                                                              .priceChangePercentage24h >=
                                                          0
                                                      ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                      : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                  fit: BoxFit.cover,
                                                  height: 10,
                                                  width: 10,
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
                                                  maxFontSize: 17,
                                                  minFontSize: 17,
                                                  style: GoogleFonts.nunito(
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
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            AutoSizeText(
                                              "\u2022",
                                              maxFontSize: 17,
                                              minFontSize: 17,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: height * 0.02,
                                              ),
                                              child: AutoSizeText(
                                                "\u{20B9} ${model.listModel[index].price.toString().startsWith("0.") ? model.listModel[index].price.toString() : _helper.removeDecimal(model.listModel[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                maxLines: 1,
                                                maxFontSize: 17,
                                                minFontSize: 17,
                                                style: GoogleFonts.nunito(
                                                  color: Colors.white,
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
                              );
                            },
                            future: Future.delayed(const Duration(seconds: 1)),
                          );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 32),
                  child: AutoSizeText(
                    "Top Trending",
                    maxFontSize: 20,
                    minFontSize: 20,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer<CryptoMarketDataProvider>(
                  builder: (ctx, model, _) => model.trendingCoins.isEmpty ||
                          model.trendingCoins.length < 6
                      ? Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/animation_500_kvhmucnx.gif?alt=media&token=8321a796-0c25-433b-ae46-b1db4467a32e',
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                        )
                      : FutureBuilder(
                          builder: (c, s) => Container(
                            margin: const EdgeInsets.only(
                              top: 15,
                              left: 5,
                              right: 5,
                            ),
                            height: height * 0.27,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (ctx, index) {
                                return InkWell(
                                  onTap: () {
                                    Provider.of<CryptoMarketDataProvider>(
                                      context,
                                      listen: false,
                                    )
                                        .getCryptocurrencyCountByNameSymbol(
                                      model.listModel[index].name,
                                      model.listModel[index].symbol,
                                    )
                                        .then(
                                      (value) {
                                        Get.to(
                                          () => MarketDataScreen(
                                            model.trendingCoins[index],
                                            model.trendingGraphDataList[index],
                                            model.trendingDailyGraphDataList[
                                                index],
                                            value,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: GlassmorphicContainer(
                                    margin: const EdgeInsets.only(
                                      left: 20,
                                      right: 5,
                                    ),
                                    height: height * 0.27,
                                    width: width * 0.5,
                                    borderRadius: 25,
                                    blur: 55,
                                    linearGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF1b1b1b),
                                        Color(0xFF1b1b1b),
                                      ],
                                      stops: [
                                        0.1,
                                        1,
                                      ],
                                    ),
                                    borderGradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFffffff)
                                            .withOpacity(0.5),
                                        const Color(0xFFFFFFFF)
                                            .withOpacity(0.5),
                                      ],
                                    ),
                                    border: 0,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                          ),
                                          child: ListTile(
                                            minLeadingWidth: 1,
                                            contentPadding: EdgeInsets.zero,
                                            leading: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                model
                                                    .trendingCoins[index].image,
                                              ),
                                            ),
                                            title: AutoSizeText(
                                              model.trendingCoins[index].symbol
                                                  .toUpperCase(),
                                              maxFontSize: 16,
                                              minFontSize: 16,
                                              maxLines: 1,
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: AutoSizeText(
                                              model.trendingCoins[index].name,
                                              maxFontSize: 15,
                                              minFontSize: 15,
                                              maxLines: 1,
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            trailing: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: model
                                                          .trendingCoins[index]
                                                          .priceChangePercentage24h >
                                                      0
                                                  ? const Color(
                                                      0xFF00a55b,
                                                    ).withOpacity(0.3)
                                                  : const Color(
                                                      0xFFd82e35,
                                                    ).withOpacity(
                                                      0.3,
                                                    ),
                                              child: CircleAvatar(
                                                radius: 5,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  model.trendingCoins[index]
                                                              .priceChangePercentage24h >=
                                                          0
                                                      ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                      : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (model.trendingDailyGraphDataList[0]
                                            .graphData.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            height: height * 0.08,
                                            child: model
                                                    .trendingDailyGraphDataList[
                                                        0]
                                                    .graphData
                                                    .isEmpty
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : LineChart(
                                                    LineChartData(
                                                      lineTouchData:
                                                          LineTouchData(
                                                        enabled: false,
                                                      ),
                                                      gridData: FlGridData(
                                                        show: true,
                                                        drawVerticalLine: false,
                                                        drawHorizontalLine:
                                                            false,
                                                        horizontalInterval: 4,
                                                        getDrawingHorizontalLine:
                                                            (value) {
                                                          return FlLine(
                                                            color: model
                                                                        .trendingCoins[
                                                                            index]
                                                                        .priceChangePercentage24h >
                                                                    0
                                                                ? const Color(
                                                                    0xFF00a55b,
                                                                  ).withOpacity(
                                                                    0.3,
                                                                  )
                                                                : const Color(
                                                                    0xFFd82e35,
                                                                  ).withOpacity(
                                                                    0.3,
                                                                  ),
                                                            strokeWidth: 1,
                                                          );
                                                        },
                                                        getDrawingVerticalLine:
                                                            (value) {
                                                          return FlLine(
                                                            color: model
                                                                        .trendingCoins[
                                                                            index]
                                                                        .priceChangePercentage24h >
                                                                    0
                                                                ? const Color(
                                                                    0xFF00a55b,
                                                                  ).withOpacity(
                                                                    0.3,
                                                                  )
                                                                : const Color(
                                                                    0xFFd82e35,
                                                                  ).withOpacity(
                                                                    0.3,
                                                                  ),
                                                            strokeWidth: 1,
                                                          );
                                                        },
                                                      ),
                                                      titlesData: FlTitlesData(
                                                        show: false,
                                                      ),
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      minX: 0,
                                                      maxX: model
                                                              .trendingDailyGraphDataList[
                                                                  0]
                                                              .graphData
                                                              .length
                                                              .toDouble() -
                                                          1,
                                                      minY: _helper
                                                          .extractPriceFromGraph(
                                                            model
                                                                .trendingDailyGraphDataList[
                                                                    index]
                                                                .graphData,
                                                          )
                                                          .reduce(
                                                            min,
                                                          )
                                                          .toDouble(),
                                                      maxY: _helper
                                                          .extractPriceFromGraph(
                                                            model
                                                                .trendingDailyGraphDataList[
                                                                    index]
                                                                .graphData,
                                                          )
                                                          .reduce(
                                                            max,
                                                          )
                                                          .toDouble(),
                                                      lineBarsData: [
                                                        LineChartBarData(
                                                          spots: listData(
                                                            _helper
                                                                .extractPriceFromGraph(
                                                              model
                                                                  .trendingDailyGraphDataList[
                                                                      index]
                                                                  .graphData,
                                                            ),
                                                          ),
                                                          colors: [
                                                            if (model
                                                                    .trendingCoins[
                                                                        index]
                                                                    .priceChangePercentage24h >
                                                                0)
                                                              const Color(
                                                                0xFF00a55b,
                                                              ).withOpacity(
                                                                0.3,
                                                              )
                                                            else
                                                              const Color(
                                                                0xFFd82e35,
                                                              ).withOpacity(
                                                                0.3,
                                                              ),
                                                          ],
                                                          barWidth: 3,
                                                          isStrokeCapRound:
                                                              true,
                                                          dotData: FlDotData(
                                                            show: false,
                                                          ),
                                                          belowBarData:
                                                              BarAreaData(
                                                            show: true,
                                                            gradientFrom:
                                                                const Offset(
                                                              0,
                                                              .9,
                                                            ),
                                                            gradientTo:
                                                                const Offset(
                                                              0,
                                                              0.5,
                                                            ),
                                                            colors: [
                                                              if (model
                                                                      .trendingCoins[
                                                                          index]
                                                                      .priceChangePercentage24h >
                                                                  0)
                                                                const Color(
                                                                  0xFF00a55b,
                                                                ).withOpacity(
                                                                  0.3,
                                                                )
                                                              else
                                                                const Color(
                                                                  0xFFd82e35,
                                                                ).withOpacity(
                                                                  0.3,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    swapAnimationDuration:
                                                        Duration.zero,
                                                  ),
                                          )
                                        else
                                          Container(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: model
                                                          .trendingCoins[index]
                                                          .priceChangePercentage24h >=
                                                      0
                                                  ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                  : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                              fit: BoxFit.cover,
                                              height: 10,
                                              width: 10,
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
                                              maxFontSize: 17,
                                              minFontSize: 17,
                                              style: GoogleFonts.nunito(
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
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          "\u2022",
                                          maxFontSize: 17,
                                          minFontSize: 17,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            bottom: height * 0.02,
                                          ),
                                          child: AutoSizeText(
                                            "\u{20B9} ${model.trendingCoins[index].price.toString().startsWith("0.") ? model.trendingCoins[index].price.toString() : _helper.removeDecimal(model.trendingCoins[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                            maxLines: 1,
                                            maxFontSize: 17,
                                            minFontSize: 17,
                                            style: GoogleFonts.nunito(
                                              color: Colors.white,
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
                          future: Future.delayed(
                            const Duration(milliseconds: 1000),
                          ),
                        ),
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
                      maxFontSize: 20,
                      minFontSize: 20,
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<NewsProvider>(
                builder: (ctx, model, _) => model.newsByReadCount.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, index) {
                            return index == model.newsByReadCount.length
                                ? GestureDetector(
                                    onTap: () {
                                      Get.to(() => SeeAllNewsScreen());
                                    },
                                    child: Center(
                                      child: AutoSizeText(
                                        "See all",
                                        maxFontSize: 15,
                                        minFontSize: 15,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Provider.of<NewsProvider>(
                                        context,
                                        listen: false,
                                      )
                                          .getNewsReadCount(
                                        model.newsByReadCount[index].title,
                                        model.newsByReadCount[index].source,
                                      )
                                          .then((value) {
                                        Get.to(
                                          () => NewsSummaryScreen(
                                            model.newsByReadCount[index],
                                            value,
                                          ),
                                        );
                                      });
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
                                                  BorderRadius.circular(
                                                15.0,
                                              ),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: _helper.extractImgUrl(
                                                  model.newsByReadCount[index]
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
                                                  model.newsByReadCount[index]
                                                      .title,
                                                  maxLines: 2,
                                                  maxFontSize: 15,
                                                  minFontSize: 15,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
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
                                                            .newsByReadCount[
                                                                index]
                                                            .description
                                                            .length,
                                                      ),
                                                    ),
                                                    child: AutoSizeText(
                                                      model
                                                          .newsByReadCount[
                                                              index]
                                                          .description,
                                                      maxLines: 2,
                                                      maxFontSize: 15,
                                                      minFontSize: 15,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: const Color(
                                                          0xFF757575,
                                                        ),
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
                                                                .newsByReadCount[
                                                                    index]
                                                                .publishedDate,
                                                          )} \u2022",
                                                          maxLines: 1,
                                                          maxFontSize: 15,
                                                          minFontSize: 15,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                              0xFF757575,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        model
                                                            .newsByReadCount[
                                                                index]
                                                            .source,
                                                        maxLines: 1,
                                                        maxFontSize: 15,
                                                        minFontSize: 15,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                            0xFF757575,
                                                          ),
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
                          childCount: model.newsByReadCount.length + 1,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

List<FlSpot> listData(List<num> data) {
  return data.asMap().entries.map((e) {
    return FlSpot(e.key.toDouble(), e.value.toDouble());
  }).toList();
}
