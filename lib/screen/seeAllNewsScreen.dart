import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../widget/following_list_all_section.dart';

class SeeAllNewsScreen extends StatefulWidget {
  @override
  _SeeAllNewsScreenState createState() => _SeeAllNewsScreenState();
}

class _SeeAllNewsScreenState extends State<SeeAllNewsScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        title: AutoSizeText('Latest',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
            )),
        centerTitle: true,
      ),
      body: Container(
        height: height,
        child: DefaultTabController(
          length: 5,
          child: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
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
                FollowingListAllSection(),
                FollowingListAllSection(),
                FollowingListAllSection(),
                FollowingListAllSection(),
                FollowingListAllSection(),
              ]),
            ),
          ),
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
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
