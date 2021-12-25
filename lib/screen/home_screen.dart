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
import 'package:dashed_circle/dashed_circle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          content: SizedBox(
            height: height * 0.17,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hey ${user!.displayName}, Check out your favorite crypto coin price before leaving",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(),
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
                          primary: Colors.white,
                        ),
                        child: Text(
                          "Stay",
                          style: GoogleFonts.poppins(color: Colors.black),
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

    Provider.of<NewsProvider>(context, listen: false).getNewsByReadCount();

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
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                backgroundColor: const Color(0xFF0e0c0a),
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
                bottom: PreferredSize(
                  preferredSize: const Size(0, 60),
                  child: Container(
                    color: const Color(0xFF010101),
                  ),
                ),
                expandedHeight: height * 0.35,
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 120,
                      left: 40,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "Hi, ${user!.displayName}",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: AutoSizeText(
                              "Join our Discord for NFT giveaway's",
                              style: GoogleFonts.rubik(
                                fontSize: 16,
                                color: Colors.white,
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
                                "https://discord.gg/CTBpvzDbZT",
                              );
                            },
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
                                Text(
                                  "Discord",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 250,
                      top: 120,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/animation.gif?alt=media&token=154b22f4-17da-45e8-9d70-f89c51a4c6d5",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
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
                              child: GlassmorphicContainer(
                                height: 60,
                                width: 160,
                                borderRadius: 25,
                                blur: 55,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF52CAF5).withOpacity(0.2),
                                    const Color(0xFFFFFFFF).withOpacity(0.3),
                                  ],
                                  stops: const [
                                    0.1,
                                    1,
                                  ],
                                ),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFffffff).withOpacity(0.5),
                                    const Color(0xFFFFFFFF).withOpacity(0.5),
                                  ],
                                ),
                                border: 0,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/explainer.png?alt=media&token=8f56b930-9549-4f6d-9cc3-2362e9943964",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      AutoSizeText(
                                        "Explainer",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => ConversionToolScreen());
                              },
                              child: GlassmorphicContainer(
                                height: 60,
                                width: 160,
                                borderRadius: 25,
                                blur: 55,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF52CAF5).withOpacity(0.2),
                                    const Color(0xFFFFFFFF).withOpacity(0.3),
                                  ],
                                  stops: const [
                                    0.1,
                                    1,
                                  ],
                                ),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFffffff).withOpacity(0.5),
                                    const Color(0xFFFFFFFF).withOpacity(0.5),
                                  ],
                                ),
                                border: 0,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/conversion.png?alt=media&token=fbe2b5ad-292b-49d0-90ee-4abc46e30090",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      AutoSizeText(
                                        "Convert",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
                            GlassmorphicContainer(
                              height: 60,
                              width: 160,
                              borderRadius: 25,
                              blur: 55,
                              linearGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF52CAF5).withOpacity(0.2),
                                  const Color(0xFFFFFFFF).withOpacity(0.3),
                                ],
                                stops: const [
                                  0.1,
                                  1,
                                ],
                              ),
                              borderGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFFffffff).withOpacity(0.5),
                                  const Color(0xFFFFFFFF).withOpacity(0.5),
                                ],
                              ),
                              border: 0,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const CircleAvatar(
                                      radius: 17,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/nft.png?alt=media&token=b479f6e4-5f14-470f-be77-5a31ed262556",
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    AutoSizeText(
                                      "NFT's",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
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
                              },
                              child: GlassmorphicContainer(
                                height: 60,
                                width: 160,
                                borderRadius: 25,
                                blur: 55,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF52CAF5).withOpacity(0.2),
                                    const Color(0xFFFFFFFF).withOpacity(0.3),
                                  ],
                                  stops: const [
                                    0.1,
                                    1,
                                  ],
                                ),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFffffff).withOpacity(0.5),
                                    const Color(0xFFFFFFFF).withOpacity(0.5),
                                  ],
                                ),
                                border: 0,
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Center(
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const CircleAvatar(
                                        radius: 17,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/watchlist.png?alt=media&token=36ba997f-e1b2-49db-8f28-21f8879506fe",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      AutoSizeText(
                                        "Watch List",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
                  builder: (ctx, model, _) {
                    return model.listModel.isEmpty || model.listModel.length < 5
                        ? const Center(
                            child: CircularProgressIndicator(),
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
                                        Get.to(
                                          () => MarketDataScreen(
                                            model.listModel[index],
                                            model.graphDataList[index],
                                            model.dailyGraphDataList[index],
                                          ),
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
                                        linearGradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF52CAF5)
                                                .withOpacity(0.2),
                                            const Color(0xFFFFFFFF)
                                                .withOpacity(0.3),
                                          ],
                                          stops: const [
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
                                                        .listModel[index].image,
                                                  ),
                                                ),
                                                title: AutoSizeText(
                                                  model.listModel[index].symbol
                                                      .toUpperCase(),
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: AutoSizeText(
                                                  model.listModel[index].name,
                                                  style: GoogleFonts.rubik(
                                                    color: Colors.white,
                                                    fontSize: 15,
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
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              height: height * 0.1,
                                              child: model.graphDataList.isEmpty
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
                                                          drawVerticalLine:
                                                              false,
                                                          drawHorizontalLine:
                                                              false,
                                                          horizontalInterval: 4,
                                                          getDrawingHorizontalLine:
                                                              (value) {
                                                            return FlLine(
                                                              color: model
                                                                          .listModel[
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
                                                                          .listModel[
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
                                                            spots: listData(
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
                                                                      .listModel[
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
                                                                        .listModel[
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
                                            ),
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
                                                    fontSize: 17,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            AutoSizeText(
                                              "\u2022",
                                              style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                            AutoSizeText(
                                              "\u{20B9} ${model.listModel[index].price.toString().startsWith("0.") ? model.listModel[index].price.toString() : _helper.removeDecimal(model.listModel[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                              maxLines: 1,
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
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
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer<CryptoMarketDataProvider>(
                  builder: (ctx, model, _) => model.trendingCoins.isEmpty ||
                          model.trendingCoins.length < 5
                      ? const Center(
                          child: CircularProgressIndicator(),
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
                                    Get.to(
                                      () => MarketDataScreen(
                                        model.trendingCoins[index],
                                        model.trendingGraphDataList[index],
                                        model.trendingDailyGraphDataList[index],
                                      ),
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
                                    linearGradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFF52CAF5)
                                            .withOpacity(0.2),
                                        const Color(0xFFFFFFFF)
                                            .withOpacity(0.3),
                                      ],
                                      stops: const [
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
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: AutoSizeText(
                                              model.trendingCoins[index].name,
                                              style: GoogleFonts.rubik(
                                                color: Colors.white,
                                                fontSize: 15,
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
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          height: height * 0.1,
                                          child: model.graphDataList.isEmpty
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
                                                      drawHorizontalLine: false,
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
                                                        isStrokeCapRound: true,
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
                                        ),
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
                                                fontSize: 17,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          "\u2022",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                        AutoSizeText(
                                          "\u{20B9} ${model.trendingCoins[index].price.toString().startsWith("0.") ? model.trendingCoins[index].price.toString() : _helper.removeDecimal(model.trendingCoins[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                          maxLines: 1,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                                .newsByReadCount[
                                                                    index]
                                                                .publishedDate,
                                                          )} \u2022",
                                                          maxLines: 1,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                              0xFF757575,
                                                            ),
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      AutoSizeText(
                                                        model
                                                            .newsByReadCount[
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
