import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/add_to_cart_bottom_sheet.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/hive_cart_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class FavouriteListProductCard extends ConsumerWidget {

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onTapRemove;

  const FavouriteListProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onTapRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          height: 160.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              /// IMAGE SECTION
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(15.r),
                      right: Radius.circular(15.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail ?? '',
                      width: 130.w,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// PRICE DROP BADGE
                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Price Drop!',
                          style: AppTextStyle(context)
                              .bodyTextSmall
                              .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              /// DETAILS
              Expanded(
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE + DELETE
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle(context)
                                  .bodyText
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          if (onTapRemove != null)
                            GestureDetector(
                              onTap: onTapRemove,
                              behavior: HitTestBehavior.opaque, // Ensures the entire area is tappable
                              child: SvgPicture.asset(
                                Assets.svg.deleteIcon,
                                height: 20.sp,
                                width: 20.sp,
                                colorFilter: const ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcIn,
                                ),
                              ),
                            )
                        ],
                      ),

                      Gap(6.h),

                      /// PRICE
                      Column(
                        children: [
                          if (product.discountPrice > 0)
                            Text(
                              GlobalFunction.price(
                                price: product.price.toString(),
                                ref: ref,
                              ),
                              style: AppTextStyle(context)
                                  .bodyTextSmall
                                  .copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 10
                              ),
                            ),

                          Text(
                            GlobalFunction.price(
                              price: (product.discountPrice > 0
                                  ? product.discountPrice
                                  : product.price)
                                  .toString(),
                              ref: ref,
                            ),
                            style: AppTextStyle(context)
                                .bodyText
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),

                      Gap(5.h),

                      /// SELLER + RATING
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13.r,
                            backgroundColor: Colors.grey.shade200,
                            child: Icon(Icons.store,
                                size: 16.sp, color: Colors.black),
                          ),
                          Gap(8.w),
                          Text(
                            product.shop.name ?? 'Nilbox',
                            style: AppTextStyle(context)
                                .bodyText
                                .copyWith(fontWeight: FontWeight.w600,fontSize: 14),
                          ),
                          const Spacer(),
                          Icon(Icons.star,
                              color: Colors.orange, size: 15.sp),
                          Gap(4.w),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${product.rating} ', // The rating number
                                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold, // Making the rating pop
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '(${product.totalReviews})', // The review count
                                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey, // Making the count subtle
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      const Spacer(),

                      /// ADD TO CART BUTTON
                      SizedBox(
                        width: 189.w,
                        height: 32.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            EcommerceAppColor.carrotOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              builder: (_) =>
                                  AddToCartBottomSheet(product: product),
                            );
                          },
                          child: Text(
                            'ADD TO CART',
                            style: AppTextStyle(context)
                                .bodyText
                                .copyWith(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
