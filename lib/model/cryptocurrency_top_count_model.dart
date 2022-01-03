class CryptocurrencyTopCountModel {
  final String name;
  final String symbol;
  final List<dynamic> seeCount;
  final int totalSeeCount;

  const CryptocurrencyTopCountModel({
    required this.name,
    required this.symbol,
    required this.seeCount,
    required this.totalSeeCount,
  });

  factory CryptocurrencyTopCountModel.fromJson(Map<String, dynamic> json) {
    return CryptocurrencyTopCountModel(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      seeCount: json['seeCount'] as List<dynamic>,
      totalSeeCount: json['totalSeeCount'] as int,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'symbol': symbol,
        'seeCount': seeCount,
        'totalSeeCount': totalSeeCount,
      };
}
