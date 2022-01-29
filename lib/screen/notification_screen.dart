import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF010101),
        title: Container(
          margin: const EdgeInsets.only(left: 20, top: 5),
          child: AutoSizeText(
            'Notifications',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/cryptox-aabf8.appspot.com/o/notifications.png?alt=media&token=1779bf28-bdcb-47f2-bc68-68b3a817f174",
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 50,
            ),
            AutoSizeText(
              "No New Notifications",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
