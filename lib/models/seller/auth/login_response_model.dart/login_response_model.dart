import 'dart:convert';

import 'data.dart';

class LoginResponseModel {
  String? message;
  Data? data;

  LoginResponseModel({this.message, this.data});

  factory LoginResponseModel.fromMap(Map<String, dynamic> data) {
    return LoginResponseModel(
      message: data['message'] as String?,
      data:
          data['data'] == null
              ? null
              : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginResponseModel].
  factory LoginResponseModel.fromJson(String data) {
    return LoginResponseModel.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [LoginResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
