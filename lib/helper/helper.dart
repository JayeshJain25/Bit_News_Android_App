import 'dart:convert';
import 'package:crypto_news/model/graph_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Helper {
  String convertToAgo(String input) {
    final DateTime time1 = DateTime.parse("$input Z");
    final Duration diff = DateTime.now().difference(time1);

    if (diff.inDays == 1) {
      return '${diff.inDays} day ago';
    } else if (diff.inDays > 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hrs ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} secs ago';
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
    } else if (imgUrl.startsWith("[")) {
      final String newUrl = imgUrl.substring(2);
      return newUrl.split("']")[0];
    } else if (!imgUrl.startsWith("https")) {
      return "https://$imgUrl";
    } else {
      return imgUrl;
    }
  }

  String removeDecimal(String price) {
    final List<String> splittedPrice = price.split(".");
    if (splittedPrice[1] == "0") {
      return splittedPrice[0];
    } else {
      return "${splittedPrice[0]}.${splittedPrice[1]}";
    }
  }

  List<GraphDataModel> extractGraphBasedOnPeriod(
    String period,
    List<GraphDataModel> data,
  ) {
    final List<GraphDataModel> graphData = data;

    if (period == "1m") {
      final startDate = DateTime.now().subtract(const Duration(days: 30));
      final formatter = DateFormat('yyyy-MM-dd');

      final String formattedDate1 = formatter.format(startDate);

      final List<String> timeData = extractTimeDataFromGraph(data);
      final List<String> newTimeData = [];

      for (final element in timeData) {
        newTimeData.add(element.split(" ")[0]);
      }
      final startIndex =
          newTimeData.indexWhere((element) => element == formattedDate1);
      if (startIndex == -1) {
        return graphData;
      }
      return graphData.sublist(startIndex);

      //  return graphData.reversed.toList().sublist(0, 31);
    } else if (period == "1y") {
      final startDate = DateTime.now().subtract(const Duration(days: 365));
      final formatter = DateFormat('yyyy-MM-dd');

      final String formattedDate1 = formatter.format(startDate);

      final List<String> timeData = extractTimeDataFromGraph(data);
      final List<String> newTimeData = [];

      for (final element in timeData) {
        newTimeData.add(element.split(" ")[0]);
      }
      final startIndex =
          newTimeData.indexWhere((element) => element == formattedDate1);
      if (startIndex == -1) {
        return graphData;
      }
      return graphData.sublist(startIndex);
    } else if (period == "5y") {
      final startDate = DateTime.now().subtract(const Duration(days: 1825));
      final formatter = DateFormat('yyyy-MM-dd');

      final String formattedDate1 = formatter.format(startDate);

      final List<String> timeData = extractTimeDataFromGraph(data);
      final List<String> newTimeData = [];

      for (final element in timeData) {
        newTimeData.add(element.split(" ")[0]);
      }
      final startIndex =
          newTimeData.indexWhere((element) => element == formattedDate1);
      if (startIndex == -1) {
        return graphData;
      }
      return graphData.sublist(startIndex);
    }
    return graphData;
  }

  List<num> extractPriceFromGraph(List<GraphDataModel> data) {
    final List<num> priceData = [];
    for (final element in data) {
      priceData.add(element.price);
    }
    return priceData;
  }

  List<String> extractTimeDataFromGraph(List<GraphDataModel> data) {
    final List<String> priceData = [];
    for (final element in data) {
      priceData.add(element.time);
    }
    return priceData;
  }

  String extractFacebook(String data) {
    if (data.contains("facebook")) {
      final Map valueMap = json.decode(data.replaceAll('\'', "\"")) as Map;
      return valueMap['facebook'][0] as String;
    } else {
      return "None";
    }
  }

  String extractReddit(String data) {
    if (data.contains("reddit")) {
      final Map valueMap = json.decode(data.replaceAll('\'', "\"")) as Map;
      return valueMap['reddit'][0] as String;
    } else {
      return "None";
    }
  }

  String extractSourceCode(String data) {
    if (data.contains("source_code")) {
      final Map valueMap = json.decode(data.replaceAll('\'', "\"")) as Map;
      return valueMap['source_code'][0] as String;
    } else {
      return "None";
    }
  }

  String extractWebsite(String data) {
    if (data.contains("website")) {
      final Map valueMap = json.decode(data.replaceAll('\'', "\"")) as Map;
      return valueMap['website'][0] as String;
    } else {
      return "None";
    }
  }

  String extractWhitePaper(String data) {
    if (data.isEmpty) {
      return "None";
    } else {
      final String prevWhitePaperLink = data.split(",")[0].split(":")[1].trim();
      if (prevWhitePaperLink == "None") {
        return "None";
      } else {
        final String whitePaperLink =
            data.split(",")[0].split("':")[1].split("'")[1];

        return whitePaperLink;
      }
    }
  }

  Map<String, Color> flagColor = {
    "Euro": const Color(0xFF0825cb),
    "Japanese Yen": const Color(0xFFfeced0),
    "Bulgarian Lev": const Color(0xFF00966e),
    "Czech Koruna": const Color(0xFF11457e),
    "Danish Krona": const Color(0xFFc7042d),
    "British Pound": const Color(0xFF012169),
    "Hungarian Forint": const Color(0xFF477050),
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
