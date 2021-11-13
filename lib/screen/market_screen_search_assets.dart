import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import 'market_data_screen.dart';

class MarketScreenSearchAssets extends StatefulWidget {
  @override
  State<MarketScreenSearchAssets> createState() =>
      _MarketScreenSearchAssetsState();
}

class _MarketScreenSearchAssetsState extends State<MarketScreenSearchAssets> {
  late FloatingSearchBarController controller;
  final _helper = Helper();

  String cryptoName = "";

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF010101),
      body: Consumer<CryptoMarketDataProvider>(
        builder: (ctx, model, _) => SafeArea(
          child: FloatingSearchBar(
            controller: controller,
            padding: const EdgeInsets.only(left: 10, right: 10),
            borderRadius: BorderRadius.circular(30),
            backgroundColor: const Color(0xFF292f33),
            hint: 'Search...',
            hintStyle: GoogleFonts.rubik(
              color: Colors.white,
            ),
            queryStyle: GoogleFonts.rubik(color: Colors.white),
            height: height * 0.06,
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            margins: EdgeInsets.only(
              top: height * 0.02,
              bottom: height * 0.012,
              left: width * 0.05,
              right: width * 0.05,
            ),
            axisAlignment: -1.0,
            openAxisAlignment: 0.0,
            elevation: 0,
            clearQueryOnClose: false,
            width: 500,
            iconColor: Colors.white,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query) {
              cryptoName = query;
              model.getCryptoBySearch(query);
            },
            onSubmitted: (query) {
              cryptoName = query;
              model.getCryptoBySearch(query);
              controller.close();
            },
            transition: CircularFloatingSearchBarTransition(),
            builder: (context, transition) {
              return const SizedBox(
                height: 0,
              );
            },
            body: model.searchList.isEmpty
                ? Center(
                    child: cryptoName != ""
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/not_found.gif?alt=media&token=aa8eaa99-07bb-4429-bd5e-8a892a313ea7",
                                height: 200,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                              AutoSizeText(
                                "We looked everywhere but we couldn't find anything that matches your search.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          )
                        : AutoSizeText(
                            "Recent Search",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                  )
                : Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: 10,
                      right: 10,
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          indent: 25,
                          endIndent: 25,
                          thickness: 1,
                          height: 1,
                          color: index == model.searchList.length
                              ? Colors.transparent
                              : const Color(0xFF0f0e18),
                        );
                      },
                      itemCount: model.searchList.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                Get.to(
                                  () => MarketDataScreen(
                                    model.searchList[index],
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
                                    model.searchList[index].rank
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
                                          backgroundColor: Colors.transparent,
                                          radius: 12,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            model.searchList[index].image,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: width * 0.04,
                                              ),
                                              child: AutoSizeText(
                                                model.searchList[index].name,
                                                maxLines: 2,
                                                minFontSize: 14,
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: width * 0.04,
                                              ),
                                              child: AutoSizeText(
                                                model.searchList[index].symbol
                                                    .toUpperCase(),
                                                maxLines: 1,
                                                style: GoogleFonts.rubik(
                                                  color: const Color(
                                                    0xFF757575,
                                                  ),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: width * 0.28,
                                        child: AutoSizeText(
                                          "\u{20B9} ${model.searchList[index].price.toString().startsWith("0.") ? model.searchList[index].price.toString() : _helper.removeDecimal(model.searchList[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                          maxLines: 1,
                                          style: GoogleFonts.nunito(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
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
                                              margin: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: model
                                                            .searchList[index]
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
                                              model.searchList[index]
                                                          .priceChangePercentage24h >=
                                                      0
                                                  ? "+${model.searchList[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                                  : "${model.searchList[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                              maxLines: 1,
                                              style: GoogleFonts.nunito(
                                                color: model.searchList[index]
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
                              color: index == model.searchList.length
                                  ? Colors.transparent
                                  : const Color(0xFF0f0e18),
                            )
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
