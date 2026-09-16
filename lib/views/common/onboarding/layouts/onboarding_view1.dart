import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/overlapping_images.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

import 'onboarding_view2.dart';

class OnboardingView1 extends StatelessWidget {
  const OnboardingView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 209, 220, 1),
      body: Column(
        children: [
          // Gap(150.h),
          Gap(120.h),

          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  height: 190.h,
                  'assets/png/onboarding_view1_spiral.png',
                ),
                Text(
                  'PRODUCTS',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Gap(160.h),
          OverlappingCirclesWidget(
            image1: 'assets/png/onboardingview/view1bag.png',
            image2: 'assets/png/onboardingview/view1shirt.png',
            image3: 'assets/png/onboardingview/view1chair.png',
          ),
          Text(
            '       Promotting your\n    products with music\n             and reals',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Gap(40.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              // context.nav
              //     .pushNamedAndRemoveUntil(Routes.onbarding2, (route) => false);
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const OnboardingView2(),
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
              'assets/png/nextView.png',
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
