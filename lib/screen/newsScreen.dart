import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widget/drawerScreen.dart';
import '../widget/following_list.dart';
import '../widget/top_news.dart';

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
      body: SafeArea(
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
              child: SingleChildScrollView(
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.81,
                      child: DefaultTabController(
                        length: 5,
                        child: NestedScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return [
                              SliverAppBar(
                                collapsedHeight: height * 0.37,
                                expandedHeight: height * 0.37,
                                flexibleSpace: Container(
                                  margin: EdgeInsets.all(15),
                                  height: height * 0.37,
                                  child: ListView.builder(
                                    itemCount: 5,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          TopNews(),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                backgroundColor: Colors.black,
                              ),
                              SliverPersistentHeader(
                                delegate: MyDelegate(TabBar(
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
                                )),
                                floating: true,
                              )
                            ];
                          },
                          body: Container(
                            margin: EdgeInsets.all(width * 0.04),
                            child: TabBarView(children: <Widget>[
                              FollowingList(),
                              FollowingList(),
                              FollowingList(),
                              FollowingList(),
                              FollowingList(),
                            ]),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  MyDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
      margin: EdgeInsets.only(left: 15, right: 15),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
