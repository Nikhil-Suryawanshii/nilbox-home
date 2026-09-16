// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String name;
//   final FocusNode? focusNode;
//   final TextInputType textInputType;
//   final TextEditingController controller;
//   final TextInputAction textInputAction;
//   final String? Function(String?)? validator;
//   final bool? readOnly;
//   final Widget? widget;
//   final Widget? prefixwidget;

//   final bool? obscureText;
//   final int? minLines;
//   final int? maxLines;
//   final bool showName;
//   final String hintText;
//   final Color? fillColor;
//   final bool isRequired;
//   Function(String?)? onChanged;
//   final double? borderRadius;
//   CustomTextFormField({
//     super.key,
//     required this.name,
//     this.focusNode,
//     required this.textInputType,
//     required this.controller,
//     required this.textInputAction,
//     required this.validator,
//     this.readOnly,
//     this.widget,
//     this.prefixwidget,
//     this.obscureText,
//     this.minLines,
//     this.maxLines,
//     this.fillColor,
//     this.showName = true,
//     required this.hintText,
//     this.isRequired = false,
//     this.onChanged,
//     this.borderRadius,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (showName)
//           Row(
//             children: [
//               Text(name, style: AppTextStyle(context: context).text16B400),
//               Visibility(
//                 visible: isRequired,
//                 child: const Icon(Icons.star, size: 10, color: Colors.red),
//               ),
//             ],
//           ),
//         Gap(12.h),
//         AbsorbPointer(
//           absorbing: readOnly ?? false,
//           child: FormBuilderTextField(
//             readOnly: readOnly ?? false,
//             textAlign: TextAlign.start,
//             minLines: minLines ?? 1,
//             maxLines: maxLines ?? 1,
//             name: name,
//             focusNode: focusNode,
//             controller: controller,
//             obscureText: obscureText ?? false,
//             style: AppTextStyle(
//               context: context,
//             ).text14B700.copyWith(fontWeight: FontWeight.w500),
//             cursorColor: colors(context).primaryColor,
//             decoration: GlobalFunction.inputDecoration(
//               hintText: hintText,
//               widget: widget,
//               prefixwidget: prefixwidget,
//               context: context,
//               fillColor: fillColor,
//               borderRadius: borderRadius,
//             ),
//             keyboardType: textInputType,
//             textInputAction: textInputAction,
//             validator: validator,
//             onChanged: onChanged,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Widget? widget;
  final Widget? prefixwidget;

  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final bool showName;
  final String hintText;
  final Color? fillColor;
  final bool isRequired;
  Function(String?)? onChanged;
  final double? borderRadius;
  final TextStyle? textStyle; 
  final TextStyle? labelStyle; 

  CustomTextFormField({
    super.key,
    required this.name,
    this.focusNode,
    required this.textInputType,
    required this.controller,
    required this.textInputAction,
    required this.validator,
    this.readOnly,
    this.widget,
    this.prefixwidget,
    this.obscureText,
    this.minLines,
    this.maxLines,
    this.fillColor,
    this.showName = true,
    required this.hintText,
    this.isRequired = false,
    this.onChanged,
    this.borderRadius,
    this.textStyle, // Initialize nullable text style
    this.labelStyle, // Initialize nullable label style
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName)
          Row(
            children: [
              Text(
                name,
                style: labelStyle ?? AppTextStyle(context).text16B400,
              ),
              Visibility(
                visible: isRequired,
                child: const Icon(Icons.star, size: 10, color: Colors.red),
              ),
            ],
          ),
        Gap(12.h),
        AbsorbPointer(
          absorbing: readOnly ?? false,
          child: FormBuilderTextField(
            readOnly: readOnly ?? false,
            textAlign: TextAlign.start,
            minLines: minLines ?? 1,
            maxLines: maxLines ?? 1,
            name: name,
            focusNode: focusNode,
            controller: controller,
            obscureText: obscureText ?? false,
            style: textStyle ??
                AppTextStyle(context)
                    .text14B700
                    .copyWith(fontWeight: FontWeight.w500),
            cursorColor: colors(context).primaryColor,
            decoration: GlobalFunction.inputDecoration(
              hintText: hintText,
              widget: widget,
              prefixwidget: prefixwidget,
              context: context,
              fillColor: fillColor,
              borderRadius: borderRadius,
            ),
            keyboardType: textInputType,
            textInputAction: textInputAction,
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}