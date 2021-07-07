import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/cryptoAndFiatModel.dart';

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
    list = parsedJson.map((e) => CryptoAndFiatModel.fromJson((e))).toList();
    listModel = list;
  }

  void switchValue(bool oldStatus) {
    isSwitched = oldStatus;
    var changeValue = index1;
    index1 = index2;
    index2 = changeValue;
    notifyListeners();
  }

  void changeCardValue(int index, CryptoAndFiatModel model) {
    int value = 0;
    listModel.forEach((_) {
      if (listModel.indexOf(model) != -1) {
        value = listModel.indexOf(model);
      }
    });
    if (index == 0) {
      index1 = value;
    } else {
      index2 = value;
    }
    notifyListeners();
  }

  Future<void> fiatAndCryptoList() async {
    var url = "http://192.168.31.132:8948/news/get-list";
    // var url = "http://192.168.43.93:8948/news/get-list";
    try {
      final response = await http.get(Uri.parse(url));
      var r = json.decode(response.body);
      CryptoAndFiatProvider model = CryptoAndFiatProvider.fromJson(r);
      listModel = model.listModel;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
