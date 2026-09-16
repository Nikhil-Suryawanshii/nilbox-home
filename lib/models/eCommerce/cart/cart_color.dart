class Color {
  int? id;
  String? name;
  String? colorCode;
  double? price;

  Color({
    this.id,
    this.name,
    this.colorCode,
    this.price,
  });

  factory Color.fromJson(Map<String, dynamic> json) => Color(
    id: json["id"],
    name: json["name"],
    colorCode: json["color_code"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color_code": colorCode,
    "price": price,
  };
}