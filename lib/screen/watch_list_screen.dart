import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:crypto_news/screen/watch_list_add_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import 'market_data_screen.dart';

class WatchListScreen extends StatefulWidget {
  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final _helper = Helper();
    final User? user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        appBar: AppBar(
          backgroundColor: const Color(0xFF010101),
          title: AutoSizeText(
            'Watch List',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () {
                Provider.of<CryptoMarketDataProvider>(
                  context,
                  listen: false,
                ).watchListCoins.clear();
                Get.to(() => WatchListAddScreen());
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 20,
                ),
                child: const Icon(
                  Icons.add_box,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Consumer<CryptoMarketDataProvider>(
          builder: (ctx, model, _) {
            return Container(
              color: const Color(0xFF010101),
              child: ListView.separated(
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      Provider.of<CryptoMarketDataProvider>(
                        context,
                        listen: false,
                      )
                          .getCryptocurrencyCountByNameSymbol(
                        model.listModel[index].name,
                        model.listModel[index].symbol,
                      )
                          .then(
                        (value) {
                          Get.to(
                            () => MarketDataScreen(
                              model.favouriteCoinsList[index],
                              model.favouriteGraphDataList[index],
                              model.favouriteDailyGraphDataList[index],
                              value,
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 0,
                      color: const Color(0xFF010101),
                      child: ListTile(
                        minLeadingWidth: width * 0.05,
                        leading: Text(
                          model.favouriteCoinsList[index].rank
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
                              backgroundColor: const Color(0xFF292f33),
                              radius: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 12,
                                backgroundImage: CachedNetworkImageProvider(
                                  model.favouriteCoinsList[index].image,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: width * 0.04,
                                    ),
                                    child: AutoSizeText(
                                      model.favouriteCoinsList[index].name,
                                      overflow: TextOverflow.ellipsis,
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
                                      model.favouriteCoinsList[index].symbol
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: width * 0.28,
                                  child: AutoSizeText(
                                    "\u{20B9} ${model.favouriteCoinsList[index].price.toString().startsWith("0.") ? model.favouriteCoinsList[index].price.toString() : _helper.removeDecimal(model.favouriteCoinsList[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
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
                                                      .favouriteCoinsList[index]
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
                                        model.favouriteCoinsList[index]
                                                    .priceChangePercentage24h >=
                                                0
                                            ? "+${model.favouriteCoinsList[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                            : "${model.favouriteCoinsList[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                        maxLines: 1,
                                        style: GoogleFonts.nunito(
                                          color: model.favouriteCoinsList[index]
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
                            LikeButton(
                              size: 22,
                              circleColor: const CircleColor(
                                start: Color(0xff00ddff),
                                end: Color(0xff0099cc),
                              ),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.star_purple500_outlined,
                                  color: Provider.of<GoogleSignInProvider>(
                                    context,
                                    listen: false,
                                  ).userModel.favoriteCoins.contains(
                                            model.favouriteCoinsList[index].name
                                                .toLowerCase(),
                                          )
                                      ? const Color(
                                          0xFF52CAF5,
                                        )
                                      : Colors.white,
                                  size: 22,
                                );
                              },
                              onTap: (isLiked) =>
                                  Provider.of<CryptoMarketDataProvider>(
                                context,
                                listen: false,
                              ).updateFavouriteCoin(
                                [
                                  model.favouriteCoinsList[index].name
                                      .toLowerCase()
                                ],
                                user!.uid,
                              ).then((value) {
                                if (!isLiked) {
                                  model.favouriteCoinsList.removeAt(index);
                                }

                                Provider.of<GoogleSignInProvider>(
                                  context,
                                  listen: false,
                                ).userModel = value;
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: model.favouriteCoinsList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    indent: 65,
                    endIndent: 30,
                    thickness: 1,
                    height: 1,
                    color: index == model.favouriteCoinsList.length
                        ? Colors.transparent
                        : const Color(0xFF0f0e18),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
