import 'package:flutter/material.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';

class ProductCardBackground {
  ProductCardBackground._();

  static const palette = <Color>[
    Color(0xFFFFE4EC),
    Color(0xFFDCEEFF),
    Color(0xFFE4F7EC),
    Color(0xFFFFF0E6),
    Color(0xFFF3E8FF),
    Color(0xFFE8F4FD),
  ];

  static Color forProduct(Product product, {int? index}) {
    if (product.colors.isNotEmpty) {
      final pastel = pastelFromHex(product.colors.first.colorCode);
      if (!_isTooNeutral(pastel)) return pastel;
    }

    final key = index ?? product.id;
    return palette[key.abs() % palette.length];
  }

  static Color innerGlow(Color base) {
    return Color.lerp(base, Colors.white, 0.38)!;
  }

  static Color pastelFromHex(String code) {
    final hex = code.replaceAll('#', '');
    if (hex.length != 6) {
      return palette.first;
    }

    final base = Color(int.parse('FF$hex', radix: 16));
    return Color.lerp(base, Colors.white, 0.82)!;
  }

  static bool _isTooNeutral(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.saturation < 0.12 || hsl.lightness > 0.94;
  }
}
