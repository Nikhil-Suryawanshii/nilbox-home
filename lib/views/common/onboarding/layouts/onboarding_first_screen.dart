import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

import 'onboarding_view1.dart';

class OnboardingFirst extends ConsumerStatefulWidget {
  const OnboardingFirst({super.key});

  @override
  ConsumerState<OnboardingFirst> createState() => _OnboardingFirstState();
}

class _OnboardingFirstState extends ConsumerState<OnboardingFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 142, 130, 1),
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color(0xFFFFB5B5),
        //     Color(0xFFFFADAD),
        //     Color(0xFFFFA5A5),
        //   ],
        // ),
        child: Stack(
          children: [
            // Fixed positioned bubbles with elevation
            // Row 1 - Top area
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_Jacket.png',
              label: 'Jackets',
              left: 140.w,
              top: 160.h,
              size: 95.w,
              opacity: 0.35,
            ),
            _buildFloatingBubble(
              fontsize: 20.sp,
              label: 'Auction',
              left: 20.w,
              top: 200.h,
              size: 95.w,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_Jacket.png',
              label: 'Jackets',
              left: 0.w,
              top: 300.h,
              size: 95.w,
              opacity: 0.35,
            ),
            _buildFloatingBubble(
              icon: Icons.chair_outlined,
              label: 'Sofas',
              left: 20.w,
              top: 400.h,
              size: 95.w,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_desk.png',
              label: 'Desk',
              left: 120.w,
              top: 420.h,
              size: 95.w,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              fontsize: 20.sp,
              label: 'Duets',
              left: 110.w,
              top: 500.h,
              size: 95.w,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              fontsize: 25.sp,
              label: 'Stories',
              left: 10.w,
              top: 500.h,
              size: 115.w,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              color: Color.fromRGBO(246, 149, 137, 1),
              imageAsset: 'assets/png/onboarding_Jacket.png',
              label: 'Jackets',
              left: 70.w,
              top: 600.h,
              size: 110.w,
              fontsize: 12.sp,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_products.png',
              color: Color.fromRGBO(255, 191, 185, 1),
              label: '34k Products',
              left: 90.w,
              top: 240.h,
              size: 150.w,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_sweater.png',
              label: 'Sweater',
              left: 233.w,
              top: 210.h,
              size: 95.w,
              opacity: 0.35,
            ),
            _buildFloatingBubble(
              color: Color.fromRGBO(246, 149, 137, 1),
              label: 'Shirt',
              imageAsset: 'assets/png/onboarding_shirt.png',
              left: 330.w,
              top: 280.h,
              size: 100.w,
              fontsize: 12.sp,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_user.png',
              label: '1.4k Users',
              left: 230.w,
              top: 350.h,
              size: 100.w,
              fontsize: 12.sp,
              opacity: 0.9,
            ),
            _buildFloatingBubble(
              label: 'Post',
              left: 300.w,
              top: 110.h,
              size: 120.w,
              opacity: 0.9,
              isTextOnly: true,
            ),

            // Row 2 after 1.4k users
            _buildFloatingBubble(
              icon: Icons.bed,
              label: 'Bed',
              left: 300.w,
              top: 430.h,
              size: 135.w,
              opacity: 0.35,
            ),
            _buildFloatingBubble(
              imageAsset: 'assets/png/onboarding_Jacket.png',
              color: Color.fromRGBO(255, 191, 185, 1),
              label: 'Jackets',
              left: 198.w,
              top: 470.h,
              size: 105.w,
              opacity: 0.3,
            ),

            _buildFloatingBubble(
              fontsize: 30.sp,
              label: 'Reels',
              left: 218.w,
              top: 570.h,
              size: 105.w,
              opacity: 0.4,
            ),

            // Top content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Nilbox ',
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          // height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/png/onboarding_clap.png',
                              height: 40.h,
                              width: 40.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                children: [
                  Text(
                    'The best social\nE-commerce App of\nThe century for your\nfashion Needs!',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  // Gap(120.w),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to next screen
                        // context.nav.pushNamedAndRemoveUntil(
                        //     Routes.onbarding1, (route) => false);
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const OnboardingView1(),
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
                      child: Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D2D2D),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                            Gap(4.h),
                            Text(
                              'Get started',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBubble({
    IconData? icon,
    required String label,
    double? left,
    Color? color,
    double? fontsize,
    double? right,
    required double top,
    required double size,
    String? imageAsset,
    required double opacity,
    bool isTextOnly = false,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? Color.fromRGBO(235, 142, 130, 1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: isTextOnly
            ? Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageAsset != null)
                    Image.asset(
                      imageAsset,
                      height: size * 0.35,
                      width: size * 0.35,
                      fit: BoxFit.contain,
                    )
                  else if (icon != null)
                    Icon(
                      icon,
                      color: Colors.white,
                      size: size * 0.35,
                    ),
                  Gap(4.h),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }
}
