import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  final TabController tabController;
  const SettingScreen({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SizedBox(
        height: height * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: height * 0.2,
                  color: Colors.black,
                ),
                Container(
                  width: width,
                  height: height * 0.15,
                  color: const Color(0xFF1B1B1B),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 35),
                        child: AutoSizeText(
                          'Settings',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (user != null)
                  Positioned(
                    top: height * 0.1,
                    left: width * 0.4,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                        user.photoURL ??
                            "https://www.pngkey.com/png/full/114-1149847_avatar-unknown-dp.png",
                      ),
                    ),
                  )
                else
                  Positioned(
                    top: height * 0.12,
                    left: width * 0.2,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(width * 0.65, height * 0.06),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF24a0ed),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            user = FirebaseAuth.instance.currentUser;
                          });
                        });

                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('skip', false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
              ],
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
                left: width * 0.05,
              ),
              child: AutoSizeText(
                "Follow Us",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
                left: width * 0.05,
              ),
              width: width * 0.9,
              height: height * 0.08,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      launch(
                        "https://discord.gg/CTBpvzDbZT",
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/discord.png?alt=media&token=ab6626d5-931e-4a03-bffb-8df4e0949ff9",
                      height: 50,
                      width: 50,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(
                        "https://www.instagram.com/cryptoX_in/",
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/instagram.png?alt=media&token=c53453e3-a2ef-41f8-aa34-d5824d5c24db",
                      height: 50,
                      width: 50,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // launch(

                      // );
                    },
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/facebook1.png?alt=media&token=e0f304d8-7fb4-4b3a-ac8d-ed268522b5b1",
                      height: 50,
                      width: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 55,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.circle,
                    color: Colors.grey,
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: AutoSizeText(
                    "Layout",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Divider(
                indent: width * 0.037,
                endIndent: width * 0.037,
                thickness: 1,
                height: 1,
                color: const Color(0xFF292f33),
              ),
            ),
            SizedBox(
              height: 55,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/advertise.png?alt=media&token=0ed94be2-1360-41ce-be6d-9a7424786589",
                    color: Colors.grey,
                    width: 25,
                    height: 50,
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: AutoSizeText(
                    "Advertise",
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Divider(
                indent: width * 0.037,
                endIndent: width * 0.037,
                thickness: 1,
                height: 1,
                color: const Color(0xFF292f33),
              ),
            ),
            SizedBox(
              height: 55,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.feedback,
                    color: Colors.grey,
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: AutoSizeText(
                    "Feedback",
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Divider(
                indent: width * 0.037,
                endIndent: width * 0.037,
                thickness: 1,
                height: 1,
                color: const Color(0xFF292f33),
              ),
            ),
            SizedBox(
              height: 55,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.privacy_tip,
                    color: Colors.grey,
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: AutoSizeText(
                    "Privacy Policy",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Divider(
                indent: width * 0.037,
                endIndent: width * 0.037,
                thickness: 1,
                height: 1,
                color: const Color(0xFF292f33),
              ),
            ),
            SizedBox(
              height: 55,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: AutoSizeText(
                    "Contact Us",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Divider(
                indent: width * 0.037,
                endIndent: width * 0.037,
                thickness: 1,
                height: 1,
                color: const Color(0xFF292f33),
              ),
            ),
            SizedBox(
              height: 55,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.grey,
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: AutoSizeText(
                    "Rate Us",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.05,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 30,
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
