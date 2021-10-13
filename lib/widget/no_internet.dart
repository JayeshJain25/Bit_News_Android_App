import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/no_internet.gif?alt=media&token=3fe80377-8174-4e84-862a-efdac382cfcb",
          ),
          AutoSizeText(
            "Whoops!!",
            style: GoogleFonts.rubik(color: Colors.white, fontSize: 20),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Center(
              child: AutoSizeText(
                "Slow or no internet connection\nPlease check your internet settings",
                style: GoogleFonts.rubik(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
