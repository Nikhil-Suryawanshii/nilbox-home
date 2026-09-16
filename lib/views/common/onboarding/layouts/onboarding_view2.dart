import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/overlapping_images.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

import 'onboarding_view3.dart';

class OnboardingView2 extends StatelessWidget {
  const OnboardingView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(202, 224, 195, 1),
      body: Column(
        children: [
          // Gap(70.h),
          Gap(40.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                "ts",
                style: TextStyle(fontSize: 50.h, fontWeight: FontWeight.bold),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/png/onboardingview/onboarding_spiral2.png',
                    width: 260.w,
                    height: 290.h,
                  ),
                  Text(
                    'Reels',
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              Text(
                " St",
                style: TextStyle(fontSize: 50.h, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Gap(160.h),
          const OverlappingCirclesWidget(
            image1: 'assets/png/onboardingview/view2person.png',
            image2: 'assets/png/onboardingview/view2person2.png',
            image3: 'assets/png/onboardingview/view2person3.png',
          ),
          Text(
            '  Sell and buy quality\n      goods ,clothing ,\n       furniture , etc',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Gap(20.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              // context.nav
              //     .pushNamedAndRemoveUntil(Routes.onbarding3, (route) => false);
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const OnboardingView3(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
            child: Image.asset(
              'assets/png/nextview2.png',
              width: 88,
              height: 88,
              fit: BoxFit.contain,
            ),
          ),
          TextButton(
             onPressed: () {
            context.nav.pushNamed(
                  Routes.getCoreRouteName(AppConstants.appServiceName));
            },
            child: Text(
              "Skip",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
