import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatelessWidget {
  final TabController tabController;
  const SettingScreen({Key? key, required this.tabController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Container(
          margin: const EdgeInsets.only(top: 5, left: 15),
          child: AutoSizeText(
            'Setting',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
