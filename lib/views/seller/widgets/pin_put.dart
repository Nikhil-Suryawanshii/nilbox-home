import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/theme.dart';

class PinPutWidget extends ConsumerStatefulWidget {
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final TextEditingController pinCodeController;
  final void Function(String)? onChanged;
  
  const PinPutWidget({
    super.key,
    required this.onCompleted,
    required this.validator,
    required this.pinCodeController,
    required this.onChanged,
  });

  @override
  ConsumerState<PinPutWidget> createState() => _PinputWidgetState();
}

class _PinputWidgetState extends ConsumerState<PinPutWidget> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 70.w,
      height: 56.h,
      textStyle: const TextStyle(fontSize: 22, color: EcommerceAppColor.black),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors(context).bodyTextColor!.withOpacity(0.1),
          width: 2,
        ),
      ),
    );

    return Pinput(
      controller: widget.pinCodeController,
      focusNode: focusNode,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => SizedBox(width: 22.w),
      validator: widget.validator,
      onCompleted: widget.onCompleted,
      onChanged: widget.onChanged,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: colors(context).primaryColor!),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: colors(context).accentColor,
        ),
      ),
    );
  }
}