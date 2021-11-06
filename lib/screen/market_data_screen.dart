import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/coin_paprika_market_static_data_model.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class MarketDataScreen extends StatefulWidget {
  final CryptoMarketDataModel cryptoData;

  const MarketDataScreen(this.cryptoData);

  @override
  _MarketDataScreenState createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  final _helper = Helper();

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
      body: Consumer<CryptoMarketDataProvider>(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.05,
                      left: width * 0.03,
                      right: width * 0.03,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: () {
                            Get.back();
                          },
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
                  GlassmorphicContainer(
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
                              return gradient
                                  .createShader(Offset.zero & bounds.size);
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
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.03,
                      left: width * 0.04,
                      right: width * 0.04,
                    ),
                    height: height * 0.3,
                    color: Colors.transparent,
                  ),
                  Container(
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
                  Row(
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
                  Container(
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
                                        color: Colors.white.withOpacity(0.7),
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
                                        color: Colors.white.withOpacity(0.7),
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
                                        color: Colors.white.withOpacity(0.7),
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
                                        color: Colors.white.withOpacity(0.7),
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
                  Container(
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
                  Container(
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
                  if (_globalDataLoaded)
                    const CircularProgressIndicator()
                  else
                    Container(
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
                  Container(
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
                  Container(
                    margin: EdgeInsets.only(
                      top: height * 0.1,
                      left: width * 0.04,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
