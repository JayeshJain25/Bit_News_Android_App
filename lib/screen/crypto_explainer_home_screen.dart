import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_news/provider/crypto_explainer_provider.dart';
import 'package:crypto_news/screen/crypto_explainer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CryptoExplainerHomeScreen extends StatefulWidget {
  const CryptoExplainerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CryptoExplainerHomeScreen> createState() =>
      _CryptoExplainerHomeScreenState();
}

class _CryptoExplainerHomeScreenState extends State<CryptoExplainerHomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF010101),
        title: Container(
          margin: const EdgeInsets.only(top: 10),
          child: AutoSizeText(
            'Crypto Explainer',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.only(top: 10),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 22,
            ),
            color: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF010101),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: _selectedIndex == 0
                          ? const Color(0xFF52CAF5)
                          : const Color(0xFF010101),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'Beginner',
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          color:
                              _selectedIndex == 0 ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: _selectedIndex == 1
                          ? const Color(0xFF52CAF5)
                          : const Color(0xFF010101),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'Intermediate',
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          color:
                              _selectedIndex == 1 ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: _selectedIndex == 2
                          ? const Color(0xFF52CAF5)
                          : const Color(0xFF010101),
                    ),
                    child: Center(
                      child: AutoSizeText(
                        'Expert',
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w600,
                          color:
                              _selectedIndex == 2 ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CryptoExplainerProvider>(
              builder: (ctx, data, _) {
                return data.listModel.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: data.listModel.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => CryptoExplainerScreen(
                                  data.listModel[index],
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 23,
                                top: 15,
                                right: 23,
                              ),
                              width: 347,
                              height: 270,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                ),
                                elevation: 0,
                                color: const Color(0xFF121212),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: data.listModel[index].imgUrl,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "lib/assets/logo.png",
                                          fit: BoxFit.cover,
                                        ),
                                        height: 150,
                                        width: 500,
                                      ),
                                    ),
                                    ListTile(
                                      title: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 7,
                                          top: 7,
                                        ),
                                        child: AutoSizeText(
                                          data.listModel[index].title,
                                          maxLines: 2,
                                          style: GoogleFonts.rubik(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 7,
                                            ),
                                            child: AutoSizeText(
                                              data.listModel[index].description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            "By ${data.listModel[index].author}",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
