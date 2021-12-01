class UserDataModel {
  final String name;
  final String emailId;
  final String photoUrl;
  final String userUid;
  final List<dynamic> favoriteCoins;

  const UserDataModel({
    required this.name,
    required this.emailId,
    required this.photoUrl,
    required this.userUid,
    required this.favoriteCoins,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      name: json['name'] as String,
      emailId: json['emailId'] as String,
      photoUrl: json['photoUrl'] as String,
      userUid: json['userUid'] as String,
      favoriteCoins: json['favoriteCoins'] as List<dynamic>,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'emailId': emailId,
        'photoUrl': photoUrl,
        'userUid': userUid,
        'favoriteCoins': favoriteCoins,
      };
}
