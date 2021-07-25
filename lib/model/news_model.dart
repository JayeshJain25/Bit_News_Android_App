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
      title: json['title'],
      source: json['source'],
      description: json['description'],
      content: json['content'],
      publishedDate: json['publishedDate'],
      url: json['url'],
      photoUrl: json['photoUrl']);

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'source': this.source,
        'description': this.description,
        'content': this.content,
        'publishedDate': this.publishedDate,
        'url': this.url,
        'photoUrl': this.photoUrl,
      };
}
