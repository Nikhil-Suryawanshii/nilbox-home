import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_decrement_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/cart_product.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/my_cart/components/gift_bottom_sheet.dart';

import '../../../../controllers/misc/misc_controller.dart';

// class CartProductCard extends ConsumerWidget {
//   final CartProduct product;
//   final bool hasGift;
//   final void Function()? increment;
//   final void Function()? decrement;
//   final bool showIncrementDecrement;
//   const CartProductCard({
//     super.key,
//     required this.product,
//     required this.hasGift,
//     this.increment,
//     this.decrement,
//     this.showIncrementDecrement = true,
//   });
//
//   void _handleGiftTap({
//     required bool isGift,
//     required WidgetRef ref,
//     required int shopId,
//   }) async {
//     await ref.read(cartController.notifier).getAllGifts(shopId: shopId);
//     showModalBottomSheet(
//       context: GlobalFunction.navigatorKey.currentContext!,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => GiftBottomSheet(
//         productId: product.id,
//         gift: product.gift,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: EdgeInsets.only(top: 5.h),
//       child: Material(
//         color: GlobalFunction.getContainerColor(),
//         child: Container(
//           // padding: EdgeInsets.all(14.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           padding: EdgeInsets.symmetric(vertical: 20.h).copyWith(right: 20.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildProductImage(
//                     productImage: product.thumbnail,
//                   ),
//                   Gap(16.w),
//                   _buildProductInfo(
//                     context: context,
//                     product: product,
//                     ref: ref,
//                     showIncrementDecrement: showIncrementDecrement,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductImage({required String productImage}) {
//     return Flexible(
//       flex: 1,
//       child: Container(
//         width: 64.w,
//         height: 64.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.r),
//           image: DecorationImage(
//             image: CachedNetworkImageProvider(
//               productImage,
//               errorListener: (error) => debugPrint(error.toString()),
//             ),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductInfo({
//     required BuildContext context,
//     required CartProduct product,
//     required WidgetRef ref,
//     bool showIncrementDecrement = true,
//   }) {
//     return Flexible(
//       flex: 5,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   product.name,
//                   style: AppTextStyle(context)
//                       .bodyText
//                       .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           Gap(6.h),
//           _buildProductBottomRow(
//             context: context,
//             product: product,
//           ),
//           Gap(8.h),
//           if (showIncrementDecrement)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IncrementDecrementButton(
//                   productQuantity: product.quantity,
//                   increment: increment,
//                   decrement: decrement,
//                 ),
//                 Visibility(
//                   visible: hasGift,
//                   child: _giftWidget(isGifted: product.gift != null, ref: ref),
//                 )
//               ],
//             ),
//           Visibility(
//               visible: product.gift != null,
//               child: _senderReceiverInfoWidget()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProductBottomRow({
//     required BuildContext context,
//     required CartProduct product,
//   }) {
//     return Consumer(builder: (context, ref, _) {
//       return Row(
//         children: [
//           Text(
//             GlobalFunction.price(
//               ref: ref,
//               price: product.discountPrice > 0
//                   ? product.discountPrice.toString()
//                   : product.price.toString(),
//             ),
//             style: AppTextStyle(context).bodyText.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: colors(context).primaryColor,
//                 ),
//           ),
//           Visibility(
//             visible: product.discountPrice > 0,
//             child: Row(
//               children: [
//                 Gap(2.w),
//                 Text(
//                   GlobalFunction.price(
//                     ref: ref,
//                     price: product.price.toString(),
//                   ),
//                   style: AppTextStyle(context).bodyText.copyWith(
//                         fontSize: 12.sp,
//                         color: EcommerceAppColor.lightGray,
//                         decoration: TextDecoration.lineThrough,
//                         decorationColor: EcommerceAppColor.lightGray,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           Gap(8.w),
//           Visibility(
//             visible: product.color != null,
//             child:
//             // Container(
//             //   height: 20.r, // Use .r (radius) for consistent circular dimensions
//             //   width: 20.r,
//             //   decoration: BoxDecoration(
//             //     shape: BoxShape.circle,
//             //     // Added a safety check to handle different hex formats
//             //     color: Color('0xff${product.color.colorCode}'),
//             //     border: Border.all(
//             //       color: Colors.grey.withOpacity(0.2), // Adds definition if the color is white
//             //       width: 0.5,
//             //     ),
//             //   ),
//             // ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 5.w,
//                 vertical: 3.h,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.r),
//                 color: colors(context).accentColor,
//               ),
//               child: Center(
//                 child: Text(
//                   product.color?.name ?? '',
//                   style: AppTextStyle(context).bodyTextSmall.copyWith(),
//                 ),
//               ),
//             ),
//           ),
//           Gap(8.w),
//           Visibility(
//             visible: product.size != null,
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 5.w,
//                 vertical: 3.h,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.r),
//                 color: colors(context).accentColor,
//               ),
//               child: Center(
//                 child: Text(
//                   product.size?.name ?? '',
//                   style: AppTextStyle(context).bodyTextSmall.copyWith(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _giftWidget({required bool isGifted, required WidgetRef ref}) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(5.r),
//       onTap: () => _handleGiftTap(isGift: isGifted, ref: ref, shopId: 1),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.r),
//           border: Border.all(
//             color: isGifted
//                 ? EcommerceAppColor.green
//                 : colors(GlobalFunction.navigatorKey.currentContext)
//                     .primaryColor!
//                     .withOpacity(0.3),
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           children: [
//             SvgPicture.asset(
//               Assets.svg.gift,
//               colorFilter: ColorFilter.mode(
//                 isGifted
//                     ? EcommerceAppColor.green
//                     : colors(GlobalFunction.navigatorKey.currentContext)
//                         .primaryColor!,
//                 BlendMode.srcIn,
//               ),
//             ),
//             Gap(5.w),
//             Text(
//               isGifted ? 'Gifted' : 'Gift',
//               style: AppTextStyle(GlobalFunction.navigatorKey.currentContext!)
//                   .bodyText
//                   .copyWith(fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _senderReceiverInfoWidget() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _senderColumn('Sender', product.gift?.senderName ?? ''),
//           SvgPicture.asset(
//             Assets.svg.arrowRight,
//             colorFilter: ColorFilter.mode(
//                 colors(GlobalFunction.navigatorKey.currentContext!)
//                     .primaryColor!,
//                 BlendMode.srcIn),
//           ),
//           _senderColumn('Receiver', product.gift?.receiverName ?? '',
//               isReceiver: true),
//         ],
//       ),
//     );
//   }
//
//   Column _senderColumn(String senderName, String senderValue,
//       {bool isReceiver = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Gift $senderName',
//           style: AppTextStyle(GlobalFunction.navigatorKey.currentContext!)
//               .bodyTextSmall,
//         ),
//         Text(
//           senderValue,
//           style: AppTextStyle(GlobalFunction.navigatorKey.currentContext!)
//               .bodyTextSmall
//               .copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: isReceiver
//                       ? colors(GlobalFunction.navigatorKey.currentContext!)
//                           .primaryColor
//                       : colors(GlobalFunction.navigatorKey.currentContext!)
//                           .bodyTextColor),
//         ),
//       ],
//     );
//   }
// }

class CartProductCard extends ConsumerWidget {
  final CartProduct product;
  final bool hasGift;
  final void Function()? onDelete;
  final void Function()? increment;
  final void Function()? decrement;
  final bool showIncrementDecrement;
  const CartProductCard({
    super.key,
    required this.product,
    required this.hasGift,
    this.onDelete,
    this.increment,
    this.decrement,
    this.showIncrementDecrement = true,
  });

  // 1. New function to handle delete by setting quantity to 0
  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            "Remove Item",
            style: AppTextStyle(context).bodyText.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          content: Text(
            "Are you sure you want to remove this item from the cart?",
            style: AppTextStyle(context).bodyText.copyWith(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: colors(context).hintTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog

                // 2. LOGIC: Set Quantity to 0 to trigger delete
                // We reuse the existing addToCart method but force quantity 0
                if (onDelete != null) {
                  onDelete!();
                }
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _handleGiftTap({
    required bool isGift,
    required WidgetRef ref,
    required int shopId,
  }) async {
    await ref.read(cartController.notifier).getAllGifts(shopId: shopId);
    showModalBottomSheet(
      context: GlobalFunction.navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GiftBottomSheet(
        productId: product.id,
        gift: product.gift,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Container(
        // padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(9.w), // Adjusted padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(
                  productImage: product.thumbnail,
                ),
                Gap(30.w),
                _buildProductInfo(
                  context: context,
                  product: product,
                  ref: ref,
                  showIncrementDecrement: showIncrementDecrement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage({required String productImage}) {
    return Container(
      width: 105.w, // Increased width for better proportion
      height: 105.h, // Increased height for better proportion
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r), // More rounded corners
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            productImage,
            errorListener: (error) => debugPrint(error.toString()),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductInfo({
    required BuildContext context,
    required CartProduct product,
    required WidgetRef ref,
    bool showIncrementDecrement = true,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // color: Colors.red,
            height: 25,
            // width: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp), // Larger, bolder title
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                // Delete Icon
                SizedBox(
                  height: 25,
                  width: 25,
                  child: IconButton(
                    onPressed: () => _confirmDelete(context,ref),
                    constraints: const BoxConstraints(),

                    // ✅ Keep this to remove internal spacing
                    padding: EdgeInsets.zero,

                    // Optional: Adjusts the ripple effect size to match the small icon
                    splashRadius: 12,
                    icon: SvgPicture.asset(
                      Assets.svg.deleteIcon, // Make sure you have a delete.svg asset
                      colorFilter: ColorFilter.mode(
                        colors(context).bodyTextColor!,
                        BlendMode.srcIn,
                      ),
                      height: 15.h,
                    ),

                    // constraints: const BoxConstraints(),
                    // splashRadius: 10.r,
                  ),
                ),
              ],
            ),
          ),
          Gap(10.h),
          // Attributes: Size and Color
          if (product.size != null)
            Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp),
                  children: [
                    TextSpan(
                      text: 'Size   : ',
                      style: TextStyle(color: colors(context).hintTextColor),
                    ),
                    TextSpan(
                      text: product.size!.name!.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          if (product.color != null)
            RichText(
              text: TextSpan(
                style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp),
                children: [
                  TextSpan(
                    text: 'Color : ',
                    style: TextStyle(color: colors(context).hintTextColor),
                  ),
                  TextSpan(
                    text: product.color!.name!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          Gap(12.h),
          // Bottom Row: Increment/Decrement and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showIncrementDecrement)
                IncrementDecrementButton(
                  productQuantity: product.quantity,
                  increment: increment,
                  decrement: decrement,
                ),
              // Price
              Text(
                GlobalFunction.price(
                  ref: ref,
                  price: product.discountPrice > 0
                      ? product.discountPrice.toString()
                      : product.price.toString(),
                ),
                style: AppTextStyle(context).bodyText.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp, // Larger price font
                  color: colors(context).bodyTextColor, // Using body text color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
