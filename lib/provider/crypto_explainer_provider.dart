import 'dart:async';
import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/crypto_explainer_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoExplainerProvider with ChangeNotifier {
  List<CryptoExplainerModel> listModel = [];

  CryptoExplainerProvider();

  CryptoExplainerProvider.fromJson(List<dynamic> parsedJson) {
    List<CryptoExplainerModel> list = [];
    list = parsedJson
        .map((e) => CryptoExplainerModel.fromJson(e as Map<String, dynamic>))
        .toList();
    listModel = list;
  }

  Future<void> getcryptoExplainerByType(String type) async {
    final url = "${ApiEndpoints.baseUrl}coin-explainer?type=$type";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoExplainerProvider model = CryptoExplainerProvider.fromJson(r);
      for (final element in model.listModel) {
        listModel.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
