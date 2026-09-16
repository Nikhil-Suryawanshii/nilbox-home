import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/theme.dart';

class AppTextStyle {
  final BuildContext context;
  AppTextStyle(this.context);

  TextStyle get title => TextStyle(
        color: colors(context).headingColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
      );
  TextStyle get headerTitle => TextStyle(
        color: colors(context).headingColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );
  TextStyle get subTitle => TextStyle(
        // color: colors(context).dark,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
    letterSpacing: 0
      );
  TextStyle get categoryTitle => TextStyle(
      color: colors(context).dark,
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 0
  );
  TextStyle get bodyText => TextStyle(
        color: colors(context).bodyTextColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      );
  TextStyle get bodyTextSmall => TextStyle(
        color: colors(context).bodyTextSmallColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      );
  TextStyle get buttonText => TextStyle(
        fontSize: 13.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
      );
  TextStyle get hintText => TextStyle(
        color: colors(context).hintTextColor,
        fontSize: 21.sp,
        fontWeight: FontWeight.w300,
      );
  TextStyle get appBarText => TextStyle(
        color: colors(context).headingColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      );

  TextStyle get TitleBold=> TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 34.sp,
    fontWeight: FontWeight.w700,
  );
  TextStyle get text24B700 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );
    TextStyle get text18B700 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );
  TextStyle get text16B700 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );
  TextStyle get text16B400 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  TextStyle get hintText16B400 => TextStyle(
    color: colors(context).hintTextColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  TextStyle get text14B400 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  TextStyle get text14B700 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );
  TextStyle get text12B700 => TextStyle(
    color: colors(context).bodyTextColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );
}
