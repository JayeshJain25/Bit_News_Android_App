import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/screen/onboarding_screen.dart';
import 'package:crypto_news/widget/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool signUpComplete = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              bottom: PreferredSize(
                preferredSize: const Size(0, 60),
                child: Container(
                  color: const Color(0xFF292f33),
                ),
              ),
              expandedHeight: height * 0.5,
              flexibleSpace: Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2a5470), Color(0xFF4c4177)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      child: SizedBox(
                        height: height * 0.94,
                        width: width,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo_without_bg.png?alt=media&token=f03f5a0b-b15e-4314-bd26-20468e6f4fb1",
                          height: 400,
                          width: 400,
                          fit: BoxFit.cover,
                        ),
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
                          top: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: height * 0.01),
            ),
            SliverToBoxAdapter(
              child: AutoSizeText(
                "CryptoX",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: height * 0.04),
            ),
            SliverToBoxAdapter(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AutoSizeText(
                  "Keeps you updated",
                  maxLines: 1,
                  minFontSize: 30,
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 38,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AutoSizeText(
                  "with the constantly evolving space",
                  maxLines: 1,
                  minFontSize: 17,
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 21,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: height * 0.09),
            ),
            SliverToBoxAdapter(
              child: Align(
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      Size(width * 0.61, height * 0.06),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      signUpComplete
                          ? const Color(0xFF00fa89)
                          : const Color(0xFF24a0ed),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final provider = Provider.of<GoogleSignInProvider>(
                      context,
                      listen: false,
                    );
                    await provider.signInwithGoogle().then((value) {
                      setState(() {
                        signUpComplete = true;
                      });
                      Get.off(() => OnboardingScreen());
                    });
                  },
                  child: signUpComplete
                      ? FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  "Sign up Completed",
                                  maxLines: 1,
                                  minFontSize: 15,
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFF006230),
                                )
                              ],
                            ),
                          ),
                        )
                      : FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "lib/assets/google.png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                AutoSizeText(
                                  "Sign up with Google",
                                  maxLines: 1,
                                  minFontSize: 15,
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: height * 0.02),
            ),
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('skip', true);
                  Get.off(() => OnboardingScreen());
                },
                child: AutoSizeText(
                  "Skip",
                  style: GoogleFonts.raleway(
                    color: Colors.white60,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
