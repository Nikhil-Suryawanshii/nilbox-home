class SellerProduct {
  final int id;
  final String name;
  final String thumbnail;
  final double price;
  final double discountPrice;
  final int quantity;
  final String? brand;
  bool isActive;

  SellerProduct({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.price,
    required this.discountPrice,
    required this.quantity,
    this.brand,
    required this.isActive,
  });

  factory SellerProduct.fromJson(Map<String, dynamic> json) {
    return SellerProduct(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discount_price'] as num).toDouble(),
      quantity: json['quantity'] ?? 0,
      brand: json['brand'],
      isActive: json['is_active'] ?? false,
    );
  }
}