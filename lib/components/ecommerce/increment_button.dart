// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/theme.dart';

class IncrementButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? iconColor;
      final double? height;
  final double? width;
  final double? iconSize;
  final void Function()? onTap;
  const IncrementButton({
    super.key,
    this.buttonColor,
    this.iconColor,
       this.height,
    this.width, 
    this.iconSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor ?? colors(context).primaryColor?.withOpacity(0.1),
      borderRadius: BorderRadius.circular(50.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(50.r),
        onTap: onTap,
        child: Container(
          height: height ?? 26.h,
          width: width ?? 26.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: iconSize ?? 20.sp,
              color: iconColor ?? colors(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
