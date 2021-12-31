import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/screen/sign_in_screen.dart';
import 'package:crypto_news/widget/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late bool? skip;
  @override
  void initState() {
    super.initState();
    if (user != null) {
      Provider.of<GoogleSignInProvider>(context, listen: false)
          .getUserData(user!.uid);
    }
    getBoolValuesSF()!.then((value) => skip = value);
    Timer(
      const Duration(seconds: 3),
      () => Get.off(
        () =>
            (user != null || skip!) ? AppBottomNavigationBar() : SignInScreen(),
      ),
    );
  }

  Future<bool?>? getBoolValuesSF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('skip') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010101),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400,
            height: 250,
            child: CachedNetworkImage(
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
            ),
          ),
          AutoSizeText(
            "CryptoX",
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
