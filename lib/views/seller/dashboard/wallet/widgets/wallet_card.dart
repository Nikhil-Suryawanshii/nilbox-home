import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

class WalletCardWidget extends StatelessWidget {
  final String text;
  final IconData icon; // Changed from String to IconData
  final String amount;

  const WalletCardWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors(context).accentColor ?? EcommerceAppColor.offWhite,
          width: 1.5, // Reduced width for a cleaner look
        ),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: style.bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: EcommerceAppColor.gray,
                ),
              ),
              Icon(
                icon,
                size: 20.sp,
                color: colors(context).primaryColor,
              ),
            ],
          ),
          Gap(8.h),
          Text(
            amount,
            style: style.text16B700.copyWith(
              color: colors(context).bodyTextColor,
            ),
          ),
        ],
      ),
    );
  }
}