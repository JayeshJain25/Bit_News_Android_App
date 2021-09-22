import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF121212),
        title: AutoSizeText(
          'CryptoX',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
          child: SizedBox(
              height: 300,
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent,
                          ),
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          height: 50,
                          width: 160,
                          child: AutoSizeText("Portfolio",style: GoogleFonts.poppins(fontSize: 17,color: Colors.white),),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent,
                          ),
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          height: 50,
                          width: 160,
                          child: AutoSizeText("Conversion",style: GoogleFonts.poppins(fontSize: 17,color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent,
                          ),
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          height: 50,
                          width: 160,
                          child: AutoSizeText("Price Alert",style: GoogleFonts.poppins(fontSize: 17,color: Colors.white),),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent,
                          ),
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          height: 50,
                          width: 160,
                          child: AutoSizeText("Price Alert",style: GoogleFonts.poppins(fontSize: 17,color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),),),
    );
  }
}
