import 'dart:convert';

import 'package:crypto_news/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  List<NewsModel> newsCompleteList = [];

  NewsProvider.fromJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson.map((e) => NewsModel.fromJson((e))).toList();
    newsCompleteList = list;
  }

  NewsProvider();

  Future<void> newsList() async {
    var url = "http://192.168.31.132:8948/news/get-news-list";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(Uri.parse(url));
      var r = json.decode(response.body);
      NewsProvider model = NewsProvider.fromJson(r);
      newsCompleteList = model.newsCompleteList;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
