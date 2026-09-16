import 'package:equatable/equatable.dart';

class ProductCreateDataModel {
  final List<CategoryMeta> categories;
  final List<SizeMeta> sizes;
  final List<ColorMeta> colors;
  final List<BrandMeta> brands;
  final List<UnitMeta> units;

  const ProductCreateDataModel({
    required this.categories,
    required this.sizes,
    required this.colors,
    required this.brands,
    required this.units,
  });

  factory ProductCreateDataModel.fromJson(Map<String, dynamic> json) {
    return ProductCreateDataModel(
      categories: (json['categories'] as List).map((e) => CategoryMeta.fromJson(e)).toList(),
      sizes: (json['sizes'] as List).map((e) => SizeMeta.fromJson(e)).toList(),
      colors: (json['colors'] as List).map((e) => ColorMeta.fromJson(e)).toList(),
      brands: (json['brands'] as List).map((e) => BrandMeta.fromJson(e)).toList(),
      units: (json['units'] as List).map((e) => UnitMeta.fromJson(e)).toList(),
    );
  }
}

class CategoryMeta extends Equatable {
  final int id;
  final String name;
  final String thumbnail;
  final List<SubCategoryMeta> subCategories;

  const CategoryMeta({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.subCategories = const [],
  });

  factory CategoryMeta.fromJson(Map<String, dynamic> json) => CategoryMeta(
        id: json['id'],
        name: json['name'],
        thumbnail: json['thumbnail'],
        subCategories: (json['sub_categories'] as List<dynamic>?)
                ?.map((e) => SubCategoryMeta.fromJson(e))
                .toList() ??
            [],
      );

  @override
  List<Object?> get props => [id]; // Compare by id only
}

class SubCategoryMeta extends Equatable {
  final int id;
  final String name;
  final String thumbnail;

  const SubCategoryMeta({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory SubCategoryMeta.fromJson(Map<String, dynamic> json) => SubCategoryMeta(
        id: json['id'],
        name: json['name'],
        thumbnail: json['thumbnail'],
      );

  @override
  List<Object?> get props => [id];
}

class SizeMeta extends Equatable {
  final int id;
  final String name;

  const SizeMeta({required this.id, required this.name});

  factory SizeMeta.fromJson(Map<String, dynamic> json) => SizeMeta(
        id: json['id'],
        name: json['name'],
      );

  @override
  List<Object?> get props => [id];
}

class ColorMeta extends Equatable {
  final int id;
  final String name;
  final String colorCode;

  const ColorMeta({required this.id, required this.name, required this.colorCode});

  factory ColorMeta.fromJson(Map<String, dynamic> json) => ColorMeta(
        id: json['id'],
        name: json['name'],
        colorCode: json['color_code'],
      );

  @override
  List<Object?> get props => [id];
}

class BrandMeta extends Equatable {
  final int id;
  final String name;

  const BrandMeta({required this.id, required this.name});

  factory BrandMeta.fromJson(Map<String, dynamic> json) => BrandMeta(
        id: json['id'],
        name: json['name'],
      );

  @override
  List<Object?> get props => [id];
}

class UnitMeta extends Equatable {
  final int id;
  final String name;

  const UnitMeta({required this.id, required this.name});

  factory UnitMeta.fromJson(Map<String, dynamic> json) => UnitMeta(
        id: json['id'],
        name: json['name'],
      );

  @override
  List<Object?> get props => [id];
}