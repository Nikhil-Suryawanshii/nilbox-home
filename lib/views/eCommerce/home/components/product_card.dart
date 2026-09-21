import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';

import 'product_listing_card.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool isSelected;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isSelected = false,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductListingCard(
      product: product,
      onTap: onTap,
      backgroundIndex: index,
    );
  }
}
