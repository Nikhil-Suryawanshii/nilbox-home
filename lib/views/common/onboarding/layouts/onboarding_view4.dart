import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/overlapping_images.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

class OnboardingView4 extends StatelessWidget {
  const OnboardingView4({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      backgroundColor: Color.fromRGBO(221, 212, 237, 1),
      body: Column(
        children: [
          // Gap(70.h),
          Gap(40.h),

          Row(
            children: [
              Text(
                "es",
                style: TextStyle(fontSize: 50.h, fontWeight: FontWeight.bold),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/png/onboardingview/spiral4.png',
                    width: 270.w,
                    height: 290.h,
                  ),
                  Text(
                    'Auction',
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(160.h),
          OverlappingCirclesWidget(
            image1: 'assets/png/onboardingview/view4chair.png',
            image2: 'assets/png/onboardingview/view4.png',
            image3: 'assets/png/onboardingview/view4lamp.png',
          ),
          Text(
            '    Sell more. Put your\n    products up for ,\n       Auction',
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
            context.nav.pushNamed(
                  Routes.getCoreRouteName(AppConstants.appServiceName));
            },
            child: Image.asset(
              'assets/png/nextview4.png',
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

    if (!kIsWeb && Platform.isAndroid) {
      content = Container(
        color: Colors.black,
        child: SafeArea(
          top: false,
          bottom: true,
          child: content,
        ),
      );
    }
    return content;
  }
}
