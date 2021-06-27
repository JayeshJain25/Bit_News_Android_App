import 'package:animate_icons/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ConversionToolScreen extends StatefulWidget {
  @override
  _ConversionToolScreenState createState() => _ConversionToolScreenState();
}

class _ConversionToolScreenState extends State<ConversionToolScreen> {
  late AnimateIconController settingAnimation;

  initState() {
    super.initState();
    settingAnimation = AnimateIconController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: AutoSizeText('Conversion Tool',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  height: height * 0.25,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [HexColor('#491f01'), Colors.black])),
                      child: Stack(children: <Widget>[
                        Positioned(
                          right: 15,
                          top: -30,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.15),
                                BlendMode.dstIn),
                            child: Image(
                                height: height * 0.25,
                                width: width * 0.25,
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          child: Image(
                              height: height * 0.07,
                              width: width * 0.07,
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png')),
                        ),
                        Positioned(
                          top: 19,
                          left: 60,
                          child: Container(
                            width: width * 0.2,
                            height: height * 0.03,
                            child: AutoSizeText(
                              'BTC',
                              style: GoogleFonts.rubik(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 26,
                          child: Container(
                            width: width * 0.5,
                            height: height * 0.1,
                            child: TextFormField(
                              initialValue: "1.00",
                              style: GoogleFonts.rubik(
                                  color: Colors.white, fontSize: 25),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType
                                  .number, // Only numbers can be entered
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 150,
                          child: Arc(
                            arcType: ArcType.CONVEX,
                            edge: Edge.TOP,
                            height: height * 0.1,
                            clipShadows: [ClipShadow(color: Colors.black)],
                            child: new Container(
                              height: height * 0.1,
                              width: width * 0.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: height * 0.25,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(15),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 0),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [HexColor('#627eeb'), Colors.black])),
                      child: Stack(children: <Widget>[
                        Positioned(
                          right: 15,
                          bottom: -30,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.15),
                                BlendMode.dstIn),
                            child: Image(
                                height: height * 0.25,
                                width: width * 0.25,
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                    'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Ethereum-ETH-icon.png')),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 25,
                          child: Image(
                              height: height * 0.07,
                              width: width * 0.07,
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Ethereum-ETH-icon.png')),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 60,
                          child: Container(
                            width: width * 0.2,
                            height: height * 0.03,
                            child: AutoSizeText(
                              'ETH',
                              style: GoogleFonts.rubik(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 70,
                          left: 26,
                          child: Container(
                            width: width * 0.5,
                            height: height * 0.1,
                            child: TextFormField(
                              initialValue: "1.00",
                              style: GoogleFonts.rubik(
                                  color: Colors.white, fontSize: 25),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType
                                  .number, // Only numbers can be entered
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 150,
                          child: Arc(
                            arcType: ArcType.CONVEX,
                            edge: Edge.BOTTOM,
                            height: height * 0.1,
                            clipShadows: [ClipShadow(color: Colors.black)],
                            child: new Container(
                              height: height * 0.1,
                              width: width * 0.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 75,
              top: 238,
              child: Container(
                height: height * 0.09,
                width: width * 0.3,
                decoration:
                    BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                child: AnimateIcons(
                  startIcon: Icons.rotate_right_rounded,
                  endIcon: Icons.rotate_right_rounded,
                  controller: settingAnimation,
                  size: 45,
                  onStartIconPress: () {
                    return true;
                  },
                  onEndIconPress: () {
                    return true;
                  },
                  duration: Duration(milliseconds: 500),
                  startIconColor: Colors.white,
                  endIconColor: Colors.white,
                  clockwise: false,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
