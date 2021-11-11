import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/model/coin_paprika_global_data_model.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/screen/market_data_screen.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();

  final TabController tabController;
  const MarketScreen({Key? key, required this.tabController}) : super(key: key);
}

class _MarketScreenState extends State<MarketScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late CoinPaprikaGlobalDataModel _globalDataModel;
  bool _globalDataLoaded = true;

  int page = 0;
  bool isLoading = false;
  final _helper = Helper();

  void pagination() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
        isLoading = true;
        Provider.of<CryptoMarketDataProvider>(context, listen: false)
            .cryptoMarketDataByPagination(page + 1)
            .then(
              (value) => {isLoading = false},
            );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(pagination);
    if (_globalDataLoaded) {
      Provider.of<CryptoMarketDataProvider>(context, listen: false)
          .getCoinPaprikaGlobalData()
          .then(
        (value) {
          setState(() {
            _globalDataLoaded = false;
            _globalDataModel = value;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        widget.tabController.index = 0;
        return true as Future<bool>;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        body: CustomRefreshIndicator(
          onRefresh: () {
            setState(() {
              page = 0;
              Provider.of<CryptoMarketDataProvider>(context, listen: false)
                  .getCoinPaprikaGlobalData()
                  .then(
                (value) {
                  setState(() {
                    _globalDataLoaded = false;
                    _globalDataModel = value;
                  });
                },
              );
              Provider.of<CryptoMarketDataProvider>(context, listen: false)
                  .listModel
                  .clear();
              Provider.of<CryptoMarketDataProvider>(context, listen: false)
                  .cryptoMarketDataByPagination(1);
            });
            return Future.delayed(const Duration(seconds: 2));
          },
          builder: (
            BuildContext context,
            Widget child,
            IndicatorController controller,
          ) {
            return AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, _) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    if (!controller.isIdle)
                      Positioned(
                        top: 20.0 * controller.value,
                        child: SizedBox(
                          height: 80,
                          width: width,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/57735-crypto-coins.gif?alt=media&token=a696da3c-4285-4479-aade-1d65ee4ec2ad',
                            height: 35,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(0, 70.0 * controller.value),
                      child: child,
                    ),
                  ],
                );
              },
            );
          },
          child: GestureDetector(
            onTap: () {
              final FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SafeArea(
              child: Consumer<CryptoMarketDataProvider>(
                builder: (ctx, model, _) => SizedBox(
                  height: height * 0.92,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        elevation: 0,
                        backgroundColor: const Color(0xFF010101),
                        title: Container(
                          margin: const EdgeInsets.only(top: 5, left: 15),
                          child: Column(
                            children: [
                              AutoSizeText(
                                'Market',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        automaticallyImplyLeading: false,
                      ),
                      SliverAppBar(
                        expandedHeight: height * 0.175,
                        collapsedHeight: height * 0.175,
                        automaticallyImplyLeading: false,
                        backgroundColor: const Color(0xFF010101),
                        flexibleSpace: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                left: width * 0.04,
                                right: width * 0.04,
                                top: height * 0.02,
                              ),
                              height: height * 0.06,
                              child: _globalDataLoaded
                                  ? const CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            AutoSizeText(
                                              "Market Cap",
                                              style: GoogleFonts.rubik(
                                                color: Colors.white70,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            AutoSizeText(
                                              NumberFormat.compact().format(
                                                _globalDataModel.marketCapUSD,
                                              ),
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          color: Colors.white,
                                        ),
                                        Column(
                                          children: [
                                            AutoSizeText(
                                              "24h Volume",
                                              style: GoogleFonts.rubik(
                                                color: Colors.white70,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            AutoSizeText(
                                              NumberFormat.compact().format(
                                                _globalDataModel.volume24hUSD,
                                              ),
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const VerticalDivider(
                                          color: Colors.white,
                                        ),
                                        Column(
                                          children: [
                                            AutoSizeText(
                                              "BTC Dominance",
                                              style: GoogleFonts.rubik(
                                                color: Colors.white70,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            AutoSizeText(
                                              "${_globalDataModel.bitcoinDominancePercentage}%",
                                              style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              margin: EdgeInsets.only(
                                top: height * 0.02,
                                bottom: height * 0.012,
                                left: height * 0.035,
                                right: height * 0.035,
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
                                      enabled: false,
                                      style: GoogleFonts.rubik(
                                          color: Colors.white),
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
                      ),
                      if (model.listModel.isEmpty)
                        const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, index) {
                              return index == model.listModel.length
                                  ? Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            Get.to(
                                              () => MarketDataScreen(
                                                model.listModel[index],
                                              ),
                                            );
                                          },
                                          child: Card(
                                            margin: const EdgeInsets.all(10),
                                            elevation: 0,
                                            color: const Color(0xFF010101),
                                            child: ListTile(
                                              minLeadingWidth: width * 0.05,
                                              leading: Text(
                                                model.listModel[index].rank
                                                    .toStringAsFixed(0),
                                                style: GoogleFonts.nunito(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              title: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        const Color(0xFF292f33),
                                                    radius: 20,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 12,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                        model.listModel[index]
                                                            .image,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: width * 0.04,
                                                          ),
                                                          child: AutoSizeText(
                                                            model
                                                                .listModel[
                                                                    index]
                                                                .name,
                                                            maxLines: 2,
                                                            minFontSize: 14,
                                                            style: GoogleFonts
                                                                .rubik(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: width * 0.04,
                                                          ),
                                                          child: AutoSizeText(
                                                            model
                                                                .listModel[
                                                                    index]
                                                                .symbol
                                                                .toUpperCase(),
                                                            maxLines: 1,
                                                            style: GoogleFonts
                                                                .rubik(
                                                              color:
                                                                  const Color(
                                                                0xFF757575,
                                                              ),
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.28,
                                                    child: AutoSizeText(
                                                      "\u{20B9} ${model.listModel[index].price.toString().startsWith("0.") ? model.listModel[index].price.toString() : _helper.removeDecimal(model.listModel[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                                      maxLines: 1,
                                                      style: GoogleFonts.nunito(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: height * 0.005,
                                                      bottom: height * 0.004,
                                                    ),
                                                    width: width * 0.28,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 2,
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: model
                                                                        .listModel[
                                                                            index]
                                                                        .priceChangePercentage24h >=
                                                                    0
                                                                ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                                                : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                                            fit: BoxFit.cover,
                                                            height: 10,
                                                            width: 10,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 2,
                                                        ),
                                                        AutoSizeText(
                                                          model.listModel[index]
                                                                      .priceChangePercentage24h >=
                                                                  0
                                                              ? "+${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                              : "${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                                          maxLines: 1,
                                                          style: GoogleFonts
                                                              .nunito(
                                                            color: model
                                                                        .listModel[
                                                                            index]
                                                                        .priceChangePercentage24h >
                                                                    0
                                                                ? const Color(
                                                                    0xFF00a55b,
                                                                  )
                                                                : const Color(
                                                                    0xFFd82e35,
                                                                  ),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          indent: 65,
                                          endIndent: 65,
                                          thickness: 1,
                                          height: 1,
                                          color: index == model.listModel.length
                                              ? Colors.transparent
                                              : const Color(0xFF0f0e18),
                                        )
                                      ],
                                    );
                            },
                            childCount: model.listModel.length + 1,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
