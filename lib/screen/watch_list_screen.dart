import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_news/screen/watch_list_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        appBar: AppBar(
          backgroundColor: const Color(0xFF010101),
          title: AutoSizeText(
            'Watch List',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => WatchListAddScreen());
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 20,
                ),
                child: const Icon(
                  Icons.add_box,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: const Color(0xFF010101),
          child: Column(
            children: [
              // // Container(
              // //   padding: const EdgeInsets.only(left: 10, right: 10),
              // //   margin: EdgeInsets.only(
              // //     top: height * 0.02,
              // //     bottom: height * 0.012,
              // //     left: height * 0.035,
              // //     right: height * 0.035,
              // //   ),
              // //   height: height * 0.06,
              // //   decoration: BoxDecoration(
              // //     borderRadius: BorderRadius.circular(30),
              // //     color: const Color(0xFF292f33),
              // //   ),
              // //   child: Row(
              // //     children: <Widget>[
              // //       const Icon(Icons.search, color: Colors.white),
              // //       const VerticalDivider(
              // //         color: Colors.white,
              // //         indent: 10,
              // //         endIndent: 10,
              // //       ),
              // //       Container(
              // //         margin: const EdgeInsets.only(top: 5),
              // //         width: width * 0.67,
              // //         height: 35,
              // //         child: TextFormField(
              // //           style: GoogleFonts.rubik(color: Colors.white),
              // //           decoration: InputDecoration(
              // //             border: InputBorder.none,
              // //             hintText: 'Search...',
              // //             hintStyle: GoogleFonts.rubik(
              // //               color: Colors.white.withOpacity(0.5),
              // //             ),
              // //           ),
              // //         ),
              // //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
