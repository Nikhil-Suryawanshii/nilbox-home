import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/add_to_cart_bottom_sheet.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

import '../../../../components/ecommerce/confirmation_dialog.dart';
import '../../../../controllers/eCommerce/product/product_controller.dart';
import '../../../../models/eCommerce/product/product.dart';
import '../../../../routes.dart';
import '../../../../services/common/hive_service_provider.dart';
import '../../../../utils/context_less_navigation.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final void Function()? onTap;
//
//   const ProductCard({
//     super.key,
//     required this.product,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0.r),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8.0.r),
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.0.r),
//             color: Theme.of(context).scaffoldBackgroundColor,
//             boxShadow: [
//               BoxShadow(
//                 color: colors(context).accentColor!,
//                 offset: const Offset(0, 2),
//                 blurRadius: 10,
//                 spreadRadius: 0,
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildProductImage(context: context),
//               // Expanded(
//               //   child: _buildProductInformation(context: context),
//               // ),
//               _buildProductInformation(context: context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductImage({required BuildContext context}) {
//     return Stack(
//       children: [
//         SizedBox(
//           height: 120.h,
//           width: double.infinity,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(5.r),
//             child: CachedNetworkImage(
//               imageUrl: product.thumbnail,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         if (product.discountPercentage != 0)
//           _buildDiscountBadge(context: context),
//         if (product.quantity == 0) ...[
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.r),
//                 color: Colors.black.withOpacity(0.6),
//               ),
//               child: Center(
//                 child: Text(
//                   'Out of Stock',
//                   style: AppTextStyle(context).subTitle.copyWith(
//                         color: colors(context).light,
//                       ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildDiscountBadge({required BuildContext context}) {
//     return Positioned(
//       top: 0,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.r),
//           color: EcommerceAppColor.red,
//         ),
//         child: Text(
//           '-${product.discountPercentage}%',
//           style: AppTextStyle(context).bodyTextSmall.copyWith(
//                 color: colors(context).light,
//                 fontWeight: FontWeight.w700,
//               ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductInformation({required BuildContext context}) {
//     return Stack(
//       children: [
//         SizedBox(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Gap(5.h),
//               Text(
//                 '${product.name}\n',
//                 style: AppTextStyle(context)
//                     .bodyText
//                     .copyWith(fontWeight: FontWeight.w500),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Gap(10.h),
//               _buildReviewAndSoldCount(context: context),
//               Gap(product.discountPrice > 0 ? 8.h : 10.h),
//               _buildPriceAndAddToCart(context: context),
//             ],
//           ),
//         ),
//         if (product.quantity == 0 || product.quantity < 0)
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: colors(context).accentColor!.withOpacity(0.4),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildReviewAndSoldCount({required BuildContext context}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.star_rounded,
//               size: 16.sp,
//               color: EcommerceAppColor.carrotOrange,
//             ),
//             Text(
//               product.rating.toString(),
//               style: AppTextStyle(context).bodyTextSmall.copyWith(
//                     fontWeight: FontWeight.w700,
//                   ),
//             ),
//             Gap(5.w),
//             Text(
//               '(${product.totalReviews})',
//               style: AppTextStyle(context).bodyTextSmall.copyWith(
//                     fontWeight: FontWeight.w500,
//                   ),
//             )
//           ],
//         ),
//         CircleAvatar(
//           radius: 2.5,
//           backgroundColor: EcommerceAppColor.lightGray.withOpacity(0.3),
//         ),
//         Text(
//           '${product.totalSold} Sold',
//           style: AppTextStyle(context).bodyTextSmall.copyWith(
//                 fontWeight: FontWeight.w500,
//               ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPriceAndAddToCart({required BuildContext context}) {
//     return Consumer(builder: (context, ref, _) {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               if (product.discountPrice > 0) ...[
//                 Text(
//                   GlobalFunction.price(
//                     ref: ref,
//                     price: product.discountPrice.toString(),
//                   ),
//                   style: AppTextStyle(context)
//                       .bodyText
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ] else ...[
//                 Text(
//                   GlobalFunction.price(
//                     ref: ref,
//                     price: product.price.toString(),
//                   ),
//                   style: AppTextStyle(context)
//                       .bodyText
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ],
//               if (product.discountPrice > 0) ...[
//                 Text(
//                   GlobalFunction.price(
//                     ref: ref,
//                     price: product.price.toString(),
//                   ),
//                   style: AppTextStyle(context).bodyText.copyWith(
//                         color: EcommerceAppColor.lightGray,
//                         decoration: TextDecoration.lineThrough,
//                         decorationColor: EcommerceAppColor.lightGray,
//                       ),
//                 ),
//               ]
//             ],
//           ),
//           IncrementButton(
//             onTap: () {
//               ref.refresh(selectedProductSizeIndex.notifier).state;
//               ref.refresh(selectedProductColorIndex.notifier).state;
//               showModalBottomSheet(
//                 isScrollControlled: true,
//                 isDismissible: false,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.r),
//                 ),
//                 context: context,
//                 builder: (_) => AddToCartBottomSheet(
//                   product: product,
//                 ),
//               );
//             },
//           )
//         ],
//       );
//     });
//   }
// }
class ProductCard extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool isSelected;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.isSelected = false,
  });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {

// class ProductCard extends StatelessWidget {
//   final Product product;
//   final VoidCallback? onTap;
//   final bool isSelected;
//
//   const ProductCard({
//     super.key,
//     required this.product,
//     this.onTap,
//     this.isSelected = false,
//   });

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoriteProvider(widget.product.id));
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 190.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          // border: widget.isSelected ? Border.all(color: Colors.blue, width: 1.5) : null,
          border: isFavorite ? Border.all(color: Color(0xffF27A1A), width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            _buildProductImage(context: context,isFavorite:isFavorite),

            /// CONTENT
            _buildProductInformation(context: context),
            // Padding(
            //   padding: EdgeInsets.all(10.w),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       /// NAME
            //       Text(
            //         product.name,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //         style: AppTextStyle(context)
            //             .bodyText
            //             .copyWith(fontWeight: FontWeight.w600),
            //       ),
            //
            //       Gap(6.h),
            //
            //       /// PRICE + ADD BUTTON
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             GlobalFunction.price(
            //               ref: ref, // not needed here
            //               price: (product.discountPrice > 0
            //                   ? product.discountPrice
            //                   : product.price)
            //                   .toString(),
            //             ),
            //             style: AppTextStyle(context).bodyText.copyWith(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //
            //           /// ADD BUTTON
            //           GestureDetector(
            //             onTap: () {
            //               showModalBottomSheet(
            //                 isScrollControlled: true,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(20.r),
            //                 ),
            //                 context: context,
            //                 builder: (_) =>
            //                     AddToCartBottomSheet(product: product),
            //               );
            //             },
            //             child: Container(
            //               height: 32.h,
            //               width: 32.h,
            //               decoration: const BoxDecoration(
            //                 color: Colors.orange,
            //                 shape: BoxShape.circle,
            //               ),
            //               child: Icon(
            //                 Icons.add,
            //                 size: 18.sp,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage({required BuildContext context,required bool isFavorite}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.product.thumbnail,
            height: 250.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        /// HEART ICON
        Positioned(
          top: 10.h,
          right: 10.w,
          child: CircleAvatar(
            radius: 14.r,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
                      // Optimistic Update (Instant UI change)
                      ref
                          .read(favoriteProvider(widget.product.id).notifier)
                          .toggle();

                      // Server Update
                      ref
                          .read(productControllerProvider.notifier)
                          .favoriteProductAddRemove(
                        productId: widget.product.id,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => ConfirmationDialog(
                          title:
                          'You are unable to favorite products without login!',
                          confirmButtonText: 'Login',
                          onPressed: () {
                            context.nav.pushNamedAndRemoveUntil(
                              Routes.login,
                                  (route) => false,
                            );
                          },
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline_rounded,
                    size: isFavorite ? 20.sp : 19.sp,
                    color: isFavorite
                        ? colors(context).errorColor
                        : colors(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: 10.h,
        //   right: 10.w,
        //   child: CircleAvatar(
        //     radius: 14.r,
        //     backgroundColor: Colors.white,
        //     child: Icon(
        //       Icons.favorite_border,
        //       size: 16.sp,
        //       color: Colors.orange,
        //     ),
        //   ),
        // ),
        // if (product.discountPercentage != 0)
        //   _buildDiscountBadge(context: context),
        if (widget.product.quantity == 0) ...[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Colors.black.withOpacity(0.6),
              ),
              child: Center(
                child: Text(
                  'Out of Stock',
                  style: AppTextStyle(context).subTitle.copyWith(
                        color: colors(context).light,
                      ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDiscountBadge({required BuildContext context}) {
    return Positioned(
      // top: 0,
      top: 46.h,
      right: 10.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: EcommerceAppColor.orange,
        ),
        child: Text(
          '-${widget.product.discountPercentage}%',
          style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: colors(context).light,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }

  Widget _buildProductInformation({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
      child: Stack(
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gap(5.h),
                // Text(
                //   '${product.name}\n',
                //   style: AppTextStyle(context)
                //       .bodyText
                //       .copyWith(fontWeight: FontWeight.w400,fontSize: 12),
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
                Gap(5.h),
                // _buildReviewAndSoldCount(context: context),
                // Gap(product.discountPrice > 0 ? 8.h : 10.h),
                _buildPriceAndAddToCart(context: context),
                Gap(5.h),
              ],
            ),
          ),
          if (widget.product.quantity == 0 || widget.product.quantity < 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: colors(context).accentColor!.withOpacity(0.4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewAndSoldCount({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 16.sp,
              color: EcommerceAppColor.carrotOrange,
            ),
            Text(
              widget.product.rating.toString(),
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Gap(5.w),
            Text(
              '(${widget.product.totalReviews})',
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            )
          ],
        ),
        CircleAvatar(
          radius: 2.5,
          backgroundColor: EcommerceAppColor.lightGray.withOpacity(0.3),
        ),
        Text(
          '${widget.product.totalSold} Sold',
          style: AppTextStyle(context).bodyTextSmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAddToCart({required BuildContext context}) {
    return Consumer(builder: (context, ref, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if (widget.product.discountPrice > 0) ...[
                Text(
                  GlobalFunction.price(
                    ref: ref,
                    price: widget.product.discountPrice.toString(),
                  ),
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.bold,fontSize: 12),
                ),
              ] else ...[
                Text(
                  GlobalFunction.price(
                    ref: ref,
                    price: widget.product.price.toString(),
                  ),
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.bold,fontSize: 12),
                ),
              ],
              // if (product.discountPrice > 0) ...[
              //   Text(
              //     GlobalFunction.price(
              //       ref: ref,
              //       price: product.price.toString(),
              //     ),
              //     style: AppTextStyle(context).bodyText.copyWith(
              //           color: EcommerceAppColor.lightGray,
              //           fontSize: 10,
              //           decoration: TextDecoration.lineThrough,
              //           decorationColor: EcommerceAppColor.lightGray,
              //         ),
              //   ),
              // ]
            ],
          ),
          GestureDetector(
              onTap: () {
                ref.refresh(selectedProductSizeIndex.notifier).state;
                ref.refresh(selectedProductColorIndex.notifier).state;
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  context: context,
                  builder: (_) => AddToCartBottomSheet(
                    product: widget.product,
                  ),
                );
              },
            child: Container(
              // height: 25.h,
              // width: 25.h,
              height: 20.h,
              width: 18.h,
              decoration: const BoxDecoration(
                // color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                    Assets.svg.shoppingBag,
                    // width: 17,
                    // height: 10,
                    // fit: fit,
                    // alignment: alignment,
                    // colorFilter: color != null
                    // ? ColorFilter.mode(color!, BlendMode.srcIn)
                    // : null,
              ),
              // IncrementButton(
              //   iconColor: Colors.white,
              //   onTap: () {
              //     ref.refresh(selectedProductSizeIndex.notifier).state;
              //     ref.refresh(selectedProductColorIndex.notifier).state;
              //     showModalBottomSheet(
              //       isScrollControlled: true,
              //       isDismissible: false,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16.r),
              //       ),
              //       context: context,
              //       builder: (_) => AddToCartBottomSheet(
              //         product: product,
              //       ),
              //     );
              //   },
              // ),
            ),
          )
        ],
      );
    });
  }
}
