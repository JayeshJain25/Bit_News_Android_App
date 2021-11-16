import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/coin_paprika_market_static_data_model.dart';
import 'package:crypto_news/model/crypto_data_graph_model.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/news_provider.dart';
import 'package:crypto_news/screen/see_all_news_screen.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news_summary_screen.dart';

class MarketDataScreen extends StatefulWidget {
  CryptoMarketDataModel cryptoData;
  final CryptoDataGraphModel graphData;

  MarketDataScreen(this.cryptoData, this.graphData);

  @override
  _MarketDataScreenState createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  final _helper = Helper();
  int _selectedIndex = 0;

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
        .getCoinPaprikaMarketStaticData(widget.cryptoData.symbol)
        .then((value) {
      setState(() {
        _globalDataLoaded = false;
        _staticDataModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                      child: Container(
                        color: const Color(0xFF35444E),
                        height: 170,
                        width: width,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/57735-crypto-coins.gif?alt=media&token=a696da3c-4285-4479-aade-1d65ee4ec2ad',
                          height: 32,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 110.0 * controller.value),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 22,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            AutoSizeText(
                              'Statistic',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CachedNetworkImage(
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/plus-square.png?alt=media&token=5287a89f-803c-451f-a3b6-51e80616b3f1",
                              color: Colors.white,
                              width: width * 0.05,
                              height: height * 0.03,
                            )
                          ],
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
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: height * 0.03,
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
                                top: height * 0.04,
                              ),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return gradient.createShader(
                                    Offset.zero & bounds.size,
                                  );
                                },
                                child: AutoSizeText(
                                  "\u{20B9} ${widget.cryptoData.price.toString().startsWith("0.") ? widget.cryptoData.price.toString() : _helper.removeDecimal(widget.cryptoData.price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    '1m',
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
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    '1y',
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
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    '5y',
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
                      child: Container(
                        margin: EdgeInsets.only(
                          top: height * 0.03,
                          left: width * 0.04,
                          right: width * 0.04,
                        ),
                        height: height * 0.3,
                        color: Colors.transparent,
                        child: LineChart(
                          LineChartData(
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
                                        : _helper
                                            .extractGraphBasedOnPeriod(
                                              "5y",
                                              widget.graphData.graphData,
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
                                          ? _helper.extractGraphBasedOnPeriod(
                                              "1y",
                                              widget.graphData.graphData,
                                            )
                                          : _helper.extractGraphBasedOnPeriod(
                                              "5y",
                                              widget.graphData.graphData,
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
                                          ? _helper.extractGraphBasedOnPeriod(
                                              "1y",
                                              widget.graphData.graphData,
                                            )
                                          : _helper.extractGraphBasedOnPeriod(
                                              "5y",
                                              widget.graphData.graphData,
                                            ),
                                )
                                .reduce(max)
                                .toDouble(),
                            lineBarsData: [
                              LineChartBarData(
                                spots: listData(
                                  _helper.extractPriceFromGraph(
                                    _selectedIndex == 0
                                        ? _helper.extractGraphBasedOnPeriod(
                                            "1m",
                                            widget.graphData.graphData,
                                          )
                                        : _selectedIndex == 1
                                            ? _helper.extractGraphBasedOnPeriod(
                                                "1y",
                                                widget.graphData.graphData,
                                              )
                                            : _helper.extractGraphBasedOnPeriod(
                                                "5y",
                                                widget.graphData.graphData,
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
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
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
                                  "\u{20B9} ${NumberFormat.compact().format(
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
                                          "\u{20B9} ${NumberFormat.compact().format(
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
                                          "\u{20B9} ${NumberFormat.compact().format(
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
                                          "\u{20B9} ${NumberFormat.compact().format(
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
                                          "\u{20B9} ${NumberFormat.compact().format(
                                            widget.cryptoData.circulatingSupply,
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
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
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
                                _staticDataModel.description,
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
                        ),
                        child: AutoSizeText(
                          "Asset",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
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
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontSize: 14,
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
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 14,
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
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 14,
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
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 14,
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
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 14,
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
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
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
                                            Get.to(
                                              () => NewsSummaryScreen(
                                                model.newsCompleteList[index],
                                              ),
                                            );
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
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: 15,
                          bottom: 15,
                        ),
                        height: height * 0.15,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MarketDataScreen(
                                      model.trendingCoins[index],
                                      widget.graphData,
                                    ),
                                  ),
                                  ModalRoute.withName("/homeScreen"),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              model.trendingCoins[index].image,
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
                                                    style: GoogleFonts.rubik(
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
