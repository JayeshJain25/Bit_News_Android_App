import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                width: 500,
                height: 200,
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 65,
                  right: 20,
                  bottom: 20,
                ),
                margin: const EdgeInsets.only(top: 45, bottom: 100),
                decoration: BoxDecoration(
                  color: const Color(0xFF1d1d1d),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      width: width * 0.69,
                    ),
                    Container(
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          width: 2,
                        ),
                      ),
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(45)),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1547792256",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            width: 2,
                          ),
                        ),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(45)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://assets.coingecko.com/coins/images/825/large/binance-coin-logo.png?1547034615",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 200,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            width: 2,
                          ),
                        ),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(45)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://assets.coingecko.com/coins/images/975/large/cardano.png?1547034860",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 150,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            width: 2,
                          ),
                        ),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(45)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 100,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            width: 2,
                          ),
                        ),
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(45)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                top: 15,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF52CAF5),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 30,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(45)),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/logo.png?alt=media&token=993eeaba-2bd5-4e5d-b44f-10664965b330",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
