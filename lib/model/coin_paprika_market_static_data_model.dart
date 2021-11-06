class CoinPaprikaMarketStaticDataModel {
  final String id;
  final String name;
  final String symbol;
  final int rank;
  final String type;
  final String description;
  final String whitepaper;
  final String links;

  CoinPaprikaMarketStaticDataModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.rank,
    required this.type,
    required this.description,
    required this.whitepaper,
    required this.links,
  });

  factory CoinPaprikaMarketStaticDataModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      CoinPaprikaMarketStaticDataModel(
        id: json["id"] as String,
        name: json["name"] as String,
        symbol: json["symbol"] as String,
        rank: json["rank"] as int,
        type: json["type"] as String,
        description: json["description"] as String,
        whitepaper: json["whitepaper"] as String,
        links: json["links"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "symbol": symbol,
        "rank": rank,
        "type": type,
        "description": description,
        "whitepaper": whitepaper,
        "links": links,
      };
}
