import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/order/order_model.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

// class MyOrderCard extends StatelessWidget {
//   final OrderModel order;
//   const MyOrderCard({
//     super.key,
//     required this.order,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 3.h),
//       child: Material(
//         color: GlobalFunction.getContainerColor(),
//         child: InkWell(
//           onTap: () {
//             context.nav.pushNamed(
//               Routes.getOrderDetailsViewRouteName(AppConstants.appServiceName),
//               arguments: order.id,
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 14.w,
//               vertical: 20.h,
//             ),
//             margin: EdgeInsets.only(top: 3.h),
//             width: double.infinity,
//             child: Column(
//               children: [
//                 _buildAddressCardWidget(context),
//                 Gap(14.h),
//                 _buildRowWidget(
//                   context: context,
//                   key: S.of(context).orderId,
//                   value: order.orderCode,
//                 ),
//                 Gap(14.h),
//                 _buildRowWidget(
//                   context: context,
//                   key: S.of(context).date,
//                   value: DateFormat('d MMMM yyyy').format(
//                     DateTime.parse(order.createdAt),
//                   ),
//                 ),
//                 Gap(14.h),
//                 _buildRowWidget(
//                   context: context,
//                   key: S.of(context).amount,
//                   value: order.amount,
//                   isAmount: true,
//                 ),
//                 Gap(14.h),
//                 _buildRowWidget(
//                   context: context,
//                   key: S.of(context).status,
//                   value: order.orderStatus.toLowerCase(),
//                   isOrderStatus: true,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRowWidget({
//     required BuildContext context,
//     required String key,
//     required dynamic value,
//     bool isAmount = false,
//     bool isOrderStatus = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           key,
//           style: AppTextStyle(context).bodyTextSmall,
//         ),
//         if (isOrderStatus) ...[
//           GlobalFunction.getStatusWidget(context: context, status: value)
//         ] else ...[
//           Consumer(builder: (context, ref, _) {
//             return Text(
//               isAmount
//                   ? GlobalFunction.price(ref: ref, price: value.toString())
//                   : value.toString(),
//               style: AppTextStyle(context).bodyText,
//             );
//           }),
//         ]
//       ],
//     );
//   }
//
//   Widget _buildAddressCardWidget(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: colors(context).accentColor,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         children: [
//           Flexible(flex: 1, child: SvgPicture.asset(Assets.svg.fillLocation)),
//           Gap(5.w),
//           Flexible(
//             flex: 8,
//             child: Text(
//               GlobalFunction.formatDeliveryAddress(
//                 context: context,
//                 address: order.address,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
///------------------

class MyOrderCard extends ConsumerWidget {
  final OrderModel order;

  const MyOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          context.nav.pushNamed(
            Routes.getOrderDetailsViewRouteName(AppConstants.appServiceName),
            arguments: order.id,
          );
        },
        child: Container(
          padding: EdgeInsets.all(18.w),
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
              /// 🔹 ORDER NUMBER
              Text(
                "Order No.#${order.orderCode}",
                style: TextStyle(
                  color: const Color(0xFF439400),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              Gap(15.h),

              /// 🔹 ROW-WISE DETAILS (DITTO IMAGE)
              _infoRow(
                title: "Order Date",
                value: DateFormat('dd.MM.yyyy')
                    .format(DateTime.parse(order.createdAt)),
              ),
              Gap(10.h),
              _infoRow(
                title: "Deliver To",
                value: order.address.name ?? "-",
              ),
              Gap(10.h),
              _infoRow(
                title: "Total Items",
                value: order.quantity.toString(),
              ),
              Gap(10.h),
              _infoRow(
                title: "Total Cost",
                value: GlobalFunction.price(
                  ref: ref,
                  price: order.amount.toString(),
                ),
                bold: true,
              ),

              Gap(10.h),

              /// 🔹 DIVIDER
              Divider(color: Colors.grey.shade300),

              Gap(10.h),

              /// 🔹 STATUS + ACTION
              Row(
                children: [
                  _statusChip(order.orderStatus),
                  const Spacer(),
                  _actionButton(
                    context,
                    status: order.orderStatus,
                    orderId: order.id,
                    onReOrder: () {
                      _handleReOrder(context, ref, order);
                    },
                    onTrackOrder: () {
                      _handleTrackOrder(context, order.id);
                    },
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 INFO ROW (LEFT LABEL – RIGHT VALUE)
  Widget _infoRow({
    required String title,
    required String value,
    bool bold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// 🔹 STATUS CHIP
  Widget _statusChip(String status) {
    final s = status.toLowerCase();

    Color bgColor;
    Color textColor;

    if (s == 'delivered') {
      bgColor = const Color(0xFFE6F7E9);
      textColor = const Color(0xFF2E7D32);
    } else if (s == 'pending') {
      bgColor = const Color(0xFFFFF3E0);
      textColor = const Color(0xFFFF9800);
    } else if (s == 'cancelled') {
      bgColor = const Color(0xFFFFE0E6);
      textColor = const Color(0xFFFF001E);
    } else {
      bgColor = const Color(0xFFE3F2FD);
      textColor = const Color(0xFF1976D2);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.capitalize(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// 🔹 ACTION BUTTON
  Widget _actionButton(
      BuildContext context, {
        required String status,
        required int orderId,
        required VoidCallback onReOrder,
        required VoidCallback onTrackOrder,
      }) {
    final isDelivered = status.toLowerCase() == 'delivered';

    return GestureDetector(
      onTap: isDelivered ? onReOrder : onTrackOrder,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFF5722),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          isDelivered ? "Re-Order" : "Track Order",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleReOrder(
      BuildContext context,
      WidgetRef ref,
      OrderModel order,
      ) async {
    try {
      // Example: loop through old order items
      // for (final item in order.products) {
      //   await ref.read(cartControllerProvider.notifier).addToCart(
      //     productId: item.productId,
      //     quantity: item.quantity,
      //   );
      // }
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Items added to cart")),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to re-order")),
      );
      //
      // // Navigate to cart
      // context.nav.pushNamed(
      //   Routes.getCartViewRouteName(AppConstants.appServiceName),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to re-order")),
      );
    }
  }
  void _handleTrackOrder(BuildContext context, int orderId) {
    context.nav.pushNamed(
      Routes.getOrderDetailsViewRouteName(AppConstants.appServiceName),
      arguments: orderId,
    );
  }



}


/// 🔹 STRING EXTENSION
extension StringCap on String {
  String capitalize() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}
