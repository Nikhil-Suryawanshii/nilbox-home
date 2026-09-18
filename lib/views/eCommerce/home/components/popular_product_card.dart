import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  static const _cardBg = Colors.white;
  static const _titleColor = Color(0xFF212121);
  static const _peachGlow = Color(0xFFFFF0E6);
  static const _accentOrange = Color(0xFFFF5722);

  bool _pressed = false;
  bool _cartPressed = false;

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

  void _onFavoriteTap(BuildContext context) {
    HapticFeedback.lightImpact();
    if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
      ref.read(favoriteProvider(widget.product.id).notifier).toggle();
      ref.read(productControllerProvider.notifier).favoriteProductAddRemove(
            productId: widget.product.id,
          );
    } else {
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: 'You are unable to favorite products without login!',
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
  }

  void _onAddToCartTap() {
    HapticFeedback.lightImpact();
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
  }

  @override
  Widget build(BuildContext context) {
    // Now this will reflect the correct state set in initState
    final isFavorite = ref.watch(favoriteProvider(widget.product.id));

    final stagger = (widget.index * 60).ms;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth;
            final isTall = widget.index.isEven;
            final imageAreaHeight = cardWidth * (isTall ? 1.12 : 1.0);
            final glowSize = cardWidth * 0.9;
            final imageHeight = cardWidth * (isTall ? 0.98 : 0.86);

            return Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 18.h),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_pressed ? 0.03 : 0.05),
                    blurRadius: _pressed ? 12 : 20,
                    offset: Offset(0, _pressed ? 3 : 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: imageAreaHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: glowSize,
                          height: glowSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: _peachGlow,
                          ),
                        ),
                        Positioned(
                          bottom: imageAreaHeight * 0.06,
                          child: Container(
                            width: cardWidth * 0.48,
                            height: 10.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ),
                        ),
                        AnimatedScale(
                          scale: _pressed ? 0.98 : 1,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOutCubic,
                          child: CachedNetworkImage(
                            imageUrl: widget.product.thumbnail,
                            width: cardWidth - 4.w,
                            height: imageHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onFavoriteTap(context),
                              customBorder: const CircleBorder(),
                              child: Container(
                                width: 34.w,
                                height: 34.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _accentOrange.withOpacity(0.35),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _accentOrange.withOpacity(0.22),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border_rounded,
                                  size: 17.sp,
                                  color: _accentOrange,
                                )
                                    .animate(
                                      key: ValueKey(
                                        'fav-${widget.product.id}-$isFavorite',
                                      ),
                                    )
                                    .scale(
                                      begin: const Offset(0.6, 0.6),
                                      end: const Offset(1, 1),
                                      duration: 450.ms,
                                      curve: Curves.elasticOut,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.product.discountPrice > 0)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/png/discount_logo.png',
                                  height: 44.h,
                                  fit: BoxFit.contain,
                                ),
                                Transform.rotate(
                                  angle: 0.6,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 5.w, top: 4.h),
                                    child: Text(
                                      '${widget.product.discountPercentage.toInt()}%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyText.copyWith(
                          color: _titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          letterSpacing: 0.2,
                        ),
                  ),
                  Gap(14.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          GlobalFunction.price(
                            ref: ref,
                            price: (widget.product.discountPrice > 0
                                    ? widget.product.discountPrice
                                    : widget.product.price)
                                .toString(),
                          ),
                          style: AppTextStyle(context).bodyText.copyWith(
                                color: _accentOrange,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => setState(() => _cartPressed = true),
                        onTapUp: (_) => setState(() => _cartPressed = false),
                        onTapCancel: () => setState(() => _cartPressed = false),
                        onTap: _onAddToCartTap,
                        child: AnimatedScale(
                          scale: _cartPressed ? 0.88 : 1,
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOutBack,
                          child: SizedBox(
                            width: 52.w,
                            height: 52.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 52.w,
                                  height: 52.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _peachGlow,
                                  ),
                                ),
                                Container(
                                  width: 42.w,
                                  height: 42.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _accentOrange,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _accentOrange.withOpacity(0.4),
                                        blurRadius: 14,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      Assets.svg.shoppingBag,
                                      height: 20.h,
                                      width: 20.w,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: stagger)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 420.ms,
          delay: stagger,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          duration: 420.ms,
          delay: stagger,
          curve: Curves.easeOutBack,
        );
  }
}
