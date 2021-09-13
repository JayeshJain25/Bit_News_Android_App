
import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/crypto_market_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoMarketDataProvider with ChangeNotifier {

  CryptoMarketDataProvider();

  final _apiEndpoints = ApiEndpoints();

   List<CryptoMarketDataModel> listModel = [];

  CryptoMarketDataProvider.fromJson(List<dynamic> parsedJson) {
    List<CryptoMarketDataModel> list = [];
    list = parsedJson
        .map((e) => CryptoMarketDataModel.fromJson(e as Map<String, dynamic>))
        .toList();
    listModel = list;
  }

  Future<void> cryptoMarketDataByPagination(int page) async {
    final url =
        "${ApiEndpoints.basUrl}cryptocurrency/get-crypto-market-data-list?page=$page";
    //final url = "http://192.168.31.132:8948/cryptocurrency/get-crypto-fiat-list?page=$page";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(Uri.parse(url),
          headers: <String, String>{'authorization': _apiEndpoints.basicAuth});
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoMarketDataProvider model = CryptoMarketDataProvider.fromJson(r);
      for (final element in model.listModel) {
        listModel.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}