import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  final TabController tabController;
  const SettingScreen({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Column(
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
                color: const Color(0xFF0e0c0a),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 35),
                      child: AutoSizeText(
                        'Settings',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: height * 0.1,
                left: width * 0.4,
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                    user!.photoURL ??
                        "https://www.pngkey.com/png/full/114-1149847_avatar-unknown-dp.png",
                  ),
                ),
              ),
              // Positioned(
              //   top: height * 0.21,
              //   left: width * 0.37,
              //   child: AutoSizeText(
              //     user.displayName ?? "Unknown",
              //     style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
              //   ),
              // ),
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
              color: const Color(0xFF1a1b2e),
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
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: height * 0.03,
                  left: width * 0.05,
                ),
                child: AutoSizeText(
                  "Apperance",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.05,
            ),
            width: width * 0.9,
            height: height * 0.2,
            decoration: BoxDecoration(
              color: const Color(0xFF1a1b2e),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
