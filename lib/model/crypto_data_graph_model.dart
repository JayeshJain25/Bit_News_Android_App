class CryptoDataGraphModel {
  final String name;
  final String symbol;
  final String period;
  final List<GraphDataModel> graphData;

  CryptoDataGraphModel({
    required this.name,
    required this.symbol,
    required this.period,
    required this.graphData,
  });

  factory CryptoDataGraphModel.fromJson(Map<String, dynamic> json) {
    List<GraphDataModel> graphData = [];
    if (json['graphData'] != null) {
      graphData = [];
      json['graphData'].forEach((v) {
        graphData.add(GraphDataModel.fromMap(v as Map<String, dynamic>));
      });
    }
    return CryptoDataGraphModel(
      name: json["name"] as String,
      symbol: json["symbol"] as String,
      period: json["period"] as String,
      graphData: graphData,
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "period": period,
        "graphData": List<dynamic>.from(graphData.map((x) => x.toMap())),
      };
}

class GraphDataModel {
  GraphDataModel({
    required this.price,
    required this.time,
  });

  final num price;
  final String time;

  factory GraphDataModel.fromMap(Map<String, dynamic> json) => GraphDataModel(
        price: json["price"] as num,
        time: json["time"] as String,
      );

  Map<String, dynamic> toMap() => {
        "price": price,
        "time": time,
      };
}
