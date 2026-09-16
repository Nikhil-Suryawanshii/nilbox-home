import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/hive_cart_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/home/layouts/home_view_layout.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_color_picker.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_size_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../components/ecommerce/increment_decrement_button.dart';
import '../../../../controllers/common/master_controller.dart';
import '../../../../controllers/eCommerce/cart/cart_controller.dart';
import '../../../../controllers/misc/misc_controller.dart';
import '../../../../models/eCommerce/cart/add_to_cart_model.dart';

class ProductDescription extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  const ProductDescription({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends ConsumerState<ProductDescription> {
  bool isTextExpanded = false;
  bool isFavorite = true;
  final TextEditingController promoCodeController = TextEditingController();

  @override
  void initState() {
    isFavorite = widget.productDetails.product.isFavorite;
    super.initState();
  }

  bool checkMultivendor() {
    return ref
        .read(masterControllerProvider.notifier)
        .materModel
        .data
        .isMultiVendor;
  }

  void calculateCartSummery() {
    debugPrint('calculateCartSummery');

    ref.read(shopIdsProvider.notifier).addAllShopIds();
    debugPrint(
        "sopids: ${ref.read(shopIdsProvider).toList().toString()} ${promoCodeController.text}}");
    ref.read(cartSummeryController.notifier).calculateCartSummery(
          couponCode: promoCodeController.text,
          shopIds: ref.read(shopIdsProvider).toList(),
          isBuyNow: false,
        );
  }

  Future<void> _updateQuantity({
    required WidgetRef ref,
    required bool isIncrement,
  }) async {
    final cartState = ref.read(cartController);

    /// SAFETY: cart empty
    if (cartState.cartItems.isEmpty ||
        cartState.cartItems.first.cartProduct.isEmpty) {
      debugPrint('Cart is empty');
      return;
    }

    final productId = cartState.cartItems.first.cartProduct.first.id;

    /// Multivendor handling
    if (checkMultivendor()) {
      if (ref.read(shopIdsProvider).isNotEmpty) {
        ref.read(shopIdsProvider);
        ref.read(cartSummeryController.notifier);
      }
    }

    /// Increment / Decrement
    if (isIncrement) {
      await ref.read(cartController.notifier).increment(productId: productId);
    } else {
      await ref.read(cartController.notifier).decrement(productId: productId);
    }

    calculateCartSummery();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


        // Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Text(
        //         widget.productDetails.product.name
        //             .split(' ')
        //             .map((word) => word.isNotEmpty
        //             ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        //             : '')
        //             .join(' '),
        //         maxLines: 2,
        //         overflow: TextOverflow.ellipsis,
        //         style: AppTextStyle(context)
        //             .bodyText
        //             .copyWith(fontWeight: FontWeight.w700,
        //             // fontSize: 15
        //             fontSize: 23
        //         ),
        //       ),
        //       // Text(
        //       //   widget.productDetails.product.brand ?? '',
        //       //   style: AppTextStyle(context).bodyTextSmall.copyWith(
        //       //         color: colors(context).primaryColor,
        //       //         fontWeight: FontWeight.w700,
        //       //     overflow: TextOverflow.ellipsis
        //       //       ),
        //       // ),
        //       // Gap(50.w),
        //       // Spacer(),
        //       Flexible(
        //         child: Visibility(
        //           visible: widget.productDetails.product.colors.isNotEmpty,
        //           child: ProductColorPicker(productDetails: widget.productDetails),
        //         ),
        //       ),
        //       ///-----------old design-------------------------
        //       // _buildPriceAndAddToCart(context: context),
        //       ///---------------------------------------------
        //       Gap(10.w),
        //     ],
        //   ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically center
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. PRODUCT NAME (Left Side)
              Expanded(
                flex: 3, // Give text more space (approx 60-70%)
                child: Text(
                  widget.productDetails.product.name
                      .split(' ')
                      .map((word) => word.isNotEmpty
                      ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                      : '')
                      .join(' '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 23.sp, // Use .sp for responsive font size
                  ),
                ),
              ),

              // Gap(10.w), // Space between Name and Colors

              // 2. COLOR PICKER (Right Side)
              // Only show if colors exist
              if (widget.productDetails.product.colors.isNotEmpty)
                Expanded(
                  flex: 2, // Give color picker approx 30-40% space
                  child: Align(
                    alignment: Alignment.centerRight, // Align list to the right
                    child: ProductColorPicker(productDetails: widget.productDetails),
                  ),
                ),
            ],
          ),
          // Gap(5.h),

          // Gap(5.h),
          // AnimatedSize(
          //   duration: const Duration(milliseconds: 500),
          //   child: isTextExpanded
          //       ? Text(
          //           widget.productDetails.product.shortDescription,
          //           maxLines: 3,
          //           style: AppTextStyle(context)
          //               .bodyTextSmall
          //               .copyWith(fontSize: 12.sp,),
          //         )
          //       : Text(
          //           widget.productDetails.product.shortDescription,
          //           style: AppTextStyle(context)
          //               .bodyTextSmall
          //               .copyWith(fontSize: 13.sp),
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          // ),
          // Gap(5.h),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       isTextExpanded = !isTextExpanded;
          //     });
          //   },
          //   child: Text(
          //     isTextExpanded ? S.of(context).readLess : S.of(context).readMore,
          //     style: AppTextStyle(context).bodyTextSmall.copyWith(
          //           color: colors(context).primaryColor,
          //           decoration: TextDecoration.underline,
          //           decorationColor: colors(context).primaryColor,
          //         ),
          //   ),
          // ),
          Gap(15.h),
          ///-------------old design--------------
          // Visibility(
          //   visible: widget.productDetails.product.colors.isNotEmpty,
          //   child: ProductColorPicker(productDetails: widget.productDetails),
          // ),
          ///------------------------------------------------
          Row(
            children: [
              SizedBox(
                width: 170,
                child: widget.productDetails.product.quantity == 0 ?Text(
                  "Out of stock",
                  style:
                  TextStyle(color: EcommerceAppColor.red, fontSize: 12.sp),
                ):Text(
                  // "In stock (${widget.productDetails.product.quantity ?? 0} left)",
                  "✅ Available in Stock",
                  style:
                  TextStyle(color: EcommerceAppColor.green, fontSize: 12.sp),
                ),
              ),
              _buildReviewAndSoldCount(context: context),
            ],
          ),
          Gap(15.h),
          Text(
            'Size',
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w700,
                // fontSize: 15
                fontSize: 18
            ),
          ),
          Gap(10.h),
          Visibility(
            visible: widget.productDetails.product.productSizeList.isNotEmpty,
            child: ProductSizePicker(productDetails: widget.productDetails),
          ),
          ///-------old design-------------
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
          //   children: [
          //     // FIX: Wrapped in Expanded so Size Picker doesn't push Button off screen
          //     Expanded(
          //       child: widget.productDetails.product.quantity == 0 ?Text(
          //         "Out of stock",
          //         style:
          //         TextStyle(color: EcommerceAppColor.red, fontSize: 12.sp),
          //       ):Text(
          //         "In stock (${widget.productDetails.product.quantity ?? 0} left)",
          //         style:
          //         TextStyle(color: EcommerceAppColor.green, fontSize: 12.sp),
          //       ),
          //     ),
          //
          //     // Add gap only if sizes are present
          //     // if(widget.productDetails.product.productSizeList.isNotEmpty) Gap(10.w),
          //
          //     // Giant Cart Button
          //     // GestureDetector(
          //     //   onTap: widget.productDetails.product.quantity == 0
          //     //       ? null
          //     //       : () => onTapCart(widget.productDetails, false),
          //     //   child: Container(
          //     //     width: 60.w, // Adjusted size slightly (75w might be too huge)
          //     //     height: 60.w,
          //     //     decoration: BoxDecoration(
          //     //       shape: BoxShape.circle,
          //     //       gradient: LinearGradient(
          //     //         begin: Alignment.topCenter,
          //     //         end: Alignment.bottomCenter,
          //     //         colors: widget.productDetails.product.quantity == 0
          //     //             ? [Colors.grey.shade400, Colors.grey.shade500]
          //     //             : [const Color(0xFFFFB800), const Color(0xFFFF8C00)],
          //     //       ),
          //     //       boxShadow: [
          //     //         BoxShadow(
          //     //           color: widget.productDetails.product.quantity == 0
          //     //               ? Colors.grey.withOpacity(0.3)
          //     //               : const Color(0xFFFF8C00).withOpacity(0.4),
          //     //           blurRadius: 15, // Softened shadow
          //     //           offset: const Offset(0, 8),
          //     //         ),
          //     //       ],
          //     //     ),
          //     //     padding: const EdgeInsets.all(8),
          //     //     child: Column(
          //     //       mainAxisAlignment: MainAxisAlignment.center,
          //     //       children: [
          //     //         Icon(
          //     //           Icons.shopping_cart_outlined,
          //     //           color: Colors.white,
          //     //           size: 20.sp,
          //     //         ),
          //     //         Text(
          //     //           S.of(context).addToCart,
          //     //           style: TextStyle(
          //     //             color: Colors.white,
          //     //             fontSize: 7.sp, // Smaller text to fit circle
          //     //             fontWeight: FontWeight.w600,
          //     //           ),
          //     //           textAlign: TextAlign.center,
          //     //           maxLines: 1,
          //     //           overflow: TextOverflow.visible,
          //     //         ),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
          ///---------------------------
          Gap(5.h),
          // Gap(10.h),
          // _buildReviewAndSoldCount(context: context),
          // Gap(5.h),
          // _buildPriceAndAddToCart(context: context),
          ///

          // Gap(10.h),
          widget.productDetails.product.runningFlashSale != null
              ? DealOfTheDayWidget(
                  showViewMore: false,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void onTapCart(ProductDetails productDetails, bool isBuyNow) async {
    final AddToCartModel addToCartModel = AddToCartModel(
        productId: productDetails.product.id,
        quantity: 1,
        size: productDetails.product.productSizeList.isNotEmpty
            ? productDetails
                .product.productSizeList[ref.read(selectedProductSizeIndex)].id
            : null,
        color: productDetails.product.colors.isNotEmpty
            ? productDetails
                .product.colors[ref.read(selectedProductColorIndex)!].id
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

  Widget _buildReviewAndSoldCount({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_rounded,
              size: 16.sp,
              // color: EcommerceAppColor.carrotOrange,
              color: Color(0xffFFFB00),
            ),
            Text(
              widget.productDetails.product.rating.toString(),
              style: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.w700,
                fontSize: 12
                  ),
            ),
            Gap(5.w),
            Text(
              '(${widget.productDetails.product.totalReviews} Reviews)',
              style: AppTextStyle(context).bodyText.copyWith(
                  fontWeight: FontWeight.w500,
    fontSize: 12,
                  color: colors(context).bodyTextSmallColor),
            ),
            // Gap(14.w),
            // CircleAvatar(
            //     radius: 3.r,
            //     backgroundColor: EcommerceAppColor.lightGray.withOpacity(0.5)),
            // Gap(14.w),
            // Text(
            //   '${widget.productDetails.product.totalSold} Sold',
            //   style: AppTextStyle(context).bodyText.copyWith(
            //         fontWeight: FontWeight.w500,
            //         color: colors(context).bodyTextSmallColor,
            //       ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceAndAddToCart({required BuildContext context}) {
    return ValueListenableBuilder<Box<HiveCartModel>>(
        valueListenable:
            Hive.box<HiveCartModel>(AppConstants.cartModelBox).listenable(),
        builder: (context, cartBox, _) {
          // bool inCart = false;
          // late int productQuantity;
          // int cartIndex = -1;
          final cartItems = cartBox.values.toList();
          for (int i = 0; i < cartItems.length; i++) {
            final cartProduct = cartItems[i];
            if (cartProduct.productId == widget.productDetails.product.id) {
              // inCart = true;
              // productQuantity = cartProduct.productsQTY;
              // cartIndex = i;
              break;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.productDetails.product.discountPrice > 0)
                Padding(
                  padding: EdgeInsets.only(left: 0.w),
                  child: Text(
                    GlobalFunction.price(
                      ref: ref,
                      price: widget.productDetails.product.price.toString(),
                    ),
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontSize: 15.sp,
                          color: EcommerceAppColor.black,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: EcommerceAppColor.lightGray,
                        ),
                  ),
                ),
              Gap(2.h),
              Text(
                GlobalFunction.price(
                  ref: ref,
                  price: ((widget.productDetails.product.discountPrice > 0
                              ? widget.productDetails.product.discountPrice
                              : widget.productDetails.product.price) +
                          ref.watch(selectedColorPriceProvider) +
                          ref.watch(selectedSizePriceProvider))
                      .toString(),
                ),
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 17.sp),
              ),
            ],
          );

          // Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: [
          //   Column(
          // children: [
          //   if (widget.productDetails.product.discountPrice > 0) ...[
          //     Text(
          //       GlobalFunction.price(
          //         ref: ref,
          //         price: (widget.productDetails.product.discountPrice +
          //                 ref.watch(selectedColorPriceProvider) +
          //                 ref.watch(selectedSizePriceProvider))
          //             .toString(),
          //       ),
          //       style: AppTextStyle(context)
          //           .bodyText
          //           .copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
          //     ),
          //   ] else ...[
          //     Text(
          //       GlobalFunction.price(
          //         ref: ref,
          //         price: (widget.productDetails.product.price +
          //                 ref.watch(selectedColorPriceProvider) +
          //                 ref.watch(selectedSizePriceProvider))
          //             .toString(),
          //       ),
          //       style: AppTextStyle(context)
          //           .bodyText
          //           .copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
          //     ),
          //   ],
          //   Gap(5.w),
          //   Visibility(
          //     visible: widget.productDetails.product.discountPrice > 0,
          //     child: Text(
          //       GlobalFunction.price(
          //         ref: ref,
          //         price: widget.productDetails.product.price.toString(),
          //       ),
          //       style: AppTextStyle(context).bodyText.copyWith(
          //             fontSize: 11.sp,
          //             color: EcommerceAppColor.lightGray,
          //             decoration: TextDecoration.lineThrough,
          //             decorationColor: EcommerceAppColor.lightGray,
          //           ),
          //     ),
          //   ),
          // Gap(10.w),
          // Visibility(
          //   visible: widget.productDetails.product.discountPrice > 0,
          //   child: Container(
          //     padding:
          //         EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5.r),
          //       color: colors(context).errorColor,
          //     ),
          //     child: Center(
          //       child: Text(
          //         '-${widget.productDetails.product.discountPercentage} %',
          //         style: AppTextStyle(context).bodyTextSmall.copyWith(
          //               color: colors(context).light,
          //               fontWeight: FontWeight.w700,
          //             ),
          //       ),
          //     ),
          //   ),
          // )
          //   ],
          // );

          // if (inCart) ...[
          //   IncrementDecrementButton(
          //     productQuantity: productQuantity,
          //     increment: () {
          //       ref.read(cartController.notifier).incrementProductQuantity(
          //             productId: widget.productDetails.product.id,
          //             cartBox: cartBox,
          //             index: cartIndex,
          // //           );
          // //     },
          //     decrement: () {
          //       ref.read(cartController.notifier).decrementProductQuantity(
          //             productId: widget.productDetails.product.id,
          //             cartBox: cartBox,
          //             index: cartIndex,
          //           );
          //     },
          //   )
          // ] else ...{
          //   IncrementButton(
          //     onTap: () async {
          //       HiveCartModel cartItem = HiveCartModel(
          //         shopId: widget.productDetails.product.shop.id,
          //         shopLogo: widget.productDetails.product.shop.logo,
          //         deliveryCharge:
          //             widget.productDetails.product.shop.deliveryCharge,
          //         shopName: widget.productDetails.product.shop.name,
          //         review: 4.7,
          //         productId: widget.productDetails.product.id,
          //         productLogo: widget.productDetails.product.thumbnails.first.thumbnail,
          //         title: widget.productDetails.product.name,
          //         price: GlobalFunction.getPrice(
          //           currentPrice: widget.productDetails.product.price,
          //           discountPrice:
          //               widget.productDetails.product.discountPrice,
          //         ),
          //         currentPrice: widget.productDetails.product.price,
          //         discountPrice:
          //             widget.productDetails.product.discountPrice,
          //         color: widget.productDetails.product.colors.isNotEmpty &&
          //                 ref.read(selectedProductColorIndex) != null
          //             ? widget.productDetails.product
          //                 .colors[ref.read(selectedProductColorIndex)!].name
          //                 .toLowerCase()
          //             : '',
          //         productsQTY: 1,
          //         size: '',
          //         unit: '',
          //       );
          //       await cartBox.add(cartItem);
          //     },
          //   )
          // },
          // ],
          // );
        });
  }
}
