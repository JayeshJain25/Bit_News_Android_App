import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CryptoAndFiatModel with ChangeNotifier {
  bool isSwitched = false;

  String queryValue = "";
  String newQuery = "";

  void changeValue(){
    if(queryValue.isNotEmpty){
      newQuery = queryValue;
    }else{
      queryValue = newQuery;
    }
  }

  List<CryptoAndFiatStructureModel> listModel;
  List<CryptoAndFiatStructureModel> updatedList = [];

  void onQueryChanged() {
    if (newQuery.isNotEmpty) {
      updatedList = listModel
          .where(
              (name) => name.name.toLowerCase().startsWith(newQuery.toLowerCase()))
          .toList();
    }else{
      updatedList = listModel;
    }
    notifyListeners();
  }

  CryptoAndFiatModel({required this.listModel});

  factory CryptoAndFiatModel.fromJson(List<dynamic> parsedJson) {
    List<CryptoAndFiatStructureModel> list = [];
    list = parsedJson
        .map((e) => CryptoAndFiatStructureModel.fromJson((e)))
        .toList();
    return new CryptoAndFiatModel(listModel: list);
  }

  void switchValue(bool oldStatus) {
    isSwitched = oldStatus;
    notifyListeners();
  }

  List<CryptoAndFiatStructureModel> get data {
    return isSwitched ? new List.from(listData.reversed) : listData;
  }

  List<CryptoAndFiatStructureModel> listData = [
    CryptoAndFiatStructureModel(
        name: "Bitcoin",
        price: "2500000",
        image:
            "https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Bitcoin-BTC-icon.png",
        symbol: "BTC",
        gradientColor: "#491f01",
        id: "",
        market_cap: "",
        total_volume: "",
        rank: ""),
    CryptoAndFiatStructureModel(
        name: "Ethereum",
        price: "200000",
        image:
            "https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/256/Ethereum-ETH-icon.png",
        symbol: "ETH",
        gradientColor: "#627eeb",
        rank: "",
        total_volume: "",
        market_cap: "",
        id: "")
  ];

  void fiatAndCryptoList() async {
    var url = "http://192.168.31.167:8948/news/get-list";
    try {
      final response = await http.get(Uri.parse(url));
      var r = json.decode(response.body);
      CryptoAndFiatModel model = CryptoAndFiatModel.fromJson(r);
      listModel = model.listModel;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}

class CryptoAndFiatStructureModel {
  final String id;
  final String name;
  final String price;
  final String market_cap;
  final String total_volume;
  final String rank;
  final String symbol;
  final String image;
  final String gradientColor;

  const CryptoAndFiatStructureModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.market_cap,
    required this.total_volume,
    required this.rank,
    required this.image,
    required this.gradientColor,
  });

  factory CryptoAndFiatStructureModel.fromJson(Map<String, dynamic> json) =>
      CryptoAndFiatStructureModel(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        market_cap: json["market_cap"],
        total_volume: json["total_volume"],
        rank: json["rank"],
        image: json["image"],
        gradientColor: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "price": price,
        "market_cap": market_cap,
        "total_volume": total_volume,
        "rank": rank,
        "image": image,
        "gradientColor": gradientColor
      };
}
