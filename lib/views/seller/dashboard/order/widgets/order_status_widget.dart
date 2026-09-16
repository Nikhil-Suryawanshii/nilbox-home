import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class OrderStatusWidget extends StatelessWidget {
  final String orderStatus;
  const OrderStatusWidget({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: GlobalFunction.getOrderStatsusColor(orderStatus),
        borderRadius: BorderRadius.circular(14.r), // Standardized to .r
      ),
      child: Text(
        orderStatus,
        style: style.bodyTextSmall.copyWith(
          color: colors(context).light,
          fontWeight: FontWeight.w700, // Kept the bold weight from your original
          fontSize: 12.sp,
        ),
      ),
    );
  }
}