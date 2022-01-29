import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/screen/advertise_screen.dart';
import 'package:crypto_news/widget/news_web_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  String contactUsHtml =
      "https://61d843fb7731b40c582e97a0--elegant-pasteur-7d84bc.netlify.app/";
  String privacy = "https://elated-raman-42d560.netlify.app/";
  String developers = "https://tender-mahavira-21e390.netlify.app/";
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                      child: FittedBox(
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color(0xFF1B1B1B),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/layout.png?alt=media&token=236d6ca3-41ad-41a3-9374-4487e0977354",
                    color: Colors.white,
                    width: 20,
                    height: 40,
                  ),
                  title: AutoSizeText(
                    "Layout",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54,
                    ),
                    child: Center(
                      child: Text(
                        "Dark",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color(0xFF1B1B1B),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => AdvertiseScreen());
                      },
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/advertise.png?alt=media&token=b46197fb-fa74-479e-b5d7-d55d32a302b0",
                          color: Colors.white,
                          width: 25,
                          height: 50,
                        ),
                        title: AutoSizeText(
                          "Advertise",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: width * 0.037,
                      endIndent: width * 0.037,
                      thickness: 1,
                      height: 1,
                      color: const Color(0xFF292f33),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => NewsWebView(contactUsHtml, false, "setting"),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        title: AutoSizeText(
                          "Contact Us",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: width * 0.037,
                      endIndent: width * 0.037,
                      thickness: 1,
                      height: 1,
                      color: const Color(0xFF292f33),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => NewsWebView(developers, false, "setting"),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        title: AutoSizeText(
                          "Developer's",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color(0xFF1B1B1B),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                          () => NewsWebView(privacy, false, "setting"),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.privacy_tip,
                          color: Colors.white,
                        ),
                        title: AutoSizeText(
                          "Privacy Policy",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: width * 0.037,
                      endIndent: width * 0.037,
                      thickness: 1,
                      height: 1,
                      color: const Color(0xFF292f33),
                    ),
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/feedback.png?alt=media&token=4f9bac74-4bed-4dd6-bec3-b0300e9fd8cc",
                        color: Colors.white,
                        width: 25,
                        height: 50,
                      ),
                      title: AutoSizeText(
                        "Feedback",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(
                      indent: width * 0.037,
                      endIndent: width * 0.037,
                      thickness: 1,
                      height: 1,
                      color: const Color(0xFF292f33),
                    ),
                    ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/rate.png?alt=media&token=cf924fd4-f6ca-48a1-820d-4672884c4ec9",
                        color: Colors.white,
                        width: 30,
                        height: 50,
                      ),
                      title: AutoSizeText(
                        "Rate Us",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
                left: width * 0.05,
              ),
              child: AutoSizeText(
                "Follow Us",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      launch(
                        "https://discord.gg/v8HPFsV4jQ",
                      );
                    },
                    child: Container(
                      width: width * 0.45,
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF738ADB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/discord.png?alt=media&token=ab6626d5-931e-4a03-bffb-8df4e0949ff9",
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: AutoSizeText(
                              "Discord",
                              maxFontSize: 18,
                              minFontSize: 18,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(
                        "https://www.instagram.com/cryptoX_in/",
                      );
                    },
                    child: Container(
                      width: width * 0.45,
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFb62f78),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/instagram.png?alt=media&token=c53453e3-a2ef-41f8-aa34-d5824d5c24db",
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: AutoSizeText(
                              "Instagram",
                              maxFontSize: 18,
                              minFontSize: 18,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      // launch(
                      //   "",
                      // );
                    },
                    child: Container(
                      width: width * 0.45,
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3b5998),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/facebook1.png?alt=media&token=e0f304d8-7fb4-4b3a-ac8d-ed268522b5b1",
                              height: 40,
                              width: 40,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: AutoSizeText(
                              "Facebook",
                              maxFontSize: 18,
                              minFontSize: 18,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.45,
                    height: height * 0.2,
                    color: Colors.transparent,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
