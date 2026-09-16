import 'dart:convert';

class Shop {
  int? id;
  String? name;
  String? logo;
  String? banner;
  String? address;
  String? openTime;
  String? closeTime;
  List<dynamic>? offDay;
  String? prefix;
  // int? estimatedDeliveryTime;
  // int? minOrderAmount;
  String? shopStatus;
  // int? totalProducts;
  // int? totalCategories;
  double? rating;
  double? totalReviews;
  String? description;

  Shop({
    this.id,
    this.name,
    this.logo,
    this.banner,
    this.address,
    this.openTime,
    this.closeTime,
    this.offDay,
    this.prefix,
    // this.estimatedDeliveryTime,
    // this.minOrderAmount,
    this.shopStatus,
    // this.totalProducts,
    // this.totalCategories,
    this.rating,
    this.totalReviews,
    this.description,
  });

  factory Shop.fromMap(Map<dynamic, dynamic> data) => Shop(
    id: data['id'] as int?,
    name: data['name'] as String?,
    logo: data['logo'] as String?,
    banner: data['banner'] as String?,
    address: data['address'] as String?,
    openTime: data['open_time'] as String?,
    closeTime: data['close_time'] as String?,
    offDay: data['off_day'] as List<dynamic>?,
    prefix: data['prefix'] as String?,
    // estimatedDeliveryTime: data['estimated_delivery_time'] as int?,
    // minOrderAmount: data['min_order_amount'] as int?,
    shopStatus: data['shop_status'] as String?,
    // totalProducts: data['total_products'] as int?,
    // totalCategories: data['total_categories'] as int?,
    rating: (data['rating'] as num).toDouble(),
    totalReviews: (data['total_reviews'] as num).toDouble(),
    description: data['description'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'logo': logo,
    'banner': banner,
    'address': address,
    'open_time': openTime,
    'close_time': closeTime,
    'off_day': offDay,
    'prefix': prefix,
    // 'estimated_delivery_time': estimatedDeliveryTime,
    // 'min_order_amount': minOrderAmount,
    'shop_status': shopStatus,
    // 'total_products': totalProducts,
    // 'total_categories': totalCategories,
    'rating': rating,
    'total_reviews': totalReviews,
    'description': description,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Shop].
  factory Shop.fromJson(String data) {
    return Shop.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Shop] to a JSON string.
  String toJson() => json.encode(toMap());
}
