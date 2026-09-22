// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/app_color.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
// import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';

// class ProductSizePicker extends ConsumerStatefulWidget {
//   final ProductDetails productDetails;
//   const ProductSizePicker({
//     super.key,
//     required this.productDetails,
//   });

//   @override
//   ConsumerState<ProductSizePicker> createState() => _ProductSizePickerState();
// }

// class _ProductSizePickerState extends ConsumerState<ProductSizePicker> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.refresh(selectedProductSizeIndex.notifier).state;
//       ref.read(selectedSizePriceProvider.notifier).state =
//           widget.productDetails.product.productSizeList[0].price;
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       // margin: EdgeInsets.symmetric(horizontal: 20.w),
//       padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.r),
//         color: Colors.transparent,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   // S.of(context).size,
//           //   'Choose size',
//           //   style: AppTextStyle(context)
//           //       .bodyText
//           //       .copyWith(fontWeight: FontWeight.w500, fontSize: 14),
//           // ),
//           // Gap(5.h),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 Wrap(
//                   alignment: WrapAlignment.start,
//                   direction: Axis.horizontal,
//                   children: List.generate(
//                     widget.productDetails.product.productSizeList.length,
//                     (index) => Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 5.w),
//                       child: Material(
//                         color: Theme.of(context).scaffoldBackgroundColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5.r),
//                         ),
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(5.r),
//                           onTap: () {
//                             ref.read(selectedProductSizeIndex.notifier).state =
//                                 index;
//                             ref.read(selectedSizePriceProvider.notifier).state =
//                                 widget.productDetails.product
//                                     .productSizeList[index].price;
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 8.w, vertical: 4.h),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color:
//                                   ref.watch(selectedProductSizeIndex) == index
//                                       ? EcommerceAppColor.primary
//                                       : colors(context).accentColor!,
//                               border: Border.all(
//                                 color:
//                                     ref.watch(selectedProductSizeIndex) == index
//                                         ? EcommerceAppColor.black
//                                         : colors(context).accentColor!,
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 widget.productDetails.product
//                                     .productSizeList[index].name
//                                     .toUpperCase(),
//                                 style: AppTextStyle(context)
//                                     .bodyTextSmall
//                                     .copyWith(
//                                       fontWeight: FontWeight.w500,
//                                       color:
//                                           ref.watch(selectedProductSizeIndex) ==
//                                                   index
//                                               ? EcommerceAppColor.white
//                                               : EcommerceAppColor.gray,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   "asdasd",
//                   style: AppTextStyle(context)
//                       .bodyTextSmall
//                       .copyWith(fontSize: 12.sp),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_transparent_button.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_decrement_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/add_to_cart_model.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/hive_cart_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
///--------just previous------------
// class ProductSizePicker extends ConsumerStatefulWidget {
//   final ProductDetails productDetails;
//   const ProductSizePicker({
//     super.key,
//     required this.productDetails,
//   });
//
//   @override
//   ConsumerState<ProductSizePicker> createState() => _ProductSizePickerState();
// }

