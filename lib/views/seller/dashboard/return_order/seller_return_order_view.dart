import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/return_order/return_order_model.dart';
import 'package:ready_ecommerce/providers/seller/return_orders_provider.dart'; // We'll create this
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/dashboard/return_order/components/order_update_status.dart';

class SellerReturnOrdersView extends ConsumerWidget {
  const SellerReturnOrdersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnOrdersAsync = ref.watch(sellerReturnOrdersProvider);

    return Scaffold(
      backgroundColor: colors(context).accentColor,
      appBar: AppBar(
        title: Text("Return Orders", style: AppTextStyle(context).appBarText),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: returnOrdersAsync.when(
        data: (data) {
          if (data.returnOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.keyboard_return_outlined,
                      size: 80.sp, color: Colors.grey),
                  Gap(16.h),
                  Text(
                    "No Return Orders Yet!",
                    style: AppTextStyle(context)
                        .subTitle
                        .copyWith(color: Colors.grey),
                  ),
                  Gap(8.h),
                  Text(
                    "Return requests will appear here",
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: data.returnOrders.length,
            itemBuilder: (context, index) {
              final order = data.returnOrders[index];
              return _ReturnOrderCard(order: order);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 60.sp, color: colors(context).errorColor),
              Gap(16.h),
              Text("Failed to load return orders",
                  style: AppTextStyle(context).subTitle),
              Gap(8.h),
              Text("$error", style: AppTextStyle(context).bodyTextSmall),
              Gap(16.h),
              ElevatedButton(
                onPressed: () => ref.invalidate(sellerReturnOrdersProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Card for each return order
class _ReturnOrderCard extends StatelessWidget {
  final ReturnOrder order; // Assume you have a model class for this

  const _ReturnOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order: ${order.orderId}",
                  style: AppTextStyle(context).text16B700,
                ),
                Gap(50),
                GlobalFunction.getReturnStatusWidget(
                  context: context,
                  status: order.status,
                ),
                IconButton(
                  icon: Icon(Icons.remove_red_eye_outlined,
                      color: colors(context).primaryColor, size: 22.sp),
                  tooltip: 'View Return Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellerReturnOrderDetailView(
                            returnOrderId: order.id),
                      ),
                    );
                  },
                ),
              ],
            ),
            Gap(8.h),
            Text("Reason: ${order.reason}",
                style: AppTextStyle(context).bodyText),
            Gap(8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Amount: \$${order.amount.toStringAsFixed(2)}",
                        style: AppTextStyle(context).text14B700),
                    Gap(4.h),
                    Text("Quantity: ${order.quantity}",
                        style: AppTextStyle(context).bodyTextSmall),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Date: ${order.returnDate}",
                        style: AppTextStyle(context).bodyTextSmall),
                    Gap(4.h),
                    Text("Payment: ${order.paymentStatus}",
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: order.paymentStatus == "Paid"
                                  ? Colors.green
                                  : Colors.red,
                            )),
                  ],
                ),
              ],
            ),
            if (order.rejectNote != null && order.rejectNote!.isNotEmpty) ...[
              Gap(12.h),
              Text("Reject Note: ${order.rejectNote}",
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(color: Colors.red)),
            ],
            Gap(8.h),
            Text("Return Address: ${order.returnAddress}",
                style: AppTextStyle(context).bodyTextSmall),
          ],
        ),
      ),
    );
  }
}
