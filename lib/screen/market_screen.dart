import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/helper/helper.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:crypto_news/screen/market_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final _scrollController = ScrollController();

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
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF010101),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF010101),
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
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_sharp))
        ],
      ),
      body: SafeArea(
        child: Consumer<CryptoMarketDataProvider>(
          builder: (ctx, model, _) => SizedBox(
            height: height * 0.835,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => MarketDataScreen());
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 0,
                          color: const Color(0xFF1d1d1d),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: ListTile(
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
                                SizedBox(
                                  height: height * 0.07,
                                  width: width * 0.1,
                                  child: CachedNetworkImage(
                                    imageUrl: model.listModel[index].image,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.07),
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
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\u{20B9} ${_helper.removeDecimal(model.listModel[index].price.toString()).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                  margin: EdgeInsets.only(
                                    top: height * 0.005,
                                    bottom: height * 0.004,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: model.listModel[index]
                                                .priceChangePercentage24h >=
                                            0
                                        ? const Color(0xFF01331b)
                                        : const Color(0xFF42070c),
                                  ),
                                  width: 90,
                                  height: 20,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 2,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: model.listModel[index]
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
                                      Text(
                                        model.listModel[index]
                                                    .priceChangePercentage24h >=
                                                0
                                            ? "+${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%"
                                            : "${model.listModel[index].priceChangePercentage24h.toStringAsFixed(2)}%",
                                        style: GoogleFonts.nunito(
                                          color: model.listModel[index]
                                                      .priceChangePercentage24h >
                                                  0
                                              ? const Color(0xFF00a55b)
                                              : const Color(0xFFd82e35),
                                          fontSize: 17,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 0,
                        color: Colors.transparent,
                      );
                    },
                    itemCount: model.listModel.length,
                  ),
                ),
                if (isLoading == true)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
