import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();

  final TabController tabController;
  const FavouriteScreen({Key? key, required this.tabController})
      : super(key: key);
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  void initState() {
    super.initState();
    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .getWatchListCoins();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        widget.tabController.index = 0;
        return true as Future<bool>;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF010101),
          title: Container(
            margin: const EdgeInsets.only(left: 20, top: 5),
            child: AutoSizeText(
              'Following',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFF010101),
        body: SafeArea(
          child: Consumer<CryptoMarketDataProvider>(
            builder: (ctx, model, child) {
              return Container(
                color: const Color(0xFF010101),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      margin: EdgeInsets.only(
                        top: height * 0.02,
                        bottom: height * 0.012,
                        left: width * 0.05,
                        right: width * 0.05,
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: model.watchListCoins.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : GridView.builder(
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
                                        backgroundColor:
                                            const Color(0xFF292f33),
                                        radius: 30,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 24,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
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
      ),
    );
  }
}
