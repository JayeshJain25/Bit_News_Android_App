import 'package:flutter/material.dart';

class NewsModel extends ChangeNotifier {
  List<NewsStructureModel> newsModel = history;

  List<NewsStructureModel> get suggestions => newsModel;

  void onQueryChanged(String query) async {
    newsModel = history1;
    notifyListeners();
  }
}

const List<NewsStructureModel> history1 = [
  NewsStructureModel(
      newsHeadline: "Crypto market is in the green",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
  NewsStructureModel(
      newsHeadline:
          "China crackdown triggers Bitcoin crash; what should investors do?",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
  NewsStructureModel(
      newsHeadline:
          "Bitcoin is the future of currency if government, banks understand and regulate it: Experts",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
];

const List<NewsStructureModel> history = [
  NewsStructureModel(
      newsHeadline: "Crypto market is in the green",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
  NewsStructureModel(
      newsHeadline:
          "China crackdown triggers Bitcoin crash; what should investors do?",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
  NewsStructureModel(
      newsHeadline:
          "Millennials and cryptocurrencies: A story of missed profits, hard lessons and losses",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
  NewsStructureModel(
      newsHeadline:
          "Two South African brothers vanish with 3.6 billion in Bitcoin",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
  NewsStructureModel(
      newsHeadline:
          "Bitcoin is the future of currency if government, banks understand and regulate it: Experts",
      newsUrl:
          "https://www.coindesk.com/bitcoin-hashrate-china-mining-crackdown"),
];

class NewsStructureModel {
  final String newsHeadline;
  final String newsUrl;

  const NewsStructureModel({required this.newsHeadline, required this.newsUrl});
}
