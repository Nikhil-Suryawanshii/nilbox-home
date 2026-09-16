import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

class OrderOverViewCard extends StatelessWidget {
  final String count;
  final String status;
  final String icon; // Path to SVG asset
  
  const OrderOverViewCard({
    super.key,
    required this.count,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors(context).light,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count, 
                style: AppTextStyle(context).text16B700.copyWith(
                  fontSize: 18.sp,
                  color: colors(context).primaryColor,
                )
              ),
              // Using a fallback Icon if SVG fails or placeholder is needed
              SvgPicture.asset(
                icon,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  colors(context).primaryColor!, 
                  BlendMode.srcIn
                ),
                placeholderBuilder: (context) => Icon(
                  Icons.shopping_basket, 
                  size: 20.sp, 
                  color: colors(context).primaryColor
                ),
              ),
            ],
          ),
          Gap(4.h),
          Text(
            status,
            style: AppTextStyle(context).text12B700.copyWith(
                  fontWeight: FontWeight.w500,
                  color: EcommerceAppColor.gray,
                ),
          ),
        ],
      ),
    );
  }
}