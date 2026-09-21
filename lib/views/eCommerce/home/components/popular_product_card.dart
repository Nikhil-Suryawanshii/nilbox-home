import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';

import 'product_listing_card.dart';

class PopularProductCard extends ConsumerWidget {
  final Product product;
  final int index;
  final VoidCallback? onTap;

  const PopularProductCard({
    super.key,
    required this.product,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagger = (index * 60).ms;

    return ProductListingCard(
      product: product,
      onTap: onTap,
      backgroundIndex: index,
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: stagger)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 420.ms,
          delay: stagger,
          curve: Curves.easeOutCubic,
        );
  }
}
