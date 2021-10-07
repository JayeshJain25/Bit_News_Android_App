class NewsModel {
  final String title;
  final String source;
  final String description;
  final String readTime;
  final String publishedDate;
  final String url;
  final String photoUrl;
  final String summary;
  final List<dynamic> tags;

  const NewsModel({
    required this.title,
    required this.source,
    required this.description,
    required this.readTime,
    required this.publishedDate,
    required this.url,
    required this.photoUrl,
    required this.summary,
    required this.tags,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String newPhotoUrl = "";
    if (json['photoUrl'] != null) {
      newPhotoUrl = json['photoUrl'] as String;
    }
    return NewsModel(
      title: json['title'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      readTime: json['readTime'] as String,
      publishedDate: json['publishedDate'] as String,
      url: json['url'] as String,
      photoUrl: newPhotoUrl,
      summary: json['summary'] as String,
      tags: json['tags'] as List<dynamic>,
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'source': source,
        'description': description,
        'readTime': readTime,
        'publishedDate': publishedDate,
        'url': url,
        'photoUrl': photoUrl,
        'summary': summary,
        'tags': tags,
      };
}
