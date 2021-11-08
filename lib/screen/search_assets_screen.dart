import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

  final _scrollController = ScrollController();

  void pagination() {
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(pagination);
  }

  @override
  void dispose() {
    super.dispose();
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
          child: Container(
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
                              onChanged: (text) {
                                Provider.of<CryptoAndFiatProvider>(
                                  context,
                                  listen: false,
                                ).getCryptoAndFiatBySearch(text);
                              },
                              onFieldSubmitted: (text) {
                                Provider.of<CryptoAndFiatProvider>(
                                  context,
                                  listen: false,
                                ).getCryptoAndFiatBySearch(text);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: model.listModel.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
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
                                      if (model.listModel[index].image
                                          .startsWith("https"))
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFF292f33),
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
                                                  color:
                                                      const Color(0xFF757575),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
