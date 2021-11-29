class GraphDataModel {
  GraphDataModel({
    required this.price,
    required this.time,
  });

  final num price;
  final String time;

  factory GraphDataModel.fromMap(Map<String, dynamic> json) => GraphDataModel(
        price: json["price"] as num,
        time: json["time"] as String,
      );

  Map<String, dynamic> toMap() => {
        "price": price,
        "time": time,
      };
}
