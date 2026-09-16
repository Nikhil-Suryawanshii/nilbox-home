// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final String? secondTitle;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Widget? widget;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final bool showName;
  final String hintText;
  final Color? fillColor;
  final VoidCallback? secondTitleOnTap;

  const CustomTextFormField({
    super.key,
    required this.name,
    this.secondTitle,
    this.focusNode,
    required this.textInputType,
    required this.controller,
    required this.textInputAction,
    required this.validator,
    this.readOnly,
    this.widget,
    this.obscureText,
    this.minLines,
    this.maxLines,
    this.showName = true,
    required this.hintText,
    this.fillColor,
    this.secondTitleOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName)
          // Row(
          //   children: [
          //     Text(
          //       name,
          //       style: AppTextStyle(context)
          //           .bodyText
          //           .copyWith(fontWeight: FontWeight.w500),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 4.0),
          //       child: GestureDetector(
          //         onTap: secondTitleOnTap,
          //         child: Text(
          //           secondTitle ?? '',
          //           style: AppTextStyle(context).bodyText.copyWith(
          //                 fontWeight: FontWeight.w400,
          //                 color: colors(context).primaryColor,
          //                 decoration: TextDecoration.underline,
          //                 decorationColor: colors(context).primaryColor,
          //               ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        Gap(12.h),
        // AbsorbPointer(
        //   absorbing: readOnly ?? false,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(30.r), // 👈 pill shape
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.08),
        //           blurRadius: 12,
        //           offset: const Offset(0, 4),
        //         ),
        //       ],
        //     ),
        //     child: FormBuilderTextField(
        //       readOnly: readOnly ?? false,
        //       textAlign: TextAlign.start,
        //       minLines: minLines ?? 1,
        //       maxLines: maxLines ?? 1,
        //       name: name,
        //       focusNode: focusNode,
        //       controller: controller,
        //       obscureText: obscureText ?? false,
        //       style: AppTextStyle(context).bodyText.copyWith(
        //             fontWeight: FontWeight.w600,
        //           ),
        //       cursorColor: colors(context).primaryColor,
        //       obscuringCharacter: '●',
        //       decoration: InputDecoration(
        //         errorMaxLines: 3,
        //         contentPadding:
        //             EdgeInsets.symmetric(horizontal: 20.w, vertical: 16),
        //         alignLabelWithHint: true,
        //         hintText: hintText,
        //         hintStyle: AppTextStyle(context).bodyText.copyWith(
        //               fontWeight: FontWeight.w500,
        //               color: colors(context).hintTextColor,
        //             ),
        //         suffixIcon: widget,
        //         floatingLabelStyle: AppTextStyle(context).bodyText.copyWith(
        //               fontWeight: FontWeight.w400,
        //               color: colors(context).primaryColor,
        //             ),
        //         filled: true,
        //         fillColor: fillColor ?? colors(context).accentColor,
        //         errorStyle: AppTextStyle(context).bodyTextSmall.copyWith(
        //               fontWeight: FontWeight.w400,
        //               color: colors(context).errorColor,
        //             ),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(10.r),
        //           borderSide: BorderSide(
        //             color: colors(context).hintTextColor ??
        //                 EcommerceAppColor.lightGray,
        //           ),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(10.r),
        //           borderSide: BorderSide(
        //             color:
        //                 colors(context).accentColor ?? EcommerceAppColor.offWhite,
        //             width: 2,
        //           ),
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           borderSide: BorderSide(
        //             color:
        //                 colors(context).primaryColor ?? EcommerceAppColor.primary,
        //             width: 1.5,
        //           ),
        //         ),
        //         errorBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(10),
        //           borderSide: BorderSide(
        //             color: colors(context).errorColor ?? EcommerceAppColor.red,
        //           ),
        //         ),
        //       ),
        //       keyboardType: textInputType,
        //       textInputAction: textInputAction,
        //       validator: validator,
        //     ),
        //   ),
        // ),
        ///
        FormBuilderField<String>(
          name: name,
          validator: validator,
          // Sync initial value from controller if needed
          initialValue: controller.text,
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 2. THE WHITE PILL CONTAINER
                AbsorbPointer(
                  absorbing: readOnly ?? false,
                  child: Container(
                    // height: 48, // Fixed height keeps the pill look consistent
                    constraints: const BoxConstraints(minHeight: 45),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(40.r),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.08),
                    //       blurRadius: 16,
                    //       offset: const Offset(0, 6),
                    //     ),
                    //   ],
                    //   // If there is an error, optionally show a red border on the container
                    //   border: field.hasError
                    //       ? Border.all(color: Colors.red.withOpacity(0.5), width: 1)
                    //       : null,
                    // ),
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.15), // Translucent background
                      color: Colors.white.withOpacity(0.7), // Translucent background
                      borderRadius: BorderRadius.circular(15),
                      border: field.hasError? Border.all(color: Colors.red.withOpacity(0.5), width: 1):
                        Border.all(color: Colors.white30, width: 1),
                    ),
                    alignment: Alignment.center,

                    /// 3. THE ACTUAL INPUT FIELD
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      textAlign: TextAlign.center,
                      keyboardType: textInputType,
                      textInputAction: textInputAction,
                      obscureText: obscureText ?? false,
                      style: AppTextStyle(context).bodyText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: colors(context).dark,

                      // Bind changes to the FormBuilder state
                      onChanged: (value) {
                        field.didChange(value);
                      },

                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: AppTextStyle(context).bodyText.copyWith(
                            color: colors(context).dark,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 14.h,
                                ),// Vertical 0 allows Center alignment
                        suffixIcon: widget,
                        filled: false,
                      ),
                    ),
                  ),
                ),

                /// 4. THE ERROR MESSAGE (OUTSIDE THE PILL)
                if (field.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 24.w),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        // AbsorbPointer(
        //   absorbing: readOnly ?? false,
        //   child: Container(
        //     // height: 45,
        //     constraints: const BoxConstraints(minHeight: 45),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(40.r), // 🔥 pill shape
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.08),
        //           blurRadius: 16,
        //           offset: const Offset(0, 6),
        //         ),
        //       ],
        //     ),
        //     alignment: Alignment.center,
        //     child: FormBuilderTextField(
        //       readOnly: readOnly ?? false,
        //       name: name,
        //       controller: controller,
        //       focusNode: focusNode,
        //       minLines: 1,
        //       maxLines: 1,
        //       textAlign: TextAlign.center, // 👈 matches image
        //       obscureText: obscureText ?? false,
        //       style: AppTextStyle(context).bodyText.copyWith(
        //         fontWeight: FontWeight.w500,
        //       ),
        //       cursorColor: colors(context).primaryColor,
        //       decoration: InputDecoration(
        //         hintText: hintText,
        //
        //         hintStyle: AppTextStyle(context).bodyText.copyWith(
        //           color: colors(context).hintTextColor,
        //           fontWeight: FontWeight.w400,
        //           fontSize: 13
        //         ),
        //
        //         // ❌ remove all borders
        //         border: InputBorder.none,
        //         enabledBorder: InputBorder.none,
        //         focusedBorder: InputBorder.none,
        //         errorBorder: InputBorder.none,
        //
        //         // contentPadding: EdgeInsets.symmetric(
        //         //   horizontal: 24.w,
        //         //   vertical: 18.h,
        //         // ),
        //         contentPadding: EdgeInsets.symmetric(
        //           horizontal: 24.w,
        //           vertical: 14.h,
        //         ),
        //
        //         suffixIcon: widget,
        //         filled: false,
        //       ),
        //       keyboardType: textInputType,
        //       textInputAction: textInputAction,
        //       validator: validator,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
