import 'dart:async';
import 'dart:convert';

import 'package:crypto_news/helper/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/crypto_and_fiat_model.dart';

class CryptoAndFiatProvider with ChangeNotifier {
  bool isSwitched = false;

  String queryValue = "";
  String newQuery = "";

  int index1 = 0;
  int index2 = 1;

  List<CryptoAndFiatModel> listModel = [];
  List<CryptoAndFiatModel> updatedList = [];

  CryptoAndFiatProvider();

  void changeValue() {
    if (queryValue.isNotEmpty) {
      newQuery = queryValue;
    } else {
      queryValue = newQuery;
    }
  }

  void onQueryChanged() {
    if (newQuery.isNotEmpty) {
      updatedList = listModel
          .where((name) =>
              name.name.toLowerCase().startsWith(newQuery.toLowerCase()))
          .toList();
    } else {
      updatedList = listModel;
    }
    notifyListeners();
  }

  CryptoAndFiatProvider.fromJson(List<dynamic> parsedJson) {
    List<CryptoAndFiatModel> list = [];
    list = parsedJson
        .map((e) => CryptoAndFiatModel.fromJson(e as Map<String, dynamic>))
        .toList();
    listModel = list;
  }

  void switchValue({required bool oldStatus}) {
    isSwitched = oldStatus;
    final changeValue = index1;
    index1 = index2;
    index2 = changeValue;
    notifyListeners();
  }

  void changeCardValue(int index, CryptoAndFiatModel model) {
    int value = 0;
    if (listModel.contains(model)) {
      value = listModel.indexOf(model);
    }
    if (index == 0) {
      index1 = value;
    } else {
      index2 = value;
    }
    notifyListeners();
  }

  double getConversionRate(
      double coinV1, double coinV2, String conversionValue) {
    if (conversionValue.isEmpty) {
      return (coinV1 * 0) / coinV2;
    } else {
      return (coinV1 * double.parse(conversionValue)) / coinV2;
    }
  }

  Future<void> fiatAndCryptoList(int page) async {
    final url =
        "${ApiEndpoints.basUrl}cryptocurrency/get-crypto-fiat-list?page=$page";
    //final url = "http://192.168.31.132:8948/cryptocurrency/get-crypto-fiat-list?page=$page";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(Uri.parse(url));
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoAndFiatProvider model = CryptoAndFiatProvider.fromJson(r);
      for (final element in model.listModel) {
        listModel.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
