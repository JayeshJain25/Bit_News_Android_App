import 'package:animate_icons/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/conversionToolScreen.dart';
import '../screen/settingScreen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late AnimateIconController settingAnimation;

  initState() {
    super.initState();
    settingAnimation = AnimateIconController();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    _controller.forward();
    return Container(
      height: height,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.055, top: width * 0.11),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: AutoSizeText(
                        'J',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.07,
                    ),
                    FadeTransition(
                      opacity: _animation,
                      child: Container(
                        width: width * 0.37,
                        child: FittedBox(
                          child: Text(
                            "Jayesh Jain",
                            style: GoogleFonts.poppins(
                                fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.27,
                    ),
                    AnimateIcons(
                      startIcon: Icons.settings,
                      endIcon: Icons.settings,
                      controller: settingAnimation,
                      size: 25,
                      onStartIconPress: () {
                        Get.to(() => SettingScreen());
                        return true;
                      },
                      onEndIconPress: () {
                        Get.to(() => SettingScreen());
                        return true;
                      },
                      duration: Duration(milliseconds: 500),
                      startIconColor: Colors.white,
                      endIconColor: Colors.white,
                      clockwise: false,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.17,
                ),
                Container(
                  margin: EdgeInsets.only(right: width * 0.423),
                  child: Material(
                    color: Colors.black,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      splashColor: Colors.white30,
                      onTap: () {
                        Get.to(() => ConversionToolScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: <Widget>[
                            ImageIcon(
                              AssetImage("lib/assets/equal.png"),
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            FadeTransition(
                              opacity: _animation,
                              child: Container(
                                width: width * 0.4,
                                child: FittedBox(
                                  child: Text(
                                    "Conversion Tool",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                // Container(
                //   margin: EdgeInsets.only(right: width * 0.523),
                //   child: Material(
                //     color: Colors.black,
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(25),
                //       splashColor: Colors.white30,
                //       onTap: () {},
                //       child: Padding(
                //         padding: const EdgeInsets.all(3.0),
                //         child: Row(
                //           children: <Widget>[
                //             Icon(
                //               Icons.group_rounded,
                //               color: Colors.white,
                //             ),
                //             SizedBox(
                //               width: width * 0.03,
                //             ),
                //             FadeTransition(
                //               opacity: _animation,
                //               child: Container(
                //                 width: width * 0.3,
                //                 child: FittedBox(
                //                   child: Text(
                //                     "Community",
                //                     style: GoogleFonts.poppins(
                //                         fontSize: 18, color: Colors.white),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
