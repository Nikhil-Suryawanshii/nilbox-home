import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';

class SellerUnderReview extends StatelessWidget {
  const SellerUnderReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors(context).light,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user_outlined, size: 100, color: Colors.green),
              Gap(20.h),
              Text('Registration Submitted!', style: AppTextStyle(context).text16B400),
              Gap(16.h),
              Text('Under Review', style: AppTextStyle(context).text24B700),
              Gap(24.h),
              Text(
                'Your application is being processed. We will notify you via email once approved.',
                textAlign: TextAlign.center,
                style: AppTextStyle(context).text16B400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}