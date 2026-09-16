import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/order/order_filter_model.dart';
import 'package:ready_ecommerce/models/seller/order/order_model.dart';
import 'package:ready_ecommerce/providers/seller/order_provider.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/screens/orders.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/item_card.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';

class OrderDetailsBottomSheet extends StatelessWidget {
  final SellerOrder order;
  const OrderDetailsBottomSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return Consumer(
      builder: (context, ref, _) {
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.3,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: colors(context).containerColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'New Order',
                      style: style.title.copyWith(fontSize: 24.sp),
                    ),
                    Gap(12.h),
                    Divider(
                      height: 0,
                      thickness: 1,
                      color: colors(context).accentColor,
                    ),
                    Gap(16.h),
                    _buildOrderItemsWidget(context),
                    Gap(20.h),
                    RichText(
                      text: TextSpan(
                        text: 'Order ID: ',
                        style: style.title.copyWith(
                          color: colors(context).primaryColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: order.orderCode,
                            style: style.title.copyWith(
                              color: colors(context).primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.h),
                    _buildOrderSummaryWidget(context),
                    Gap(12.h),
                    _buildShippingInfoWidget(context),
                    Gap(24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ref.watch(orderStatusProvider)
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              color: EcommerceAppColor.green,
                              buttonName: 'Confirm Order',
                              onTap: () {
                                ref
                                    .read(orderStatusProvider.notifier)
                                    .updateOrderStatus(
                                      orderId: order.id,
                                      // status: 'confirm',
                                      status: order.orderStatus,
                                    )
                                    .then((response) {
                                  GlobalFunction.showCustomSnackbar(
                                    message: response.message,
                                    isSuccess: response.status,
                                  );
                                  ref.read(orderServiceProvider.notifier).getOrders(
                                        filter: OrderFilterModel(
                                          page: 1,
                                          perPage: 20,
                                          status: ref.read(selectedOrderStatusProvider),
                                        ),
                                      );
                                  // Replaced context.pop()
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                    ),
                    Gap(12.h),
                    TextButton(
                      onPressed: () {
                        // Replaced context.pop()
                        Navigator.of(context).pop();
                        // Replaced context.push()
                        Navigator.of(context).pushNamed(
                          Routes.sellerOrderDetails, 
                          arguments: order.id
                        );
                      },
                      child: Text(
                        'View Full Details',
                        style: style.buttonText.copyWith(
                          color: colors(context).primaryColor,
                        ),
                      ),
                    ),
                    Gap(16.h),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 8.w,
              top: 8.h,
              child: IconButton(
                // Replaced context.pop()
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: colors(context).bodyTextColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ... rest of the helper widgets remain the same as they don't use navigation ...
  Widget _buildOrderItemsWidget(BuildContext context) {
    final style = AppTextStyle(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: colors(context).accentColor?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'Order Items (${order.products.length})',
              style: style.bodyText.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Gap(8.h),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.products.length,
            itemBuilder: (context, index) => ItemCard(product: order.products[index]),
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
              indent: 12,
              endIndent: 12,
              color: colors(context).secondaryColor?.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors(context).accentColor?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildInfoRowWidget(context, key: 'Order Placed', value: order.orderPlaced),
          Gap(12.h),
          _buildInfoRowWidget(context, key: 'Delivery Date', value: order.estimatedDeliveryDate),
          Gap(12.h),
          _buildInfoRowWidget(context, key: 'Total Amount', value: '\$${order.amount}'),
          Gap(12.h),
          _buildInfoRowWidget(context, key: 'Payment via', value: order.paymentMethod),
        ],
      ),
    );
  }

  Widget _buildShippingInfoWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Address:',
            style: AppTextStyle(context).bodyText.copyWith(fontWeight: FontWeight.w700),
          ),
          Gap(8.h),
          _buildShippingInfoCardWidget(context),
        ],
      ),
    );
  }

  Widget _buildShippingInfoCardWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border.all(color: colors(context).accentColor!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, 
               color: colors(context).primaryColor, size: 20.sp),
          Gap(8.w),
          Expanded(
            child: Text(
              GlobalFunction.getFormattedAddress(order.user.address),
              style: AppTextStyle(context).bodyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWidget(BuildContext context, {required String key, required String value}) {
    final style = AppTextStyle(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: style.bodyText.copyWith(color: EcommerceAppColor.gray)),
        Text(value, style: style.bodyText.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}