class CryptoAndFiatModel {
  final String id;
  final String name;
  final double price;
  final double marketCap;
  final double totalVolume;
  final double rank;
  final String symbol;
  final String image;
  final String type;
  final String gradientColor;

  const CryptoAndFiatModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.marketCap,
    required this.totalVolume,
    required this.rank,
    required this.image,
    required this.type,
    required this.gradientColor,
  });

  factory CryptoAndFiatModel.fromJson(Map<String, dynamic> json) {
    double marketCap = 0.0;
    double totalVolume = 0.0;

    if (json['market_cap'] != null) {
      marketCap = json['market_cap'] as double;
    }

    if (json['total_volume'] != null) {
      totalVolume = json['total_volume'] as double;
    }

    return CryptoAndFiatModel(
      id: json["id"] as String,
      symbol: json["symbol"] as String,
      name: json["name"] as String,
      price: json["price"] as double,
      marketCap: marketCap,
      totalVolume: totalVolume,
      rank: json["rank"] as double,
      image: json["image"] as String,
      type: json['type'] as String,
      gradientColor: "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "price": price,
        "market_cap": marketCap,
        "total_volume": totalVolume,
        "rank": rank,
        "image": image,
        "type": type,
        "gradientColor": gradientColor
      };
}
