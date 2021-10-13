import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_market_data_provider.dart';
import 'package:flutter/material.dart';
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
          margin: const EdgeInsets.only(left: 20, top: 5),
          child: AutoSizeText(
            'Market',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Consumer<CryptoMarketDataProvider>(
          builder: (ctx, model, _) => SizedBox(
            height: height * 0.82,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                        onTap: () {},
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 0,
                          color: const Color(0xFF010101),
                          child: Row(
                            children: <Widget>[
                              Text(
                                model.listModel[index].rank.toStringAsFixed(0),
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              Container(
                                height: height * 0.07,
                                width: width * 0.1,
                                margin: EdgeInsets.only(left: width * 0.07),
                                child: CachedNetworkImage(
                                  imageUrl: model.listModel[index].image,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: width * 0.07),
                                  child: Text(
                                    model.listModel[index].name,
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
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
                                      fontSize: 17,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: model.listModel[index]
                                                  .priceChangePercentage24h >=
                                              0
                                          ? const Color(0xFF01331b)
                                          : const Color(0xFF42070c),
                                    ),
                                    width: 79,
                                    height: 20,
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: model.listModel[index]
                                                      .priceChangePercentage24h >=
                                                  0
                                              ? "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/up_arrow.png?alt=media&token=03660f10-1eab-46ce-bcdd-a72e4380d012"
                                              : "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/down_arrow.png?alt=media&token=dcfbaf91-b5d1-42ca-bee4-e785a7c58e8c",
                                          fit: BoxFit.cover,
                                          height: 10,
                                          width: 10,
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
                                          style: GoogleFonts.rubik(
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
