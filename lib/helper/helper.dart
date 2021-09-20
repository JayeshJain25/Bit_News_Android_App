import 'package:flutter/cupertino.dart';

class Helper {
  String convertToAgo(String input) {
    final DateTime time1 = DateTime.parse("$input Z");
    final Duration diff = DateTime.now().difference(time1);

    if (diff.inDays >= 1) {
      return 'about ${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return 'about ${diff.inHours} hrs ago';
    } else if (diff.inMinutes >= 1) {
      return 'about ${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return 'about ${diff.inSeconds} secs ago';
    } else {
      return 'just now';
    }
  }

  String convertToSmallerAgo(String input) {
    final DateTime time1 = DateTime.parse("$input Z");
    final Duration diff = DateTime.now().difference(time1);

    if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds}s ago';
    } else {
      return 'just now';
    }
  }

  String extractImgUrl(String imgUrl) {
    if (imgUrl.startsWith("(")) {
      final String newUrl = imgUrl.substring(2);
      final List<String> newUrlArray = newUrl.split(",");
      return newUrlArray[0].substring(0, newUrlArray[0].length - 1);
    } else {
      return imgUrl;
    }
  }


  Map<String, Color> flagColor =  {
    "Euro":  const Color(0xFF0825cb),
    "Japanese Yen": const Color(0xFFfeced0),
    "Bulgarian Lev": const Color(0xFF00966e),
    "Czech Koruna": const Color(0xFF11457e),
    "Danish Krona": const Color(0xFFc7042d),
    "British Pound": const Color(0xFF012169),
    "Hungarian Forint":const Color(0xFF477050),
    "Polish Zloty": const Color(0xFFff0000),
    "Romanian Leu": const Color(0xFFFCD116),
    "Swedish Krona": const Color(0xFF006aa8),
    "Swiss Franc": const Color(0xFFD52B1E),
    "Norwegian Krona": const Color(0xFF00205B),
    "Croatian kuna": const Color(0xFF0093dd),
    "Russian Ruble": const Color(0xFFd52b1e),
    "Turkish Lira": const Color(0xFFE30A17),
    "Australian Dollar": const Color(0xFF00008B),
    "Brazilian Real": const Color(0xFF009c3b),
    "Canadian Dollar": const Color(0xFFff0000),
    "Chinese Renminbi": const Color(0xFFFF0000),
    "Hong Kong Dollar": const Color(0xFFDE2910),
    "Indonesian Rupiah": const Color(0xFFED1C24),
    "Indian Rupee": const Color(0xFFFF9933),
    "South Korean won": const Color(0xFF0047A0),
    "Mexican Peso": const Color(0xFF006847),
    "Malaysian Ringgit": const Color(0xFFFFD100),
    "New-Zealand Dollar": const Color(0xFF012169),
    "Philippines Peso": const Color(0xFFfcd116),
    "Singapore Dollar": const Color(0xFFee2536),
    "Thai Baht": const Color(0xFF2D2A4A),
    "US Dollar": const Color(0xFF3C3B6E)
  };
}
