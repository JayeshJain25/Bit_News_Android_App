import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: const SafeArea(child: SizedBox()),
    );
  }
}