// class _ProductSizePickerState extends ConsumerState<ProductSizePicker> {
//   bool _isInitialized = false;
//
//   void onTapCart(ProductDetails productDetails, bool isBuyNow) async {
//     final selectedSizeIndex = ref.read(selectedProductSizeIndex);
//     final selectedColorIndex = ref.read(selectedProductColorIndex);
//
//     final AddToCartModel addToCartModel = AddToCartModel(
//       productId: productDetails.product.id,
//       quantity: 1,
//       size: productDetails.product.productSizeList.isNotEmpty &&
//               selectedSizeIndex != null
//           ? productDetails.product.productSizeList[selectedSizeIndex].id
//           : null,
//       color:
//           productDetails.product.colors.isNotEmpty && selectedColorIndex != null
//               ? productDetails.product.colors[selectedColorIndex].id
//               : null,
//       isBuyNow: isBuyNow,
//     );
//
//     if (!ref.read(hiveServiceProvider).userIsLoggedIn()) {
//       showTheWarningDialog();
//     } else {
//       await ref
//           .read(cartController.notifier)
//           .addToCart(addToCartModel: addToCartModel);
//
//       if (isBuyNow) {
//         context.nav.pushNamed(
//           Routes.getMyCartViewRouteName(
//             AppConstants.appServiceName,
//           ),
//           arguments: [false, isBuyNow],
//         );
//       }
//     }
//   }
//
//   void showTheWarningDialog() {
//     showDialog(
//       barrierColor: colors(context).accentColor!.withOpacity(0.8),
//       context: context,
//       builder: (_) => ConfirmationDialog(
//         title: S.of(context).youAreNotLoggedIn,
//         confirmButtonText: S.of(context).login,
//         onPressed: () {
//           context.nav.pushNamedAndRemoveUntil(Routes.login, (route) => false);
//         },
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize size on first build
//     if (!_isInitialized &&
//         widget.productDetails.product.productSizeList.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           ref.read(selectedProductSizeIndex.notifier).state = 0;
//           ref.read(selectedSizePriceProvider.notifier).state =
//               widget.productDetails.product.productSizeList[0].price;
//         }
//       });
//       _isInitialized = true;
//     }
//
//     return ValueListenableBuilder<Box<HiveCartModel>>(
//       valueListenable:
//           Hive.box<HiveCartModel>(AppConstants.cartModelBox).listenable(),
//       builder: (context, cartBox, _) {
//         bool inCart = false;
//         late int productQuantity;
//         int cartIndex = -1;
//
//         final cartItems = cartBox.values.toList();
//         for (int i = 0; i < cartItems.length; i++) {
//           final cartProduct = cartItems[i];
//           if (cartProduct.productId == widget.productDetails.product.id) {
//             inCart = true;
//             productQuantity = cartProduct.productsQTY;
//             cartIndex = i;
//             break;
//           }
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List.generate(
//                         widget.productDetails.product.productSizeList.length,
//                             (index) {
//                           final bool isSelected =
//                               ref.watch(selectedProductSizeIndex) == index;
//
//                           return Padding(
//                             padding: EdgeInsets.only(right: 10.w),
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(17.r),
//                               onTap: () {
//                                 ref.read(selectedProductSizeIndex.notifier).state = index;
//                                 ref.read(selectedSizePriceProvider.notifier).state =
//                                     widget.productDetails.product.productSizeList[index].price;
//                               },
//                               child: Container(
//                                 width: 47.w,
//                                 height: 39.h,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? Colors.white
//                                       : const Color(0xFFE6E6E6), // light grey
//                                   borderRadius: BorderRadius.circular(17.r),
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? const Color(0xFF9B2CFF) // purple border
//                                         : Colors.transparent,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Text(
//                                   widget.productDetails.product.productSizeList[index].name
//                                       .toUpperCase(),
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: isSelected
//                                         ? const Color(0xFF9B2CFF) // purple text
//                                         : Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 ///--------old design-----------
//                 // Size selection chips
//                 // Expanded(
//                 //   child: SingleChildScrollView(
//                 //     scrollDirection: Axis.horizontal,
//                 //     child: Row(
//                 //       children: List.generate(
//                 //         widget.productDetails.product.productSizeList.length,
//                 //         (index) => Padding(
//                 //           padding: EdgeInsets.only(right: 10.w,left: 2),
//                 //           child: InkWell(
//                 //             borderRadius: BorderRadius.circular(17.r),
//                 //             onTap: () {
//                 //               ref
//                 //                   .read(selectedProductSizeIndex.notifier)
//                 //                   .state = index;
//                 //               ref
//                 //                       .read(selectedSizePriceProvider.notifier)
//                 //                       .state =
//                 //                   widget.productDetails.product
//                 //                       .productSizeList[index].price;
//                 //             },
//                 //             child: Container(
//                 //               padding: EdgeInsets.symmetric(
//                 //                   horizontal: 8.w, vertical: 4.h),
//                 //               decoration: BoxDecoration(
//                 //                 // shape: BoxShape.circle,
//                 //                 borderRadius: BorderRadius.all(Radius.circular(17)),
//                 //                 color:
//                 //                     ref.watch(selectedProductSizeIndex) ==
//                 //                             index
//                 //                         ? EcommerceAppColor.primary
//                 //                         : colors(context).accentColor!,
//                 //                 border: Border.all(
//                 //                   color:
//                 //                       ref.watch(selectedProductSizeIndex) ==
//                 //                               index
//                 //                           ? EcommerceAppColor.black
//                 //                           : colors(context).accentColor!,
//                 //                 ),
//                 //               ),
//                 //               child: Center(
//                 //                 child: Text(
//                 //                   widget.productDetails.product
//                 //                       .productSizeList[index].name
//                 //                       .toUpperCase(),
//                 //                   style: AppTextStyle(context)
//                 //                       .bodyTextSmall
//                 //                       .copyWith(
//                 //                         fontWeight: FontWeight.w500,
//                 //                         color: ref.watch(
//                 //                                     selectedProductSizeIndex) ==
//                 //                                 index
//                 //                             ? EcommerceAppColor.white
//                 //                             : EcommerceAppColor.gray,
//                 //                       ),
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 ///-------------------------------
//                 // // Cart button section
//                 // if (inCart) ...[
//                 //   Container(
//                 //     decoration: BoxDecoration(
//                 //       borderRadius: BorderRadius.circular(19.r),
//                 //       border: Border.all(
//                 //         color: Colors.grey,
//                 //       ),
//                 //     ),
//                 //     child: Padding(
//                 //       padding: const EdgeInsets.all(3.0),
//                 //       child: IncrementDecrementButton(
//                 //         heightIncrement: 20.h,
//                 //         widthIncrement: 20.w,
//                 //         heightDecrement: 20.h,
//                 //         widthDecrement: 20.w,
//                 //         buttonColorIncrement: EcommerceAppColor.carrotOrange,
//                 //         buttonColorDecrement: EcommerceAppColor.white,
//                 //         iconColorIncrement: EcommerceAppColor.white,
//                 //         iconColorDecrement: EcommerceAppColor.black,
//                 //         productQuantity: productQuantity,
//                 //         increment: () {
//                 //           ref.read(cartController.notifier).increment(
//                 //                 productId: widget.productDetails.product.id,
//                 //               );
//                 //         },
//                 //         decrement: () {
//                 //           ref.read(cartController.notifier).decrement(
//                 //                 productId: widget.productDetails.product.id,
//                 //               );
//                 //         },
//                 //       ),
//                 //     ),
//                 //   )
//                 // ] else ...[
//                 //   GestureDetector(
//                 //     onTap: widget.productDetails.product.quantity == 0
//                 //         ? null
//                 //         : () => onTapCart(widget.productDetails, false),
//                 //     child: Container(
//                 //       width: 75.w,
//                 //       height: 75.w,
//                 //       decoration: BoxDecoration(
//                 //         shape: BoxShape.circle,
//                 //         gradient: LinearGradient(
//                 //           begin: Alignment.topCenter,
//                 //           end: Alignment.bottomCenter,
//                 //           colors: widget.productDetails.product.quantity == 0
//                 //               ? [
//                 //                   Colors.grey.shade400,
//                 //                   Colors.grey.shade500,
//                 //                 ]
//                 //               : [
//                 //                   Color(0xFFFFB800),
//                 //                   Color(0xFFFF8C00),
//                 //                 ],
//                 //         ),
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //             color: widget.productDetails.product.quantity == 0
//                 //                 ? Colors.grey.withOpacity(0.3)
//                 //                 : Color(0xFFFF8C00).withOpacity(0.4),
//                 //             blurRadius: 20,
//                 //             offset: Offset(0, 10),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //       padding: EdgeInsets.all(10),
//                 //       child: Column(
//                 //         mainAxisAlignment: MainAxisAlignment.center,
//                 //         children: [
//                 //           Icon(
//                 //             Icons.shopping_cart_outlined,
//                 //             color: Colors.white,
//                 //             size: 24.sp,
//                 //           ),
//                 //           Gap(4.h),
//                 //           Text(
//                 //             S.of(context).addToCart,
//                 //             style: TextStyle(
//                 //               color: Colors.white,
//                 //               fontSize: 8.sp,
//                 //               fontWeight: FontWeight.w600,
//                 //             ),
//                 //             textAlign: TextAlign.center,
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ],
//               ],
//             ),
//             Gap(10.h),
//             // Text(
//             //   "In stock (${widget.productDetails.product.quantity ?? 0} left)",
//             //   style:
//             //       TextStyle(color: EcommerceAppColor.green, fontSize: 12.sp),
//             // ),
//           ],
//         );
//       },
//     );
//   }
// }
///--------just previous------------

class ProductSizePicker extends ConsumerWidget {
  final ProductDetails productDetails;
  const ProductSizePicker({super.key, required this.productDetails});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizes = productDetails.product.productSizeList;
    if (sizes.isEmpty) return const SizedBox.shrink();

    final rawIndex = ref.watch(selectedProductSizeIndex);
    final selectedIndex = rawIndex.clamp(0, sizes.length - 1);
    if (rawIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedProductSizeIndex.notifier).state = selectedIndex;
        ref.read(selectedSizePriceProvider.notifier).state =
            sizes[selectedIndex].price;
      });
    }
    final selectedSizeName = sizes[selectedIndex].name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Size: ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: selectedSizeName,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        Gap(10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              sizes.length,
              (index) {
                final isSelected = selectedIndex == index;
                final size = sizes[index];
                
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedProductSizeIndex.notifier).state = index;
                    ref.read(selectedSizePriceProvider.notifier).state = size.price;
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF5722) : Colors.black12,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      size.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFFFF5722) : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
