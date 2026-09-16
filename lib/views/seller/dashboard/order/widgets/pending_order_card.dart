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
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/screens/orders.dart';

class PendingOrderCard extends StatefulWidget {
  final SellerOrder order;
  final VoidCallback callback;
  const PendingOrderCard({
    super.key,
    required this.callback,
    required this.order,
  });

  @override
  State<PendingOrderCard> createState() => _PendingOrderCardState();
}

class _PendingOrderCardState extends State<PendingOrderCard> {
  bool cancelLoading = false;
  bool confirmLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors(context).containerColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: widget.callback,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ).copyWith(top: 12.h, bottom: 8.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDataWidget(),
              Gap(4.h),
              _buildOrderInfoRow(),
              Gap(12.h),
              _buildDotDividerWidget(),
              Gap(8.h),
              _buildBottomWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.order.orderPlaced,
            style: AppTextStyle(context).bodyText.copyWith(fontSize: 10.sp),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 12.sp,
            color: EcommerceAppColor.gray,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoColumn(
          key: "Order ID",
          value: widget.order.orderCode,
        ),
        _buildInfoColumn(
          key: "Order Amount",
          value: '\$${widget.order.amount}',
        ),
        _buildInfoColumn(
          key: "Payment Method",
          value: widget.order.paymentMethod,
        ),
      ],
    );
  }

  Widget _buildInfoColumn({required String key, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: AppTextStyle(context).bodyText.copyWith(
                fontSize: 10.sp,
                color: EcommerceAppColor.lightGray,
              ),
        ),
        Gap(4.h),
        Text(
          value,
          style: AppTextStyle(context).bodyText.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  Widget _buildDotDividerWidget() {
    return Row(
      children: List.generate(
        150 ~/ 3,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0
                ? EcommerceAppColor.lightGray.withOpacity(0.5)
                : colors(context).containerColor,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomWidget() {
    return Consumer(
      builder: (context, ref, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location",
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontSize: 10.sp,
                          color: EcommerceAppColor.lightGray,
                        ),
                  ),
                  Text(
                    '${widget.order.user.address.addressLine}, ${widget.order.user.address.area}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp),
                  ),
                  // Text(
                  //   '${widget.order.orderStatus}',
                  //   overflow: TextOverflow.ellipsis,
                  //   style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp),
                  // ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  cancelLoading
                      ? const CircularProgressIndicator()
                      : _buildButton(
                          buttonText: "Cancel",
                          textColor: colors(context).errorColor!,
                          isBorder: true,
                          buttonColor: colors(context).containerColor!,
                          callback: () {
                            setState(() => cancelLoading = true);
                            ref
                                .read(orderStatusProvider.notifier)
                                .updateOrderStatus(
                                  orderId: widget.order.id,
                                  status: Status.cancel.name,

                                )
                                .then((response) {
                              setState(() => cancelLoading = false);
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
                            });
                          },
                        ),
                  Gap(8.w),
                  confirmLoading
                      ? const CircularProgressIndicator()
                      : _buildButton(
                          buttonText: "Confirm",
                          textColor: colors(context).light!,
                          isBorder: false,
                          buttonColor: EcommerceAppColor.green,
                          callback: () {
                            setState(() => confirmLoading = true);
                            ref
                                .read(orderStatusProvider.notifier)
                                .updateOrderStatus(
                                  orderId: widget.order.id,
                                  status: Status.confirm.name,
                                  // status: 'to_pickup',
                                )
                                .then((response) {
                              setState(() => confirmLoading = false);
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
                            });
                          },
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton({
    required VoidCallback callback,
    required Color buttonColor,
    required bool isBorder,
    required Color textColor,
    required String buttonText,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(6.r),
      color: buttonColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(6.r),
        onTap: callback,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: isBorder
                ? Border.all(
                    color: colors(context).errorColor!.withOpacity(0.3),
                  )
                : null,
          ),
          child: Text(
            buttonText,
            style: AppTextStyle(context).text12B700.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

enum Status { cancel, confirm }