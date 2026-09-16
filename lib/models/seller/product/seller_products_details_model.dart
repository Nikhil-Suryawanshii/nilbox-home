class SellerProductDetailsModel {
  final int id;
  final String name;
  final double price;
  final double discountPrice;
  final int quantity;
  final int code;
  final int minOrderQuantity;
  final String thumbnail;
  final List<dynamic> additionalThumbnail;
  final CategoryDetails? category;
  final List<SubCategoryDetails> subCategories;
  final List<dynamic> sizes;
  final List<dynamic> colors;
  final dynamic brand;
  final dynamic unit;
  final String shortDescription;
  final String description;

  SellerProductDetailsModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.quantity,
    required this.code,
    required this.minOrderQuantity,
    required this.thumbnail,
    required this.additionalThumbnail,
    this.category,
    required this.subCategories,
    required this.sizes,
    required this.colors,
    this.brand,
    this.unit,
    required this.shortDescription,
    required this.description,
  });

  factory SellerProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return SellerProductDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discount_price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      code: json['code'] is String ? int.tryParse(json['code']) ?? 0 : (json['code'] ?? 0),
      minOrderQuantity: json['min_order_quantity'] ?? 1,
      thumbnail: json['thumbnail'] ?? "",
      additionalThumbnail: json['additional_thumbnail'] ?? [],
      category: json['category'] != null ? CategoryDetails.fromJson(json['category']) : null,
      subCategories: (json['sub_categories'] as List?)
              ?.map((e) => SubCategoryDetails.fromJson(e))
              .toList() ?? [],
      sizes: json['sizes'] ?? [],
      colors: json['colors'] ?? [],
      brand: json['brand'],
      unit: json['unit'],
      shortDescription: json['short_description'] ?? "",
      description: json['description'] ?? "",
    );
  }
}

class CategoryDetails {
  final int id;
  final String name;
  final String thumbnail;

  CategoryDetails({required this.id, required this.name, required this.thumbnail});

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      thumbnail: json['thumbnail'] ?? "",
    );
  }
}

class SubCategoryDetails {
  final int id;
  final String name;
  final String thumbnail;

  SubCategoryDetails({required this.id, required this.name, required this.thumbnail});

  factory SubCategoryDetails.fromJson(Map<String, dynamic> json) {
    return SubCategoryDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      thumbnail: json['thumbnail'] ?? "",
    );
  }
}