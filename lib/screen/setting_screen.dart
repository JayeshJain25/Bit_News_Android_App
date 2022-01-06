import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/screen/crypto_explainer_screen.dart';
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
      """"<html lang="en"><head> <meta charset="UTF-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"> <link rel="preconnect" href="https://fonts.googleapis.com"> <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> <link href="https://fonts.googleapis.com/css2?family=Rubik:wght@300&display=swap" rel="stylesheet"> <link rel="preconnect" href="https://fonts.googleapis.com"> <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin> <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet"> <title>CryptoExplainer</title> <style>body{background: #fff; font-family: 'Poppins', sans-serif;}.heading{box-shadow: rgba(0, 0, 0, 0.1) 0px 5px 5px;}h1{color: black; font-size: 22px; margin-top: 25px; padding-top: 50px; font-weight: 600; text-align: center;}.heading h3{color: black; margin-top: 30px; padding-bottom: 5px; font-size: 32px; text-align: center; font-weight: 800; font-family: 'Poppins', sans-serif;}h5{color: black; padding-top: 25px; display: block; margin-left: 3px; margin-right: 3px; font-size: 20px; text-align: center; font-family: 'Rubik', sans-serif; font-weight: 500;}img{display: block; margin-top: 30px; margin-left: auto; margin-right: auto; width: 60%;}p{color: black; display: block; margin-left: 2px; margin-right: 2px; font-size: 18px; text-align: center; font-family: 'Poppins', sans-serif; font-weight: 500; margin-bottom: 0;}.enquiry{margin: 15px; background-color: #faf0e6; padding-bottom: 20px;}.enquiry h5{font-weight: 600; padding-top: 2px;}.enquiry h1{margin-bottom: 25px;}.enquiry p:nth-child(3){font-weight: 500; font-size: 2px;}.enquiry p span{font-weight: 600;}.main h5{font-size: 14px; font-weight: 600;}.link{background-color: #100c08; color: white; text-align: center; margin-bottom: 20px;}.link h3{font-size : 20px; font-weight: 500; padding: 20px 0 20px; font-family: 'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;}.link p{color: white; font-size : 16px; font-family: 'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif; font-weight: 400;}.link a{margin-bottom: 20px; margin-top: 20px;}<b:if cond='data:blog.pageType==&quot;item&quot;'> <style type='text/css'> /*<![CDATA[*/ @font-face{font-family:"fontfutura";src:url("https://fonts.googleapis.com/css?family=Open+Sans") format("ttf");font-weight:normal;font-style:normal;}a.btn-google{color:rgb(0, 0, 0)}.btn{padding:10px 16px;margin:5px;font-size:18px;line-height:1.3333333;border-radius:12px;text-align:center;white-space:nowrap;vertical-align:middle;-ms-touch-action:manipulation;touch-action:manipulation;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;border:1px solid transparent;font-weight:500;text-decoration:none;display:inline-block}.btn:active:focus,.btn:focus{outline:0}.btn:focus,.btn:hover{color:#333;text-decoration:none;outline:0}.btn:active{outline:0;-webkit-box-shadow:inset 0 3px 5px rgba(0,0,0,.125);box-shadow:inset 0 3px 5px rgba(0,0,0,.125)}.btn-google{color:#fff;background-color:rgb(255, 255, 255);border-color:#000;padding:15px 16px 5px 40px;position:relative;font-family:'Trebuchet MS', 'Lucida Sans Unicode', 'Lucida Grande', 'Lucida Sans', Arial, sans-serif;font-weight:600}.btn-google:focus{color:#fff;background-color:#555;border-color:#000}.btn-google:active,.btn-google:hover{color:#fff;background-color:#555;border-color:#000;}.btn-google:before{content:"";background-image:url(https://4.bp.blogspot.com/-52U3eP2JDM4/WSkIT1vbUxI/AAAAAAAArQA/iF1BeARv2To-2FGQU7V6UbNPivuv_lccACLcB/s30/nexus2cee_ic_launcher_play_store_new-1.png);background-size:cover;background-repeat:no-repeat;width:30px;height:30px;position:absolute;left:6px;top:50%;margin-top:-15px}.btn-google:after{content:"GET IT ON";position:absolute;top:5px;left:40px;font-size:10px;font-weight:400;}/*]]>*/ </style> </b:if> </style> </head><body> <div class="main"> <div class="heading"> <h3>Contact us</h3> </div><img src="https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/conact_us.png?alt=media&token=4e5d330d-169b-406d-9a4b-9fb1e788de6f" alt=""> <div id="main"> <h5> CryptoX is a blockchain news aggregator app which connects users through daily updates of the cryptocurrency market.<!-- We are driven to provide you with news from all over the globe right within our app. We believe blockchain will continue it's dominance and soon be an inseperable part of our lives for it's various applications and capabilities. --> </h5> </div><div class="enquiry"> <h1> General Enquires </h1> <p> <span>Tel</span>: +91 99676 10365 <br>+91 98199 06537 </p><br><p> You can also write to us at </p><h5>help.cryptox@gmail.com</h5> </div><div class="link"> <h3> Get the best experience on our app </h3> <p> Download the app now and get the latest news of the cryptocurrency world </p><a class="btn btn-google" href="#" title="Google Play">Google Play</a> </div></div></body></html>""";

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
            InkWell(
              onTap: () {
                Get.to(
                  () => CryptoExplainerScreen(
                    contactUsHtml,
                  ),
                );
              },
              child: SizedBox(
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
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
