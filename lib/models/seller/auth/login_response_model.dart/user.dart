import 'dart:convert';

import 'banner.dart';
import 'shop.dart';

class LoginUser {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? profilePhoto;
  String? gender;
  dynamic dateOfBirth;
  bool? isActive;
  String? shopStatus;
  Shop? shop;
  List<Banner>? banners;

  LoginUser({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.profilePhoto,
    this.gender,
    this.dateOfBirth,
    this.isActive,
    this.shopStatus,
    this.shop,
    this.banners,
  });

  factory LoginUser.fromMap(Map<dynamic, dynamic> data) => LoginUser(
    id: data['id'] as int?,
    firstName: data['first_name'] as String?,
    lastName: data['last_name'] as String?,
    phone: data['phone'] as String?,
    email: data['email'] as String?,
    profilePhoto: data['profile_photo'] as String?,
    gender: data['gender'] as String?,
    dateOfBirth: data['date_of_birth'] as dynamic,
    isActive: data['is_active'] as bool?,
    shopStatus: data['shop_status'] as String?,
    shop:
        data['shop'] == null
            ? null
            : Shop.fromMap(data['shop'] as Map<dynamic, dynamic>),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'phone': phone,
    'email': email,
    'profile_photo': profilePhoto,
    'gender': gender,
    'date_of_birth': dateOfBirth,
    'is_active': isActive,
    'shop_status': shopStatus,
    'shop': shop?.toMap(),
    'banners': banners?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginUser].
  factory LoginUser.fromJson(String data) {
    return LoginUser.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginUser] to a JSON string.
  String toJson() => json.encode(toMap());
}
