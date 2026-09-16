import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;
  final bool isArrowShow;
  final Color? color;
  final Color? textColor;
  final void Function()? onTap;
  final BoxDecoration? decoration; 
  final double? borderRadius; 

  const CustomButton({
    super.key,
    required this.buttonName,
    this.isArrowShow = false,
    this.color,
    this.textColor,
    this.onTap,
    this.decoration, 
    this.borderRadius, 
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 100;
    
 
    if (decoration != null) {
      return InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: decoration,
          child: Center(
            child: Text(
              buttonName,
              style: AppTextStyle(context).text16B700.copyWith(
                color: textColor ?? colors(context).light,
              ),
            ),
          ),
        ),
      );
    }
    
    // Default Material design
    return Material(
      color: color ?? colors(context).primaryColor,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          height: 56.h,
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                buttonName,
                style: AppTextStyle(context).text16B700.copyWith(
                  color: textColor ?? colors(context).light,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}