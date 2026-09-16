import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

import 'package:ready_ecommerce/models/seller/order/order_model.dart';
import 'package:ready_ecommerce/providers/seller/order_provider.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/invoice_download_widget.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/item_card.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/order_status_widget.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/views/seller/widgets/transparent_button.dart';

class OrderDetails extends ConsumerStatefulWidget {
  final int orderId;
  const OrderDetails(this.orderId, {super.key});

  @override
  ConsumerState<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends ConsumerState<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: GlobalFunction.appLocale(slref: ref) == 'ar' ? 0 : 16.w,
              left: GlobalFunction.appLocale(slref: ref) == 'ar' ? 16.w : 0,
            ),
            child: ref
                .watch(orderDetailsServiceProvider(widget.orderId))
                .whenOrNull(
                  data: (data) => OrderStatusWidget(orderStatus: data.orderStatus),
                  error: (error, stackTrace) => Text(error.toString()),
                ),
          ),
        ],
      ),
      bottomNavigationBar: ref
          .watch(orderDetailsServiceProvider(widget.orderId))
          .whenOrNull(
            data: (data) =>
                data.orderStatus == 'Pending' || data.orderStatus == 'Confirm' || data.orderStatus == 'Pickup'|| data.orderStatus == 'To Delivery'
                    ? _buildBottomNavigationBar() : null,
          ),
      body: ref.watch(orderDetailsServiceProvider(widget.orderId)).when(
            data: (orderDetails) => SingleChildScrollView(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOrderItemsWidget(order: orderDetails),
                  Gap(14.h),
                  _buildOrderSummaryWidget(order: orderDetails),
                  Gap(8.h),
                  _buildShippingInfoWidget(order: orderDetails),
                  Gap(12.h),
                ],
              ),
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }

  Widget _buildOrderItemsWidget({required SellerOrder order}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.only(top: 12.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors(context).containerColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              'Order Items (${order.products.length})',
              style: AppTextStyle(context).text14B700,
            ),
          ),
          Gap(12.h),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: order.products.length,
            itemBuilder: (context, index) => ItemCard(product: order.products[index]),
            separatorBuilder: (context, index) => Divider(
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: colors(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryWidget({required SellerOrder order}) {
    return Container(
      color: colors(context).containerColor,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: 'Order ID: ',
              style: AppTextStyle(context).text24B700.copyWith(
                    color: colors(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
              children: [
                TextSpan(
                  text: order.orderCode,
                  style: AppTextStyle(context).text24B700.copyWith(
                        color: colors(context).primaryColor,
                      ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          _buildInfo(order: order),
          Gap(16.h),
          _buildDotDividerWidget(),
          Gap(12.h),
          Align(
            alignment: Alignment.topCenter,
            child: InvoiceDownload(order.orderCode, order.invoiceUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo({required SellerOrder order}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors(context).accentColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildInfoRowWidget(
            key: 'Order Placed',
            value: order.orderPlaced,
          ),
          Gap(12.h),
          _buildInfoRowWidget(
            key: 'Order Amount',
            value: '\$${order.amount}',
          ),
          Gap(12.h),
          _buildInfoRowWidget(
            key: 'Payment Method',
            value: order.paymentMethod,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWidget({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: AppTextStyle(context).text16B400.copyWith(
                color: EcommerceAppColor.gray,
              ),
        ),
        Text(
          value,
          style: AppTextStyle(context).text16B700,
        ),
      ],
    );
  }

  Widget _buildShippingInfoWidget({required SellerOrder order}) {
    return Container(
      color: colors(context).containerColor,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Information:',
            style: AppTextStyle(context).text14B700,
          ),
          Gap(8.h),
          _buildShippingInfoCardWidget(order: order),
          Gap(12.h),
          _deliveryInfoWidget(order: order),
        ],
      ),
    );
  }

  Widget _buildShippingInfoCardWidget({required SellerOrder order}) {
    return Container(
      padding: EdgeInsets.all(8.r),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: colors(context).accentColor!,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 18.r,
              backgroundImage: CachedNetworkImageProvider(
                order.user.profilePhoto,
              ),
            ),
            title: Text(
              order.user.name,
              style: AppTextStyle(context).text12B700,
            ),
            subtitle: Text(
              order.user.phone,
              style: AppTextStyle(context).text12B700.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors(context).primaryColor,
                  ),
            ),
          ),
          Divider(
            height: 0,
            color: colors(context).accentColor,
            thickness: 1,
          ),
          Gap(4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: EcommerceAppColor.gray,
                size: 18.sp,
              ),
              Gap(8.w),
              Flexible(
                flex: 7,
                child: Text(
                  GlobalFunction.getFormattedAddress(order.user.address),
                  style: AppTextStyle(context).text14B400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryInfoWidget({required SellerOrder order}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors(context).accentColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: EcommerceAppColor.gray.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _dateColumn(
                  title: order.orderStatus != 'Delivered' ? 'Delivery Between' : 'Picked Up',
                  date: order.orderStatus != 'Delivered'
                      ? order.estimatedDeliveryDate
                      : order.pickupDate ?? 'N/A',
                ),
              ),
              if (order.orderStatus == 'Delivered' || order.pickupDate != null) ...[
                Flexible(
                  flex: 1,
                  child: _dateColumn(
                    title: order.orderStatus == 'Delivered' ? 'Delivered' : 'Picked Up',
                    date: order.orderStatus == 'Delivered'
                        ? order.estimatedDeliveryDate
                        : order.pickupDate ?? 'N/A',
                  ),
                ),
              ],
            ],
          ),
          if (order.rider != null) ...[
            Gap(8.h),
            _buildDotDividerWidget(),
            Gap(8.h),
            Row(
              children: [
                Icon(
                  Icons.delivery_dining_outlined,
                  color: EcommerceAppColor.gray,
                  size: 20.sp,
                ),
                Gap(8.w),
                Text(
                  'Assigned for Delivery',
                  style: AppTextStyle(context).text14B400,
                ),
              ],
            ),
            Gap(5.h),
            _buildRiderCard(rider: order.rider!),
          ],
        ],
      ),
    );
  }

  Widget _buildDotDividerWidget() {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            color: index % 2 == 0
                ? EcommerceAppColor.lightGray.withOpacity(0.5)
                : Colors.transparent,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildRiderCard({required SellerRider rider}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: colors(context).containerColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 18.r,
          backgroundImage: CachedNetworkImageProvider(rider.profilePhoto),
        ),
        title: Text(
          rider.name,
          style: AppTextStyle(context).text14B400.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          rider.assignedAt,
          style: AppTextStyle(context).text12B700.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                color: EcommerceAppColor.gray,
              ),
        ),
        trailing: CircleAvatar(
          radius: 18.r,
          backgroundColor: colors(context).accentColor,
          child: Icon(
            Icons.call_outlined,
            color: EcommerceAppColor.gray,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _dateColumn({required String title, required String date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle(context).text12B700.copyWith(
                fontSize: 12.sp,
                color: EcommerceAppColor.gray,
              ),
        ),
        Gap(4.h),
        Row(
          children: [
            Icon(Icons.calendar_month_outlined, size: 18.sp),
            Gap(8.w),
            Text(
              date,
              style: AppTextStyle(context).text14B700,
            ),
          ],
        ),
      ],
    );
  }

  //   Widget _buildDownloadButton() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       SvgPicture.asset(Assets.svg.cloud),
  //       Gap(8.w),
  //       Text(
  //         S.of(ContextLess.context).downloadInvoice,
  //         style: AppTextStyle(context: ContextLess.context).text14B400,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBottomNavigationBar() {
    return Consumer(
      builder: (context, slref, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          color: colors(context).containerColor,
          height: 86.h,
          child: ref.watch(orderStatusProvider)
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TransparentButton(
                        textColor: EcommerceAppColor.red,
                        color: colors(context).containerColor,
                        borderColor: EcommerceAppColor.red,
                        buttonName: 'Cancel',
                        onTap: () {
                          ref
                              .read(orderStatusProvider.notifier)
                              .updateOrderStatus(
                                orderId: widget.orderId,
                                status: 'cancel',
                              )
                              .then(
                                (value) => ref.refresh(
                                  orderDetailsServiceProvider(widget.orderId),
                                ),
                              );
                        },
                      ),
                    ),
                    Gap(12.w),
                    Flexible(
                      flex: 1,
                      child: CustomButton(
                        buttonName: 'Confirm',
                        onTap: () {
                          ref
                              .read(orderStatusProvider.notifier)
                              .updateOrderStatus(
                                orderId: widget.orderId,
                                status: 'confirm',
                              )
                              .then(
                                (value) => ref.refresh(
                                  orderDetailsServiceProvider(widget.orderId),
                                ),
                              );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}