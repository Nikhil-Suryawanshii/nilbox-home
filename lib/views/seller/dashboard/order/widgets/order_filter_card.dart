import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/models/seller/order/order_status_model.dart';

class OrderFilterCard extends StatelessWidget {
  final OrderStatusModel statusModel;
  final bool isActive;
  final VoidCallback callback;

  const OrderFilterCard({
    super.key,
    required this.isActive,
    required this.callback,
    required this.statusModel,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = colors(context);
    final style = AppTextStyle(context);

    return Material(
      color: themeColors.containerColor,
      borderRadius: BorderRadius.circular(44.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(44.r),
        onTap: callback,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          // Removed hard height to let text breathe, or use 38.h if strict UI is needed
          constraints: BoxConstraints(minHeight: 38.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(44.r),
            border: Border.all(
              color: isActive
                  ? themeColors.primaryColor!
                  : themeColors.accentColor ?? Colors.transparent,
            ),
          ),
          child: Center(
            child: Text(
              "${statusModel.name} (${statusModel.value})",
              style: style.bodyText.copyWith(
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? themeColors.primaryColor
                    : EcommerceAppColor
                        .gray, // Using EcommerceAppColor instead of AppStaticColor
              ),
            ),
          ),
        ),
      ),
    );
  }
}
