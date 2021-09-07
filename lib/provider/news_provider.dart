import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  NewsProvider();

  List<NewsModel> newsCompleteList = [];

  NewsProvider.fromJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    newsCompleteList = list;
  }

  Future<void> newsList() async {
    const url = "${ApiEndpoints.basUrl}news/get-news-list";
    //const url = "http://192.168.31.132:8948/news/get-news-list";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(Uri.parse(url));
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromJson(r);
      newsCompleteList = model.newsCompleteList;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
