// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
// import 'package:ready_ecommerce/views/seller/auth/forget_password.dart';
// import 'package:ready_ecommerce/views/seller/auth/registration.dart';
// import 'package:ready_ecommerce/views/seller/widgets/pin_put.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
// import 'package:ready_ecommerce/utils/context_less_navigation.dart';

// class SellerConfirmOTPBottomSheet extends ConsumerStatefulWidget {
//   final TabController tabController;
//   final String otp;
//   const SellerConfirmOTPBottomSheet({
//     super.key,
//     required this.tabController,
//     required this.otp,
//   });

//   @override
//   ConsumerState<SellerConfirmOTPBottomSheet> createState() =>
//       _SellerConfirmOTPBottomSheetState();
// }

// class _SellerConfirmOTPBottomSheetState extends ConsumerState<SellerConfirmOTPBottomSheet> {
//   late TextEditingController _otpController;
//   Timer? timer;
//   int start = 60;

//   @override
//   void initState() {
//     // Note: widget.otp is passed from the registration screen
//     _otpController = TextEditingController();
//     startTimer();
//     super.initState();
//   }

//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     timer = Timer.periodic(oneSec, (timer) {
//       if (start == 0) {
//         timer.cancel();
//       } else {
//         setState(() {
//           start--;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     _otpController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, slref, _) {
//         return Container(
//           decoration: BoxDecoration(
//             color: colors(context).light,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.r),
//               topRight: Radius.circular(16.r),
//             ),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: 20.w,
//             vertical: 30.h,
//           ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Enter OTP',
//                   style: AppTextStyle(context).text24B700,
//                 ),
//                 Gap(16.h),
//                 Text(
//                   'We sent an OTP code to your email address',
//                   textAlign: TextAlign.center,
//                   style: AppTextStyle(context).text16B400,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       slref.read(emailController).text,
//                       style: AppTextStyle(context).text16B400.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                     Gap(5.w),
//                     GestureDetector(
//                       onTap: () => context.nav.pop(),
//                       child: const Icon(Icons.edit, size: 18, color: Colors.blue),
//                     ),
//                   ],
//                 ),
//                 Gap(20.h),
//                 PinPutWidget(
//                   onChanged: (v) {},
//                   onCompleted: (v) {},
//                   validator: FormBuilderValidators.required(
//                     errorText: 'Please enter OTP',
//                   ),
//                   pinCodeController: _otpController,
//                 ),
//                 Gap(24.h),
//                 slref.watch(sellerAuthServiceProvider)
//                     ? const Center(child: CircularProgressIndicator())
//                     : CustomButton(
//                         buttonName: 'Confirm OTP',
//                         onTap: () {
//                           slref
//                               .read(sellerAuthServiceProvider.notifier)
//                               .verifyOTP(
//                                 email: slref.read(emailController).text,
//                                 otp: _otpController.text,
//                               )
//                               .then((response) {
//                             if (response.status) {
//                               widget.tabController.animateTo(1);
//                               slref.read(isEmailVerified.notifier).state = true;
//                               context.nav.pop();
//                             }
//                           });
//                         },
//                       ),
//                 Gap(20.h),
//                 Text(
//                   "Resend code in 00:${start.toString().padLeft(2, "0")} sec",
//                   style: AppTextStyle(context).text16B400,
//                 ),
//                 if (start == 0)
//                   Padding(
//                     padding: EdgeInsets.only(top: 10.h),
//                     child: GestureDetector(
//                       onTap: () async {
//                         await slref
//                             .read(sellerAuthServiceProvider.notifier)
//                             .sendOTP(
//                               email: slref.read(emailController).text,
//                               isForgotPassword: false,
//                             );
//                         setState(() {
//                           start = 60;
//                         });
//                         startTimer();
//                       },
//                       child: Text(
//                         'Resend',
//                         style: AppTextStyle(context).text14B400.copyWith(
//                               color: colors(context).primaryColor,
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                     ),
//                   ),
//                 Gap(16.h),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/views/seller/auth/forget_password.dart';
import 'package:ready_ecommerce/views/seller/auth/registration.dart';
import 'package:ready_ecommerce/views/seller/auth/shop_owner_widget.dart';
import 'package:ready_ecommerce/views/seller/widgets/pin_put.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

class ConfirmOTPBottomSheet extends ConsumerStatefulWidget {
  final TabController tabController;
  final String otp;
  const ConfirmOTPBottomSheet({
    super.key,
    required this.tabController,
    required this.otp,
  });

  @override
  ConsumerState<ConfirmOTPBottomSheet> createState() =>
      _ConfirmOTPBottomSheetState();
}

class _ConfirmOTPBottomSheetState extends ConsumerState<ConfirmOTPBottomSheet> {
  late TextEditingController _otpController;

  Timer? timer;
  int start = 60;
  bool isComplete = false;

  @override
  void initState() {
    _otpController = TextEditingController(text: widget.otp);
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        timer.cancel();
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, slref, _) {
        return Container(
          decoration: BoxDecoration(
            color: colors(context).light,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 30.h,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter OTP',
                  style: AppTextStyle(context).text24B700,
                ),
                Gap(16.h),
                Column(
                  children: [
                    Text(
                      'We sent OTP code to your email address',
                      textAlign: TextAlign.center,
                      style: AppTextStyle(context).text16B400,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          slref.read(emailController).text,
                          style: AppTextStyle(context).text16B400.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Gap(5.w),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.edit_note,
                            color: colors(context).primaryColor,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(20.h),
                PinPutWidget(
                  onChanged: (v) {},
                  onCompleted: (v) {},
                  validator: FormBuilderValidators.required(
                    errorText: 'Please enter OTP',
                  ),
                  pinCodeController: _otpController,
                ),
                Gap(24.h),
                slref.watch(sellerAuthServiceProvider)
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        buttonName: 'Confirm OTP',
                        onTap: () {
                          slref
                              .read(sellerAuthServiceProvider.notifier)
                              .verifyOTP(
                                email: slref.read(emailController).text,
                                otp: _otpController.text,
                              )
                              .then((response) {
                          if (response.status) {
                          // Verify the index syncing with your TabController
                          widget.tabController.animateTo(1);
                          slref.read(isEmailVerified.notifier).state = true;
                          // Update the global tab index provider so the button text changes to "Submit"
                          slref.read(sellerTabIndex.notifier).state = 2;
                          navigationPop();
                              }
                            });
                        },
                      ),
                Gap(20.h),
                Text(
                  "Resend code in 00:${start.toString().padLeft(2, "0")} sec",
                  style: AppTextStyle(context).text16B400,
                ),
                if (start == 0)
                  GestureDetector(
                    onTap: () async {
                      await slref
                          .read(sellerAuthServiceProvider.notifier)
                          .sendOTP(
                            email: slref.read(emailController).text,
                            isForgotPassword: false,
                          );
                      setState(() {
                        start = 60;
                      });
                      startTimer();
                    },
                    child: Text(
                      'Resend',
                      style: AppTextStyle(context).text14B400.copyWith(
                            color: colors(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                Gap(16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  navigationPop() => Navigator.pop(context);
}
