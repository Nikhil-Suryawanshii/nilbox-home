import 'dart:convert';

class Banner {
  int? id;
  dynamic title;
  String? thumbnail;

  Banner({this.id, this.title, this.thumbnail});

  factory Banner.fromMap(Map<String, dynamic> data) => Banner(
    id: data['id'] as int?,
    title: data['title'] as dynamic,
    thumbnail: data['thumbnail'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'thumbnail': thumbnail,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Banner].
  factory Banner.fromJson(String data) {
    return Banner.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Banner] to a JSON string.
  String toJson() => json.encode(toMap());
}
