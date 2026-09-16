// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/decrement_button.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

class IncrementDecrementButton extends StatelessWidget {
  final void Function()? increment;
  final void Function()? decrement;
  final int productQuantity;
  final Color? buttonColorIncrement;
  final Color? buttonColorDecrement;
  final Color? iconColorDecrement;
  final Color? iconColorIncrement;
  final double? heightIncrement;
  final double? widthIncrement;
  final double? iconSizeIncrement;
    final double? heightDecrement;
  final double? widthDecrement;
  final double? iconSizeDecrement;
  final FontWeight? fontWeight;
  const IncrementDecrementButton({
    super.key,
    this.buttonColorIncrement,
    this.buttonColorDecrement,
    this.iconColorDecrement,
    this.iconColorIncrement,
    this.increment,
    this.fontWeight,
    this.heightDecrement,
    this.widthDecrement,
    this.iconSizeDecrement,
    this.heightIncrement,
    this.widthIncrement,
    this.iconSizeIncrement,
    this.decrement,
    required this.productQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecrementButton(
          height: heightDecrement,
          width: widthDecrement,
          iconSize: iconSizeDecrement,
          buttonColor: buttonColorDecrement ?? colors(context).light,
          iconColor: iconColorDecrement ?? EcommerceAppColor.lightGray,
          onTap: decrement,
        ),
        Gap(10.w),
        Text(
          productQuantity.toString(),
          style: AppTextStyle(context)
              .bodyText
              .copyWith(fontWeight: fontWeight ?? FontWeight.w600),
        ),
        Gap(10.w),
        IncrementButton(
          height: heightIncrement,
          width: widthIncrement,  
          iconSize: iconSizeIncrement,
          buttonColor: buttonColorIncrement ?? colors(context).primaryColor,
          iconColor: iconColorIncrement ?? EcommerceAppColor.white,
          onTap: increment,
        ),
      ],
    );
  }
}
