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
  List<CryptoAndFiatModel> cardData = [];

  CryptoAndFiatProvider();

  CryptoAndFiatProvider.fromJson(List<dynamic> parsedJson) {
    List<CryptoAndFiatModel> list = [];
    list = parsedJson
        .map((e) => CryptoAndFiatModel.fromJson(e as Map<String, dynamic>))
        .toList();
    listModel = list;
  }

  void changeValue() {
    if (queryValue.isNotEmpty) {
      newQuery = queryValue;
    } else {
      queryValue = newQuery;
    }
  }

  void switchValue({required bool oldStatus}) {
    isSwitched = oldStatus;
    final changeValue = index1;
    index1 = index2;
    index2 = changeValue;
    notifyListeners();
  }

  void changeCardValue(int index, CryptoAndFiatModel model) {
    if (index == 0 && isSwitched == false) {
      cardData[0] = model;
    } else if (index == 1 && isSwitched == false) {
      cardData[1] = model;
    } else if (index == 0 && isSwitched == true) {
      cardData[1] = model;
    } else {
      cardData[0] = model;
    }
    notifyListeners();
  }

  double getConversionRate(
    double coinV1,
    double coinV2,
    String conversionValue,
    String type1,
    String type2,
    double fiatIndianPrice,
  ) {
    if (type1 == "Crypto" && type2 == "Fiat" && conversionValue.isNotEmpty) {
      return ((coinV1 * coinV2) / fiatIndianPrice) *
          double.parse(conversionValue);
    } else if (type2 == "Crypto" &&
        type1 == "Fiat" &&
        conversionValue.isNotEmpty) {
      final double cryptoPriceFiat = (coinV1 * coinV2) / fiatIndianPrice;
      return double.parse(conversionValue) / cryptoPriceFiat;
    } else if (conversionValue.isEmpty) {
      return (coinV1 * 0) / coinV2;
    } else {
      return (coinV1 * double.parse(conversionValue)) / coinV2;
    }
  }

  Future<void> getCryptoAndFiatBySearch(String name) async {
    updatedList.clear();
    final url =
        "${ApiEndpoints.baseUrl}cryptocurrency/get-crypto-fiat-list-by-search/?name=$name";
    //final url = "http://192.168.31.132:8948/cryptocurrency/get-crypto-fiat-list?page=$page";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(
        Uri.parse(url),
        //headers: <String, String>{'authorization': _apiEndpoints.basicAuth}
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoAndFiatProvider model = CryptoAndFiatProvider.fromJson(r);
      for (final element in model.listModel) {
        updatedList.add(element);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fiatAndCryptoList(int page) async {
    final url = "${ApiEndpoints.baseUrl}cryptocurrency/crypto-fiat/?page=$page";
    //final url = "http://192.168.31.132:8948/cryptocurrency/get-crypto-fiat-list?page=$page";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(
        Uri.parse(url),
        //headers: <String, String>{'authorization': _apiEndpoints.basicAuth}
      );
      final r = json.decode(response.body) as List<dynamic>;
      final CryptoAndFiatProvider model = CryptoAndFiatProvider.fromJson(r);
      for (final element in model.listModel) {
        listModel.add(element);
      }
      if (page == 0) {
        cardData.add(listModel[0]);
        cardData.add(listModel[1]);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
