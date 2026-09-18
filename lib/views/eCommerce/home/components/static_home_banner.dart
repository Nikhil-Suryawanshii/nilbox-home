import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';

/// Temporary static home banner with auto-sliding carousel.
/// Toggle [AppConstants.useStaticHomeBanner] to disable.
class StaticHomeBanner extends StatefulWidget {
  const StaticHomeBanner({super.key});

  @override
  State<StaticHomeBanner> createState() => _StaticHomeBannerState();
}

class _StaticHomeBannerState extends State<StaticHomeBanner> {
  static const _bannerHeight = 130.0;

  int _currentPage = 0;
  late final List<_StaticBannerData> _slides;
  late final Duration _autoPlayInterval;

  static final _allSlides = [
    _StaticBannerData(
      title: 'Welcome to Nilbox',
      subtitle: 'Discover top deals & new arrivals',
      cta: 'Shop Now',
      imageAsset: 'assets/png/banner_image.png',
      gradientColors: [
        Color(0xFFFF5722),
        Color(0xFFFF8322),
        Color(0xFFFF8322),
      ],
      gradientStops: [0.0, 0.55, 1.0],
    ),
    _StaticBannerData(
      title: 'Big Sale Live',
      subtitle: 'Up to 50% off on selected items',
      cta: 'Grab Deals',
      imageAsset: 'assets/png/banner.png',
      gradientColors: [
        Color(0xFFE65100),
        Color(0xFFFF5722),
        Color(0xFFFF8322),
      ],
      gradientStops: [0.0, 0.5, 1.0],
    ),
    _StaticBannerData(
      title: 'Free Delivery',
      subtitle: 'On all orders — shop with ease',
      cta: 'Order Now',
      imageAsset: 'assets/png/delivery.png',
      gradientColors: [
        Color(0xFFFF5722),
        Color(0xFFFF7043),
        Color(0xFFFFAB91),
      ],
      gradientStops: [0.0, 0.6, 1.0],
    ),
    _StaticBannerData(
      title: 'New Collection',
      subtitle: 'Trending styles for Men & Women',
      cta: 'Explore',
      imageAsset: 'assets/png/banner_image.png',
      gradientColors: [
        Color(0xFFBF360C),
        Color(0xFFFF5722),
        Color(0xFFFF8322),
      ],
      gradientStops: [0.0, 0.45, 1.0],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slides = List<_StaticBannerData>.from(_allSlides)..shuffle(Random());
    _currentPage = Random().nextInt(_slides.length);
    _autoPlayInterval = Duration(seconds: 3 + Random().nextInt(3));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider.builder(
              itemCount: _slides.length,
              itemBuilder: (context, index, realIndex) {
                return _StaticBannerSlide(
                  data: _slides[index],
                  isActive: _currentPage == index,
                );
              },
              options: CarouselOptions(
                height: _bannerHeight.h,
                initialPage: _currentPage,
                autoPlay: _slides.length > 1,
                autoPlayInterval: _autoPlayInterval,
                autoPlayAnimationDuration:
                    const Duration(milliseconds: 700),
                autoPlayCurve: Curves.easeOutCubic,
                viewportFraction: 1,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() => _currentPage = index);
                },
              ),
            ),
            Positioned(
              bottom: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => _BannerDot(isActive: _currentPage == index),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms, delay: 120.ms)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 450.ms,
          delay: 120.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.94, 0.94),
          end: const Offset(1, 1),
          duration: 450.ms,
          delay: 120.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class _StaticBannerData {
  final String title;
  final String subtitle;
  final String cta;
  final String imageAsset;
  final List<Color> gradientColors;
  final List<double> gradientStops;

  const _StaticBannerData({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.imageAsset,
    required this.gradientColors,
    required this.gradientStops,
  });
}

class _StaticBannerSlide extends StatelessWidget {
  final _StaticBannerData data;
  final bool isActive;

  const _StaticBannerSlide({
    required this.data,
    required this.isActive,
  });

  static const _accentOrange = Color(0xFFFF5722);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1 : 0.98,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        width: double.infinity,
        height: 130.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              data.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: data.gradientColors,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: data.gradientColors
                      .map((c) => c.withOpacity(0.88))
                      .toList(),
                  stops: data.gradientStops,
                ),
              ),
            ),
            Positioned(
              top: -30.h,
              right: -20.w,
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -25.h,
              left: -15.w,
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 28.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.title,
                          style: AppTextStyle(context).bodyText.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 17.sp,
                                height: 1.2,
                              ),
                        ),
                        Gap(4.h),
                        Text(
                          data.subtitle,
                          style: AppTextStyle(context).bodyText.copyWith(
                                color: Colors.white.withOpacity(0.92),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                        ),
                        Gap(10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            data.cta,
                            style: AppTextStyle(context).bodyText.copyWith(
                                  color: _accentOrange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.w),
                  Image.asset(
                    'assets/png/app_logo.png',
                    width: 72.w,
                    height: 32.h,
                    fit: BoxFit.contain,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _BannerDot extends StatelessWidget {
  final bool isActive;

  const _BannerDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 7.h,
      width: isActive ? 22.w : 7.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 250.ms,
          curve: Curves.easeOutBack,
        );
  }
}
