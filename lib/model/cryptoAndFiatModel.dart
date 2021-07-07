class CryptoAndFiatModel {
  final String id;
  final String name;
  final String price;
  final String marketCap;
  final String totalVolume;
  final String rank;
  final String symbol;
  final String image;
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
    required this.gradientColor,
  });

  factory CryptoAndFiatModel.fromJson(Map<String, dynamic> json) =>
      CryptoAndFiatModel(
        id: json["id"],
        symbol: json["symbol"],
        name: json["name"],
        price: json["price"],
        marketCap: json["market_cap"],
        totalVolume: json["total_volume"],
        rank: json["rank"],
        image: json["image"],
        gradientColor: "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "price": price,
        "market_cap": marketCap,
        "total_volume": totalVolume,
        "rank": rank,
        "image": image,
        "gradientColor": gradientColor
      };
}
