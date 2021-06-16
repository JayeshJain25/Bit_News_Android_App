import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../widget/drawerScreen.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              DrawerScreen(),
              AnimatedContainer(
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFactor)
                  ..rotateY(isDrawerOpen ? -0.5 : 0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: !isDrawerOpen
                        ? BorderRadius.circular(0)
                        : BorderRadius.circular(40)),
                duration: Duration(milliseconds: 250),
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
                            'News',
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
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          height: height / 3,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              TopNews(),
                              SizedBox(
                                width: 20,
                              ),
                              TopNews(),
                              SizedBox(
                                width: 20,
                              ),
                              TopNews(),
                              SizedBox(
                                width: 20,
                              ),
                              TopNews(),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        DefaultTabController(
                          length: 5,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: TabBar(
                                  labelColor: Colors.white,
                                  isScrollable: true,
                                  indicator: BoxDecoration(
                                      color: HexColor("#4E8799"),
                                      borderRadius: BorderRadius.circular(25),
                                      shape: BoxShape.rectangle),
                                  tabs: [
                                    Tab(
                                        child: AutoSizeText(
                                      'Following',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(),
                                    )),
                                    Tab(
                                        child: AutoSizeText(
                                      'Recommended',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(),
                                    )),
                                    Tab(
                                        child: AutoSizeText(
                                      'Everything',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(),
                                    )),
                                    Tab(
                                        child: AutoSizeText(
                                      'Hot News', //Trending News
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(),
                                    )),
                                    Tab(
                                        child: AutoSizeText(
                                      'Twitter',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(),
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(width * 0.04),
                                height: height * 0.36,
                                child: TabBarView(children: <Widget>[
                                  FollowingList(),
                                  FollowingList(),
                                  FollowingList(),
                                  FollowingList(),
                                  FollowingList(),
                                ]),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimationLimiter(
      child: ListView.builder(
          itemCount: 11,
          itemBuilder: (BuildContext context, int index) {
            if (index == 10) {
              return Container(
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    "See all",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                  ),
                ),
              );
            }
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 150,
                child: FadeInAnimation(
                  child: Card(
                    elevation: 2,
                    color: Colors.black,
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: height * 0.04,
                              width: width * 0.1,
                              child: Image(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                      'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.027, top: width * 0.015),
                              width: width * 0.1,
                              height: height * 0.025,
                              child: AutoSizeText(
                                'BTC',
                                style: GoogleFonts.rubik(
                                    fontSize: 14, color: HexColor("#6a6a6a")),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: height * 0.04),
                                width: width * 0.72,
                                height: height * 0.055,
                                child: AutoSizeText(
                                  "Bitcoin Ransomware Payments Set 'Dangerous Precedent': House Oversight Chair",
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Container(
                                width: width * 0.72,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  "Bitcoin Ransomware Payments Set 'Dangerous Precedent': House Oversight Chair",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: GoogleFonts.poppins(
                                    color: HexColor("#6a6a6a"),
                                    fontSize: 15,
                                  ),
                                )),
                            Container(
                                width: width * 0.5,
                                height: height * 0.03,
                                child: AutoSizeText(
                                  "- 3 hours ago",
                                  minFontSize: 12,
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                    color: HexColor("#6a6a6a"),
                                    fontSize: 15,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class TopNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width / 1.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [HexColor('#491f01'), Colors.black])),
      child: Stack(children: <Widget>[
        Positioned(
          right: 15,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.15), BlendMode.dstIn),
            child: Image(
                height: height / 3,
                width: width / 2,
                fit: BoxFit.contain,
                image: NetworkImage(
                    'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
          ),
        ),
        Positioned(
          left: 25,
          child: Image(
              height: height / 9,
              width: width / 9,
              fit: BoxFit.contain,
              image: NetworkImage(
                  'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
        ),
        Positioned(
          top: 70,
          left: 28,
          child: Container(
            width: width * 0.2,
            height: height * 0.03,
            child: AutoSizeText(
              'BTC',
              style: GoogleFonts.rubik(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: 100,
          child: Container(
              padding: const EdgeInsets.all(16.0),
              width: width * 0.81,
              height: height * 0.23,
              child: AutoSizeText(
                'MATIC is Innovative, but It Looks as If It Might Not Be Very Useful',
                minFontSize: 14,
                maxLines: 4,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ]),
    );
  }
}
