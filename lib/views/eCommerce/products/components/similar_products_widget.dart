import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/models/eCommerce/category/category.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart'
    hide Product;
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class SimilarProductsWidget extends ConsumerWidget {
  final ProductDetails productDetails;
  const SimilarProductsWidget({
    super.key,
    required this.productDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (productDetails.relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Related Products',
              style: AppTextStyle(context).subTitle,
            ),
            InkWell(
              onTap: () {
                context.nav.pushNamed(
                  Routes.getProductsViewRouteName(
                    AppConstants.appServiceName,
                  ),
                  arguments: [
                    null, // categoryId
                    'All Product',
                    null, // sortType
                    null, // subCategoryId
                    null, // shopName
                    <SubCategory>[],
                  ],
                );
              },
              child: Text(
                'View All >',
                style: TextStyle(
                  color: const Color(0xFFFF5722),
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
        Gap(14.h),
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: productDetails.relatedProducts.length,
            separatorBuilder: (_, __) => Gap(12.w),
            itemBuilder: (context, index) {
              final product = productDetails.relatedProducts[index];
              return _RelatedProductTile(product: product);
            },
          ),
        ),
      ],
    );
  }
}

class _RelatedProductTile extends ConsumerWidget {
  final Product product;
  const _RelatedProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDiscount = product.discountPercentage > 0 ||
        (product.discountPrice > 0 && product.discountPrice < product.price);
    final currentPrice =
        product.discountPrice > 0 ? product.discountPrice : product.price;

    return GestureDetector(
      onTap: () {
        context.nav.popAndPushNamed(
          Routes.getProductDetailsRouteName(AppConstants.appServiceName),
          arguments: product.id,
        );
      },
      child: Container(
        width: 148.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 110.h,
                  width: 148.w,
                  color: const Color(0xFFF5F5F5),
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${product.discountPercentage.toInt()}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    GlobalFunction.price(
                      ref: ref,
                      price: currentPrice.toString(),
                    ),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF5722),
                    ),
                  ),
                  if (hasDiscount) ...[
                    Gap(2.h),
                    Text(
                      GlobalFunction.price(
                        ref: ref,
                        price: product.price.toString(),
                      ),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
