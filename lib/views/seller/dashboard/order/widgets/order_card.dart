import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/order/order_model.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class OrderCard extends StatelessWidget {
  final SellerOrder order;
  final VoidCallback callback;
  const OrderCard({super.key, required this.callback, required this.order});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.r),
      color: colors(context).containerColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: callback,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            children: [
              _buildDateWidget(context), 
              Gap(12.h), 
              _buildBottomWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            order.estimatedDeliveryDate,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 10.sp,
            color: colors(context).bodyTextSmallColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomWidget(BuildContext context) {
    final style = AppTextStyle(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Order Code
        Text(
          order.orderCode,
          style: style.bodyText.copyWith(fontWeight: FontWeight.w700),
        ),
        // Vertical Divider
        Container(
          height: 14.h,
          width: 1.5,
          color: colors(context).secondaryColor?.withOpacity(0.3),
        ),
        // User Info
        Flexible(
          flex: 2,
          child: Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: colors(context).primaryColor?.withOpacity(0.1),
                child: Icon(
                  Icons.delivery_dining_outlined, // Replaced Bike SVG
                  size: 14.r,
                  color: colors(context).primaryColor,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  order.user.name,
                  overflow: TextOverflow.ellipsis,
                  style: style.bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Status Tag
       Flexible(flex: 1, child: _statusCard(style.context)),
      ],
    );
  }

  Widget _statusCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: GlobalFunction.getOrderStatsusColor(order.orderStatus),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        order.orderStatus,
        maxLines: 1,
        style: AppTextStyle(context).bodyTextSmall.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }
}