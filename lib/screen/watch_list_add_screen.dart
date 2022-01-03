import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/provider/google_sign_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class WatchListAddScreen extends StatefulWidget {
  @override
  State<WatchListAddScreen> createState() => _WatchListAddScreenState();
}

class _WatchListAddScreenState extends State<WatchListAddScreen> {
  late FloatingSearchBarController controller;
  String cryptoName = "";
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoMarketDataProvider>(context, listen: false)
        .getWatchListCoins();
    controller = FloatingSearchBarController();
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
              model.getCryptoBySearchForWatchList(query);
            },
            onSubmitted: (query) {
              cryptoName = query;
              model.getCryptoBySearchForWatchList(query);
              controller.close();
            },
            transition: CircularFloatingSearchBarTransition(),
            builder: (context, transition) {
              return const SizedBox(
                height: 0,
              );
            },
            body: model.watchListCoins.isEmpty
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
                    height: height,
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
                          color: index == model.watchListCoins.length
                              ? Colors.transparent
                              : const Color(0xFF0f0e18),
                        );
                      },
                      itemCount: model.watchListCoins.length,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false,
                              ).userModel.favoriteCoins.contains(
                                        model.watchListCoins[index].name
                                            .toLowerCase(),
                                      )
                                  ? Provider.of<GoogleSignInProvider>(
                                      context,
                                      listen: false,
                                    ).userModel.favoriteCoins.remove(
                                        model.watchListCoins[index].name
                                            .toLowerCase(),
                                      )
                                  : Provider.of<GoogleSignInProvider>(
                                      context,
                                      listen: false,
                                    ).userModel.favoriteCoins.add(
                                        model.watchListCoins[index].name
                                            .toLowerCase(),
                                      );
                            });
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 0,
                            color: const Color(0xFF010101),
                            child: ListTile(
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF292f33),
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 12,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        model.watchListCoins[index].image,
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
                                            model.watchListCoins[index].name,
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
                                            model.watchListCoins[index].symbol
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
                                        Provider.of<GoogleSignInProvider>(
                                          context,
                                          listen: false,
                                        ).userModel.favoriteCoins.contains(
                                                  model.watchListCoins[index]
                                                      .name
                                                      .toLowerCase(),
                                                )
                                            ? Icons.star_purple500_outlined
                                            : Icons.star_border,
                                        color:
                                            Provider.of<GoogleSignInProvider>(
                                          context,
                                          listen: false,
                                        ).userModel.favoriteCoins.contains(
                                                      model
                                                          .watchListCoins[index]
                                                          .name
                                                          .toLowerCase(),
                                                    )
                                                ? const Color(
                                                    0xFF52CAF5,
                                                  )
                                                : Colors.white,
                                        size: 22,
                                      );
                                    },
                                    onTap: (isLiked) {
                                      Provider.of<CryptoMarketDataProvider>(
                                        context,
                                        listen: false,
                                      ).updateFavouriteCoin(
                                        [
                                          model.watchListCoins[index].name
                                              .toLowerCase()
                                        ],
                                        user!.uid,
                                      ).then((value) {
                                        Provider.of<GoogleSignInProvider>(
                                          context,
                                          listen: false,
                                        ).userModel = value;
                                      });
                                      if (Provider.of<GoogleSignInProvider>(
                                        context,
                                        listen: false,
                                      ).userModel.favoriteCoins.contains(
                                            model.watchListCoins[index].name
                                                .toLowerCase(),
                                          )) {
                                        model.favouriteCoinsList.removeWhere(
                                          (element) =>
                                              element.name.toLowerCase() ==
                                              model.watchListCoins[index].name
                                                  .toLowerCase(),
                                        );

                                        model.favouriteGraphDataList
                                            .removeWhere(
                                          (element) =>
                                              element.name.toLowerCase() ==
                                              model.watchListCoins[index].name
                                                  .toLowerCase(),
                                        );
                                        model.favouriteDailyGraphDataList
                                            .removeWhere(
                                          (element) =>
                                              element.name.toLowerCase() ==
                                              model.watchListCoins[index].name
                                                  .toLowerCase(),
                                        );
                                      } else {
                                        model.favouriteCoinsList
                                            .add(model.watchListCoins[index]);

                                        Provider.of<CryptoMarketDataProvider>(
                                          context,
                                          listen: false,
                                        )
                                            .getCryptoGraphData(
                                              model
                                                  .watchListCoins[index].symbol,
                                            )
                                            .then(
                                              (value) => {
                                                model.favouriteGraphDataList
                                                  ..add(value)
                                              },
                                            );
                                        Provider.of<CryptoMarketDataProvider>(
                                          context,
                                          listen: false,
                                        )
                                            .getCryptoGraphDailyData(
                                              model
                                                  .watchListCoins[index].symbol,
                                            )
                                            .then(
                                              (value) => {
                                                model
                                                    .favouriteDailyGraphDataList
                                                    .add(value)
                                              },
                                            );
                                      }
                                      return Future.delayed(
                                        const Duration(microseconds: 1),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
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
