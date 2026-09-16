import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/order/order_model.dart';

class ItemCard extends StatelessWidget {
  final SellerProducts product;
  const ItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Product Image
          SizedBox(
            height: 48.h,
            width: 48.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: colors(context).accentColor),
                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          Gap(12.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: style.bodyTextSmall.copyWith(
                    color: colors(context).headingColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(6.h),
                Row(
                  children: [
                    _buildPcsWidget(context),
                    if (product.color != null && product.color!.isNotEmpty) ...[
                      Gap(4.w),
                      _buildAttributeWidget(
                        context,
                        attribute: product.color![0].toUpperCase() +
                            product.color!.substring(1),
                      ),
                    ],
                    if (product.size != null && product.size!.isNotEmpty) ...[
                      Gap(4.w),
                      _buildAttributeWidget(
                        context,
                        attribute: product.size?.toUpperCase(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPcsWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: colors(context).dark,
      ),
      child: Text(
        '${product.quantity} Pcs',
        style: AppTextStyle(context).bodyTextSmall.copyWith(
              fontSize: 10.sp,
              color: colors(context).light,
            ),
      ),
    );
  }

  Widget _buildAttributeWidget(BuildContext context, {required String? attribute}) {
    if (attribute == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: colors(context).dark!.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        attribute,
        style: AppTextStyle(context).bodyTextSmall.copyWith(
              fontSize: 10.sp,
              color: colors(context).bodyTextColor,
            ),
      ),
    );
  }
  final String image =
      'https://cdn1.vectorstock.com/i/1000x1000/06/70/earphones-icon-realistic-style-vector-21880670.jpg';
}

