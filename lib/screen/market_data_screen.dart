import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/coin_paprika_market_static_data_model.dart';
import 'package:crypto_news/model/crpyto_data_daily_graph_model.dart';
import 'package:crypto_news/model/crypto_data_graph_model.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:crypto_news/model/cryptocurrency_top_count_model.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news_summary_screen.dart';

class MarketDataScreen extends StatefulWidget {
  CryptoMarketDataModel cryptoData;
  final CryptoDataGraphModel graphData;
  final CryptoDataDailyGraphModel dailyGraphData;
  final CryptocurrencyTopCountModel cryptocurrencyTopModel;

  MarketDataScreen(
    this.cryptoData,
    this.graphData,
    this.dailyGraphData,
    this.cryptocurrencyTopModel,
  );

  @override
  _MarketDataScreenState createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  final _helper = Helper();
  int _selectedIndex = 3;

  Timer? timer;
  final User? user = FirebaseAuth.instance.currentUser;
  List<dynamic> dataList = [];

  late CoinPaprikaMarketStaticDataModel _staticDataModel;
  bool _globalDataLoaded = true;

  Future<Color> getImagePalette(String url) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(url),
    );
    return paletteGenerator.dominantColor!.color;
  }

  final gradient = const LinearGradient(
    colors: [
      Color(0xFF9c98dc),
      Color(0xFF7ac7cf),
      Color(0xFF699a8d),
      Color(0xFFa3a683)
    ],
  );

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
        .getCoinPaprikaMarketStaticData(widget.cryptoData.name)
        .then((value) {
      setState(() {
        _globalDataLoaded = false;
        _staticDataModel = value;
      });
    });

    dataList = [...widget.cryptocurrencyTopModel.seeCount];

    final CryptocurrencyTopCountModel cryptocurrencyTopCountModel;
    if (user != null) {
      if (dataList.isEmpty || !dataList.contains(user!.uid)) {
        final List<dynamic> uid = [
          ...widget.cryptocurrencyTopModel.seeCount,
          user!.uid
        ];

        cryptocurrencyTopCountModel = CryptocurrencyTopCountModel(
          name: widget.cryptoData.name,
          symbol: widget.cryptoData.symbol,
          seeCount: uid,
          totalSeeCount: uid.length,
        );

        timer = Timer.periodic(const Duration(seconds: 8), (Timer t) {
          if (dataList.isEmpty || !dataList.contains(user!.uid)) {
            Provider.of<CryptoMarketDataProvider>(context, listen: false)
                .updateCryptocurrenctCount(cryptocurrencyTopCountModel)
                .then((_) {
              setState(() {
                dataList = [
                  ...widget.cryptocurrencyTopModel.seeCount,
                  user!.uid
                ];
              });
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
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
                .getCryptoMarketDataBySymbol(widget.cryptoData.symbol)
                .then(
                  (value) => {widget.cryptoData = value},
                );
            Provider.of<NewsProvider>(context, listen: false)
                .newsCompleteList
                .clear();
            Provider.of<NewsProvider>(context, listen: false).getNewsFeed(1);
            Provider.of<CryptoMarketDataProvider>(context, listen: false)
                .getCryptoCoinsByCount();
          });
          return Future.delayed(const Duration(seconds: 2));
        },
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          //35444E
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
          top: false,
          child: Consumer<CryptoMarketDataProvider>(
            builder: (ctx, model, _) {
              return Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.4,
                      0.5,
                      0.8,
                    ],
                    colors: [
                      Color(0xFF35444E),
                      Color(0xFF10171D),
                      Color(0xFF10171D),
                      Colors.black,
                    ],
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: height * 0.04,
                          left: width * 0.03,
                          right: width * 0.03,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                'Statistics',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (user != null)
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF22313e)
                                        .withOpacity(0.5),
                                  ),
                                  child: LikeButton(
                                    size: 22,
                                    circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc),
                                    ),
                                    bubblesColor: const BubblesColor(
                                      dotPrimaryColor: Color(0xff33b5e5),
                                      dotSecondaryColor: Color(0xff0099cc),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.star_purple500_outlined,
                                        color:
                                            Provider.of<GoogleSignInProvider>(
                                          context,
                                          listen: false,
                                        ).userModel.favoriteCoins.contains(
                                                      widget.cryptoData.name
                                                          .toLowerCase(),
                                                    )
                                                ? const Color(
                                                    0xFF52CAF5,
                                                  )
                                                : Colors.white,
                                        size: 22,
                                      );
                                    },
                                    onTap: (isLiked) =>
                                        Provider.of<CryptoMarketDataProvider>(
                                      context,
                                      listen: false,
                                    ).updateFavouriteCoin(
                                      [widget.cryptoData.name.toLowerCase()],
                                      user.uid,
                                    ).then((value) {
                                      Provider.of<GoogleSignInProvider>(
                                        context,
                                        listen: false,
                                      ).userModel = value;
                                    }),
                                  ),
                                )
                              else
                                const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: GlassmorphicContainer(
                        margin: EdgeInsets.only(
                          top: height * 0.01,
                          left: width * 0.05,
                          right: width * 0.05,
                        ),
                        width: width,
                        height: height * 0.25,
                        borderRadius: 40,
                        blur: 55,
                        alignment: Alignment.center,
                        border: 0,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(0.1),
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
                        child: FittedBox(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: height * 0.02,
                                  right: width * 0.67,
                                ),
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage: CachedNetworkImageProvider(
                                    widget.cryptoData.image,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: height * 0.01,
                                ),
                                child: AutoSizeText(
                                  widget.cryptoData.symbol.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              AutoSizeText(
                                widget.cryptoData.name,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: height * 0.025,
                                ),
                                height: height * 0.045,
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return gradient.createShader(
                                      Offset.zero & bounds.size,
                                    );
                                  },
                                  child: AutoSizeText(
                                    "\u{20B9} ${widget.cryptoData.price.toString().startsWith("0.") ? widget.cryptoData.price.toString() : _helper.removeDecimal(widget.cryptoData.price.toString()).replaceAllMapped(
                                          RegExp(
                                            r'(\d{1,3})(?=(\d{3})+(?!\d))',
                                          ),
                                          (Match m) => '${m[1]},',
                                        )}",
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.graphData.graphData.isNotEmpty ||
                        widget.dailyGraphData.graphData.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 3;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Center(
                                      child: AutoSizeText(
                                        '24H',
                                        maxLines: 1,
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w600,
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
                                      color: _selectedIndex == 3
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 0;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Center(
                                      child: AutoSizeText(
                                        '1M',
                                        maxLines: 1,
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w600,
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
                                      color: _selectedIndex == 0
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Center(
                                      child: AutoSizeText(
                                        '1Y',
                                        maxLines: 1,
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w600,
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
                                      color: _selectedIndex == 1
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 2;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Center(
                                      child: AutoSizeText(
                                        '5Y',
                                        maxLines: 1,
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w600,
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
                                      color: _selectedIndex == 2
                                          ? const Color(0xFF52CAF5)
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: height * 0.03,
                          left: width * 0.04,
                          right: width * 0.04,
                        ),
                        height: height * 0.3,
                        color: Colors.transparent,
                        child: (widget.graphData.graphData.isEmpty ||
                                (widget.dailyGraphData.graphData.isEmpty &&
                                    _selectedIndex == 3))
                            ? Center(
                                child: AutoSizeText(
                                  "No Graph Data Available",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  lineTouchData: LineTouchData(
                                    touchTooltipData: LineTouchTooltipData(
                                      fitInsideHorizontally: true,
                                      fitInsideVertically: true,
                                      tooltipRoundedRadius: 24,
                                      getTooltipItems: (
                                        List<LineBarSpot> touchedBarSpots,
                                      ) {
                                        return touchedBarSpots.map((barSpot) {
                                          return LineTooltipItem(
                                            "${_helper.extractPriceFromGraph(
                                              _selectedIndex == 0
                                                  ? _helper
                                                      .extractGraphBasedOnPeriod(
                                                      "1m",
                                                      widget
                                                          .graphData.graphData,
                                                    )
                                                  : _selectedIndex == 1
                                                      ? _helper
                                                          .extractGraphBasedOnPeriod(
                                                          "1y",
                                                          widget.graphData
                                                              .graphData,
                                                        )
                                                      : _selectedIndex == 3
                                                          ? widget
                                                              .dailyGraphData
                                                              .graphData
                                                          : _helper
                                                              .extractGraphBasedOnPeriod(
                                                              "5y",
                                                              widget.graphData
                                                                  .graphData,
                                                            ),
                                            )[barSpot.x.toInt()]}"
                                                    .startsWith("0.")
                                                ? _helper
                                                    .extractPriceFromGraph(
                                                      _selectedIndex == 0
                                                          ? _helper
                                                              .extractGraphBasedOnPeriod(
                                                              "1m",
                                                              widget.graphData
                                                                  .graphData,
                                                            )
                                                          : _selectedIndex == 1
                                                              ? _helper
                                                                  .extractGraphBasedOnPeriod(
                                                                  "1y",
                                                                  widget
                                                                      .graphData
                                                                      .graphData,
                                                                )
                                                              : _selectedIndex ==
                                                                      3
                                                                  ? widget
                                                                      .dailyGraphData
                                                                      .graphData
                                                                  : _helper
                                                                      .extractGraphBasedOnPeriod(
                                                                      "5y",
                                                                      widget
                                                                          .graphData
                                                                          .graphData,
                                                                    ),
                                                    )[barSpot.x.toInt()]
                                                    .toString()
                                                : _helper
                                                    .removeDecimal(
                                                      _helper
                                                          .extractPriceFromGraph(
                                                            _selectedIndex == 0
                                                                ? _helper
                                                                    .extractGraphBasedOnPeriod(
                                                                    "1m",
                                                                    widget
                                                                        .graphData
                                                                        .graphData,
                                                                  )
                                                                : _selectedIndex ==
                                                                        1
                                                                    ? _helper
                                                                        .extractGraphBasedOnPeriod(
                                                                        "1y",
                                                                        widget
                                                                            .graphData
                                                                            .graphData,
                                                                      )
                                                                    : _selectedIndex ==
                                                                            3
                                                                        ? widget
                                                                            .dailyGraphData
                                                                            .graphData
                                                                        : _helper
                                                                            .extractGraphBasedOnPeriod(
                                                                            "5y",
                                                                            widget.graphData.graphData,
                                                                          ),
                                                          )[barSpot.x.toInt()]
                                                          .toStringAsFixed(2),
                                                    )
                                                    .replaceAllMapped(
                                                      RegExp(
                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))',
                                                      ),
                                                      (Match m) => '${m[1]},',
                                                    ),
                                            GoogleFonts.nunito(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    drawHorizontalLine: false,
                                    horizontalInterval: 4,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: const Color(
                                          0xff37434d,
                                        ),
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return FlLine(
                                        color: const Color(
                                          0xff37434d,
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
                                  maxX: (_selectedIndex == 0
                                          ? _helper
                                              .extractGraphBasedOnPeriod(
                                                "1m",
                                                widget.graphData.graphData,
                                              )
                                              .length
                                              .toDouble()
                                          : _selectedIndex == 1
                                              ? _helper
                                                  .extractGraphBasedOnPeriod(
                                                    "1y",
                                                    widget.graphData.graphData,
                                                  )
                                                  .length
                                                  .toDouble()
                                              : _selectedIndex == 3
                                                  ? widget.dailyGraphData
                                                      .graphData.length
                                                      .toDouble()
                                                  : _helper
                                                      .extractGraphBasedOnPeriod(
                                                        "5y",
                                                        widget.graphData
                                                            .graphData,
                                                      )
                                                      .length
                                                      .toDouble()) -
                                      1,
                                  minY: _helper
                                      .extractPriceFromGraph(
                                        _selectedIndex == 0
                                            ? _helper.extractGraphBasedOnPeriod(
                                                "1m",
                                                widget.graphData.graphData,
                                              )
                                            : _selectedIndex == 1
                                                ? _helper
                                                    .extractGraphBasedOnPeriod(
                                                    "1y",
                                                    widget.graphData.graphData,
                                                  )
                                                : _selectedIndex == 3
                                                    ? widget.dailyGraphData
                                                        .graphData
                                                    : _helper
                                                        .extractGraphBasedOnPeriod(
                                                        "5y",
                                                        widget.graphData
                                                            .graphData,
                                                      ),
                                      )
                                      .reduce(min)
                                      .toDouble(),
                                  maxY: _helper
                                      .extractPriceFromGraph(
                                        _selectedIndex == 0
                                            ? _helper.extractGraphBasedOnPeriod(
                                                "1m",
                                                widget.graphData.graphData,
                                              )
                                            : _selectedIndex == 1
                                                ? _helper
                                                    .extractGraphBasedOnPeriod(
                                                    "1y",
                                                    widget.graphData.graphData,
                                                  )
                                                : _selectedIndex == 3
                                                    ? widget.dailyGraphData
                                                        .graphData
                                                    : _helper
                                                        .extractGraphBasedOnPeriod(
                                                        "5y",
                                                        widget.graphData
                                                            .graphData,
                                                      ),
                                      )
                                      .reduce(max)
                                      .toDouble(),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: listData(
                                        _helper.extractPriceFromGraph(
                                          _selectedIndex == 0
                                              ? _helper
                                                  .extractGraphBasedOnPeriod(
                                                  "1m",
                                                  widget.graphData.graphData,
                                                )
                                              : _selectedIndex == 1
                                                  ? _helper
                                                      .extractGraphBasedOnPeriod(
                                                      "1y",
                                                      widget
                                                          .graphData.graphData,
                                                    )
                                                  : _selectedIndex == 3
                                                      ? widget.dailyGraphData
                                                          .graphData
                                                      : _helper
                                                          .extractGraphBasedOnPeriod(
                                                          "5y",
                                                          widget.graphData
                                                              .graphData,
                                                        ),
                                        ),
                                      ),
                                      colors: [const Color(0xff02d39a)],
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: false,
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradientFrom: const Offset(0, .9),
                                        gradientTo: const Offset(
                                          0,
                                          0.5,
                                        ),
                                        colors: [
                                          const Color(
                                            0xff02d39a,
                                          ).withOpacity(.01),
                                          const Color(
                                            0xff02d39a,
                                          ).withOpacity(.3)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                swapAnimationDuration: Duration.zero,
                              ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: height * 0.03,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: height * 0.02,
                              left: width * 0.04,
                            ),
                            child: AutoSizeText(
                              "Market Data",
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: height * 0.02,
                              right: width * 0.04,
                            ),
                            child: AutoSizeText(
                              "#${widget.cryptoData.rank.toStringAsFixed(0)}",
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: height * 0.015,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.5,
                              child: ListTile(
                                title: AutoSizeText(
                                  "Market Cap",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: AutoSizeText(
                                  widget.cryptoData.marketCap == 0
                                      ? "NA"
                                      : "\u{20B9} ${NumberFormat.compact().format(
                                          widget.cryptoData.marketCap,
                                        )}",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: width * 0.5,
                                      child: ListTile(
                                        title: AutoSizeText(
                                          "Low (24h)",
                                          style: GoogleFonts.rubik(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: AutoSizeText(
                                          widget.cryptoData.low24h == 0
                                              ? "NA"
                                              : "\u{20B9} ${NumberFormat.compact().format(
                                                  widget.cryptoData.low24h,
                                                )}",
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.5,
                                      child: ListTile(
                                        title: AutoSizeText(
                                          "Total Volume",
                                          style: GoogleFonts.rubik(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: AutoSizeText(
                                          widget.cryptoData.totalVolume == 0
                                              ? "NA"
                                              : "\u{20B9} ${NumberFormat.compact().format(
                                                  widget.cryptoData.totalVolume,
                                                )}",
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: width * 0.5,
                                      child: ListTile(
                                        title: AutoSizeText(
                                          "High (24h)",
                                          style: GoogleFonts.rubik(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: AutoSizeText(
                                          widget.cryptoData.high24h == 0
                                              ? "NA"
                                              : "\u{20B9} ${NumberFormat.compact().format(
                                                  widget.cryptoData.high24h,
                                                )}",
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.5,
                                      child: ListTile(
                                        title: AutoSizeText(
                                          "Circulating Supply",
                                          style: GoogleFonts.rubik(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: AutoSizeText(
                                          widget.cryptoData.circulatingSupply ==
                                                  0
                                              ? "NA"
                                              : "\u{20B9} ${NumberFormat.compact().format(
                                                  widget.cryptoData
                                                      .circulatingSupply,
                                                )}",
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.04,
                        ),
                        child: AutoSizeText(
                          "${widget.cryptoData.name} Description",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _globalDataLoaded
                          ? const CircularProgressIndicator()
                          : Container(
                              margin: EdgeInsets.only(
                                top: height * 0.02,
                                left: width * 0.04,
                                right: width * 0.04,
                              ),
                              child: ReadMoreText(
                                _staticDataModel.description == "unKnown"
                                    ? "Not Available"
                                    : _staticDataModel.description,
                                trimLines: 8,
                                trimMode: TrimMode.Line,
                                colorClickableText: const Color(0xFF52CAF5),
                                trimCollapsedText: 'Read more',
                                trimExpandedText: 'Read less',
                                style: GoogleFonts.rubik(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.left,
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
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.04,
                          bottom: height * 0.02,
                        ),
                        child: AutoSizeText(
                          "Asset's",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _globalDataLoaded
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    launch(
                                      _helper.extractWebsite(
                                        _staticDataModel.links,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: _helper.extractWebsite(
                                              _staticDataModel.links,
                                            ) ==
                                            "None"
                                        ? 0
                                        : width,
                                    margin: EdgeInsets.only(
                                      left: width * 0.04,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: width * 0.04,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/website.png?alt=media&token=f7de66d1-8492-4574-a7b7-08ec5cdca54e",
                                            color: Colors.white,
                                            height: height * 0.05,
                                            width: width * 0.05,
                                          ),
                                        ),
                                        AutoSizeText(
                                          "Website",
                                          style: GoogleFonts.raleway(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    launch(
                                      _helper.extractWhitePaper(
                                        _staticDataModel.whitepaper,
                                      ),
                                    );
                                  },
                                  child: _helper.extractWhitePaper(
                                            _staticDataModel.whitepaper,
                                          ) ==
                                          "None"
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Container(
                                          width: width,
                                          margin: EdgeInsets.only(
                                            left: width * 0.04,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * 0.04,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/whitepaper.png?alt=media&token=85789045-7c9b-42ab-9833-83d2f2383aa3",
                                                  color: Colors.white,
                                                  height: height * 0.05,
                                                  width: width * 0.05,
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Whitepaper",
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                InkWell(
                                  onTap: () {
                                    launch(
                                      _helper.extractFacebook(
                                        _staticDataModel.links,
                                      ),
                                    );
                                  },
                                  child: _helper.extractFacebook(
                                            _staticDataModel.links,
                                          ) ==
                                          "None"
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Container(
                                          width: width,
                                          margin: EdgeInsets.only(
                                            left: width * 0.04,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * 0.04,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/facebook.png?alt=media&token=886a4966-5a3d-41b9-8d77-10fe7b0b7635",
                                                  color: Colors.white,
                                                  height: height * 0.05,
                                                  width: width * 0.05,
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Facebook",
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                InkWell(
                                  onTap: () {
                                    launch(
                                      _helper.extractReddit(
                                        _staticDataModel.links,
                                      ),
                                    );
                                  },
                                  child: _helper.extractReddit(
                                            _staticDataModel.links,
                                          ) ==
                                          "None"
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Container(
                                          width: width,
                                          margin: EdgeInsets.only(
                                            left: width * 0.04,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * 0.04,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/reddit.png?alt=media&token=631c1490-0383-4700-848f-dfa3cf78b0ff",
                                                  color: Colors.white,
                                                  height: height * 0.05,
                                                  width: width * 0.05,
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Reddit",
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                InkWell(
                                  onTap: () {
                                    launch(
                                      _helper.extractSourceCode(
                                        _staticDataModel.links,
                                      ),
                                    );
                                  },
                                  child: _helper.extractSourceCode(
                                            _staticDataModel.links,
                                          ) ==
                                          "None"
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Container(
                                          width: width,
                                          margin: EdgeInsets.only(
                                            left: width * 0.04,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * 0.04,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/source_code.png?alt=media&token=9941c0eb-f514-4ddc-b784-98cdd3450c8b",
                                                  color: Colors.white,
                                                  height: height * 0.05,
                                                  width: width * 0.05,
                                                ),
                                              ),
                                              AutoSizeText(
                                                "Source Code",
                                                style: GoogleFonts.raleway(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
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
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.04,
                        ),
                        child: AutoSizeText(
                          "Related News",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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
                                  return index == 4
                                      ? Container(
                                          width: width,
                                          height: height * 0.06,
                                          margin: const EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            right: 15,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.to(
                                                () => SeeAllNewsScreen(),
                                              );
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                const Color(0xFF52CAF5),
                                              ),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    7.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "See All",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
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
                                              model.newsCompleteList[index]
                                                  .title,
                                              model.newsCompleteList[index]
                                                  .source,
                                            )
                                                .then((value) {
                                              Get.to(
                                                () => NewsSummaryScreen(
                                                  model.newsCompleteList[index],
                                                  value,
                                                ),
                                              );
                                            });
                                          },
                                          child: Container(
                                            margin:
                                                EdgeInsets.all(width * 0.04),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15.0,
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          _helper.extractImgUrl(
                                                        model
                                                            .newsCompleteList[
                                                                index]
                                                            .photoUrl,
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
                                                        model
                                                            .newsCompleteList[
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
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
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
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                "${_helper.convertToAgo(
                                                                  model
                                                                      .newsCompleteList[
                                                                          index]
                                                                      .publishedDate,
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
                                                              model
                                                                  .newsCompleteList[
                                                                      index]
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
                                        );
                                },
                                childCount: 5,
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
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.04,
                        ),
                        child: AutoSizeText(
                          "People Also Watch",
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Consumer<CryptoMarketDataProvider>(
                        builder: (ctx, model, _) {
                      return SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                            left: 15,
                            bottom: 15,
                          ),
                          height: height * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: model.topCryptocurrencyCoinsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<CryptoMarketDataProvider>(
                                    context,
                                    listen: false,
                                  )
                                      .getCryptocurrencyCountByNameSymbol(
                                    model
                                        .topCryptocurrencyCoinsList[index].name,
                                    model.topCryptocurrencyCoinsList[index]
                                        .symbol,
                                  )
                                      .then(
                                    (value) {
                                      Get.to(
                                        () => MarketDataScreen(
                                          model.topCryptocurrencyCoinsList[
                                              index],
                                          widget.graphData,
                                          widget.dailyGraphData,
                                          value,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    8,
                                  ),
                                  margin: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  height: height * 0.15,
                                  width: width * 0.42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      25,
                                    ),
                                    color: const Color(
                                      0xFF292f33,
                                    ),
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
                                                model
                                                    .topCryptocurrencyCoinsList[
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
                                                          const EdgeInsets.only(
                                                        left: 3,
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: model
                                                                    .topCryptocurrencyCoinsList[
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
                                                      model.topCryptocurrencyCoinsList[index]
                                                                  .priceChangePercentage24h >=
                                                              0
                                                          ? "+${model.topCryptocurrencyCoinsList[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                          : "${model.topCryptocurrencyCoinsList[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                                      maxLines: 1,
                                                      minFontSize: 14,
                                                      style: GoogleFonts.rubik(
                                                        color: model
                                                                    .topCryptocurrencyCoinsList[
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
                                          model
                                              .topCryptocurrencyCoinsList[index]
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
                                          "\u{20B9} ${model.topCryptocurrencyCoinsList[index].price.toString().startsWith("0.") ? model.topCryptocurrencyCoinsList[index].price.toString() : _helper.removeDecimal(model.topCryptocurrencyCoinsList[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

List<FlSpot> listData(List<num> data) {
  return data.asMap().entries.map((e) {
    return FlSpot(e.key.toDouble(), e.value.toDouble());
  }).toList();
}
