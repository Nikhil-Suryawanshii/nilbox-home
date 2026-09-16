import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/theme.dart';

class DecrementButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? iconColor;
  final double? height;
  final double? width;
  final double? iconSize;
  final void Function()? onTap;
  const DecrementButton({
    super.key,
    this.buttonColor,
    this.height,
    this.width, 
    this.iconSize,
    this.iconColor,
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
            border: Border.all(color: iconColor!)
          ),
          child: Center(
            child: Icon(
              Icons.remove,
              size: iconSize ?? 20,
              color: iconColor ?? colors(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
