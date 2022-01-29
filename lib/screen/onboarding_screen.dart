import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/widget/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onboarding/onboarding.dart';

class OnboardingScreen extends StatelessWidget {
  final onboardingPagesList = [
    PageModel(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 400,
            padding: const EdgeInsets.only(bottom: 45.0),
            child: CachedNetworkImage(
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/homepage_aniamtion.png?alt=media&token=7e646e96-de69-422d-a4bc-1cad39404f04",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Welcome Aboard',
              style: GoogleFonts.poppins(
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "CryptoX is a machine learning powered next-generation cryptocurrency news aggregator platform with complete blockchain data from all around the globe.",
              style: GoogleFonts.rubik(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 45.0),
            height: 400,
            child: CachedNetworkImage(
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/page2.png?alt=media&token=aa595d59-7038-4d8d-9a93-0d58463930a0",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              'User Friendly Interface',
              style: GoogleFonts.poppins(
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "CryptoX is designed in such a way that every section is easily accessible. The explainer section provides you with an in-depth introduction to the cryptocurrency world.",
              style: GoogleFonts.rubik(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    ),
    PageModel(
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 45.0),
            height: 300,
            child: CachedNetworkImage(
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/page3.png?alt=media&token=825e40de-40f1-4278-a854-296a9f4a76a5",
              fit: BoxFit.cover,
              height: 300,
              width: 350,
            ),
          ),
          const SizedBox(
            height: 125,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Claim Your Free NFT',
              style: GoogleFonts.poppins(
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "You are all set. Also, don't forget to drop your polygon wallet addresses on our discord channel for free NFT airdrops. You will find the discord link within the app.",
              style: GoogleFonts.rubik(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Onboarding(
        background: const Color(0xFF171717),
        pages: onboardingPagesList,
        skipButtonStyle: SkipButtonStyle(
          skipButtonColor: const Color(0xFFb33f40),
          skipButtonText: Text(
            "Skip",
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
          ),
        ),
        proceedButtonStyle: ProceedButtonStyle(
          proceedpButtonText: Text(
            "Continue",
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
          ),
          proceedButtonRoute: (context) {
            return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AppBottomNavigationBar(),
              ),
              (route) => false,
            );
          },
        ),
        indicator: Indicator(
          indicatorDesign: IndicatorDesign.line(
            lineDesign: LineDesign(
              lineType: DesignType.line_uniform,
            ),
          ),
        ),
      ),
    );
  }
}
