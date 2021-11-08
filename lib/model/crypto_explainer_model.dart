class CryptoExplainerModel {
  final String title;
  final String description;
  final String author;
  final String difficulty;
  final String imgUrl;
  final String content;
  final String type;

  CryptoExplainerModel({
    required this.title,
    required this.description,
    required this.author,
    required this.difficulty,
    required this.imgUrl,
    required this.content,
    required this.type,
  });

  factory CryptoExplainerModel.fromJson(Map<String, dynamic> json) =>
      CryptoExplainerModel(
        title: json["title"] as String,
        description: json["description"] as String,
        author: json["author"] as String,
        difficulty: json["difficulty"] as String,
        imgUrl: json["imgUrl"] as String,
        content: json["content"] as String,
        type: json["type"] as String,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "author": author,
        "difficulty": difficulty,
        "imgUrl": imgUrl,
        "content": content,
        "type": type,
      };
}
