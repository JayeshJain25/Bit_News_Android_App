import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../provider/crypto_and_fiat_provider.dart';

class SearchAssetsScreen extends StatefulWidget {
  final int index;

  const SearchAssetsScreen({required this.index});

  @override
  _SearchAssetsScreenState createState() => _SearchAssetsScreenState();
}

class _SearchAssetsScreenState extends State<SearchAssetsScreen> {
  final _helper = Helper();

  late int page = 0;

  bool closePagination = false;

  final _scrollController = ScrollController();

  late FloatingSearchBarController controller;

  void pagination() {
    if (!closePagination) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          page++;
          Provider.of<CryptoAndFiatProvider>(context, listen: false)
              .fiatAndCryptoList(page + 1);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(pagination);
    controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF010101),
      body: Consumer<CryptoAndFiatProvider>(
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
              closePagination = true;
              model.queryValue = query;
              model.changeValue();
              model.getCryptoAndFiatBySearch(query);
            },
            onSubmitted: (query) {
              controller.close();
            },
            transition: CircularFloatingSearchBarTransition(),
            builder: (context, transition) {
              return const SizedBox(
                height: 0,
              );
            },
            body: model.listModel.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
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
                          color: index == model.listModel.length
                              ? Colors.transparent
                              : const Color(0xFF0f0e18),
                        );
                      },
                      itemCount: model.listModel.length,
                      controller: _scrollController,
                      itemBuilder: (ctx, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            Provider.of<CryptoAndFiatProvider>(
                              context,
                              listen: false,
                            ).changeCardValue(
                              widget.index,
                              model.listModel[index],
                            );
                            Get.back();
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 0,
                            color: const Color(0xFF010101),
                            child: ListTile(
                              minLeadingWidth: width * 0.05,
                              leading: Text(
                                model.listModel[index].rank.toStringAsFixed(0),
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              title: Row(
                                children: [
                                  if (model.listModel[index].image
                                      .startsWith("https"))
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFF292f33),
                                      radius: 20,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 12,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          model.listModel[index].image,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      model.listModel[index].image,
                                      style: const TextStyle(fontSize: 25),
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
                                            model.listModel[index].name,
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
                                            model.listModel[index].symbol
                                                .toUpperCase(),
                                            maxLines: 1,
                                            style: GoogleFonts.rubik(
                                              color: const Color(0xFF757575),
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
                              trailing: SizedBox(
                                width: width * 0.25,
                                child: AutoSizeText(
                                  "\u{20B9} ${model.listModel[index].image.startsWith("https") ? model.listModel[index].price.toString().startsWith("0.") ? model.listModel[index].price.toString() : _helper.removeDecimal(model.listModel[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') : NumberFormat.compact().format(model.listModel[index].price)}",
                                  maxLines: 1,
                                  minFontSize: 14,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
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
