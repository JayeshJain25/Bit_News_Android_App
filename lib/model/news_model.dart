class NewsModel {
  final String title;
  final String source;
  final String description;
  final String content;
  final String publishedDate;
  final String url;
  final String photoUrl;

  const NewsModel(
      {required this.title,
      required this.source,
      required this.description,
      required this.content,
      required this.publishedDate,
      required this.url,
      required this.photoUrl});

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
      title: json['title'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      publishedDate: json['publishedDate'] as String,
      url: json['url'] as String,
      photoUrl: json['photoUrl'] as String);

  Map<String, dynamic> toJson() => {
        'title': title,
        'source': source,
        'description': description,
        'content': content,
        'publishedDate': publishedDate,
        'url': url,
        'photoUrl': photoUrl,
      };
}
