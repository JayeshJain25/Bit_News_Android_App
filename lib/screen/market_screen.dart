import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../widget/drawer_screen.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  final _scrollController = ScrollController();

  int page = 0;

  void pagination() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
        Provider.of<CryptoMarketDataProvider>(context, listen: false)
            .cryptoMarketDataByPagination(page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .cryptoMarketDataByPagination(0);
    _scrollController.addListener(pagination);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            DrawerScreen(),
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: !isDrawerOpen
                      ? BorderRadius.circular(0)
                      : BorderRadius.circular(40)),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (isDrawerOpen)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () {
                              setState(() {
                                xOffset = 230;
                                yOffset = 150;
                                scaleFactor = 0.6;
                                isDrawerOpen = true;
                              });
                            },
                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                          ),
                        AutoSizeText(
                          'Market',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  Consumer<CryptoMarketDataProvider>(
                    builder: (ctx, model, _) => SizedBox(
                      height: height * 0.82,
                      child: ListView.separated(
                          controller: _scrollController,
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                elevation: 0,
                                color: const Color(0xFF121212),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      model.listModel[index].rank
                                          .toStringAsFixed(0),
                                      style: GoogleFonts.rubik(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.1,
                                        margin: EdgeInsets.only(left: width*0.07),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              model.listModel[index].image,
                                        )),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: width*0.07),
                                            child: Text(
                                              model.listModel[index].name,
                                              style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\u{20B9}${NumberFormat.compact().format(model.listModel[index].price)}",
                                          style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: model.listModel[index]
                                                .priceChangePercentage24h >=
                                                0
                                                ? const Color(0xFF01331b)
                                : const Color(0xFF42070c),
                                          ),
                                          width: 65,
                                          height: 20,
                                          child: Text(
                                            model.listModel[index]
                                                        .priceChangePercentage24h >=
                                                    0
                                                ? "+${model.listModel[index]
                                                        .priceChangePercentage24h
                                                        .toStringAsFixed(2)}%"
                                                : "${model.listModel[index]
                                                        .priceChangePercentage24h
                                                        .toStringAsFixed(2)}%",
                                            style: GoogleFonts.rubik(
                                                color:    model.listModel[index]
                                                    .priceChangePercentage24h >
                                                    0 ? const Color(0xFF00a55b)  : const Color(0xFFd82e35),
                                                fontSize: 17),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: Color(0xFF6a6a6a),
                            );
                          },
                          itemCount: model.listModel.length),
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
