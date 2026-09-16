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
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

import '../../../../components/ecommerce/confirmation_dialog.dart';
import '../../../../controllers/eCommerce/product/product_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../routes.dart';
import '../../../../services/common/hive_service_provider.dart';
import '../../../../utils/context_less_navigation.dart';

// class PopularProductCard extends ConsumerWidget {
//   final Product product;
//   final void Function()? onTap;
//   const PopularProductCard({
//     super.key,
//     required this.product,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: EdgeInsets.only(right: 10.w),
//       child: Material(
//         borderRadius: BorderRadius.circular(8.0.r),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(8.0.r),
//           onTap: onTap,
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 5.w),
//             padding: EdgeInsets.symmetric(
//               horizontal: 12.w,
//             ).copyWith(top: 12.h),
//             width: 220.w,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.0.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Flexible(
//                   flex: 6,
//                   fit: FlexFit.tight,
//                   child: Stack(
//                     children: [
//                       SizedBox(
//                         width: double.infinity,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(5.r),
//                           child: CachedNetworkImage(
//                             imageUrl: product.thumbnail,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                       if (product.discountPercentage != 0)
//                         Positioned(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 2.w, vertical: 1.h),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.r),
//                               color: EcommerceAppColor.red,
//                             ),
//                             child: Text(
//                               '-${product.discountPercentage}%',
//                               style:
//                                   AppTextStyle(context).bodyTextSmall.copyWith(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w700,
//                                         color: colors(context).light,
//                                       ),
//                             ),
//                           ),
//                         ),
//                       if (product.quantity == 0) ...[
//                         Positioned.fill(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5.r),
//                               color: Colors.black.withOpacity(0.6),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Out of Stock',
//                                 style: AppTextStyle(context).subTitle.copyWith(
//                                       color: colors(context).light,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                   flex: 5,
//                   fit: FlexFit.tight,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Gap(5.h),
//                       Text(
//                         "${product.name}\n",
//                         style: AppTextStyle(context)
//                             .bodyText
//                             .copyWith(fontWeight: FontWeight.w500),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Gap(10.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.star_rounded,
//                                 size: 16.sp,
//                                 color: EcommerceAppColor.carrotOrange,
//                               ),
//                               Text(
//                                 product.rating.toString(),
//                                 style: AppTextStyle(context)
//                                     .bodyTextSmall
//                                     .copyWith(
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 12.sp),
//                               ),
//                               Gap(5.w),
//                               Text(
//                                 '(${product.totalReviews})',
//                                 style: AppTextStyle(context)
//                                     .bodyTextSmall
//                                     .copyWith(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w500),
//                               )
//                             ],
//                           ),
//                           CircleAvatar(
//                             radius: 2.5,
//                             backgroundColor:
//                                 EcommerceAppColor.lightGray.withOpacity(0.3),
//                           ),
//                           Text(
//                             '${product.totalSold} Sold',
//                             style: AppTextStyle(context).bodyTextSmall.copyWith(
//                                 fontWeight: FontWeight.w500, fontSize: 12.sp),
//                           )
//                         ],
//                       ),
//                       const Spacer(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               if (product.discountPrice > 0) ...[
//                                 Text(
//                                   GlobalFunction.price(
//                                     ref: ref,
//                                     price: product.discountPrice.toString(),
//                                   ),
//                                   style:
//                                       AppTextStyle(context).bodyText.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                 ),
//                               ] else ...[
//                                 Text(
//                                   GlobalFunction.price(
//                                     ref: ref,
//                                     price: product.price.toString(),
//                                   ),
//                                   style:
//                                       AppTextStyle(context).bodyText.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                 ),
//                               ],
//                               Visibility(
//                                 visible: product.discountPrice > 0,
//                                 child: Text(
//                                   GlobalFunction.price(
//                                     ref: ref,
//                                     price: product.price.toString(),
//                                   ),
//                                   style: AppTextStyle(context)
//                                       .bodyText
//                                       .copyWith(
//                                         color: EcommerceAppColor.lightGray,
//                                         decoration: TextDecoration.lineThrough,
//                                         decorationColor:
//                                             EcommerceAppColor.lightGray,
//                                         fontSize: 12.sp,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           IncrementButton(
//                             onTap: () {
//                               ref
//                                   .refresh(selectedProductColorIndex.notifier)
//                                   .state;
//                               ref
//                                   .refresh(selectedProductSizeIndex.notifier)
//                                   .state;
//                               showModalBottomSheet(
//                                 isScrollControlled: true,
//                                 isDismissible: false,
//                                 barrierColor: colors(context)
//                                     .accentColor!
//                                     .withOpacity(0.8),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(16.r),
//                                 ),
//                                 context: context,
//                                 builder: (_) => AddToCartBottomSheet(
//                                   product: product,
//                                 ),
//                               );
//                             },
//                           )
//                         ],
//                       ),
//                       Gap(product.discountPrice > 0 ? 10.h : 12),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
///
// class PopularProductCard extends ConsumerWidget {
//   final Product product;
//   final VoidCallback? onTap;
//   // final bool isFavorite ;
//
//   const PopularProductCard({
//     super.key,
//     required this.product,
//     this.onTap,
//     // this.isFavorite = true,
//   });
//
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isFavorite = ref.watch(favoriteProvider(product.id));
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 190.w,
//         margin: EdgeInsets.only(right: 0.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// IMAGE
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(20.r),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: product.thumbnail,
//                     height: 250.h,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//
//                 /// FAVORITE ICON
//                 // Positioned(
//                 //   top: 12.h,
//                 //   right: 12.w,
//                 //   child: CircleAvatar(
//                 //     radius: 16.r,
//                 //     backgroundColor: Colors.white,
//                 //     child:
//                 //
//                 //     Icon(
//                 //       Icons.favorite_border,
//                 //       size: 18.sp,
//                 //       color: Colors.orange,
//                 //     ),
//                 //     //   AnimatedSize(
//                 //     //     duration: const Duration(milliseconds: 250),
//                 //     //     child: IconButton(
//                 //     //       padding: EdgeInsets.zero,
//                 //     //       visualDensity: VisualDensity.compact,
//                 //     //       onPressed: () {
//                 //     //         if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                 //     //           // setState(() {
//                 //     //             isFavorite = !isFavorite;
//                 //     //
//                 //     //           // });
//                 //     //           ref
//                 //     //               .read(productControllerProvider.notifier)
//                 //     //               .favoriteProductAddRemove(
//                 //     //             productId: product.id,
//                 //     //           );
//                 //     //         } else {
//                 //     //           showDialog(
//                 //     //               context: context,
//                 //     //               builder: (_) => ConfirmationDialog(
//                 //     //                 title:
//                 //     //                 'You are unable to favorite products without login!',
//                 //     //                 confirmButtonText: 'Login',
//                 //     //                 onPressed: () {
//                 //     //                   context.nav.pushNamedAndRemoveUntil(
//                 //     //                       Routes.login, (route) => false);
//                 //     //                 },
//                 //     //               ));
//                 //     //         }
//                 //     //       },
//                 //     //       icon: Icon(
//                 //     //         isFavorite ? Icons.favorite : Icons.favorite_outline_rounded,
//                 //     //         size: isFavorite ? 31.sp : 30.sp,
//                 //     //         color: isFavorite
//                 //     //             ? colors(context).errorColor
//                 //     //             : colors(context).bodyTextSmallColor,
//                 //     //       ),
//                 //     //     ),
//                 //     //   )
//                 //   ),
//                 // ),
//                 Positioned(
//                   top: 12.h,
//                   right: 12.w,
//                   child: CircleAvatar(
//                     radius: 14.r,
//                     backgroundColor: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 3),
//                       child: AnimatedSize(
//                         duration: const Duration(milliseconds: 250),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           visualDensity: VisualDensity.compact,
//                           onPressed: () {
//                             if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                               ref
//                                   .read(favoriteProvider(product.id).notifier)
//                                   .toggle();
//
//                               ref
//                                   .read(productControllerProvider.notifier)
//                                   .favoriteProductAddRemove(
//                                 productId: product.id,
//                               );
//                             } else {
//                               showDialog(
//                                 context: context,
//                                 builder: (_) => ConfirmationDialog(
//                                   title:
//                                   'You are unable to favorite products without login!',
//                                   confirmButtonText: 'Login',
//                                   onPressed: () {
//                                     context.nav.pushNamedAndRemoveUntil(
//                                       Routes.login,
//                                           (route) => false,
//                                     );
//                                   },
//                                 ),
//                               );
//                             }
//                           },
//                           icon: Icon(
//                             isFavorite ? Icons.favorite : Icons.favorite_outline_rounded,
//                             size: isFavorite ? 20.sp : 19.sp,
//                             color: isFavorite
//                                 ? colors(context).errorColor
//                                 : colors(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 /// DISCOUNT BADGE
//                 // if (product.discountPercentage > 0)
//                 //   Positioned(
//                 //     top: 48.h,
//                 //     right: 5.w,
//                 //     child: Container(
//                 //       padding: EdgeInsets.symmetric(
//                 //           horizontal: 7.w, vertical: 4.h),
//                 //       decoration: BoxDecoration(
//                 //         color: Colors.orange,
//                 //         borderRadius: BorderRadius.circular(5.r),
//                 //       ),
//                 //       child: RichText(
//                 //         textAlign: TextAlign.center,
//                 //         text: TextSpan(
//                 //           children: [
//                 //             TextSpan(
//                 //               text: '${product.discountPercentage}%\n',
//                 //               style: TextStyle(
//                 //                 color: Colors.white,
//                 //                 fontSize: 11.sp,
//                 //                 fontWeight: FontWeight.w700,
//                 //               ),
//                 //             ),
//                 //             TextSpan(
//                 //               text: 'Discount',
//                 //               style: TextStyle(
//                 //                 color: Colors.white,
//                 //                 fontSize: 8.sp,
//                 //                 fontWeight: FontWeight.w500,
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //
//                 //     ),
//                 //   ),
//               ],
//             ),
//
//             /// CONTENT
//             Padding(
//               padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// NAME
//                   Text(
//                     product.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTextStyle(context)
//                         .bodyText
//                         .copyWith(fontWeight: FontWeight.w400,fontSize: 12),
//                   ),
//
//                   Gap(5.h),
//                   /// REVIEW + SOLD
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     Row(
//                   //       children: [
//                   //         Icon(
//                   //           Icons.star_rounded,
//                   //           size: 16.sp,
//                   //           color: EcommerceAppColor.carrotOrange,
//                   //         ),
//                   //         Text(
//                   //           product.rating.toString(),
//                   //           style: AppTextStyle(context)
//                   //               .bodyTextSmall
//                   //               .copyWith(
//                   //               fontWeight: FontWeight.w700,
//                   //               fontSize: 12.sp),
//                   //         ),
//                   //         Gap(5.w),
//                   //         Text(
//                   //           '(${product.totalReviews})',
//                   //           style: AppTextStyle(context)
//                   //               .bodyTextSmall
//                   //               .copyWith(
//                   //               fontSize: 12.sp,
//                   //               fontWeight: FontWeight.w500),
//                   //         )
//                   //       ],
//                   //     ),
//                   //     CircleAvatar(
//                   //       radius: 2.5,
//                   //       backgroundColor:
//                   //       EcommerceAppColor.lightGray.withOpacity(0.3),
//                   //     ),
//                   //     Text(
//                   //       '${product.totalSold} Sold',
//                   //       style: AppTextStyle(context).bodyTextSmall.copyWith(
//                   //           fontWeight: FontWeight.w500, fontSize: 12.sp),
//                   //     )
//                   //   ],
//                   // ),
//                   // Gap(6.h),
//                   /// PRICE + ADD BUTTON
//                   ///
//                   Row(
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         GlobalFunction.price(
//                           ref: ref,
//                           price: (product.discountPrice > 0
//                               ? product.discountPrice
//                               : product.price)
//                               .toString(),
//                         ),
//                         style: AppTextStyle(context).bodyText.copyWith(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12
//                         ),
//                       ),
//                       Gap(10.w),
//                       if (product.discountPrice > 0) ...[
//                         Text(
//                           GlobalFunction.price(
//                             ref: ref,
//                             price: product.price.toString(),
//                           ),
//                           style: AppTextStyle(context).bodyText.copyWith(
//                                 color: EcommerceAppColor.lightGray,
//                                 fontSize: 10,
//                                 decoration: TextDecoration.lineThrough,
//                                 decorationColor: EcommerceAppColor.lightGray,
//                               ),
//                         ),
//                       ]
//                     ],
//                   ),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     Text(
//                   //       GlobalFunction.price(
//                   //         ref: ref,
//                   //         price: (product.discountPrice > 0
//                   //             ? product.discountPrice
//                   //             : product.price)
//                   //             .toString(),
//                   //       ),
//                   //       style: AppTextStyle(context).bodyText.copyWith(
//                   //         fontWeight: FontWeight.bold,
//                   //           fontSize: 12
//                   //       ),
//                   //     ),
//                   //
//                   //     /// ADD BUTTON
//                   //     GestureDetector(
//                   //       onTap: () {
//                   //         ref.refresh(
//                   //             selectedProductColorIndex.notifier).state;
//                   //         ref.refresh(
//                   //             selectedProductSizeIndex.notifier).state;
//                   //
//                   //         showModalBottomSheet(
//                   //           isScrollControlled: true,
//                   //           shape: RoundedRectangleBorder(
//                   //             borderRadius: BorderRadius.circular(20.r),
//                   //           ),
//                   //           context: context,
//                   //           builder: (_) =>
//                   //               AddToCartBottomSheet(product: product),
//                   //         );
//                   //       },
//                   //       child: Container(
//                   //         height: 25.h,
//                   //         width: 25.h,
//                   //         decoration: const BoxDecoration(
//                   //           color: Colors.orange,
//                   //           shape: BoxShape.circle,
//                   //         ),
//                   //         child: Icon(
//                   //           Icons.add,
//                   //           color: Colors.white,
//                   //           size: 20.sp,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class PopularProductCard extends ConsumerStatefulWidget {
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
  ConsumerState<PopularProductCard> createState() => _PopularProductCardState();
}

class _PopularProductCardState extends ConsumerState<PopularProductCard> {

  // 👇 2. THE FIX: Sync API data with Provider Data
  @override
  void initState() {
    super.initState();
    // We use addPostFrameCallback to ensure the provider is ready
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Check if user is logged in first (optional, but good practice)
    //   final isLoggedIn = ref.read(hiveServiceProvider).userIsLoggedIn();
    //
    //   if (isLoggedIn) {
    //     // 👇 CHECK YOUR MODEL: Ensure 'widget.product.isFavorite' exists.
    //     // If your API uses 1/0, use: widget.product.isFavorite == 1
    //     final bool apiStatus = widget.product.isFavorite ?? false;
    //
    //     // Force the provider to match the API data
    //     ref.read(favoriteProvider(widget.product.id).notifier).state = apiStatus;
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // ✅ IMPORTANT FIX

      final isLoggedIn = ref.read(hiveServiceProvider).userIsLoggedIn();

      if (isLoggedIn) {
        final bool apiStatus = widget.product.isFavorite ?? false;

        ref.read(favoriteProvider(widget.product.id).notifier).state = apiStatus;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Now this will reflect the correct state set in initState
    final isFavorite = ref.watch(favoriteProvider(widget.product.id));

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 190.w,
        margin: EdgeInsets.only(right: 0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.thumbnail,
                    // height: 250.h,
                    height: widget.index.isEven ? 250.h : 170.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),

                /// FAVORITE ICON
                Positioned(
                  top: 12.h,
                  right: 12.w,
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
                //   top: -0.h,
                //   left: -10.w,
                //   child: AnimatedSize(
                //     duration: const Duration(milliseconds: 250),
                //     child: Stack(
                //       children: [
                //         Image.asset(
                //           'assets/png/discount_logo.png',
                //           height: 45.h,
                //           fit: BoxFit.contain,
                //         ),
                //         Text(widget.product.discountPercentage.toString()),
                //       ],
                //     ),
                //   ),
                // ),
                if (widget.product.discountPrice > 0)Positioned(
                    top: -0.h,
                    left: -10.w,
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// 🔴 DISCOUNT TAG PNG
                        Transform.rotate(
                          angle: 0.0, // tilt like image
                          child: Image.asset(
                            'assets/png/discount_logo.png',
                            height: 50.h,
                            fit: BoxFit.contain,
                          ),
                        ),

                        /// 🏷️ DISCOUNT TEXT
                        Transform.rotate(
                          angle: 0.6, // SAME tilt as image
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w,top: 5),
                            child: Text(
                              '${widget.product.discountPercentage.toInt()}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
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

            /// CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// NAME
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context)
                        .bodyText
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                  ),

                  Gap(5.h),

                  /// PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(30.w),
                      Text(
                        GlobalFunction.price(
                          ref: ref,
                          price: (widget.product.discountPrice > 0
                              ? widget.product.discountPrice
                              : widget.product.price)
                              .toString(),
                        ),
                        style: AppTextStyle(context)
                            .bodyText
                            .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      // Gap(10.w),
                      Gap(20.w),
                      // if (widget.product.discountPrice > 0) ...[
                      //   Text(
                      //     GlobalFunction.price(
                      //       ref: ref,
                      //       price: widget.product.price.toString(),
                      //     ),
                      //     style: AppTextStyle(context).bodyText.copyWith(
                      //       color: EcommerceAppColor.lightGray,
                      //       fontSize: 10,
                      //       decoration: TextDecoration.lineThrough,
                      //       decorationColor: EcommerceAppColor.lightGray,
                      //     ),
                      //   ),
                      // ]

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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
