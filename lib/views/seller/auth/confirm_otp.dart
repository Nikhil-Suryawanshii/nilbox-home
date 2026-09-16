import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/views/seller/widgets/pin_put.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class SellerConfirmOTP extends ConsumerStatefulWidget {
  final String email;
  const SellerConfirmOTP({super.key, required this.email});

  @override
  ConsumerState<SellerConfirmOTP> createState() => _SellerConfirmOTPState();
}

class _SellerConfirmOTPState extends ConsumerState<SellerConfirmOTP> {
  final TextEditingController pinCodeController = TextEditingController();
  Timer? timer;
  int start = 60;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        timer.cancel();
      } else {
        setState(() => start--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slref = ref;
    return Scaffold(
      backgroundColor: colors(context).light,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 100, color: Colors.blue),
              Gap(20.h),
              Text("Enter OTP", style: AppTextStyle(context).text24B700.copyWith(fontSize: 28.sp)),
              Gap(10.h),
              Text("We sent an OTP to ${widget.email}", style: AppTextStyle(context).text16B400),
              Gap(40.h),
              PinPutWidget(
                pinCodeController: pinCodeController,
                onCompleted: (pin) {},
                validator: (v) => null,
                onChanged: (v) {},
              ),
              Gap(30.h),
              slref.watch(sellerAuthServiceProvider)
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      buttonName: "Confirm OTP",
                      onTap: () {
                        slref.read(sellerAuthServiceProvider.notifier).verifyOTP(
                          email: widget.email,
                          otp: pinCodeController.text,
                        ).then((response) {
                          if (response.status) {
                            Navigator.pushNamed(context, Routes.sellerCreatePassword, arguments: response.data);
                          } else {
                            GlobalFunction.showCustomSnackbar(message: response.message, isSuccess: false);
                          }
                        });
                      },
                    ),
              Gap(20.h),
              Text("Resend code in 00:$start sec", style: AppTextStyle(context).text14B400),
              if (start == 0)
                TextButton(
                  onPressed: () {
                    slref.read(sellerAuthServiceProvider.notifier).sendOTP(email: widget.email, isForgotPassword: true);
                    setState(() => start = 60);
                    startTimer();
                  },
                  child: const Text("Resend"),
                )
            ],
          ),
        ),
      ),
    );
  }
}