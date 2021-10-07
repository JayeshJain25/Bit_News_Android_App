class CryptoMarketDataModel {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double marketCap;
  final double totalVolume;
  final double rank;
  final String image;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCapChange24h;
  final double marketCapChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  final double atl;
  final double atlChangePercentage;
  final String atlDate;
  final String lastUpdated;

  CryptoMarketDataModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.marketCap,
    required this.totalVolume,
    required this.rank,
    required this.image,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.lastUpdated,
  });

  factory CryptoMarketDataModel.fromJson(Map<String, dynamic> json) {
    double newTotalSupply = 0.0;

    if (json['totalSupply'] == "NaN") {
      newTotalSupply = 0.0;
    } else {
      newTotalSupply = json['totalSupply'] as double;
    }
    return CryptoMarketDataModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      price: json['price'] as double,
      marketCap: json['marketCap'] as double,
      totalVolume: json['totalVolume'] as double,
      rank: json['rank'] as double,
      image: json['image'] as String,
      high24h: json['high24h'] as double,
      low24h: json['low24h'] as double,
      priceChange24h: json['priceChange24h'] as double,
      priceChangePercentage24h: json['priceChangePercentage24h'] as double,
      marketCapChange24h: json['marketCapChange24h'] as double,
      marketCapChangePercentage24h:
          json['marketCapChangePercentage24h'] as double,
      circulatingSupply: json['circulatingSupply'] as double,
      totalSupply: newTotalSupply,
      maxSupply: json['maxSupply'] as double,
      atl: json['atl'] as double,
      atlChangePercentage: json['atlChangePercentage'] as double,
      atlDate: json['atlDate'] as String,
      lastUpdated: json['lastUpdated'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'price': price,
        'marketCap': marketCap,
        'totalVolume': totalVolume,
        'rank': rank,
        'image': image,
        'high24h': high24h,
        'low24h': low24h,
        'priceChange24h': priceChange24h,
        'priceChangePercentage24h': priceChangePercentage24h,
        'marketCapChange24h': marketCapChange24h,
        'marketCapChangePercentage24h': marketCapChangePercentage24h,
        'circulatingSupply': circulatingSupply,
        'totalSupply': totalSupply,
        'maxSupply': maxSupply,
        'atl': atl,
        'atlChangePercentage': atlChangePercentage,
        'atlDate': atlDate,
        'lastUpdated': lastUpdated
      };
}
