import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sizer/sizer.dart';

class MarketDataScreen extends StatefulWidget {
  final CryptoMarketDataModel cryptoData;

  const MarketDataScreen(this.cryptoData);

  @override
  _MarketDataScreenState createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  final _helper = Helper();

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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
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
        child: Column(
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
                  Container(
                    margin: EdgeInsets.only(right: width * 0.04),
                    child: AutoSizeText(
                      widget.cryptoData.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/plus-square.png?alt=media&token=5287a89f-803c-451f-a3b6-51e80616b3f1",
                    color: Colors.white,
                    width: width * 0.06,
                    height: height * 0.04,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.03,
              ),
              child: Hero(
                tag: widget.cryptoData.name,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.cryptoData.image,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
              ),
              child: AutoSizeText(
                widget.cryptoData.symbol.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return gradient.createShader(Offset.zero & bounds.size);
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
    );
  }
}
