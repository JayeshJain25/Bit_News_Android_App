import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/screen/crypto_explainer_screen.dart';
import 'package:crypto_news/screen/notification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  int _selectedIndex = 0;
  late AnimationController controller;
  Animation<double>? animation;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();

    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .cryptoMarketDataByPagination(1);

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
      Future.delayed(const Duration(milliseconds: 100)).then((v) {
        controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        );

        // var width = (media.size.width - (2 * media.padding.left)) / 2;
        animation = Tween<double>(begin: 0, end: 100).animate(controller);

        setState(() {});

        controller.addListener(() {
          setState(() {});
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF010101),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _showAppbar ? 56.0 : 0.0,
              child: AppBar(
                elevation: 0,
                backgroundColor: const Color(0xFF010101),
                actions: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 20, top: 5),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => NotificationScreen());
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
                title: Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      AutoSizeText(
                        'CryptoX',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollViewController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'Hi, ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: user!.displayName,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF52CAF5),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  'Head Over To Our News Section For the Latest News Of The ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Cryptocurrency Market',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF52CAF5),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 160,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 15,
                              left: 10,
                              right: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFF1B1212),
                                    border: Border.all(
                                      color: Colors.white10.withAlpha(40),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withAlpha(100),
                                        blurRadius: 5.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  height: 60,
                                  width: 160,
                                  child: Center(
                                    // child: Row(
                                    //   children: [
                                    // CachedNetworkImage(
                                    //   imageUrl:
                                    //       "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/portfolio.png?alt=media&token=0e6f0637-7ce9-4b3a-83ce-8354c7710326",
                                    //   fit: BoxFit.cover,
                                    // ),
                                    child: AutoSizeText(
                                      "Portfolio",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // ],
                                    //),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFF1B1212),
                                    border: Border.all(
                                      color: Colors.white10.withAlpha(40),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withAlpha(100),
                                        blurRadius: 5.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  height: 60,
                                  width: 160,
                                  child: Center(
                                    child: AutoSizeText(
                                      "Conversion",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: 15,
                              left: 10,
                              right: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: const Color(0xFF1B1212),
                                    border: Border.all(
                                      color: Colors.white10.withAlpha(40),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withAlpha(100),
                                        blurRadius: 5.0,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  height: 60,
                                  width: 160,
                                  child: Center(
                                    child: AutoSizeText(
                                      "Price Alert",
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => CryptoExplainerScreen());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: const Color(0xFF1B1212),
                                      border: Border.all(
                                        color: Colors.white10.withAlpha(0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withAlpha(100),
                                          blurRadius: 5.0,
                                          spreadRadius: 0.0,
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                    ),
                                    height: 60,
                                    width: 160,
                                    child: Center(
                                      child: AutoSizeText(
                                        "Whale Alert",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 32),
                          child: AutoSizeText(
                            "Coins",
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 32),
                            child: AutoSizeText(
                              "See All",
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF52CAF5),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<CryptoMarketDataProvider>(
                      builder: (ctx, model, _) => Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 5, right: 5),
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (ctx, index) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 20, right: 5),
                              height: 110,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: const Color(0xFF1B1212),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    model.listModel[index].name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Container(
                        margin: const EdgeInsets.only(left: 32),
                        child: AutoSizeText(
                          "Top Trending",
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15, left: 5, right: 5),
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (ctx, index) {
                          return Container(
                            margin: const EdgeInsets.only(left: 20, right: 5),
                            height: 110,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: const Color(0xFF1B1212),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 25, left: 25, right: 25),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.transparent,
                        border: Border.all(color: const Color(0xFF52CAF5)),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          "Crypto Explainer",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        const SizedBox(
                          height: 500,
                        ),
                        Row(
                          children: <Widget>[
                            // Transform.translate(
                            //   offset: Offset(animation?.value ?? 0, 0),
                            //   child: Container(
                            //     key: key,
                            //     height: 44,
                            //     width: 100,
                            //     decoration: BoxDecoration(
                            //       color: Colors.blueAccent,
                            //       borderRadius: BorderRadius.circular(25),
                            //       boxShadow: const [
                            //         BoxShadow(
                            //           color: Colors.grey,
                            //           blurRadius: 3,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex == 0
                                        ? controller.forward()
                                        : controller.reverse();
                                    _selectedIndex =
                                        _selectedIndex == 0 ? 1 : 0;
                                    _selectedIndex = 0;
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    color: const Color(0xFF010101),
                                    border: Border.all(
                                      color: _selectedIndex == 0
                                          ? const Color(0xFF52CAF5)
                                          : const Color(0xFF010101),
                                    ),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      'Beginner',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    color: const Color(0xFF010101),
                                    border: Border.all(
                                        color: _selectedIndex == 1
                                            ? const Color(0xFF52CAF5)
                                            : const Color(0xFF010101)),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      'Intermediate',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 2;
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    color: const Color(0xFF010101),
                                    border: Border.all(
                                        color: _selectedIndex == 2
                                            ? const Color(0xFF52CAF5)
                                            : const Color(0xFF010101)),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      'Expert',
                                      maxLines: 1,
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 79,
                          child: AnimatedContainer(
                            margin: const EdgeInsets.only(left: 23),
                            width: 347,
                            height: 270,
                            decoration: BoxDecoration(
                              borderRadius: _selectedIndex == 0
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    )
                                  : _selectedIndex == 1
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          bottomLeft: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                              color: const Color(0xFF010101),
                              border:
                                  Border.all(color: const Color(0xFF52CAF5)),
                            ),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutBack,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: _selectedIndex == 0
                                    ? const BorderRadius.only(
                                        bottomLeft: Radius.circular(25),
                                        topRight: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        topLeft: Radius.circular(25),
                                      )
                                    : _selectedIndex == 1
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                          )
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                          ),
                              ),
                              elevation: 0,
                              color: const Color(0xFF121212),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          "https://coindesk-coindesk-prod.cdn.arcpublishing.com/resizer/nkZ1E8g3-bBKCgOD6w5Bj5UYrpI=/400x300/filters:format(jpg):quality(70)/cloudfront-us-east-1.images.arcpublishing.com/coindesk/LTBLXH2ZPBBHZNVZAMFZDHHYHU.jpg",
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        "lib/assets/logo.png",
                                        fit: BoxFit.cover,
                                      ),
                                      height: 150,
                                      width: 500,
                                    ),
                                  ),
                                  ListTile(
                                    title: Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 7,
                                        top: 7,
                                      ),
                                      child: AutoSizeText(
                                        "What Is Bitcoin?",
                                        maxLines: 2,
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 7,
                                          ),
                                          child: AutoSizeText(
                                            "In 2008, a pseudonymous programmer named Satoshi Nakamoto published a 9-page document outlining a new decentralized, digital currency. They called it Bitcoin.",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        AutoSizeText(
                                          "By Andrey Sergeenkov",
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
