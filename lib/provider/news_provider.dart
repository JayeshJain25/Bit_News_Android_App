import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/contact_us_model.dart';
import 'package:crypto_news/model/news_model.dart';
import 'package:crypto_news/model/news_read_count_model.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  NewsProvider();

  List<NewsModel> newsCompleteList = [];
  List<NewsModel> bitcoinNewsList = [];
  List<NewsModel> ethereumNewsList = [];
  List<NewsModel> nftNewsList = [];
  List<NewsModel> metaverseNewsList = [];
  List<NewsModel> newsByReadCount = [];
  List<NewsModel> topHeadlineNewsList = [];

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

  NewsProvider.fromMetaverseJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    metaverseNewsList = list;
  }

  NewsProvider.fromReadCountJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    newsByReadCount = list;
  }

  NewsProvider.fromTopHeadlinesNewsJson(List<dynamic> parsedJson) {
    List<NewsModel> list = [];
    list = parsedJson
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
    topHeadlineNewsList = list;
  }

  Future<void> getNewsFeed(
    int page,
  ) async {
    final url = "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=all";
    try {
      final response = await http.get(
        Uri.parse(url),
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
    final url = "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=btc,bitcoin";
    try {
      final response = await http.get(
        Uri.parse(url),
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
    final url = "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=eth,ethereum";
    try {
      final response = await http.get(
        Uri.parse(url),
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
    final url = "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=nft,nfts";
    try {
      final response = await http.get(
        Uri.parse(url),
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

  Future<void> getMetaverseNews(
    int page,
  ) async {
    final url =
        "${ApiEndpoints.baseUrl}news/news/?page=$page&tag=metaverse,Metaverse";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromMetaverseJson(r);
      for (final element in model.metaverseNewsList) {
        metaverseNewsList.add(element);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getTopHeadlinesNews() async {
    final url = "${ApiEndpoints.baseUrl}news/top-headline-news";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromTopHeadlinesNewsJson(r);
      for (final element in model.topHeadlineNewsList) {
        topHeadlineNewsList.add(element);
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getNewsByReadCount() async {
    final url = "${ApiEndpoints.baseUrl}news/top-news";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final NewsProvider model = NewsProvider.fromReadCountJson(r);
      for (final element in model.newsByReadCount) {
        if (newsByReadCount.length <= 5) {
          newsByReadCount.add(element);
        }
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<NewsReadCountModel> getNewsReadCount(
    String title,
    String source,
  ) async {
    final NewsReadCountModel model;
    final url =
        "${ApiEndpoints.baseUrl}news/read-count-news?title=$title&source=$source";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      if (r.isEmpty) {
        model = const NewsReadCountModel(
          readCount: [],
          title: "",
          source: "",
          totalReadCount: 0,
        );
      } else {
        model = NewsReadCountModel.fromJson(
          r[0] as Map<String, dynamic>,
        );
      }

      notifyListeners();
      return model;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateNewsReadCount(
    NewsReadCountModel countModel,
  ) async {
    final url = "${ApiEndpoints.baseUrl}news/update-read-count";
    try {
      await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': countModel.title,
          'source': countModel.source,
          'readCount': countModel.readCount,
          'totalReadCount': countModel.readCount.length
        }),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
