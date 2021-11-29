import 'graph_data_model.dart';

class CryptoDataDailyGraphModel {
  final String name;
  final String symbol;
  final List<GraphDataModel> graphData;

  CryptoDataDailyGraphModel({
    required this.name,
    required this.symbol,
    required this.graphData,
  });

  factory CryptoDataDailyGraphModel.fromJson(Map<String, dynamic> json) {
    List<GraphDataModel> graphData = [];
    if (json['graphData'] != null) {
      graphData = [];
      json['graphData'].forEach((v) {
        graphData.add(GraphDataModel.fromMap(v as Map<String, dynamic>));
      });
    }
    return CryptoDataDailyGraphModel(
      name: json["name"] as String,
      symbol: json["symbol"] as String,
      graphData: graphData,
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "graphData": List<dynamic>.from(graphData.map((x) => x.toMap())),
      };
}
