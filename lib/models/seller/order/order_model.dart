class SellerOrder {
  SellerOrder({
    required this.id,
    required this.orderCode,
    required this.amount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.estimatedDeliveryDate,
    this.pickupDate,
    required this.deliveryDate,
    required this.orderPlaced,
    required this.deliveryCharge,
    required this.user,
    required this.products,
    required this.invoiceUrl,
  });
  late final int id;
  late final String orderCode;
  late final double amount;
  late final String orderStatus;
  late final String paymentStatus;
  late final String paymentMethod;
  late final String estimatedDeliveryDate;
  late final String? pickupDate;
  late final String? deliveryDate;
  late final String orderPlaced;
  late final double deliveryCharge;
  late final SellerUser user; // Renamed
  late final List<SellerProducts> products; // Renamed
  late final SellerRider? rider; // Renamed
  late final String invoiceUrl;

  SellerOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderCode = json['order_code'];
    amount = json['amount'].toDouble();
    orderStatus = json['order_status'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    estimatedDeliveryDate = json['estimated_delivery_date'];
    pickupDate = json['pickup_date'];
    deliveryDate = json['delivery_date'] ?? '';
    orderPlaced = json['order_placed'];
    deliveryCharge = json['delivery_charge'].toDouble();
    user = SellerUser.fromJson(json['user']);
    rider = json['rider'] != null ? SellerRider.fromJson(json['rider']) : null;
    products =
        List.from(json['products']).map((e) => SellerProducts.fromJson(e)).toList();
    invoiceUrl = json['invoice_url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['order_code'] = orderCode;
    data['amount'] = amount;
    data['order_status'] = orderStatus;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['estimated_delivery_date'] = estimatedDeliveryDate;
    data['pickup_date'] = pickupDate;
    data['delivery_date'] = deliveryDate;
    data['order_placed'] = orderPlaced;
    data['delivery_charge'] = deliveryCharge;
    data['user'] = user.toJson();
    data['products'] = products.map((e) => e.toJson()).toList();
    data['invoice_url'] = invoiceUrl;
    return data;
  }
}

class SellerUser {
  SellerUser({
    required this.name,
    required this.phone,
    required this.profilePhoto,
    required this.address,
  });
  late final String name;
  late final String phone;
  late final String profilePhoto;
  late final SellerAddress address; // Renamed

  SellerUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    profilePhoto = json['profile_photo'];
    address = SellerAddress.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['profile_photo'] = profilePhoto;
    data['address'] = address.toJson();
    return data;
  }
}

class SellerAddress {
  SellerAddress({
    required this.id,
    required this.name,
    required this.phone,
    required this.area,
    required this.flatNo,
    required this.addressType,
    required this.addressLine,
    required this.addressLine2,
    required this.postCode,
    required this.isDefault,
    this.langitude,
    required this.latitude,
  });
  late final int id;
  late final String? name;
  late final String? phone;
  late final String? area;
  late final String? flatNo;
  late final String? addressType;
  late final String? addressLine;
  late final String? addressLine2;
  late final String? postCode;
  late final bool isDefault;
  late final String? langitude;
  late final String? latitude;

  SellerAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    area = json['area'];
    flatNo = json['flat_no'] ?? '';
    addressType = json['address_type'] ?? '';
    addressLine = json['address_line'] ?? '';
    addressLine2 = json['address_line2'] ?? '';
    postCode = json['post_code'] ?? '';
    isDefault = json['is_default'] ?? false;
    langitude = json['langitude'] ?? '';
    latitude = json['latitude'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['area'] = area;
    data['flat_no'] = flatNo;
    data['address_type'] = addressType;
    data['address_line'] = addressLine;
    data['address_line2'] = addressLine2;
    data['post_code'] = postCode;
    data['is_default'] = isDefault;
    data['langitude'] = langitude;
    data['latitude'] = latitude;
    return data;
  }
}

class SellerProducts {
  SellerProducts({
    required this.id,
    required this.name,
    required this.brand,
    required this.thumbnail,
    required this.price,
    required this.quantity,
    required this.color,
    required this.size,
    this.unit,
  });
  late final int id;
  late final String name;
  late final String brand;
  late final String thumbnail;
  late final double? price;
  late final int quantity;
  late final String? color;
  late final String? size;
  late final String? unit;

  SellerProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    brand = json['brand'] ?? '';
    thumbnail = json['thumbnail'];
    price = json['price'].toDouble() ?? 0.0;
    quantity = json['quantity'];
    color = json['color'];
    size = json['size'];
    unit = json['unit'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['brand'] = brand;
    data['thumbnail'] = thumbnail;
    data['price'] = price;
    data['quantity'] = quantity;
    data['color'] = color;
    data['size'] = size;
    data['unit'] = unit;
    return data;
  }
}

class SellerRider {
  SellerRider({
    required this.id,
    required this.name,
    required this.phone,
    required this.profilePhoto,
    required this.assignedAt,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String profilePhoto;
  late final String assignedAt;

  SellerRider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    profilePhoto = json['profile_photo'];
    assignedAt = json['assigned_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['profile_photo'] = profilePhoto;
    data['assigned_at'] = assignedAt;
    return data;
  }
}