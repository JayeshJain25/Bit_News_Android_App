import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/coin_paprika_global_data_model.dart';
import 'package:crypto_news/model/coin_paprika_market_static_data_model.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoMarketDataProvider with ChangeNotifier {
  CryptoMarketDataProvider();

  List<CryptoMarketDataModel> listModel = [];
  List<CryptoMarketDataModel> trendingCoins = [];
  List<CryptoMarketDataModel> watchListCoins = [];

  CryptoMarketDataProvider.fromJson(List<dynamic> parsedJson) {
    List<CryptoMarketDataModel> list = [];
    list = parsedJson
        .map((e) => CryptoMarketDataModel.fromJson(e as Map<String, dynamic>))
        .toList();
    listModel = list;
  }

  CryptoMarketDataProvider.fromMap(List<dynamic> parsedJson) {
    List<CryptoMarketDataModel> list = [];
    list = parsedJson
        .map((e) => CryptoMarketDataModel.fromJson(e as Map<String, dynamic>))
        .toList();
    trendingCoins = list;
  }

  CryptoMarketDataProvider.frommap1(List<dynamic> parsedJson) {
    List<CryptoMarketDataModel> list = [];
    list = parsedJson
        .map((e) => CryptoMarketDataModel.fromJson(e as Map<String, dynamic>))
        .toList();
    watchListCoins = list;
  }

  Future<void> cryptoMarketDataByPagination(int page) async {
    final url =
        "${ApiEndpoints.baseUrl}cryptocurrency/crypto-market-data/?page=$page";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoMarketDataProvider model =
          CryptoMarketDataProvider.fromJson(r);
      for (final element in model.listModel) {
        listModel.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getCryptoBySearch(String name) async {
    listModel.clear();
    final url =
        "${ApiEndpoints.baseUrl}cryptocurrency/crypto-by-search?name=$name";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoMarketDataProvider model =
          CryptoMarketDataProvider.fromJson(r);
      for (final element in model.listModel) {
        listModel.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getTrendingCoins() async {
    final url = "${ApiEndpoints.baseUrl}cryptocurrency/trending-coins";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoMarketDataProvider model =
          CryptoMarketDataProvider.fromMap(r);
      for (final element in model.trendingCoins) {
        trendingCoins.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getWatchListCoins() async {
    final url = "${ApiEndpoints.baseUrl}cryptocurrency/watch-list-coins";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoMarketDataProvider model =
          CryptoMarketDataProvider.frommap1(r);
      for (final element in model.watchListCoins) {
        watchListCoins.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<CoinPaprikaGlobalDataModel> getCoinPaprikaGlobalData() async {
    final url =
        "${ApiEndpoints.baseUrl}cryptocurrency/coin-paprika-global-data";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CoinPaprikaGlobalDataModel globalData =
          CoinPaprikaGlobalDataModel.fromJson(
        r[0] as Map<String, dynamic>,
      );
      notifyListeners();
      return globalData;
    } catch (error) {
      rethrow;
    }
  }

  Future<CoinPaprikaMarketStaticDataModel> getCoinPaprikaMarketStaticData(
    String symbol,
  ) async {
    final url =
        "${ApiEndpoints.baseUrl}/cryptocurrency/coin-paprika-market-static-data?symbol=$symbol";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CoinPaprikaMarketStaticDataModel globalData =
          CoinPaprikaMarketStaticDataModel.fromJson(
        r[0] as Map<String, dynamic>,
      );
      notifyListeners();
      return globalData;
    } catch (error) {
      rethrow;
    }
  }
}
