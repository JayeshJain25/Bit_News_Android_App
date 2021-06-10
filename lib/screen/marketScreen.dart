import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widget/drawerScreen.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            DrawerScreen(),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: !isDrawerOpen
                      ? BorderRadius.circular(0)
                      : BorderRadius.circular(40)),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        isDrawerOpen
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    scaleFactor = 1;
                                    isDrawerOpen = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffset = 230;
                                    yOffset = 150;
                                    scaleFactor = 0.6;
                                    isDrawerOpen = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.menu_rounded,
                                  color: Colors.white,
                                ),
                              ),
                        AutoSizeText(
                          'Market',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
