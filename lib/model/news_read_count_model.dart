class NewsReadCountModel {
  final String title;
  final String source;
  final List<dynamic> readCount;

  const NewsReadCountModel({
    required this.title,
    required this.source,
    required this.readCount,
  });

  factory NewsReadCountModel.fromJson(Map<String, dynamic> json) {
    return NewsReadCountModel(
      title: json['title'] as String,
      source: json['source'] as String,
      readCount: json['readCount'] as List<dynamic>,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'source': source,
        'readCount': readCount,
      };
}
