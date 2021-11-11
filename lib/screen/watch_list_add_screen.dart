import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WatchListAddScreen extends StatefulWidget {
  @override
  State<WatchListAddScreen> createState() => _WatchListAddScreenState();
}

class _WatchListAddScreenState extends State<WatchListAddScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .getWatchListCoins();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Consumer<CryptoMarketDataProvider>(
          builder: (ctx, model, child) {
            return Container(
              color: const Color(0xFF010101),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        margin: EdgeInsets.only(
                          top: height * 0.02,
                          bottom: height * 0.012,
                        ),
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFF292f33),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.search, color: Colors.white),
                            const VerticalDivider(
                              color: Colors.white,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: width * 0.67,
                              height: 35,
                              child: TextFormField(
                                style: GoogleFonts.rubik(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search...',
                                  hintStyle: GoogleFonts.rubik(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: model.watchListCoins.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 30.0,
                          mainAxisSpacing: 15.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF292f33),
                                radius: 30,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 24,
                                  backgroundImage: CachedNetworkImageProvider(
                                    model.watchListCoins[index].image,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AutoSizeText(
                                model.watchListCoins[index].name,
                                maxLines: 2,
                                minFontSize: 14,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}