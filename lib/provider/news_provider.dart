import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  NewsProvider();

  List<NewsModel> newsCompleteList = [];
  List<NewsModel> bitcoinNewsList = [];
  List<NewsModel> ethereumNewsList = [];
  List<NewsModel> nftNewsList = [];

  NewsProvider.fromJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    newsCompleteList = list;
  }

  NewsProvider.fromBitcoinJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    bitcoinNewsList = list;
  }

  NewsProvider.fromEthereumJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    ethereumNewsList = list;
  }

  NewsProvider.fromNFTJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    nftNewsList = list;
  }

  Future<void> getNewsFeed(
    int page,
  ) async {
    final url =
        "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=all"; //?page=1&tag=btc,Bitcoin
    try {
      final response = await http.get(
        Uri.parse(url),
        // headers: <String, String>{'authorization': _apiEndpoints.basicAuth}
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromJson(r);
      for (final element in model.newsCompleteList) {
        newsCompleteList.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getBitcoinNews(
    int page,
  ) async {
    final url =
        "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=btc,bitcoin"; //?page=1&tag=btc,Bitcoin
    try {
      final response = await http.get(
        Uri.parse(url),
        // headers: <String, String>{'authorization': _apiEndpoints.basicAuth}
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromBitcoinJson(r);
      for (final element in model.bitcoinNewsList) {
        bitcoinNewsList.add(element);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getEthereumNews(
    int page,
  ) async {
    final url =
        "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=eth,ethereum"; //?page=1&tag=btc,Bitcoin
    try {
      final response = await http.get(
        Uri.parse(url),
        // headers: <String, String>{'authorization': _apiEndpoints.basicAuth}
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromEthereumJson(r);
      for (final element in model.ethereumNewsList) {
        ethereumNewsList.add(element);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getNFTNews(
    int page,
  ) async {
    final url =
        "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=nft,nfts"; //?page=1&tag=btc,Bitcoin
    try {
      final response = await http.get(
        Uri.parse(url),
        // headers: <String, String>{'authorization': _apiEndpoints.basicAuth}
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromNFTJson(r);
      for (final element in model.nftNewsList) {
        nftNewsList.add(element);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
