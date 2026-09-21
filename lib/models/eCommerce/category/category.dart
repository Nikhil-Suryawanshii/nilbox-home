import 'dart:convert';

class Category {
  final int id;
  final String name;
  final String thumbnail;
  final int displayOrder;
  final List<SubCategory> subCategories;
  Category({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.displayOrder,
    required this.subCategories,
  });

  Category copyWith({
    int? id,
    String? name,
    String? thumbnail,
    int? displayOrder,
    List<SubCategory>? subCategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      displayOrder: displayOrder ?? this.displayOrder,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'display_order': displayOrder,
      'subCategories': subCategories.map((x) => x.toMap()).toList(),
    };
  }

  static String _readThumbnail(Map<String, dynamic> map) {
    for (final key in ['thumbnail', 'logo', 'image', 'category_logo']) {
      final value = map[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
        id: map['id'].toInt() as int,
        name: map['name'] as String,
        thumbnail: _readThumbnail(map),
        displayOrder: map['display_order'].toInt() as int,
        subCategories: List<SubCategory>.from(
            (map['sub_categories'] as List<dynamic>).map<SubCategory>(
                (x) => SubCategory.fromMap(x as Map<String, dynamic>))));
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Category(id: $id, name: $name, thumbnail: $thumbnail, display_order: $displayOrder)';

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.thumbnail == thumbnail && other.displayOrder == displayOrder;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ thumbnail.hashCode;
}

class SubCategory {
  final int id;
  final String name;
  final String thumbnail;
  final int displayOrder;
  SubCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.displayOrder,
  });

  SubCategory copyWith({
    int? id,
    String? name,
    String? thumbnail,
    int? displayOrder,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'display_order': displayOrder,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map['id'].toInt() as int,
      name: map['name'] as String,
      thumbnail: Category._readThumbnail(map),
      displayOrder: map['display_order'].toInt() as int,
    );
  }
}
