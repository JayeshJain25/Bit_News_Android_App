class CoinPaprikaGlobalDataModel {
  final int marketCapUSD;
  final int volume24hUSD;
  final double bitcoinDominancePercentage;
  final int cryptocurrenciesNumber;
  final int marketCapAthValue;
  final String marketCapAthDate;
  final int volume24hAthValue;
  final String volume24hAthDate;
  final double volume24hPercentFromAth;
  final double volume24hPercentToAth;
  final double marketCapChange24h;
  final double volume24hChange24h;
  final int lastUpdated;

  CoinPaprikaGlobalDataModel({
    required this.marketCapUSD,
    required this.volume24hUSD,
    required this.bitcoinDominancePercentage,
    required this.cryptocurrenciesNumber,
    required this.marketCapAthValue,
    required this.marketCapAthDate,
    required this.volume24hAthValue,
    required this.volume24hAthDate,
    required this.volume24hPercentFromAth,
    required this.volume24hPercentToAth,
    required this.marketCapChange24h,
    required this.volume24hChange24h,
    required this.lastUpdated,
  });

  factory CoinPaprikaGlobalDataModel.fromJson(Map<String, dynamic> json) =>
      CoinPaprikaGlobalDataModel(
        marketCapUSD: json['marketCapUSD'] as int,
        volume24hUSD: json['volume24hUSD'] as int,
        bitcoinDominancePercentage:
            json['bitcoinDominancePercentage'] as double,
        cryptocurrenciesNumber: json['cryptocurrenciesNumber'] as int,
        marketCapAthValue: json['marketCapAthValue'] as int,
        marketCapAthDate: json['marketCapAthDate'] as String,
        volume24hAthValue: json['volume24hAthValue'] as int,
        volume24hAthDate: json['volume24hAthDate'] as String,
        volume24hPercentFromAth: json['volume24hPercentFromAth'] as double,
        volume24hPercentToAth: json['volume24hPercentToAth'] as double,
        marketCapChange24h: json['marketCapChange24h'] as double,
        volume24hChange24h: json['volume24hChange24h'] as double,
        lastUpdated: json['lastUpdated'] as int,
      );

  Map<String, dynamic> toJson() => {
        'volume24hUSD': volume24hUSD,
        'bitcoinDominancePercentage': bitcoinDominancePercentage,
        'cryptocurrenciesNumber': cryptocurrenciesNumber,
        'marketCapAthValue': marketCapAthValue,
        'marketCapAthDate': marketCapAthDate,
        'volume24hAthValue': volume24hAthValue,
        'volume24hAthDate': volume24hAthDate,
        'volume24hPercentFromAth': volume24hPercentFromAth,
        'volume24hPercentToAth': volume24hPercentToAth,
        'marketCapChange24h': marketCapChange24h,
        'volume24hChange24h': volume24hChange24h,
        'lastUpdated': lastUpdated,
      };
}
