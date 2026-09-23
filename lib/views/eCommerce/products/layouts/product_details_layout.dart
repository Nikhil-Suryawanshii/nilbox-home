import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_cart.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_transparent_button.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/shop/shop_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/add_to_cart_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_color_picker.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_description.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_details_and_review.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_details_tabs_section.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_image_page_view.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_size_picker.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/shop_info.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/similar_products_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../components/ecommerce/increment_decrement_button.dart';
import '../../../../config/app_color.dart';
import '../../../../config/app_text_style.dart';
import '../../../../controllers/eCommerce/message/message_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../models/eCommerce/category/category.dart';
// import '../../../../models/eCommerce/message_model/shop.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/shop.dart';

import '../../../../models/eCommerce/shop/shop_review.dart';
import '../components/review_card.dart';

class EcommerceProductDetailsLayout extends ConsumerStatefulWidget {
  final int productId;
  const EcommerceProductDetailsLayout({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<EcommerceProductDetailsLayout> createState() =>
      _EcommerceProductDetailsLayoutState();
}

///---1st design figma---
// class _EcommerceProductDetailsLayoutState
//     extends ConsumerState<EcommerceProductDetailsLayout> {
//   bool isTextExpanded = false;
//   bool isFavorite = false;
//   bool isLoading = false;
//
//   bool shippingExpanded = false;
//   bool returnExpanded = false;
//   bool reviewExpanded = false;
//
//   final List<SubCategory> subCategories = [];
//
//   // change the status bar color to transparent
//
//   @override
//   Widget build(BuildContext context) {
//     ref.listen(productDetailsControllerProvider(widget.productId), (previous, next) {
//       next.whenData((details) {
//         // Check if we need to update local state to match server state
//         // Note: Replace 'isFavorite' with the actual field name from your model
//         // (e.g., isWishlist, is_favorite, etc.)
//         if (isFavorite != details.product.isFavorite) {
//           setState(() {
//             isFavorite = details.product.isFavorite;
//           });
//         }
//       });
//     });
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (didpop, result) {
//         ref.invalidate(selectedSizePriceProvider);
//         ref.invalidate(selectedColorPriceProvider);
//       },
//       child: LoadingWrapperWidget(
//         isLoading: ref.watch(cartController).isLoading,
//         child: Scaffold(
//           floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//           floatingActionButton: ref
//               .watch(productDetailsControllerProvider(widget.productId))
//               .whenOrNull(
//             data: (productDetails) =>
//                 _buildPriceFloatingButton(productDetails),
//           ),
//           // appBar: AppBar(
//           //   scrolledUnderElevation: 0,
//           //   automaticallyImplyLeading: false,
//           //   actionsPadding: EdgeInsets.all(0),
//           //   actions: [
//           //     ///--------old app bar-----
//           //     _buildAppBarRightRow(
//           //         context: context,
//           //         productDetails: ref
//           //             .watch(productDetailsControllerProvider(widget.productId))
//           //             .value)
//           //     ///--------old app bar-----
//           //     //     .whenOrNull(
//           //     //   data: (productDetails) => _buildBottomNavigationBar(
//           //     //       context: context, productDetails: productDetails),
//           //     // ),
//           //   ],
//           // ),
//           // backgroundColor: Color(0xffd6d6d6),
//           backgroundColor: Color(0xffffffff),
//           // bottomNavigationBar: ref
//           //     .watch(productDetailsControllerProvider(widget.productId))
//           //     .whenOrNull(
//           //       data: (productDetails) => _buildBottomNavigationBar(
//           //           context: context, productDetails: productDetails),
//           //     ),
//           body: ref
//               .watch(productDetailsControllerProvider(widget.productId))
//               .when(
//                 data: (productDetails) => SingleChildScrollView(
//                   child: AnimationLimiter(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: AnimationConfiguration.toStaggeredList(
//                         duration: const Duration(milliseconds: 500),
//                         childAnimationBuilder: (widget) => SlideAnimation(
//                             verticalOffset: 50.h,
//                             child: FadeInAnimation(
//                               child: widget,
//                             )),
//                         children: [
//                           // Gap(110.h),
//                           ProductImagePageView(productDetails: productDetails),
//                           // Container(
//                           //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
//                           //   decoration: BoxDecoration(
//                           //     borderRadius: BorderRadius.circular(8.r),
//                           //     color: EcommerceAppColor.lightGray,
//                           //     // color: Colors.red,
//                           //   ),
//                           //   alignment: Alignment.bottomCenter,
//                           //   child: Wrap(
//                           //     alignment: WrapAlignment.center,
//                           //     children: List.generate(
//                           //       productDetails.product.thumbnails.length,
//                           //           (index) => AnimatedContainer(
//                           //         duration: const Duration(milliseconds: 300),
//                           //         margin: const EdgeInsets.symmetric(horizontal: 2),
//                           //         decoration: BoxDecoration(
//                           //           color:
//                           //           ref.read(currentPageController.notifier).state == index
//                           //               ? colors(context).light
//                           //               : colors(context).accentColor!.withOpacity(0.5),
//                           //           borderRadius: BorderRadius.circular(30.sp),
//                           //         ),
//                           //         height: 8.h,
//                           //         width: 8.w,
//                           //       ),
//                           //     ).toList(),
//                           //   ),
//                           // ),
//                           ///----------old design------------
//                           // Center(
//                           //   child: Container(
//                           //     padding: EdgeInsets.symmetric(
//                           //         horizontal: 6.w, vertical: 6.h),
//                           //     // decoration: BoxDecoration(
//                           //     //   color: EcommerceAppColor.lightGray
//                           //     //       .withOpacity(0.4),
//                           //     //   borderRadius: BorderRadius.circular(20.r),
//                           //     // ),
//                           //     child: Row(
//                           //       mainAxisSize: MainAxisSize.min,
//                           //       children: List.generate(
//                           //         productDetails.product.thumbnails.length,
//                           //         (index) {
//                           //           final isActive =
//                           //               ref.watch(currentPageController) ==
//                           //                   index;
//                           //
//                           //           return AnimatedContainer(
//                           //             duration:
//                           //                 const Duration(milliseconds: 300),
//                           //             margin:
//                           //                 EdgeInsets.symmetric(horizontal: 4.w),
//                           //             height: 6.w,
//                           //             width: 6.w,
//                           //             decoration: BoxDecoration(
//                           //               shape: BoxShape.circle,
//                           //               color: isActive
//                           //                   ? EcommerceAppColor.primary
//                           //                   // : Color.fromARGB(
//                           //                   //     255, 252, 231, 217),
//                           //                     : Color.fromARGB(
//                           //                       255, 209, 171, 253),
//                           //             ),
//                           //           );
//                           //         },
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                           ///----------------------------------
//                           // Gap(14.h),
//
//                           Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               // MAIN PRODUCT CARD
//                               /// YOUR DESCRIPTION WIDGET
//                               Container(
//                                 // padding: EdgeInsets.fromLTRB(25, 20, 20, 16),
//                                 decoration: BoxDecoration(
//                                   // color: const Color.fromARGB(255, 255, 244, 236),
//                                   color: EcommerceAppColor.white,
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(50),
//                                     topLeft: Radius.circular(50),
//                                   ),
//                                   // gradient: const LinearGradient(
//                                   //   begin: Alignment.topCenter,
//                                   //   end: Alignment.bottomCenter,
//                                   //   colors: [
//                                   //     Color(0xFFE9BCFF), // #E9BCFF
//                                   //     Color(0xFFFFFFFF), // #FFFFFF
//                                   //   ],
//                                   //   stops: [
//                                   //     -0.4114, // -41.14% (CSS → Flutter)
//                                   //     1.0,     // 100%
//                                   //   ],
//                                   // ),
//
//                                   /// 🌫️ BOX SHADOW
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Color(0x26000000), // #00000026
//                                       blurRadius: 50,           // blur = 50px
//                                       spreadRadius: 15,         // spread = 15px
//                                       offset: Offset(0, 0),     // 0px 0px
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.fromLTRB(25, 20, 20, 0),
//                                       decoration: BoxDecoration(
//                                         // color: const Color.fromARGB(255, 255, 244, 236),
//                                         // color: EcommerceAppColor.white,
//                                         borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(50),
//                                           topLeft: Radius.circular(50),
//                                         ),
//                                         gradient: const LinearGradient(
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                           colors: [
//                                             Color(0x49E9BCFF), // #E9BCFF
//                                             Color(0xFFFFFFFF), // #FFFFFF
//                                             Color(0xFFFFFFFF), // #FFFFFF
//                                           ],
//                                           stops: [
//                                             -0.4114, // -41.14% (CSS → Flutter)
//                                             1.0,     // 100%
//                                             1.0,     // 100%
//                                           ],
//                                         ),
//
//                                         /// 🌫️ BOX SHADOW
//                                         boxShadow: const [
//                                           BoxShadow(
//                                             color: Color(0x26000000), // #00000026
//                                             blurRadius: 50,           // blur = 50px
//                                             spreadRadius: 15,         // spread = 15px
//                                             offset: Offset(0, 0),     // 0px 0px
//                                           ),
//                                         ],
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           ProductDescription(
//                                               productDetails: productDetails),
//                                           Gap(10.w),
//                                           Container(
//                                             height: 65.h,
//                                             width: 240,
//                                             padding: EdgeInsets.symmetric(horizontal: 0.w),
//                                             decoration: BoxDecoration(
//                                               color: Colors.transparent,
//                                               borderRadius: BorderRadius.circular(18.r),
//                                               border: Border.all(color: Colors.black12),
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 InkWell(
//                                                   borderRadius: BorderRadius.circular(10.r),
//                                                   onTap: () async {
//                                                     if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                                                       final saveUser =
//                                                       await ref.read(hiveServiceProvider).getUserInfo();
//
//                                                       final shop = Shop(
//                                                         id: productDetails.product.shop.id,
//                                                         name: productDetails.product.shop.name,
//                                                         logo: productDetails.product.shop.logo,
//                                                       );
//
//                                                       ref.read(storeMessageControllerProvider.notifier).storeMessage(
//                                                         shopId: productDetails.product.shop.id,
//                                                         userId: saveUser!.id!,
//                                                         productId: productDetails.product.id,
//                                                       );
//
//                                                       context.nav.pushNamed(
//                                                         Routes.getChatViewRouteName(AppConstants.appServiceName),
//                                                         arguments: shop,
//                                                       );
//                                                     } else {
//                                                       showDialog(
//                                                         context: context,
//                                                         builder: (_) => ConfirmationDialog(
//                                                           title: 'You can\'t send message without login!',
//                                                           confirmButtonText: 'Login',
//                                                           onPressed: () {
//                                                             context.nav.pushNamedAndRemoveUntil(
//                                                                 Routes.login, (route) => false);
//                                                           },
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                   child: Container(
//                                                     width: 64.w,
//                                                     height: 64.h,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(10.r),
//                                                       gradient: const LinearGradient(
//                                                         begin: Alignment.topLeft,
//                                                         end: Alignment.bottomRight,
//                                                         colors: [
//                                                           Color(0xFF8B2CF5),
//                                                           Color(0xFF6A00FF),
//                                                         ],
//                                                       ),
//                                                       boxShadow: [
//                                                         BoxShadow(
//                                                           color: const Color(0xFF6A00FF).withOpacity(0.35),
//                                                           blurRadius: 14,
//                                                           offset: const Offset(0, 8),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     child: Column(
//                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                       children: [
//                                                         SvgPicture.asset(
//                                                           Assets.svg.chat,
//                                                           width: 26.w,
//                                                           colorFilter: const ColorFilter.mode(
//                                                             Colors.white,
//                                                             BlendMode.srcIn,
//                                                           ),
//                                                         ),
//                                                         Gap(4.h),
//                                                         Text(
//                                                           'Chats',
//                                                           style: TextStyle(
//                                                             fontSize: 11.sp,
//                                                             fontWeight: FontWeight.w700,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 // Spacer(),
//                                                 Gap(40.w),
//                                                 CircleAvatar(
//                                                   radius: 20.r,
//                                                   backgroundImage: NetworkImage(
//                                                     productDetails.product.shop.logo,
//                                                   ),
//                                                 ),
//                                                 Gap(12.w),
//                                                 Expanded(
//                                                   child: Text(
//                                                     productDetails.product.shop.name,
//                                                     maxLines: 1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                       fontSize: 14.sp,
//                                                       fontWeight: FontWeight.w600,
//                                                       color: Colors.black,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Gap(18.w),
//                                           Text(
//                                             '...Details',
//                                             maxLines: 1,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                               fontSize: 15.sp,
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xffC5BCFF),
//                                             ),
//                                           ),
//                                           Gap(15.w),
//                                         ],
//                                       ),
//                                     ),
//                                     // ProductDetailsAndReview(
//                                     //   productDetails: productDetails,
//                                     // ),
//
//
//
//                                     Container(
//                                       color: Colors.white,
//                                       child: Padding(
//                                         padding: EdgeInsets.fromLTRB(25, 0, 20, 16),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Description',
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             Gap(5.h),
//                                             AnimatedSize(
//                                               duration: const Duration(milliseconds: 500),
//                                               child: isTextExpanded
//                                                   ? Text(
//                                                 productDetails.product.description,
//                                                 maxLines: 3,
//                                                 style: AppTextStyle(context).bodyTextSmall.copyWith(
//                                                   fontSize: 12.sp,
//                                                 ),
//                                               )
//                                                   : Text(
//                                                 productDetails.product.description,
//                                                 style: AppTextStyle(context)
//                                                     .bodyTextSmall
//                                                     .copyWith(fontSize: 13.sp),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                             Gap(5.h),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   isTextExpanded = !isTextExpanded;
//                                                 });
//                                               },
//                                               child: Text(
//                                                 isTextExpanded ? S.of(context).readLess : S.of(context).readMore,
//                                                 style: AppTextStyle(context).bodyTextSmall.copyWith(
//                                                   color: colors(context).dark,
//                                                   decoration: TextDecoration.underline,
//                                                   fontSize: 12.sp,
//                                                   decorationColor: colors(context).dark,
//                                                 ),
//                                               ),
//                                             ),
//                                             Gap(25.h),
//                                             Column(
//                                               children: [
//                                                 productInfoTile(
//                                                   icon: Icons.local_shipping_outlined,
//                                                   title: "Shipping Information",
//                                                   isExpanded: shippingExpanded,
//                                                   onTap: () {
//                                                     setState(() => shippingExpanded = !shippingExpanded);
//                                                   },
//                                                   content: Text(
//                                                     "Delivered within ${productDetails.product.shop.estimatedDeliveryTime}.\nFree shipping on orders above \$50.",
//                                                     style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
//                                                   ),
//                                                 ),
//
//                                                 Gap(12.h),
//
//                                                 productInfoTile(
//                                                   icon: Icons.assignment_return_outlined,
//                                                   title: "Returns",
//                                                   isExpanded: returnExpanded,
//                                                   onTap: () {
//                                                     setState(() => returnExpanded = !returnExpanded);
//                                                   },
//                                                   content: Text(
//                                                     "Easy 7-day return policy.\nProduct must be unused and in original packaging.",
//                                                     style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
//                                                   ),
//                                                 ),
//
//                                                 Gap(12.h),
//
//                                                 productInfoTile(
//                                                     icon: Icons.chat_bubble_outline,
//                                                     title: "Reviews",
//                                                     isExpanded: reviewExpanded,
//                                                     onTap: () {
//                                                       setState(() => reviewExpanded = !reviewExpanded);
//                                                     },
//                                                     content: _buildReviewListWidget()
//                                                   // Text(
//                                                   //   "⭐ 4.6 rating\nBased on 273 verified reviews.",
//                                                   //   style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
//                                                   // ),
//                                                 ),
//                                                 Gap(20.w),
//                                                 /// PRODUCT CATEGORY
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       "Product Category",
//                                                       style: TextStyle(
//                                                         fontSize: 12.sp,
//                                                         color: Colors.grey,
//                                                         fontWeight: FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                     Gap(10.w),
//                                                     Row(
//                                                       children: [
//                                                         Container(
//                                                           width: 26.w,
//                                                           height: 26.w,
//                                                           decoration: const BoxDecoration(
//                                                             shape: BoxShape.circle,
//                                                             color: Color(0xFFFFD5F1), // light pink background (like image)
//                                                           ),
//                                                           child: Center(
//                                                             child: SvgPicture.asset(
//                                                               Assets.svg.shirt,
//                                                               width: 15.w,
//                                                               height: 15.w,
//                                                               colorFilter: const ColorFilter.mode(
//                                                                 Colors.black, // 🖤 icon color
//                                                                 BlendMode.srcIn,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),                                                Gap(6.w),
//                                                         Text(
//                                                           productDetails.product.brand ?? '',
//                                                           style: TextStyle(
//                                                             fontSize: 12.sp,
//                                                             fontWeight: FontWeight.w600,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//
//                                                 Gap(12.h),
//
//                                                 /// SKU
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       "SKU",
//                                                       style: TextStyle(
//                                                         fontSize: 12.sp,
//                                                         color: Colors.grey,
//                                                         fontWeight: FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                     Gap(10.w),
//                                                     Text(
//                                                       // productDetails.product.,
//                                                       "#234560345",
//                                                       style: TextStyle(
//                                                         fontSize: 13.sp,
//                                                         fontWeight: FontWeight.w600,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//
//                                                 Gap(14.h),
//                                                 Divider(thickness: 0.6,color: Colors.black.withOpacity(0.25)),
//                                               ],
//                                             ),
//
//                                             Gap(15.h),
//                                             SimilarProductsWidget(
//                                               productDetails: productDetails,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                             ///---------------old design--------------------------
//                             //   // 🔴 OFFER RIBBON (PNG)
//                             //   if (productDetails.product.discountPrice > 0)
//                             //   Positioned(
//                             //     top: -60,
//                             //     right: 100,
//                             //     child: Transform.rotate(
//                             //       angle: -0.0, // ribbon tilt (same as before)
//                             //       child: Stack(
//                             //         alignment: Alignment.center,
//                             //         children: [
//                             //           // 🎀 Ribbon PNG
//                             //           Image.asset(
//                             //             Assets.png.productPageBanner.path,
//                             //             height: 160,
//                             //             fit: BoxFit.contain,
//                             //           ),
//                             //
//                             //           // 🔁 ROTATED TEXT (30% OFF)
//                             //           // 🔁 ROTATED TEXT (30% OFF)
//                             //           Positioned(
//                             //             right: 25,
//                             //             top: 62, // Push it down to the straight part of the ribbon
//                             //             child: Transform.rotate(
//                             //               angle: -4.8, // ri // ✅ Rotates exactly 90 degrees clockwise
//                             //               child: Stack(
//                             //                 // mainAxisSize: MainAxisSize.min,
//                             //                 children: [
//                             //                   // Row to put "30" and "%" side-by-side with different sizes
//                             //                   Row(
//                             //                     mainAxisSize: MainAxisSize.min,
//                             //                     crossAxisAlignment: CrossAxisAlignment.start,
//                             //                     children: [
//                             //                       Text(
//                             //                         productDetails.product.discountPercentage.toInt().toString(),
//                             //                         // "30",
//                             //                         style: TextStyle(
//                             //                           color: Colors.white,
//                             //                           fontSize: 19.sp, // Bigger font for the number
//                             //                           fontWeight: FontWeight.bold,
//                             //                           height: 0.9,
//                             //                         ),
//                             //                       ),
//                             //                       Padding(
//                             //                         padding: const EdgeInsets.only(top: 0.0, left: 0),
//                             //                         child: Text(
//                             //                           "%",
//                             //                           style: TextStyle(
//                             //                             color: Colors.white,
//                             //                             fontSize: 16.sp, // Smaller font for %
//                             //                             fontWeight: FontWeight.bold,
//                             //                           ),
//                             //                         ),
//                             //                       ),
//                             //                     ],
//                             //                   ),
//                             //                   // Positioned(
//                             //                   //   top: 12,
//                             //                   //   right: -15,
//                             //                   //   child: Container(
//                             //                   //     // width: 38,
//                             //                   //     decoration: BoxDecoration(
//                             //                   //       color: Colors.red
//                             //                   //     ),
//                             //                   //     child: Text(
//                             //                   //       "OFF",
//                             //                   //       style: TextStyle(
//                             //                   //         color: Colors.white,
//                             //                   //         fontSize: 10.sp,
//                             //                   //         fontWeight: FontWeight.w600,
//                             //                   //         letterSpacing: 1.5, // Spaced out letters
//                             //                   //       ),
//                             //                   //     ),
//                             //                   //   ),
//                             //                   // ),
//                             //                 ],
//                             //               ),
//                             //             ),
//                             //           ),
//                             //         ],
//                             //       ),
//                             //     ),
//                             //   ),
//                             //
//                             //
//                             //   // 🟡 ADD TO CART FLOATING BUTTON
//                             //  if(productDetails.product.quantity > 0) Positioned(
//                             //     right: 20,
//                             //     top: 165,
//                             //     child: GestureDetector(
//                             //       onTap: productDetails.product.quantity == 0
//                             //           ? null
//                             //           : () => onTapCart(productDetails, false),
//                             //       child: Container(
//                             //         width: 70.w,
//                             //         height: 70.w,
//                             //         decoration: BoxDecoration(
//                             //           shape: BoxShape.circle,
//                             //           gradient: LinearGradient(
//                             //             begin: Alignment.topCenter,
//                             //             end: Alignment.bottomCenter,
//                             //             colors: productDetails.product.quantity == 0
//                             //                 ? [Colors.grey.shade400, Colors.grey.shade500]
//                             //                 : [const Color(0xFFFFB800), const Color(0xFFFF8C00)],
//                             //           ),
//                             //           boxShadow: [
//                             //             BoxShadow(
//                             //               color: productDetails.product.quantity == 0
//                             //                   ? Colors.grey.withOpacity(0.3)
//                             //                   : const Color(0xFFFF8C00).withOpacity(0.45),
//                             //               blurRadius: 20,
//                             //               offset: const Offset(0, 10),
//                             //             ),
//                             //           ],
//                             //         ),
//                             //         child: Column(
//                             //           mainAxisAlignment: MainAxisAlignment.center,
//                             //           children: [
//                             //             Icon(
//                             //               Icons.shopping_cart_outlined,
//                             //               color: Colors.white,
//                             //               size: 22.sp,
//                             //             ),
//                             //             const SizedBox(height: 4),
//                             //             Text(
//                             //               S.of(context).addToCart,
//                             //               style: TextStyle(
//                             //                 color: Colors.white,
//                             //                 fontSize: 8.sp,
//                             //                 fontWeight: FontWeight.w600,
//                             //               ),
//                             //               textAlign: TextAlign.center,
//                             //             ),
//                             //           ],
//                             //         ),
//                             //       ),
//                             //     ),
//                             //   ),
//                               ///-------------------------------------------------
//                             ],
//                           ),
//
//
//
//                           // Container(
//                           //   padding: EdgeInsets.all(16.w),
//                           //   decoration: BoxDecoration(
//                           //     color: const Color.fromARGB(255, 255, 244, 236),
//                           //     borderRadius: BorderRadius.circular(29.r),
//                           //   ),
//                           //   child: Column(
//                           //     crossAxisAlignment: CrossAxisAlignment.start,
//                           //     children: [
//                           //       ProductDescription(
//                           //           productDetails: productDetails),
//                           //       ProductDetailsAndReview(
//                           //         productDetails: productDetails,
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//                           ///
//                           // Gap(14.h),
//                           Visibility(
//                             visible: ref
//                                 .read(masterControllerProvider.notifier)
//                                 .materModel
//                                 .data
//                                 .isMultiVendor,
//                             child: Gap(0.h),
//                           ),
//                           // Visibility(
//                           //     visible: ref
//                           //         .read(masterControllerProvider.notifier)
//                           //         .materModel
//                           //         .data
//                           //         .isMultiVendor,
//                           //     child: ShopInformation(
//                           //         productDetails: productDetails)),
//                           // Gap(10.h),
//
//                           // Padding(
//                           //   padding: const EdgeInsets.symmetric(horizontal: 25),
//                           //   child: _buildShopInfoRow(
//                           //     icon: Assets.svg.clock,
//                           //     text: S.of(context).estdTime,
//                           //     value: productDetails
//                           //         .product.shop.estimatedDeliveryTime,
//                           //     context: context,
//                           //   ),
//                           // ),
//                           // Gap(10.h),
//                           // Divider(
//                           //   color: colors(context).accentColor,
//                           // ),
//                           // Gap(5.h),
//                           // SimilarProductsWidget(
//                           //   productDetails: productDetails,
//                           // ),
//                           // Gap(5.h),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 error: ((error, stackTrace) => Center(
//                       child: Text(
//                         error.toString(),
//                       ),
//                     )),
//                 loading: () => const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//         ),
//       ),
//     );
//   }
//
//   _buildAppBarRightRow(
//       {required BuildContext context, ProductDetails? productDetails}) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width * .95,
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20.r,
//             backgroundColor: colors(context).accentColor,
//             child: IconButton(
//               padding: EdgeInsets.zero,
//               icon: const Icon(
//                 Icons.keyboard_arrow_left,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 // ref.read(shopControllerProvider.notifier).review.clear();
//                 context.nav.pop();
//               },
//             ),
//           ),
//           // Spacer(),
//           // SizedBox(
//           //   width: 280.w,
//           // ),
//           ///-----------favorite--old--
//           // CircleAvatar(
//           //   radius: 20.r,
//           //   backgroundColor: colors(context).accentColor,
//           //   child: Padding(
//           //     padding: const EdgeInsets.only(top: 5),
//           //     child: AnimatedSize(
//           //       duration: const Duration(milliseconds: 250),
//           //       child: IconButton(
//           //         padding: EdgeInsets.zero,
//           //         visualDensity: VisualDensity.compact,
//           //         onPressed: () {
//           //           // 1. Safety Check: Ensure productDetails is not null
//           //           if (productDetails == null) return;
//           //
//           //           if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//           //             setState(() {
//           //               isFavorite = !isFavorite;
//           //             });
//           //
//           //             ref.read(productControllerProvider.notifier)
//           //                 .favoriteProductAddRemove(
//           //               productId: productDetails.product.id,
//           //             );
//           //           } else {
//           //             showDialog(
//           //                 context: context,
//           //                 builder: (_) => ConfirmationDialog(
//           //                   title: 'You are unable to favorite products without login!',
//           //                   confirmButtonText: 'Login',
//           //                   onPressed: () {
//           //                     context.nav.pushNamedAndRemoveUntil(
//           //                         Routes.login, (route) => false);
//           //                   },
//           //                 ));
//           //           }
//           //         },
//           //         icon: Icon(
//           //           // Now this variable is synced with the server!
//           //           isFavorite
//           //               ? Icons.favorite
//           //               : Icons.favorite_outline_rounded,
//           //           size: isFavorite ? 21.sp : 20.sp,
//           //           color: isFavorite
//           //               ? colors(context).primaryColor
//           //               : colors(context).bodyTextSmallColor,
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           ///--------------------------
//           Gap(20.w),
//           // Positioned(
//           //   top: 25,
//           //   right: 40,
//           //   child: CircleAvatar(
//           //     radius: 17.r,
//           //     backgroundColor: Colors.white,
//           //     child: Padding(
//           //       padding: const EdgeInsets.only(top: 5),
//           //       child: AnimatedSize(
//           //         duration: const Duration(milliseconds: 250),
//           //         child: IconButton(
//           //           padding: EdgeInsets.zero,
//           //           visualDensity: VisualDensity.compact,
//           //           onPressed: () {
//           //             if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//           //               setState(() {
//           //                 isFavorite = !isFavorite;
//           //               });
//           //               ref
//           //                   .read(productControllerProvider.notifier)
//           //                   .favoriteProductAddRemove(
//           //                 productId: widget.productId,
//           //               );
//           //             } else {
//           //               showDialog(
//           //                   context: context,
//           //                   builder: (_) => ConfirmationDialog(
//           //                     title:
//           //                     'You are unable to favorite products without login!',
//           //                     confirmButtonText: 'Login',
//           //                     onPressed: () {
//           //                       context.nav.pushNamedAndRemoveUntil(
//           //                           Routes.login, (route) => false);
//           //                     },
//           //                   ));
//           //             }
//           //           },
//           //           icon: Icon(
//           //             isFavorite
//           //                 ? Icons.favorite
//           //                 : Icons.favorite_outline_rounded,
//           //             size: isFavorite ? 21.sp : 20.sp,
//           //             color: isFavorite
//           //                 ? colors(context).errorColor
//           //                 : colors(context).bodyTextSmallColor,
//           //           ),
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           ///
//           // Expanded(
//           //   child: GestureDetector(
//           //     onTap: () => context.nav.pushNamed(
//           //       Routes.getProductsViewRouteName(
//           //         AppConstants.appServiceName,
//           //       ),
//           //       arguments: [
//           //         null,
//           //         'All Product',
//           //         null,
//           //         null,
//           //         null,
//           //         subCategories,
//           //       ],
//           //     ),
//           //     child: Container(
//           //       height: 40.h,
//           //       padding: EdgeInsets.symmetric(horizontal: 10.w),
//           //       decoration: BoxDecoration(
//           //         color: Colors.grey.shade100,
//           //         borderRadius: BorderRadius.circular(30.r),
//           //       ),
//           //       child: Row(
//           //         children: [
//           //           SvgPicture.asset(
//           //             Assets.svg.searchHome,
//           //             height: 15.h,
//           //             colorFilter: const ColorFilter.mode(
//           //               Colors.grey,
//           //               BlendMode.srcIn,
//           //             ),
//           //           ),
//           //           Gap(10.w),
//           //           Text(
//           //             S.of(context).searchProduct,
//           //             style: AppTextStyle(context)
//           //                 .bodyText
//           //                 .copyWith(color: Colors.grey, fontSize: 12),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           // CustomCartWidget(context: context),
//           // InkWell(
//           //   onTap: () {
//           //     final websiteUrl =
//           //         AppConstants.baseUrl.replaceAll("api", "products");
//           //     Share.share(
//           //         "check out my website $websiteUrl/${widget.productId}/details");
//           //   },
//           //   child: CircleAvatar(
//           //       radius: 24.r,
//           //       backgroundColor: colors(context).accentColor?.withOpacity(0.2),
//           //       child: Padding(
//           //         padding: const EdgeInsets.all(6.0),
//           //         child: Icon(Icons.share, color: colors(context).dark),
//           //       )),
//           // ),
//           // Gap(10.w),
//           // SvgPicture.asset(
//           //   Assets.svg.share,
//           //   width: 52.w,
//           // )
//         ],
//       ),
//     );
//   }
//   final ScrollController reviewScrollController = ScrollController();
//   Widget _buildReviewListWidget() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       child: ref.watch(shopControllerProvider)
//           ? SizedBox(
//         height: 300.h,
//         child: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       )
//           : SizedBox(
//         height:
//         ref.watch(shopControllerProvider.notifier).review.isNotEmpty
//             ? 400.h
//             : null,
//         child: ListView.builder(
//           controller: reviewScrollController,
//           shrinkWrap: true,
//           itemCount:
//           ref.watch(shopControllerProvider.notifier).review.length,
//           itemBuilder: ((context, index) {
//             final Review review =
//             ref.watch(shopControllerProvider.notifier).review[index];
//             return ReviewCard(review: review);
//           }),
//         ),
//       ),
//     );
//   }
//
//   _buildBottomNavigationBar(
//       {required BuildContext context, required ProductDetails productDetails}) {
//     return Container(
//       // padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25)
//         ),
//         border: Border.all(color: Colors.black12.withOpacity(0.1))
//       ),
//       // color: Theme.of(context).scaffoldBackgroundColor,
//       height: 72.h,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
//         child: Row(
//           children: [
//             // SizedBox(
//             //   width: 50,
//             //   child: InkWell(
//             //     borderRadius: BorderRadius.circular(50.r),
//             //     onTap: () async {
//             //       if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//             //         final saveUser =
//             //             await ref.read(hiveServiceProvider).getUserInfo();
//
//             //         final shop = Shop(
//             //           id: productDetails.product.shop.id,
//             //           name: productDetails.product.shop.name,
//             //           logo: productDetails.product.shop.logo,
//             //         );
//             //         ref
//             //             .read(storeMessageControllerProvider.notifier)
//             //             .storeMessage(
//             //               shopId: productDetails.product.shop.id,
//             //               userId: saveUser!.id!,
//             //               productId: productDetails.product.id,
//             //             );
//             //         context.nav.pushNamed(
//             //           Routes.getChatViewRouteName(AppConstants.appServiceName),
//             //           arguments: shop,
//             //         );
//             //       } else {
//             //         showDialog(
//             //             context: context,
//             //             builder: (_) => ConfirmationDialog(
//             //                   title: 'You can\'t send message without login!',
//             //                   confirmButtonText: 'Login',
//             //                   onPressed: () {
//             //                     context.nav.pushNamedAndRemoveUntil(
//             //                         Routes.login, (route) => false);
//             //                   },
//             //                 ));
//             //       }
//             //     },
//             //     child: Container(
//             //       height: 50.h,
//             //       width: double.infinity,
//             //       decoration: BoxDecoration(
//             //         borderRadius: BorderRadius.circular(50.r),
//             //         // color: ColorTween(
//             //         //   begin: colors(context).primaryColor,
//             //         //   end: colors(context).light,
//             //         // ).lerp(0.5),
//             //         border: Border.all(
//             //           color: colors(context).primaryColor!,
//             //         ),
//             //       ),
//             //       child: Container(
//             //         decoration: BoxDecoration(
//             //           borderRadius: BorderRadius.circular(90.r),
//             //         ),
//             //         child: Center(
//             //           child: Image.asset(
//             //             "assets/png/chat.png",
//             //             fit: BoxFit.cover,
//             //           ),
//             //           // child: SvgPicture.asset(
//             //           //   Assets.svg.shopChats,
//             //           //   colorFilter: ColorFilter.mode(
//             //           //       // Colors.white,
//             //           //       colors(context).primaryColor!,
//             //           //       BlendMode.srcIn),
//             //           //   height: 27.h,
//             //           //   width: 27.w,
//             //           // ),
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             InkWell(
//               borderRadius: BorderRadius.circular(12.r),
//               onTap: () async {
//                 if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                   final saveUser =
//                   await ref.read(hiveServiceProvider).getUserInfo();
//
//                   final shop = Shop(
//                     id: productDetails.product.shop.id,
//                     name: productDetails.product.shop.name,
//                     logo: productDetails.product.shop.logo,
//                   );
//
//                   ref
//                       .read(storeMessageControllerProvider.notifier)
//                       .storeMessage(
//                     shopId: productDetails.product.shop.id,
//                     userId: saveUser!.id!,
//                     productId: productDetails.product.id,
//                   );
//
//                   context.nav.pushNamed(
//                     Routes.getChatViewRouteName(AppConstants.appServiceName),
//                     arguments: shop,
//                   );
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (_) => ConfirmationDialog(
//                       title: 'You can\'t send message without login!',
//                       confirmButtonText: 'Login',
//                       onPressed: () {
//                         context.nav.pushNamedAndRemoveUntil(
//                             Routes.login, (route) => false);
//                       },
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 width: 54.w,
//                 height: 54.w,
//                 padding: EdgeInsets.all(2.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFF8C1A), // 🔶 Orange bg
//                   borderRadius: BorderRadius.circular(12.r),
//                   border: Border.all(color: colors(context).primaryColor!),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.25),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     /// 💬 CHAT ICON (WHITE BUBBLE)
//                     Center(
//                       child: SvgPicture.asset(
//                         Assets.svg.chat,
//                         width: 30.w,
//                         colorFilter: const ColorFilter.mode(
//                           Color(0xFFFFFFFF), // brown dots
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//
//                     // SizedBox(height: 2.h),
//
//                     /// 📝 TEXT
//                     Text(
//                       'Chats',
//                       style: TextStyle(
//                         fontSize: 10.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                         // shadows: const [
//                         //   Shadow(
//                         //     color: Colors.black54,
//                         //     offset: Offset(0, 1),
//                         //     blurRadius: 2,
//                         //   ),
//                         // ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             Gap(5.w),
//
//             InkWell(
//               onTap: () {
//                 final websiteUrl =
//                     AppConstants.baseUrl.replaceAll("api", "products");
//                 Share.share(
//                     "check out my website $websiteUrl/${widget.productId}/details");
//               },
//               child: CircleAvatar(
//                   radius: 24.r,
//                   backgroundColor:
//                       colors(context).accentColor?.withOpacity(0.2),
//                   child: Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Icon(Icons.share, color: colors(context).dark),
//                   )),
//             ),
//             Gap(20.w),
//             Expanded(
//               child: ShopInformation(
//                 productDetails: productDetails,
//               ),
//             ),
//             //productDetails.product.shop.estimatedDeliveryTime,
//             Gap(20.w),
//             Column(
//               children: [
//                 Container(
//                     height: 30.h,
//                     width: 30.w,
//                     child: Image.asset('assets/png/delivery.png',height: 30,)),
//                 Text(productDetails.product.shop.estimatedDeliveryTime,
//                 style: TextStyle(color: Colors.grey,fontSize: 10),)
//               ],
//             ),
//
//             // if (productDetails.product.isDigital == false)
//             //   Flexible(
//             //     flex: 1,
//             //     child: AbsorbPointer(
//             //       absorbing: productDetails.product.quantity == 0,
//             //       child: CustomTransparentButton(
//             //         buttonTextColor: productDetails.product.quantity == 0
//             //             ? ColorTween(
//             //                 begin: colors(context).primaryColor,
//             //                 end: colors(context).light,
//             //               ).lerp(0.5)
//             //             : colors(context).primaryColor,
//             //         borderColor: productDetails.product.quantity == 0
//             //             ? ColorTween(
//             //                 begin: colors(context).primaryColor,
//             //                 end: colors(context).light,
//             //               ).lerp(0.5)
//             //             : colors(context).primaryColor,
//             //         buttonText: S.of(context).addToCart,
//             //         onTap: () => onTapCart(productDetails, false),
//             //       ),
//             //     ),
//             //   ),
//             // Gap(10.w),
//             // Flexible(
//             //   flex: 1,
//             //   child: AbsorbPointer(
//             //     absorbing: productDetails.product.quantity == 0,
//             //     child: CustomButton(
//             //         buttonText: S.of(context).buyNow,
//             //         buttonColor: productDetails.product.quantity == 0
//             //             ? ColorTween(
//             //                 begin: colors(context).primaryColor,
//             //                 end: colors(context).light,
//             //               ).lerp(0.5)
//             //             : colors(context).primaryColor,
//             //         onPressed: () => onTapCart(productDetails, true)),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onTapCart(ProductDetails productDetails, bool isBuyNow) async {
//     final AddToCartModel addToCartModel = AddToCartModel(
//         productId: productDetails.product.id,
//         quantity: 1,
//         size: productDetails.product.productSizeList.isNotEmpty
//             ? productDetails
//                 .product.productSizeList[ref.read(selectedProductSizeIndex)].id
//             : null,
//         color: productDetails.product.colors.isNotEmpty
//             ? productDetails
//                 .product.colors[ref.read(selectedProductColorIndex)!].id
//             : null,
//         isBuyNow: isBuyNow);
//     if (!ref.read(hiveServiceProvider).userIsLoggedIn()) {
//       showTheWarningDialog();
//     } else {
//       await ref
//           .read(cartController.notifier)
//           .addToCart(addToCartModel: addToCartModel);
//
//       if (isBuyNow) {
//         context.nav.pushNamed(
//             Routes.getMyCartViewRouteName(
//               AppConstants.appServiceName,
//             ),
//             arguments: [false, isBuyNow]);
//       }
//     }
//   }
//
//   showTheWarningDialog() {
//     showDialog(
//       barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
//           .accentColor!
//           .withOpacity(0.8),
//       context: GlobalFunction.navigatorKey.currentContext!,
//       builder: (_) => ConfirmationDialog(
//         title: S.of(context).youAreNotLoggedIn,
//         confirmButtonText:
//             S.of(GlobalFunction.navigatorKey.currentContext!).login,
//         onPressed: () {
//           GlobalFunction.navigatorKey.currentContext!.nav
//               .pushNamedAndRemoveUntil(Routes.login, (route) => false);
//         },
//       ),
//     );
//   }
//
//   Widget buildShopInfoRow(
//       {required String icon,
//       required String text,
//       required String value,
//       required BuildContext context}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           child: Row(
//             children: [
//               SvgPicture.asset(icon),
//               Gap(10.w),
//               Text(
//                 text,
//                 style: AppTextStyle(context).bodyTextSmall,
//               )
//             ],
//           ),
//         ),
//         Text(
//           value,
//           style: AppTextStyle(context).bodyTextSmall,
//         )
//       ],
//     );
//   }
//
//   Widget _buildPriceFloatingButton(ProductDetails productDetails) {
//     final bool isDisabled = productDetails.product.quantity == 0;
//
//     return GestureDetector(
//       onTap: isDisabled ? null : () => onTapCart(productDetails, false),
//       child: Container(
//         // width: 90.w,
//         height: 125.h,
//         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.r),
//           gradient: isDisabled
//               ? LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.grey.shade400,
//               Colors.grey.shade600,
//             ],
//           )
//               : const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF9B2CFF), // purple
//               Color(0xFF4B5CFF), // blue
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isDisabled
//                   ? Colors.grey.withOpacity(0.25)
//                   : const Color(0xFF4B5CFF).withOpacity(0.45),
//               blurRadius: 22,
//               offset: const Offset(0, 14),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.shopping_cart,
//               color: Colors.white,
//               size: 39.sp,
//             ),
//             Gap(14.h),
//             Text(
//               "\$ ${productDetails.product.price.toInt()}",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget productInfoTile({
//     required IconData icon,
//     required String title,
//     required Widget content,
//     required bool isExpanded,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(16.r),
//           onTap: onTap,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF0F0F0),
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Row(
//               children: [
//                 Icon(icon, size: 20.sp, color: Colors.black87),
//                 Gap(12.w),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   isExpanded
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   size: 22.sp,
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         /// 🔽 EXPANDED CONTENT
//         AnimatedCrossFade(
//           duration: const Duration(milliseconds: 250),
//           crossFadeState:
//           isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//           firstChild: Container(
//             width: double.infinity,
//             margin: EdgeInsets.only(top: 10.h),
//             padding: EdgeInsets.all(14.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14.r),
//               border: Border.all(color: Colors.black12),
//             ),
//             child: content,
//           ),
//           secondChild: const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
//
//
// }
///---1st design figma---
///---2nd design figma---
// class _EcommerceProductDetailsLayoutState
//     extends ConsumerState<EcommerceProductDetailsLayout> {
//   bool isTextExpanded = false;
//   bool isFavorite = false;
//   bool isLoading = false;
//
//   bool shippingExpanded = false;
//   bool returnExpanded = false;
//   bool reviewExpanded = false;
//
//   // New state for the main details section
//   bool isDetailsSectionExpanded = true;
//
//   final List<SubCategory> subCategories = [];
//
//   @override
//   Widget build(BuildContext context) {
//     ref.listen(productDetailsControllerProvider(widget.productId),
//             (previous, next) {
//           next.whenData((details) {
//             if (isFavorite != details.product.isFavorite) {
//               setState(() {
//                 isFavorite = details.product.isFavorite;
//               });
//             }
//           });
//         });
//     return PopScope(
//       canPop: true,
//       onPopInvokedWithResult: (didpop, result) {
//         ref.invalidate(selectedSizePriceProvider);
//         ref.invalidate(selectedColorPriceProvider);
//       },
//       child: LoadingWrapperWidget(
//         isLoading: ref.watch(cartController).isLoading,
//         child: Scaffold(
//           floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//           floatingActionButton: ref
//               .watch(productDetailsControllerProvider(widget.productId))
//               .whenOrNull(
//             data: (productDetails) =>
//                 _buildPriceFloatingButton(productDetails),
//           ),
//           backgroundColor: const Color(0xffffffff),
//           body: ref
//               .watch(productDetailsControllerProvider(widget.productId))
//               .when(
//             data: (productDetails) => SingleChildScrollView(
//               child: AnimationLimiter(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: AnimationConfiguration.toStaggeredList(
//                     duration: const Duration(milliseconds: 500),
//                     childAnimationBuilder: (widget) => SlideAnimation(
//                         verticalOffset: 50.h,
//                         child: FadeInAnimation(
//                           child: widget,
//                         )),
//                     children: [
//                       ProductImagePageView(productDetails: productDetails),
//                       Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Container(
//                             decoration: const BoxDecoration(
//                               color: EcommerceAppColor.white,
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(50),
//                                 topLeft: Radius.circular(50),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Color(0x26000000),
//                                   blurRadius: 50,
//                                   spreadRadius: 15,
//                                   offset: Offset(0, 0),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       25, 20, 20, 0),
//                                   decoration: const BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(50),
//                                       topLeft: Radius.circular(50),
//                                     ),
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Color(0x49E9BCFF),
//                                         Color(0xFFFFFFFF),
//                                         Color(0xFFFFFFFF),
//                                       ],
//                                       stops: [
//                                         -0.4114,
//                                         1.0,
//                                         1.0,
//                                       ],
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Color(0x26000000),
//                                         blurRadius: 50,
//                                         spreadRadius: 15,
//                                         offset: Offset(0, 0),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       ProductDescription(
//                                           productDetails: productDetails),
//                                       Gap(10.w),
//                                       Container(
//                                         height: 65.h,
//                                         width: 240,
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 0.w),
//                                         decoration: BoxDecoration(
//                                           color: Colors.transparent,
//                                           borderRadius:
//                                           BorderRadius.circular(18.r),
//                                           border: Border.all(
//                                               color: Colors.black12),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             InkWell(
//                                               borderRadius:
//                                               BorderRadius.circular(
//                                                   10.r),
//                                               onTap: () async {
//                                                 if (ref
//                                                     .read(
//                                                     hiveServiceProvider)
//                                                     .userIsLoggedIn()) {
//                                                   final saveUser = await ref
//                                                       .read(
//                                                       hiveServiceProvider)
//                                                       .getUserInfo();
//
//                                                   final shop = Shop(
//                                                     id: productDetails
//                                                         .product.shop.id,
//                                                     name: productDetails
//                                                         .product.shop.name,
//                                                     logo: productDetails
//                                                         .product.shop.logo,
//                                                   );
//
//                                                   ref
//                                                       .read(
//                                                       storeMessageControllerProvider
//                                                           .notifier)
//                                                       .storeMessage(
//                                                     shopId:
//                                                     productDetails
//                                                         .product
//                                                         .shop
//                                                         .id,
//                                                     userId:
//                                                     saveUser!.id!,
//                                                     productId:
//                                                     productDetails
//                                                         .product.id,
//                                                   );
//
//                                                   context.nav.pushNamed(
//                                                     Routes
//                                                         .getChatViewRouteName(
//                                                         AppConstants
//                                                             .appServiceName),
//                                                     arguments: shop,
//                                                   );
//                                                 } else {
//                                                   showDialog(
//                                                     context: context,
//                                                     builder: (_) =>
//                                                         ConfirmationDialog(
//                                                           title:
//                                                           'You can\'t send message without login!',
//                                                           confirmButtonText:
//                                                           'Login',
//                                                           onPressed: () {
//                                                             context.nav
//                                                                 .pushNamedAndRemoveUntil(
//                                                                 Routes
//                                                                     .login,
//                                                                     (route) =>
//                                                                 false);
//                                                           },
//                                                         ),
//                                                   );
//                                                 }
//                                               },
//                                               child: Container(
//                                                 width: 64.w,
//                                                 height: 64.h,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       10.r),
//                                                   gradient:
//                                                   const LinearGradient(
//                                                     begin:
//                                                     Alignment.topLeft,
//                                                     end: Alignment
//                                                         .bottomRight,
//                                                     colors: [
//                                                       Color(0xFF8B2CF5),
//                                                       Color(0xFF6A00FF),
//                                                     ],
//                                                   ),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: const Color(
//                                                           0xFF6A00FF)
//                                                           .withOpacity(
//                                                           0.35),
//                                                       blurRadius: 14,
//                                                       offset:
//                                                       const Offset(
//                                                           0, 8),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .center,
//                                                   children: [
//                                                     SvgPicture.asset(
//                                                       Assets.svg.chat,
//                                                       width: 26.w,
//                                                       colorFilter:
//                                                       const ColorFilter
//                                                           .mode(
//                                                         Colors.white,
//                                                         BlendMode.srcIn,
//                                                       ),
//                                                     ),
//                                                     Gap(4.h),
//                                                     Text(
//                                                       'Chats',
//                                                       style: TextStyle(
//                                                         fontSize: 11.sp,
//                                                         fontWeight:
//                                                         FontWeight.w700,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Gap(40.w),
//                                             CircleAvatar(
//                                               radius: 20.r,
//                                               backgroundImage: NetworkImage(
//                                                 productDetails
//                                                     .product.shop.logo,
//                                               ),
//                                             ),
//                                             Gap(12.w),
//                                             Expanded(
//                                               child: Text(
//                                                 productDetails
//                                                     .product.shop.name,
//                                                 maxLines: 1,
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   fontWeight:
//                                                   FontWeight.w600,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Gap(18.w),
//
//                                       // --------- BUTTON ---------
//                                       InkWell(
//                                         onTap: () {
//                                           setState(() {
//                                             isDetailsSectionExpanded =
//                                             !isDetailsSectionExpanded;
//                                           });
//                                         },
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 8.h),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                 '...Details',
//                                                 maxLines: 1,
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 style: TextStyle(
//                                                   fontSize: 15.sp,
//                                                   fontWeight:
//                                                   FontWeight.bold,
//                                                   color: const Color(
//                                                       0xffC5BCFF),
//                                                 ),
//                                               ),
//                                               Gap(5.w),
//                                               Icon(
//                                                 isDetailsSectionExpanded
//                                                     ? Icons
//                                                     .keyboard_arrow_up
//                                                     : Icons
//                                                     .keyboard_arrow_down,
//                                                 color: const Color(
//                                                     0xffC5BCFF),
//                                                 size: 20.sp,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       // --------- BUTTON END ---------
//
//                                       Gap(15.w),
//                                     ],
//                                   ),
//                                 ),
//
//                                 // --------- ANIMATED SECTION START ---------
//                                 AnimatedSize(
//                                   duration: const Duration(milliseconds: 500),
//                                   alignment: Alignment.topCenter, // Ensures it scrolls UP
//                                   curve: Curves.easeInOut,
//                                   child: isDetailsSectionExpanded
//                                       ? Container(
//                                     color: Colors.white,
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.fromLTRB(25, 0, 20, 16),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Description',
//                                           maxLines: 1,
//                                           overflow:
//                                           TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                             fontWeight:
//                                             FontWeight.w600,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         Gap(5.h),
//                                         AnimatedSize(
//                                           duration: const Duration(
//                                               milliseconds: 500),
//                                           child: isTextExpanded
//                                               ? Text(
//                                             productDetails
//                                                 .product
//                                                 .description,
//                                             maxLines: 3,
//                                             style: AppTextStyle(
//                                                 context)
//                                                 .bodyTextSmall
//                                                 .copyWith(
//                                               fontSize:
//                                               12.sp,
//                                             ),
//                                           )
//                                               : Text(
//                                             productDetails
//                                                 .product
//                                                 .description,
//                                             style: AppTextStyle(
//                                                 context)
//                                                 .bodyTextSmall
//                                                 .copyWith(
//                                                 fontSize:
//                                                 13.sp),
//                                             maxLines: 1,
//                                             overflow:
//                                             TextOverflow
//                                                 .ellipsis,
//                                           ),
//                                         ),
//                                         Gap(5.h),
//                                         GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               isTextExpanded =
//                                               !isTextExpanded;
//                                             });
//                                           },
//                                           child: Text(
//                                             isTextExpanded
//                                                 ? S
//                                                 .of(context)
//                                                 .readLess
//                                                 : S
//                                                 .of(context)
//                                                 .readMore,
//                                             style: AppTextStyle(
//                                                 context)
//                                                 .bodyTextSmall
//                                                 .copyWith(
//                                               color: colors(
//                                                   context)
//                                                   .dark,
//                                               decoration:
//                                               TextDecoration
//                                                   .underline,
//                                               fontSize: 12.sp,
//                                               decorationColor:
//                                               colors(context)
//                                                   .dark,
//                                             ),
//                                           ),
//                                         ),
//                                         Gap(25.h),
//                                         Column(
//                                           children: [
//                                             productInfoTile(
//                                               icon: Icons
//                                                   .local_shipping_outlined,
//                                               title:
//                                               "Shipping Information",
//                                               isExpanded:
//                                               shippingExpanded,
//                                               onTap: () {
//                                                 setState(() =>
//                                                 shippingExpanded =
//                                                 !shippingExpanded);
//                                               },
//                                               content: Text(
//                                                 "Delivered within ${productDetails.product.shop.estimatedDeliveryTime}.\nFree shipping on orders above \$50.",
//                                                 style: TextStyle(
//                                                     fontSize: 13.sp,
//                                                     color: Colors
//                                                         .grey[700]),
//                                               ),
//                                             ),
//                                             Gap(12.h),
//                                             productInfoTile(
//                                               icon: Icons
//                                                   .assignment_return_outlined,
//                                               title: "Returns",
//                                               isExpanded:
//                                               returnExpanded,
//                                               onTap: () {
//                                                 setState(() =>
//                                                 returnExpanded =
//                                                 !returnExpanded);
//                                               },
//                                               content: Text(
//                                                 "Easy 7-day return policy.\nProduct must be unused and in original packaging.",
//                                                 style: TextStyle(
//                                                     fontSize: 13.sp,
//                                                     color: Colors
//                                                         .grey[700]),
//                                               ),
//                                             ),
//                                             Gap(12.h),
//                                             productInfoTile(
//                                                 icon: Icons
//                                                     .chat_bubble_outline,
//                                                 title: "Reviews",
//                                                 isExpanded:
//                                                 reviewExpanded,
//                                                 onTap: () {
//                                                   setState(() =>
//                                                   reviewExpanded =
//                                                   !reviewExpanded);
//                                                 },
//                                                 content:
//                                                 _buildReviewListWidget()),
//                                             Gap(20.w),
//
//                                             /// PRODUCT CATEGORY
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "Product Category",
//                                                   style: TextStyle(
//                                                     fontSize: 12.sp,
//                                                     color:
//                                                     Colors.grey,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500,
//                                                   ),
//                                                 ),
//                                                 Gap(10.w),
//                                                 Row(
//                                                   children: [
//                                                     Container(
//                                                       width: 26.w,
//                                                       height: 26.w,
//                                                       decoration:
//                                                       const BoxDecoration(
//                                                         shape: BoxShape
//                                                             .circle,
//                                                         color: Color(
//                                                             0xFFFFD5F1),
//                                                       ),
//                                                       child: Center(
//                                                         child:
//                                                         SvgPicture
//                                                             .asset(
//                                                           Assets.svg
//                                                               .shirt,
//                                                           width:
//                                                           15.w,
//                                                           height:
//                                                           15.w,
//                                                           colorFilter:
//                                                           const ColorFilter
//                                                               .mode(
//                                                             Colors
//                                                                 .black,
//                                                             BlendMode
//                                                                 .srcIn,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Gap(6.w),
//                                                     Text(
//                                                       productDetails
//                                                           .product
//                                                           .brand ??
//                                                           '',
//                                                       style:
//                                                       TextStyle(
//                                                         fontSize:
//                                                         12.sp,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w600,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//
//                                             Gap(12.h),
//
//                                             /// SKU
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "SKU",
//                                                   style: TextStyle(
//                                                     fontSize: 12.sp,
//                                                     color:
//                                                     Colors.grey,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w500,
//                                                   ),
//                                                 ),
//                                                 Gap(10.w),
//                                                 Text(
//                                                   "#234560345",
//                                                   style: TextStyle(
//                                                     fontSize: 13.sp,
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .w600,
//                                                     color: Colors
//                                                         .black,
//                                                     // letterSpacing: 0.5,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//
//                                             Gap(14.h),
//                                             Divider(
//                                                 thickness: 0.6,
//                                                 color: Colors.black
//                                                     .withOpacity(
//                                                     0.25)),
//                                           ],
//                                         ),
//                                         Gap(15.h),
//                                         SimilarProductsWidget(
//                                           productDetails:
//                                           productDetails,
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                       : const SizedBox(width: double.infinity), // Keeps width context but 0 height
//                                 ),
//                                 // --------- ANIMATED SECTION END ---------
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Visibility(
//                         visible: ref
//                             .read(masterControllerProvider.notifier)
//                             .materModel
//                             .data
//                             .isMultiVendor,
//                         child: Gap(0.h),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             error: ((error, stackTrace) => Center(
//               child: Text(
//                 error.toString(),
//               ),
//             )),
//             loading: () => const Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   final ScrollController reviewScrollController = ScrollController();
//   Widget _buildReviewListWidget() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       child: ref.watch(shopControllerProvider)
//           ? SizedBox(
//         height: 300.h,
//         child: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       )
//           : SizedBox(
//         height:
//         ref.watch(shopControllerProvider.notifier).review.isNotEmpty
//             ? 400.h
//             : null,
//         child: ListView.builder(
//           controller: reviewScrollController,
//           shrinkWrap: true,
//           itemCount:
//           ref.watch(shopControllerProvider.notifier).review.length,
//           itemBuilder: ((context, index) {
//             final Review review =
//             ref.watch(shopControllerProvider.notifier).review[index];
//             return ReviewCard(review: review);
//           }),
//         ),
//       ),
//     );
//   }
//
//   _buildBottomNavigationBar(
//       {required BuildContext context, required ProductDetails productDetails}) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(25), topRight: Radius.circular(25)),
//           border: Border.all(color: Colors.black12.withOpacity(0.1))),
//       height: 72.h,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
//         child: Row(
//           children: [
//             InkWell(
//               borderRadius: BorderRadius.circular(12.r),
//               onTap: () async {
//                 if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                   final saveUser =
//                   await ref.read(hiveServiceProvider).getUserInfo();
//
//                   final shop = Shop(
//                     id: productDetails.product.shop.id,
//                     name: productDetails.product.shop.name,
//                     logo: productDetails.product.shop.logo,
//                   );
//
//                   ref
//                       .read(storeMessageControllerProvider.notifier)
//                       .storeMessage(
//                     shopId: productDetails.product.shop.id,
//                     userId: saveUser!.id!,
//                     productId: productDetails.product.id,
//                   );
//
//                   context.nav.pushNamed(
//                     Routes.getChatViewRouteName(AppConstants.appServiceName),
//                     arguments: shop,
//                   );
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (_) => ConfirmationDialog(
//                       title: 'You can\'t send message without login!',
//                       confirmButtonText: 'Login',
//                       onPressed: () {
//                         context.nav.pushNamedAndRemoveUntil(
//                             Routes.login, (route) => false);
//                       },
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 width: 54.w,
//                 height: 54.w,
//                 padding: EdgeInsets.all(2.w),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFF8C1A),
//                   borderRadius: BorderRadius.circular(12.r),
//                   border: Border.all(color: colors(context).primaryColor!),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.25),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: SvgPicture.asset(
//                         Assets.svg.chat,
//                         width: 30.w,
//                         colorFilter: const ColorFilter.mode(
//                           Color(0xFFFFFFFF),
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'Chats',
//                       style: TextStyle(
//                         fontSize: 10.sp,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Gap(5.w),
//             InkWell(
//               onTap: () {
//                 final websiteUrl =
//                 AppConstants.baseUrl.replaceAll("api", "products");
//                 Share.share(
//                     "check out my website $websiteUrl/${widget.productId}/details");
//               },
//               child: CircleAvatar(
//                   radius: 24.r,
//                   backgroundColor:
//                   colors(context).accentColor?.withOpacity(0.2),
//                   child: Padding(
//                     padding: const EdgeInsets.all(6.0),
//                     child: Icon(Icons.share, color: colors(context).dark),
//                   )),
//             ),
//             Gap(20.w),
//             Expanded(
//               child: ShopInformation(
//                 productDetails: productDetails,
//               ),
//             ),
//             Gap(20.w),
//             Column(
//               children: [
//                 Container(
//                     height: 30.h,
//                     width: 30.w,
//                     child: Image.asset(
//                       'assets/png/delivery.png',
//                       height: 30,
//                     )),
//                 Text(
//                   productDetails.product.shop.estimatedDeliveryTime,
//                   style: const TextStyle(color: Colors.grey, fontSize: 10),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onTapCart(ProductDetails productDetails, bool isBuyNow) async {
//     final AddToCartModel addToCartModel = AddToCartModel(
//         productId: productDetails.product.id,
//         quantity: 1,
//         size: productDetails.product.productSizeList.isNotEmpty
//             ? productDetails
//             .product.productSizeList[ref.read(selectedProductSizeIndex)].id
//             : null,
//         color: productDetails.product.colors.isNotEmpty
//             ? productDetails
//             .product.colors[ref.read(selectedProductColorIndex)!].id
//             : null,
//         isBuyNow: isBuyNow);
//     if (!ref.read(hiveServiceProvider).userIsLoggedIn()) {
//       showTheWarningDialog();
//     } else {
//       await ref
//           .read(cartController.notifier)
//           .addToCart(addToCartModel: addToCartModel);
//
//       if (isBuyNow) {
//         context.nav.pushNamed(
//             Routes.getMyCartViewRouteName(
//               AppConstants.appServiceName,
//             ),
//             arguments: [false, isBuyNow]);
//       }
//     }
//   }
//
//   showTheWarningDialog() {
//     showDialog(
//       barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
//           .accentColor!
//           .withOpacity(0.8),
//       context: GlobalFunction.navigatorKey.currentContext!,
//       builder: (_) => ConfirmationDialog(
//         title: S.of(context).youAreNotLoggedIn,
//         confirmButtonText:
//         S.of(GlobalFunction.navigatorKey.currentContext!).login,
//         onPressed: () {
//           GlobalFunction.navigatorKey.currentContext!.nav
//               .pushNamedAndRemoveUntil(Routes.login, (route) => false);
//         },
//       ),
//     );
//   }
//
//   Widget _buildPriceFloatingButton(ProductDetails productDetails) {
//     final bool isDisabled = productDetails.product.quantity == 0;
//
//     return GestureDetector(
//       onTap: isDisabled ? null : () => onTapCart(productDetails, false),
//       child: Container(
//         height: 125.h,
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.r),
//           gradient: isDisabled
//               ? LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.grey.shade400,
//               Colors.grey.shade600,
//             ],
//           )
//               : const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF9B2CFF),
//               Color(0xFF4B5CFF),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isDisabled
//                   ? Colors.grey.withOpacity(0.25)
//                   : const Color(0xFF4B5CFF).withOpacity(0.45),
//               blurRadius: 22,
//               offset: const Offset(0, 14),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.shopping_cart,
//               color: Colors.white,
//               size: 39.sp,
//             ),
//             Gap(14.h),
//             Text(
//               "\$ ${productDetails.product.price.toInt()}",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget productInfoTile({
//     required IconData icon,
//     required String title,
//     required Widget content,
//     required bool isExpanded,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(16.r),
//           onTap: onTap,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF0F0F0),
//               borderRadius: BorderRadius.circular(16.r),
//             ),
//             child: Row(
//               children: [
//                 Icon(icon, size: 20.sp, color: Colors.black87),
//                 Gap(12.w),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   isExpanded
//                       ? Icons.keyboard_arrow_up
//                       : Icons.keyboard_arrow_down,
//                   size: 22.sp,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         AnimatedCrossFade(
//           duration: const Duration(milliseconds: 250),
//           crossFadeState:
//           isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//           firstChild: Container(
//             width: double.infinity,
//             margin: EdgeInsets.only(top: 10.h),
//             padding: EdgeInsets.all(14.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14.r),
//               border: Border.all(color: Colors.black12),
//             ),
//             child: content,
//           ),
//           secondChild: const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }
///---2nd design figma---
///---3rd design figma---
class _EcommerceProductDetailsLayoutState
    extends ConsumerState<EcommerceProductDetailsLayout> {
  bool isTextExpanded = false;
  bool isFavorite = false;
  bool isLoading = false;

  bool shippingExpanded = false;
  bool returnExpanded = false;
  bool reviewExpanded = false;

  // New state for the main details section
  bool isDetailsSectionExpanded = true;

  final List<SubCategory> subCategories = [];

  @override
  Widget build(BuildContext context) {
    ref.listen(productDetailsControllerProvider(widget.productId),
        (previous, next) {
      next.whenData((details) {
        if (isFavorite != details.product.isFavorite) {
          setState(() {
            isFavorite = details.product.isFavorite;
          });
        }

        final previousId = previous?.asData?.value.product.id;
        final isNewProduct = previousId != details.product.id;
        if (!isNewProduct) return;

        ref.read(currentPageController.notifier).state = 0;
        ref.read(productDetailsQuantityProvider.notifier).state = 1;
        ref.read(productDetailsTabIndexProvider.notifier).state = 0;
        final colorCount = details.product.colors.length;
        ref.read(selectedProductColorIndex.notifier).state =
            colorCount > 0 ? 0 : null;
        ref.read(selectedColorPriceProvider.notifier).state =
            colorCount > 0 ? details.product.colors[0].price : 0;
        final sizeCount = details.product.productSizeList.length;
        ref.read(selectedProductSizeIndex.notifier).state = 0;
        ref.read(selectedSizePriceProvider.notifier).state =
            sizeCount > 0 ? details.product.productSizeList[0].price : 0;
      });
    });
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didpop, result) {
        ref.invalidate(selectedSizePriceProvider);
        ref.invalidate(selectedColorPriceProvider);
        ref.invalidate(productDetailsQuantityProvider);
        ref.invalidate(productDetailsTabIndexProvider);
        ref.invalidate(currentPageController);
        ref.invalidate(selectedProductColorIndex);
        ref.invalidate(selectedProductSizeIndex);
      },
      child: LoadingWrapperWidget(
        isLoading: ref.watch(cartController).isLoading,
        child: Platform.isAndroid
            ? AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  systemNavigationBarColor: Color(0xFF000000),
                  systemNavigationBarDividerColor: Color(0xFF000000),
                  systemNavigationBarIconBrightness: Brightness.light,
                  systemNavigationBarContrastEnforced: false,
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
                child: _buildProductDetailsScaffold(),
              )
            : _buildProductDetailsScaffold(),
      ),
    );
  }

  Widget _buildProductDetailsScaffold() {
    return Scaffold(
      bottomNavigationBar: ref
          .watch(productDetailsControllerProvider(widget.productId))
          .whenOrNull(
            data: (productDetails) =>
                _buildBottomActionSection(context, productDetails),
          ),
      backgroundColor: Colors.white,
      body: ref.watch(productDetailsControllerProvider(widget.productId)).when(
            data: (productDetails) => Column(
              children: [
                SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 52.h,
                    child: _buildAppBar(
                      context: context,
                      productDetails: productDetails,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Gap(8.h),
                        ProductImagePageView(
                          productDetails: productDetails,
                        ),
                        Gap(10.h),
                        ProductDescription(
                          productDetails: productDetails,
                          onAddToCart: () =>
                              onTapCart(productDetails, false),
                          onBuyNow: () => onTapCart(productDetails, true),
                          onViewReviews: () {
                            ref
                                .read(productDetailsTabIndexProvider.notifier)
                                .state = 2;
                          },
                        ),
                        Gap(8.h),
                        ProductDetailsTabsSection(
                          productDetails: productDetails,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            error: ((error, stackTrace) => Center(
                  child: Text(
                    error.toString(),
                  ),
                )),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }

  final ScrollController reviewScrollController = ScrollController();
  Widget _buildReviewListWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: ref.watch(shopControllerProvider)
          ? SizedBox(
              height: 300.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox(
              height:
                  ref.watch(shopControllerProvider.notifier).review.isNotEmpty
                      ? 400.h
                      : null,
              child: ListView.builder(
                controller: reviewScrollController,
                shrinkWrap: true,
                itemCount:
                    ref.watch(shopControllerProvider.notifier).review.length,
                itemBuilder: ((context, index) {
                  final Review review =
                      ref.watch(shopControllerProvider.notifier).review[index];
                  return ReviewCard(review: review);
                }),
              ),
            ),
    );
  }

  Widget _buildAppBar(
      {required BuildContext context, required ProductDetails productDetails}) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: Row(
          children: [
            Gap(12.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.white,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () {
                  context.nav.pop();
                },
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.nav.pushNamed(
                Routes.getProductsViewRouteName(
                  AppConstants.appServiceName,
                ),
                arguments: [
                  null,
                  'All Product',
                  null,
                  null,
                  null,
                  subCategories,
                ],
              ),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.black87, size: 20.sp),
              ),
            ),
            Gap(8.w),
            Material(
              type: MaterialType.transparency,
              child: CustomCartWidget(
                context: context,
                iconColor: Colors.black87,
                backgroundColor: Colors.white,
              ),
            ),
            Gap(4.w),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, color: Colors.black87, size: 22.sp),
              onSelected: (value) {
                if (value == 'share') {
                  final websiteUrl =
                      AppConstants.baseUrl.replaceAll("api", "products");
                  Share.share(
                      "check out my website $websiteUrl/${productDetails.product.id}/details");
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Text('Share'),
                ),
              ],
            ),
            Gap(8.w),
          ],
        ));
  }

  _buildBottomNavigationBar(
      {required BuildContext context, required ProductDetails productDetails}) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          border: Border.all(color: Colors.black12.withOpacity(0.1))),
      height: 72.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () async {
                if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
                  final saveUser =
                      await ref.read(hiveServiceProvider).getUserInfo();

                  final shop = Shop(
                    id: productDetails.product.shop.id,
                    name: productDetails.product.shop.name,
                    logo: productDetails.product.shop.logo,
                  );

                  ref
                      .read(storeMessageControllerProvider.notifier)
                      .storeMessage(
                        shopId: productDetails.product.shop.id,
                        userId: saveUser!.id!,
                        productId: productDetails.product.id,
                      );

                  context.nav.pushNamed(
                    Routes.getChatViewRouteName(AppConstants.appServiceName),
                    arguments: shop,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      title: 'You can\'t send message without login!',
                      confirmButtonText: 'Login',
                      onPressed: () {
                        context.nav.pushNamedAndRemoveUntil(
                            Routes.login, (route) => false);
                      },
                    ),
                  );
                }
              },
              child: Container(
                width: 54.w,
                height: 54.w,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C1A),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors(context).primaryColor!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        Assets.svg.chat,
                        width: 30.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFFFFF),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(5.w),
            InkWell(
              onTap: () {
                final websiteUrl =
                    AppConstants.baseUrl.replaceAll("api", "products");
                Share.share(
                    "check out my website $websiteUrl/${widget.productId}/details");
              },
              child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor:
                      colors(context).accentColor?.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.share, color: colors(context).dark),
                  )),
            ),
            Gap(20.w),
            Expanded(
              child: ShopInformation(
                productDetails: productDetails,
              ),
            ),
            Gap(20.w),
            Column(
              children: [
                Container(
                    height: 30.h,
                    width: 30.w,
                    child: Image.asset(
                      'assets/png/delivery.png',
                      height: 30,
                    )),
                Text(
                  productDetails.product.shop.estimatedDeliveryTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onTapCart(ProductDetails productDetails, bool isBuyNow) async {
    final colorIndex = ref.read(selectedProductColorIndex) ?? 0;
    final sizeIndex = ref.read(selectedProductSizeIndex);
    final AddToCartModel addToCartModel = AddToCartModel(
        productId: productDetails.product.id,
        quantity: ref.read(productDetailsQuantityProvider),
        size: productDetails.product.productSizeList.isNotEmpty &&
                sizeIndex < productDetails.product.productSizeList.length
            ? productDetails.product.productSizeList[sizeIndex].id
            : null,
        color: productDetails.product.colors.isNotEmpty &&
                colorIndex < productDetails.product.colors.length
            ? productDetails.product.colors[colorIndex].id
            : null,
        isBuyNow: isBuyNow);
    if (!ref.read(hiveServiceProvider).userIsLoggedIn()) {
      showTheWarningDialog();
    } else {
      await ref
          .read(cartController.notifier)
          .addToCart(addToCartModel: addToCartModel);

      if (isBuyNow) {
        context.nav.pushNamed(
            Routes.getMyCartViewRouteName(
              AppConstants.appServiceName,
            ),
            arguments: [false, isBuyNow]);
      }
    }
  }

  showTheWarningDialog() {
    showDialog(
      barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
          .accentColor!
          .withOpacity(0.8),
      context: GlobalFunction.navigatorKey.currentContext!,
      builder: (_) => ConfirmationDialog(
        title: S.of(context).youAreNotLoggedIn,
        confirmButtonText:
            S.of(GlobalFunction.navigatorKey.currentContext!).login,
        onPressed: () {
          GlobalFunction.navigatorKey.currentContext!.nav
              .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        },
      ),
    );
  }

  Widget _buildPriceFloatingButton(ProductDetails productDetails) {
    final bool isDisabled = productDetails.product.quantity == 0;

    return GestureDetector(
      onTap: isDisabled ? null : () => onTapCart(productDetails, false),
      child: Container(
        height: 125.h,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: isDisabled
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade400,
                    Colors.grey.shade600,
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF9B2CFF),
                    Color(0xFF4B5CFF),
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: isDisabled
                  ? Colors.grey.withOpacity(0.25)
                  : const Color(0xFF4B5CFF).withOpacity(0.45),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 39.sp,
            ),
            Gap(14.h),
            Text(
              "\$ ${productDetails.product.price.toInt()}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionSection(
      BuildContext context, ProductDetails productDetails) {
    final bool isDisabled = productDetails.product.quantity == 0;
    final colorPrice = ref.watch(selectedColorPriceProvider);
    final sizePrice = ref.watch(selectedSizePriceProvider);
    final basePrice = productDetails.product.discountPrice > 0
        ? productDetails.product.discountPrice
        : productDetails.product.price;
    final displayPrice = basePrice + colorPrice + sizePrice;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final ctaBar = Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            GlobalFunction.price(
              ref: ref,
              price: displayPrice.toString(),
            ),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFF5722),
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 42.h,
                width: 110.w,
                child: OutlinedButton(
                  onPressed: isDisabled
                      ? null
                      : () => onTapCart(productDetails, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF5722)),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF5722),
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              SizedBox(
                height: 42.h,
                width: 110.w,
                child: ElevatedButton(
                  onPressed: isDisabled
                      ? null
                      : () => onTapCart(productDetails, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Android only: dark system nav bar + CTA above it.
    // iOS already layouts correctly with SafeArea — leave it alone.
    if (Platform.isAndroid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ctaBar,
          Container(
            height: bottomInset,
            width: double.infinity,
            color: const Color(0xFF000000),
          ),
        ],
      );
    }

    return SafeArea(
      top: false,
      child: ctaBar,
    );
  }

  Widget productInfoTile({
    required IconData icon,
    required String title,
    required Widget content,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20.sp, color: Colors.black87),
                Gap(12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState:
              isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.black12),
            ),
            child: content,
          ),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}

///---3rd design figma---

class LoadingWrapperWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const LoadingWrapperWidget({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const Opacity(
            opacity: 0.3,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (isLoading)
          const Center(
            child: AppLogo(
              withAppName: false,
              isAnimation: true,
            ),
          ),
      ],
    );
  }
}
