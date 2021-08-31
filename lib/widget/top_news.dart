import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'news_web_view.dart';

class TopNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Get.to(() => const NewsWebView(
            "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"));
      },
      child: Container(
        width: width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF491f01), Colors.black])),
        child: Stack(children: <Widget>[
          Positioned(
            right: 15,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.15), BlendMode.dstIn),
              child: Image(
                  height: height / 3,
                  width: width / 2,
                  fit: BoxFit.contain,
                  image: const NetworkImage(
                      'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
            ),
          ),
          Positioned(
            left: 25,
            child: Image(
                height: height / 9,
                width: width / 9,
                fit: BoxFit.contain,
                image: const NetworkImage(
                    'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
          ),
          Positioned(
            top: 70,
            left: 28,
            child: SizedBox(
              width: width * 0.2,
              height: height * 0.03,
              child: AutoSizeText(
                'BTC',
                style: GoogleFonts.rubik(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 100,
            child: Container(
                padding: const EdgeInsets.all(16.0),
                width: width * 0.81,
                height: height * 0.23,
                child: AutoSizeText(
                  'MATIC is Innovative, but It Looks as If It Might Not Be Very Useful',
                  minFontSize: 14,
                  maxLines: 4,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
