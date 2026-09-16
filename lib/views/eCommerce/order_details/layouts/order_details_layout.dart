import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_transparent_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/message/message_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/order/order_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/payment/payment_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/return_policy/return_policy_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/order/order_details_model.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/shop.dart'
    as shop;
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/components/address_card.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/components/build_payment_card.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/components/order_placed_dialog.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/components/pay_card.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/layouts/checkout_layout.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/layouts/web_payment_page.dart';
import 'package:ready_ecommerce/views/eCommerce/order_details/components/order_details_card.dart';
import 'package:ready_ecommerce/views/eCommerce/order_details/components/order_product_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/layouts/product_details_layout.dart';

import '../../../../models/eCommerce/order/order_model.dart';

class OrderDetailsLayout extends ConsumerStatefulWidget {
  final int orderId;
  const OrderDetailsLayout({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailsLayout> createState() => _OrderDetailsLayoutState();
}

// class _OrderDetailsLayoutState extends ConsumerState<OrderDetailsLayout> {
//   bool isConfirmLoading = false;
//   PaymentType selectedPaymentType = PaymentType.none;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(orderDetailsControllerProvider(widget.orderId));
//     });
//   }
//
//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     final asyncValue =
//         ref.watch(orderDetailsControllerProvider(widget.orderId));
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       backgroundColor: colors(context).accentColor,
//       appBar: AppBar(
//         title: Text(S.of(context).orderDetails),
//         surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//         actions: [
//           asyncValue.maybeWhen(
//             data: (orderDetails) {
//               final isReturnable = orderDetails.data.order.isReturnable;
//               debugPrint("isReturnable: $isReturnable");
//               return isReturnable == true
//                   ? GestureDetector(
//                       onTap: () {
//                         showDialog(
//                             barrierColor:
//                                 isDark ? Color(0x99000000) : Color(0x80000000),
//                             context: context,
//                             builder: (context) {
//                               final asyncValue = ref.watch(
//                                   orderDetailsControllerProvider(
//                                       widget.orderId));
//
//                               return asyncValue.maybeWhen(
//                                 data: (orderDetails) => Dialog(
//                                   clipBehavior: Clip.hardEdge,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12.r),
//                                   ),
//                                   child: Consumer(
//                                     builder: (context, ref, child) {
//                                       return SingleChildScrollView(
//                                         child: _buildServiceItemsWidget(
//                                             context,
//                                             orderDetails.data.order.products,
//                                             orderDetails.data.order.orderStatus,
//                                             true, (index) {
//                                           ref
//                                               .read(
//                                                   selectedReturnProductProvider
//                                                       .notifier)
//                                               .toggleProductSelection(
//                                                   orderDetails.data.order
//                                                       .products[index]);
//                                         }, true, widget.orderId, isDark, true),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 orElse: () => const SizedBox(),
//                               );
//                             });
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(right: 16.w),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4.r),
//                           border: Border.all(
//                             color: colors(context).primaryColor!,
//                           ),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 4),
//                         child: Text(
//                           "Return",
//                           style: AppTextStyle(context)
//                               .bodyText
//                               .copyWith(color: colors(context).primaryColor),
//                         ),
//                       ),
//                     )
//                   : SizedBox();
//             },
//             orElse: () => const SizedBox(),
//           )
//         ],
//       ),
//       bottomNavigationBar:
//           ref.watch(orderDetailsControllerProvider(widget.orderId)).when(
//                 data: (orderDetails) =>
//                     orderDetails.data.order.orderStatus.toLowerCase() !=
//                                 'cancelled' &&
//                             orderDetails.data.order.orderStatus.toLowerCase() !=
//                                 'confirm' &&
//                             orderDetails.data.order.orderStatus.toLowerCase() !=
//                                 'processing' &&
//                             orderDetails.data.order.orderStatus.toLowerCase() !=
//                                 'on the way'
//                         ? _buildBottomNavigationWidget(
//                             context: context,
//                             orderId: orderDetails.data.order.id,
//                             orderStatus: orderDetails.data.order.orderStatus,
//                           )
//                         : null,
//                 error: (error, s) => null,
//                 loading: () => const SizedBox(),
//               ),
//       body: Consumer(
//         builder: (context, ref, _) {
//           final asyncValue =
//               ref.watch(orderDetailsControllerProvider(widget.orderId));
//           return asyncValue.when(
//             data: (orderDetails) => SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Gap(8.h),
//                   _buildServiceItemsWidget(
//                       context,
//                       orderDetails.data.order.products,
//                       orderDetails.data.order.orderStatus,
//                       false,
//                       null,
//                       false,
//                       widget.orderId,
//                       isDark,
//                       false),
//                   Gap(8.h),
//                   _buildShopCardWidget(
//                     context: context,
//                     orderDetails: orderDetails,
//                   ),
//                   Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//                     child: AddressCard(
//                       address: orderDetails.data.order.address,
//                       cardColor: GlobalFunction.getContainerColor(),
//                     ),
//                   ),
//                   // Padding(
//                   //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                   //   child: OrderStatusTimeline(
//                   //       order: orderDetails.data.order,
//                   //   ),
//                   // ),
//
//                   OrderDetailsCard(
//                     orderDetails: orderDetails,
//                   ),
//                   Gap(8.h),
//                   Visibility(
//                     visible:
//                         orderDetails.data.order.paymentStatus == 'Pending' &&
//                             orderDetails.data.order.paymentMethod ==
//                                 'Online Payment',
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: CustomTransparentButton(
//                             buttonTextColor: colors(context).primaryColor,
//                             borderColor: colors(context).primaryColor,
//                             buttonText: 'Pay Now',
//                             onTap: () {
//                               showModalBottomSheet(
//                                 showDragHandle: true,
//                                 isScrollControlled: true,
//                                 backgroundColor: EcommerceAppColor.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(12.r),
//                                     topRight: Radius.circular(12.r),
//                                   ),
//                                 ),
//                                 barrierColor: colors(context)
//                                     .accentColor!
//                                     .withOpacity(0.8),
//                                 context: context,
//                                 builder: (context) {
//                                   return _buildPaymentBottomSheet();
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                         Gap(8.h),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             error: ((error, stackTrace) => Center(
//                   child: Text(error.toString()),
//                 )),
//             loading: () => const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildServiceItemsWidget(
//       BuildContext context,
//       List<Products> products,
//       String orderStatus,
//       bool? showCheckbox,
//       Function(int)? onTap,
//       bool? showButton,
//       int? orderId,
//       bool isDark,
//       bool hideReviewButton) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final selectedProducts = ref.watch(selectedReturnProductProvider);
//         final isEnableNextButton =
//             products.any((product) => product.isReturnable == true);
//         debugPrint("isEnableNextButton: $isEnableNextButton");
//         return Container(
//           padding: EdgeInsets.symmetric(
//             vertical: 14.h,
//           ),
//           color: showCheckbox == true && isDark
//               ? Colors.grey.withValues(alpha: 0.3)
//               : GlobalFunction.getContainerColor(),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               showCheckbox == true
//                   ? Center(
//                       child: Text(
//                         'Select Return Items',
//                         style: AppTextStyle(context)
//                             .subTitle
//                             .copyWith(fontSize: 16.sp),
//                       ),
//                     )
//                   : Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.w),
//                       child: Text(
//                         '${S.of(context).serviceItem} (${products.length})',
//                         style: AppTextStyle(context)
//                             .subTitle
//                             .copyWith(fontSize: 16.sp),
//                       ),
//                     ),
//               Gap(14.h),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final isProductReturnable = products[index].isReturnable;
//
//                   return Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: onTap == null
//                             ? null
//                             : () {
//                                 debugPrint("tap");
//
//                                 onTap(index);
//                               },
//                         child: OrderProductCard(
//                           hideReviewButton: hideReviewButton,
//                           orderId: widget.orderId,
//                           product: products[index],
//                           orderStatus: orderStatus,
//                           index: index,
//                           showCheckbox: showCheckbox,
//                           isSelected:
//                               selectedProducts.contains(products[index]),
//                         ),
//                       ),
//                       if (isProductReturnable == false && showCheckbox == true)
//                         Center(
//                           child: Container(
//                             margin: EdgeInsets.only(top: 10.h),
//                             height: 100.h,
//                             width: ScreenUtil().screenWidth / 1.2,
//                             color: Colors.grey.withOpacity(0.4),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//               Gap(30.h),
//               if (showButton == true)
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             top: BorderSide(
//                               color: colors(context).accentColor!,
//                               width: 2.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Gap(24.h),
//                       CustomButton(
//                           buttonText: "Next",
//                           buttonColor: isEnableNextButton == true
//                               ? colors(context).primaryColor
//                               : colors(context).primaryColor!.withOpacity(0.5),
//                           onPressed: isEnableNextButton == true
//                               ? () {
//                                   if (selectedProducts.isEmpty) {
//                                     Fluttertoast.showToast(
//                                       msg: S.of(context).pleaseSelectOneProduct,
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.BOTTOM,
//                                       timeInSecForIosWeb: 1,
//                                       backgroundColor: Colors.red,
//                                       textColor: Colors.white,
//                                       fontSize: 16.0,
//                                     );
//                                     return;
//                                   }
//                                   context.nav.pop();
//                                   context.nav.pushNamed(
//                                     Routes.getReturnPolicyProductViewRouteName(
//                                       AppConstants.appServiceName,
//                                     ),
//                                     arguments: widget.orderId,
//                                   );
//                                 }
//                               : null),
//                     ],
//                   ),
//                 )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildShopCardWidget({
//     required BuildContext context,
//     required OrderDetails orderDetails,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
//       color: GlobalFunction.getContainerColor(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(S.of(context).shoppingFrom,
//               style: AppTextStyle(context).bodyTextSmall),
//           Gap(10.h),
//           Row(
//             children: [
//               Expanded(
//                 child: Material(
//                   borderRadius: BorderRadius.circular(8.r),
//                   color: EcommerceAppColor.offWhite,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(8.r),
//                     onTap: () {
//                       // showDialog(
//                       //   context: context,
//                       //   builder: (context) => const SellerReviewDialog(),
//                       // );
//                     },
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                       decoration: BoxDecoration(
//                         color: colors(context).accentColor,
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Row(
//                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             flex: 7,
//                             child: SizedBox(
//                               child: Row(
//                                 children: [
//                                   Flexible(
//                                     flex: 2,
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(5.r),
//                                       child: CachedNetworkImage(
//                                         imageUrl:
//                                             orderDetails.data.order.shop.logo,
//                                         height: 24.h,
//                                         width: 24.w,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                   Gap(10.w),
//                                   Flexible(
//                                     flex: 5,
//                                     child: Text(
//                                       orderDetails.data.order.shop.name,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: AppTextStyle(context)
//                                           .bodyTextSmall
//                                           .copyWith(
//                                               fontWeight: FontWeight.w600),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           Flexible(
//                             flex: 2,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Icon(
//                                   Icons.star_rounded,
//                                   color: EcommerceAppColor.carrotOrange,
//                                   size: 20.sp,
//                                 ),
//                                 Gap(5.w),
//                                 Text(
//                                   orderDetails.data.order.shop.rating
//                                       .toString(),
//                                   style: AppTextStyle(context)
//                                       .bodyTextSmall
//                                       .copyWith(fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(10.w),
//               GestureDetector(
//                 onTap: () async {
//                   final saveUser =
//                       await ref.read(hiveServiceProvider).getUserInfo();
//                   final shopModel = shop.Shop(
//                     id: orderDetails.data.order.shop.id,
//                     name: orderDetails.data.order.shop.name,
//                     logo: orderDetails.data.order.shop.logo,
//                   );
//
//                   ref
//                       .read(storeMessageControllerProvider.notifier)
//                       .storeMessage(
//                         shopId: orderDetails.data.order.shop.id,
//                         userId: saveUser!.id!,
//
//                         // productId: productDetails.product.id,
//                       );
//
//                   context.nav.pushNamed(
//                     Routes.getChatViewRouteName(AppConstants.appServiceName),
//                     arguments: shopModel,
//                   );
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(6.r),
//                   decoration: BoxDecoration(
//                     color: colors(context).primaryColor!.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: SvgPicture.asset(
//                     Assets.svg.message,
//                     color: colors(context).primaryColor,
//                     // width: 16.w,
//                     // height: 16.h,
//                   ),
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigationWidget(
//       {required BuildContext context,
//       required int orderId,
//       required String orderStatus}) {
//     return Consumer(builder: (context, ref, _) {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//         height: 86.h,
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: orderStatus.toLowerCase() == 'pending'
//             ? CustomTransparentButton(
//                 buttonText: S.of(context).cancelOrder,
//                 borderColor: colors(context).accentColor,
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) => ConfirmationDialog(
//                       title: S.of(context).areYouSureWantToCancelOrder,
//                       confirmButtonText: S.of(context).confirm,
//                       isLoading: ref.watch(orderControllerProvider),
//                       onPressed: () {
//                         ref
//                             .read(orderControllerProvider.notifier)
//                             .cancelOrder(orderId: orderId)
//                             .then((response) {
//                           final data = ref
//                               .refresh(orderDetailsControllerProvider(orderId));
//                           debugPrint(data.toString());
//                           return context.nav.pop();
//                         });
//                       },
//                     ),
//                   );
//                 },
//               )
//             : orderStatus.toLowerCase() == 'delivered'
//                 ?
//                 //  ref.watch(orderControllerProvider)
//                 //     ? const Center(child: CircularProgressIndicator())
//                 //     :
//                 CustomButton(
//                     buttonText: S.of(context).orderAgain,
//                     onPressed: () => _showPaymentBottomSheet(context, orderId),
//                   )
//                 : const SizedBox.shrink(),
//       );
//     });
//   }
//
//   Widget _buildPaymentBottomSheet() {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 16.h),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Consumer(builder: (context, ref, _) {
//             return ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               shrinkWrap: true,
//               itemCount: ref
//                   .read(masterControllerProvider.notifier)
//                   .materModel
//                   .data
//                   .paymentGateways
//                   .length,
//               itemBuilder: ((context, index) {
//                 final paymentGateway = ref
//                     .read(masterControllerProvider.notifier)
//                     .materModel
//                     .data
//                     .paymentGateways[index];
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: 7.h),
//                   child: PaymentCard(
//                     paymentGateways: paymentGateway,
//                     isActive: ref.watch(selectedPayment) == paymentGateway.name,
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         barrierColor:
//                             colors(context).accentColor!.withOpacity(0.8),
//                         builder: (_) => LoadingWrapperWidget(
//                           isLoading: ref.watch(paymentControllerProvider),
//                           child: Container(),
//                         ),
//                       );
//                       ref.read(selectedPayment.notifier).state =
//                           paymentGateway.name;
//
//                       ref
//                           .read(paymentControllerProvider.notifier)
//                           .orderPayment(
//                             orderId: widget.orderId,
//                             paymentMethod: ref.read(selectedPayment),
//                           )
//                           .then((paymentUrl) {
//                         ref.refresh(selectedPayment.notifier).state;
//                         if (paymentUrl != null) {
//                           context.nav.pop();
//                           context.nav.popAndPushNamed(
//                             Routes.webPaymentScreen,
//                             arguments: WebPaymentScreenArg(
//                               paymentUrl: paymentUrl,
//                               orderId: widget.orderId,
//                             ),
//                           );
//                         } else {
//                           Navigator.of(context)
//                             ..pop()
//                             ..pop();
//                           GlobalFunction.showCustomSnackbar(
//                             message: 'Something went wrong!',
//                             isSuccess: false,
//                           );
//                         }
//                       });
//                     },
//                   ),
//                 );
//               }),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToBePaidWidget({
//     required PaymentType selectedPaymentType,
//     required Function(PaymentType) onPaymentTypeChanged,
//   }) {
//     final masterData = ref.watch(masterControllerProvider.notifier).materModel;
//     bool isCashonDeliveryEnable = masterData.data.cashOnDelivery;
//     bool isOnlinePaymentEnable = masterData.data.onlinePayment;
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               child: Row(
//                 children: [
//                   SvgPicture.asset(Assets.svg.receipt),
//                   Gap(8.w),
//                   Text(
//                     S.of(context).toBePaid,
//                     style: AppTextStyle(context).subTitle,
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               GlobalFunction.price(
//                 ref: ref,
//                 price:
//                     ref.read(cartSummeryController)['payableAmount'].toString(),
//               ),
//               style: AppTextStyle(context).subTitle,
//             )
//           ],
//         ),
//         Gap(10.h),
//         Row(
//           children: [
//             if (isCashonDeliveryEnable)
//               Flexible(
//                 flex: 1,
//                 child: PayCard(
//                   isActive: selectedPaymentType == PaymentType.cash,
//                   type: S.of(context).cashOnDelivery,
//                   image: Assets.png.cash.image(),
//                   onTap: () {
//                     if (selectedPaymentType != PaymentType.cash) {
//                       onPaymentTypeChanged(PaymentType.cash);
//                     }
//                   },
//                 ),
//               ),
//             Gap(10.w),
//             if (isOnlinePaymentEnable)
//               Flexible(
//                 flex: 1,
//                 child: PayCard(
//                   isActive: selectedPaymentType == PaymentType.online,
//                   type: S.of(context).creditOrDebitCard,
//                   image: Assets.png.card.image(),
//                   onTap: () {
//                     if (selectedPaymentType != PaymentType.online) {
//                       onPaymentTypeChanged(PaymentType.online);
//                     }
//                   },
//                 ),
//               )
//           ],
//         ),
//       ],
//     );
//   }
//
//   void _showPaymentBottomSheet(BuildContext context, int orderId) {
//     showModalBottomSheet(
//       // isScrollControlled: true,
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setModalState) {
//           return SizedBox(
//             //  height: 400.h,
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           _buildToBePaidWidget(
//                             selectedPaymentType: selectedPaymentType,
//                             onPaymentTypeChanged: (PaymentType newType) {
//                               setModalState(() {
//                                 selectedPaymentType = newType;
//                                 debugPrint(
//                                     'selectedPaymentType: $selectedPaymentType');
//                               });
//                             },
//                           ),
//                           if (selectedPaymentType == PaymentType.online) ...[
//                             _buildPaymentMethodsWidget(setModalState)
//                             // const CircularProgressIndicator(),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                   Gap(8.h),
//                   isConfirmLoading
//                       ? CircularProgressIndicator()
//                       : CustomButton(
//                           buttonText: S.of(context).placeOrder,
//                           onPressed: () {
//                             {
//                               setModalState(() {
//                                 isConfirmLoading = true;
//                               });
//                               ref
//                                   .read(orderControllerProvider.notifier)
//                                   .orderAgain(
//                                     orderId: orderId,
//                                     paymentMethod: selectedPaymentType ==
//                                             PaymentType.online
//                                         ? ref.read(selectedPayment)
//                                         : selectedPaymentType.name,
//                                   )
//                                   .then(
//                                 (response) {
//                                   setModalState(() {
//                                     isConfirmLoading = false;
//                                   });
//                                   debugPrint(
//                                       "responseSuccess ${response.message}");
//                                   if (response.isSuccess == true) {
//                                     ref.invalidate(isProfileVefifySuccess);
//                                     ref
//                                         .read(cartController.notifier)
//                                         .getAllCarts();
//                                     ref
//                                         .refresh(
//                                             selectedTabIndexProvider.notifier)
//                                         .state;
//                                     ref.invalidate(selectedPayment);
//                                     showDialog(
//                                       context: context,
//                                       barrierColor: colors(context)
//                                           .accentColor!
//                                           .withOpacity(0.8),
//                                       builder: (context) => OrderPlacedDialog(
//                                         customButton: response.data == null
//                                             ? null
//                                             : CustomButton(
//                                                 buttonText:
//                                                     S.of(context).makePayment,
//                                                 onPressed: () {
//                                                   context.nav
//                                                       .pushNamedAndRemoveUntil(
//                                                     Routes.webPaymentScreen,
//                                                     (route) => false,
//                                                     arguments:
//                                                         WebPaymentScreenArg(
//                                                       paymentUrl: response.data,
//                                                       orderId: null,
//                                                     ),
//                                                   );
//                                                 }),
//                                       ),
//                                     );
//                                   } else {
//                                     context.nav.pop();
//                                   }
//                                 },
//                               );
//                             }
//                           })
//                 ],
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }
//
//   Widget _buildPaymentMethodsWidget(
//       void Function(void Function()) setModalState) {
//     final selectedPaymentMethod = ref.watch(selectedPayment);
//     return SizedBox(
//       child: ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.only(top: 16.h),
//         shrinkWrap: true,
//         itemCount: ref
//             .read(masterControllerProvider.notifier)
//             .materModel
//             .data
//             .paymentGateways
//             .length,
//         itemBuilder: (context, index) {
//           final paymentMethod = ref
//               .read(masterControllerProvider.notifier)
//               .materModel
//               .data
//               .paymentGateways[index];
//           return Padding(
//             padding: EdgeInsets.only(bottom: 10.h),
//             child: PaymentCard(
//               onTap: () {
//                 setModalState(() {
//                   ref.read(selectedPayment.notifier).state = paymentMethod.name;
//                 });
//               },
//               isActive: selectedPaymentMethod == paymentMethod.name,
//               paymentGateways: paymentMethod,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


///-------------------
class _OrderDetailsLayoutState
    extends ConsumerState<OrderDetailsLayout> {
  bool isConfirmLoading = false;
  PaymentType selectedPaymentType = PaymentType.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderDetailsControllerProvider(widget.orderId));
    });
  }
  PreferredSizeWidget _buildAppBar({required BuildContext context}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.h), // Set your desired height here
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .95,
            child: Row(
              children: [
                Gap(20.w),
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: colors(context).accentColor,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      context.nav.pop();
                    },
                  ),
                ),
                Gap(75.w), // Add spacing
                Text("Track Order",
                  style:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final asyncValue =
    ref.watch(orderDetailsControllerProvider(widget.orderId));

    return Scaffold(
      // backgroundColor: colors(context).accentColor,

      /// 🔹 APP BAR
      appBar: _buildAppBar(context: context),

      /// 🔹 BODY
      body: asyncValue.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (orderDetails) {
          final order = orderDetails.data.order;

          return SingleChildScrollView(
            child: Column(
              children: [
                Gap(12.h),

                /// 🟢 ORDER DETAILS CARD (NEW)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildOrderInfoCard(order),
                ),

                Gap(12.h),

                /// 🟢 ORDER STATUS TIMELINE (NEW)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: OrderStatusTimeline(order: order),
                ),

                Gap(12.h),

                /// 🔹 PRODUCTS LIST (EXISTING)
                _buildServiceItemsWidget(
                  context,
                  order.products,
                  order.orderStatus,
                  false,
                  null,
                  false,
                  widget.orderId,
                  false,
                  false,
                ),

                Gap(12.h),

                /// 🔹 ADDRESS CARD (EXISTING)
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                //   child: AddressCard(
                //     address: order.address,
                //     cardColor:
                //     GlobalFunction.getContainerColor(),
                //   ),
                // ),

                // Gap(12.h),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===================== ORDER DETAILS CARD =====================

  Widget _buildOrderInfoCard(order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 0), // 🔑 important
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Details",
            style: TextStyle(
              color: const Color(0xFF439400),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(12.h),
          _infoRow("Expected delivery date", "22 Nov 2026"),
          _infoRow("Order Number", order.orderCode),
          _infoRow("Tracking ID", "SN1234567"),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
              TextStyle(color: Colors.grey,fontWeight: FontWeight.w400, fontSize: 12.sp)),
          Text(value,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ===================== SERVICE ITEMS (UNCHANGED) =====================

  Widget _buildServiceItemsWidget(
      BuildContext context,
      List<Products> products,
      String orderStatus,
      bool? showCheckbox,
      Function(int)? onTap,
      bool? showButton,
      int? orderId,
      bool isDark,
      bool hideReviewButton,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 0), // 🔑 important
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w),
            //   child: Text(
            //     "Products (${products.length})",
            //     style: AppTextStyle(context)
            //         .subTitle
            //         .copyWith(fontSize: 16.sp),
            //   ),
            // ),

            // Gap(12.h),

            /// 🔹 PRODUCT LIST
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(
                  height: 24.h,
                  color: Colors.grey.shade300,
                ),
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🖼 PRODUCT IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: product.thumbnail ?? '',
                              height: 78.w,
                              width: 82.w,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Gap(35.w),

                          /// 📝 PRODUCT DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Gap(4.h),

                                if (product.color != null)
                                  Text(
                                    "Color: ${product.color}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),

                                if (product.size != null)
                                  Text(
                                    "Size: ${product.size}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),

                                Gap(2.h),

                                Text(
                                  GlobalFunction.price(
                                    ref: ref,
                                    price: product.price.toString(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          /// 🔢 QTY
                          // Text(
                          //   "Qty:${product.orderQty}",
                          //   style: TextStyle(
                          //     fontSize: 12.sp,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),


                          Divider(color: Color(0xffD9D9D9),)
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: Text(
                        "Qty:${product.orderQty}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

// class OrderStatusTimeline extends StatelessWidget {
//   final Order order;
//   const OrderStatusTimeline({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     final statuses = [
//       "Order Status",
//       "In Progress",
//       "Shipped",
//       "Delivered",
//     ];
//
//     final currentIndex = _currentIndex(order.orderStatus);
//
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 30,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Order Status",
//             style: TextStyle(
//               color: const Color(0xFF6BAE00),
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           Gap(16.h),
//           ...List.generate(statuses.length, (index) {
//             return _timelineTile(
//               title: statuses[index],
//               subtitle: index < currentIndex
//                   ? "18 Nov 2024, 10:00PM"
//                   : index == 2
//                   ? "Expected 18 Nov 2024"
//                   : "22 Nov 2024",
//               isCompleted: index <= currentIndex,
//               isLast: index == statuses.length - 1,
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   int _currentIndex(String status) {
//     switch (status.toLowerCase()) {
//       case 'processing':
//         return 1;
//       case 'shipped':
//         return 2;
//       case 'delivered':
//         return 3;
//       default:
//         return 0;
//     }
//   }
//
//   Widget _timelineTile({
//     required String title,
//     required String subtitle,
//     required bool isCompleted,
//     required bool isLast,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               width: 22,
//               height: 22,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isCompleted
//                     ? const Color(0xFFFF7A00)
//                     : Colors.grey.shade300,
//               ),
//               child: isCompleted
//                   ? const Icon(Icons.check,
//                   size: 14, color: Colors.white)
//                   : null,
//             ),
//             if (!isLast)
//               Container(
//                 width: 2,
//                 height: 36,
//                 color: isCompleted
//                     ? const Color(0xFFFF7A00)
//                     : Colors.grey.shade300,
//               ),
//           ],
//         ),
//         Gap(12.w),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: isCompleted
//                     ? const Color(0xFF6BAE00)
//                     : Colors.grey,
//               ),
//             ),
//             Gap(2.h),
//             Text(
//               subtitle,
//               style:
//               TextStyle(fontSize: 11.sp, color: Colors.grey),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }


///-------------------
class OrderStatusTimeline extends StatelessWidget {
  final Order order;

  const OrderStatusTimeline({
    super.key,
    required this.order,
  });

  int _currentIndex() {
    switch (order.orderStatus.toLowerCase()) {
      // case 'confirmed':
      case 'pending':
      case 'order status':
        return 0;
      case 'confirm':
      case 'in progress':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _currentIndex();

    final steps = [
      _StatusItem(
        title: "Order Status",
        subtitle: _formatDate(order.createdAt),
        icon: 'assets/svg/pending.svg',
      ),
      _StatusItem(
        title: "In Progress",
        subtitle: _formatDate(order.createdAt ?? order.createdAt),
        icon: 'assets/svg/process.svg',
      ),
      // _StatusItem(
      //   title: "Shipped",
      //   subtitle: order.shippedAt != null
      //       ? _formatDate(order.shippedAt!)
      //       : "Expected ${_formatDate(order.expectedDeliveryDate)}",
      //   icon: Icons.local_shipping_outlined,
      // ),
      _StatusItem(
        title: "Shipped",
        subtitle: "",
        icon: 'assets/svg/shipped.svg',
      ),
      // _StatusItem(
      //   title: "Delivered",
      //   subtitle: order.deliveredAt != null
      //       ? _formatDate(order.deliveredAt!)
      //       : _formatDate(order.expectedDeliveryDate),
      //   icon: Icons.handshake_outlined,
      // ),
      _StatusItem(
        title: "Delivered",
        subtitle: "",
        icon: 'assets/svg/delivered.svg',
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 0), // 🔑 important
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Status",
            style: TextStyle(
              color: Colors.green,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(16.h),

          Column(
            children: List.generate(steps.length, (index) {
              return _TimelineRow(
                item: steps[index],
                isActive: index <= currentStep,
                showLine: index != steps.length - 1,
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 📅 DATE FORMATTER
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "";

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (_) {
      return date; // fallback if parsing fails
    }
  }

}

class _TimelineRow extends StatelessWidget {
  final _StatusItem item;
  final bool isActive;
  final bool showLine;

  const _TimelineRow({
    required this.item,
    required this.isActive,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT INDICATOR
        Column(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.orange : Colors.grey.shade300,
              ),
              child: Center(
                child: Icon( Icons.check,
                  size: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, ),
              ),
            ),
            if (showLine)
              Container(
                width: 3,
                height: 40.h,
                color: isActive ? Colors.orange : Colors.grey.shade300,
              ),
          ],
        ),

        Gap(12.w),

        /// TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),
              Gap(4.h),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
              Gap(20.h),
            ],
          ),
        ),

        /// RIGHT SVG ICON
        SvgPicture.asset(
          item.icon,
          width: 30.w,
          height: 30.w,
          colorFilter:
          const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
        ),
      ],
    );
  }
}

class _StatusItem {
  final String title;
  final String subtitle;
  final String icon;

  _StatusItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
