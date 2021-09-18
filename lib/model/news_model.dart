class NewsModel {
  final String title;
  final String source;
  final String description;
  final String readTime;
  final String publishedDate;
  final String url;
  final String photoUrl;
  final String summary;

  const NewsModel({
    required this.title,
    required this.source,
    required this.description,
    required this.readTime,
    required this.publishedDate,
    required this.url,
    required this.photoUrl,
    required this.summary,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
      title: json['title'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      readTime: json['readTime'] as String,
      publishedDate: json['publishedDate'] as String,
      url: json['url'] as String,
      photoUrl: json['photoUrl'] as String,
      summary: json['summary'] as String);

  Map<String, dynamic> toJson() => {
        'title': title,
        'source': source,
        'description': description,
        'readTime': readTime,
        'publishedDate': publishedDate,
        'url': url,
        'photoUrl': photoUrl,
        'summary': summary
      };
}
