import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text(
            'News',
            style: GoogleFonts.poppins(),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu_rounded,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
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
                    'Hot News', //Treding News
                    maxLines: 1, style: GoogleFonts.rubik(),
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
          ],
        ),
      ),
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
          left: 30,
          child: Text(
            'BTC',
            style: GoogleFonts.rubik(fontSize: 18, color: Colors.white),
          ),
        ),
        Positioned(
          top: 100,
          child: Container(
              padding: const EdgeInsets.all(16.0),
              width: width * 0.81,
              child: Text(
                'MATIC is Innovative, but It Looks as If It Might Not Be Very Useful',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ]),
    );
  }
}
