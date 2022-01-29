import 'dart:async';
import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:crypto_news/model/crypto_explainer_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoExplainerProvider with ChangeNotifier {
  List<CryptoExplainerModel> explainerlist = [];
  List<CryptoExplainerModel> beginnerlist = [];
  List<CryptoExplainerModel> intermediatelist = [];
  List<CryptoExplainerModel> advancelist = [];

  CryptoExplainerProvider();

  CryptoExplainerProvider.fromJson(List<dynamic> parsedJson) {
    List<CryptoExplainerModel> list = [];
    list = parsedJson
        .map((e) => CryptoExplainerModel.fromJson(e as Map<String, dynamic>))
        .toList();
    explainerlist = list;
  }

  Future<void> getcryptoExplainerByType(String type) async {
    explainerlist.clear();
    final url = "${ApiEndpoints.baseUrl}coin-explainer";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoExplainerProvider model = CryptoExplainerProvider.fromJson(r);
      for (final element in model.explainerlist) {
        explainerlist.add(element);
      }
      for (final element in explainerlist) {
        if (element.difficulty == "Beginner") {
          beginnerlist.add(element);
        } else if (element.difficulty == "Intermediate") {
          intermediatelist.add(element);
        } else {
          advancelist.add(element);
        }
        intermediatelist = intermediatelist.reversed.toList();
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
