import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoMarketDataProvider with ChangeNotifier {
  CryptoMarketDataProvider();

  List<CryptoMarketDataModel> listModel = [];
  List<CryptoMarketDataModel> trendingCoins = [];

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
}
