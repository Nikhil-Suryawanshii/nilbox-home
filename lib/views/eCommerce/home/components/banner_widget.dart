import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/dashboard/dashboard.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/static_home_banner.dart';

class BannerWidget extends ConsumerStatefulWidget {
  final Dashboard dashboardData;
  const BannerWidget({super.key, required this.dashboardData});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {
  static const _bannerHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    if (AppConstants.useStaticHomeBanner) {
      return const StaticHomeBanner();
    }

    if (widget.dashboardData.banners.isEmpty) {
      return const StaticHomeBanner();
    }

    final currentPage = ref.watch(currentPageController);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.dashboardData.banners.length,
                  itemBuilder: (context, index, realIndex) {
                    final banner = widget.dashboardData.banners[index];
                    return _BannerSlide(
                      thumbnail: banner.thumbnail,
                      isActive: currentPage == index,
                    );
                  },
                  options: CarouselOptions(
                    height: _bannerHeight.h,
                    autoPlay: widget.dashboardData.banners.length > 1,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 700),
                    autoPlayCurve: Curves.easeOutCubic,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      ref.read(currentPageController.notifier).state = index;
                    },
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.dashboardData.banners.length,
                      (index) => _BannerDot(
                        isActive: currentPage == index,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _BannerSlide extends StatelessWidget {
  final String thumbnail;
  final bool isActive;

  const _BannerSlide({
    required this.thumbnail,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1 : 0.98,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: EcommerceAppColor.carrotOrange.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBannerImage(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.15),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12.h,
              right: 16.w,
              child: Image.asset(
                'assets/png/app_logo.png',
                width: 72.w,
                height: 30.h,
                fit: BoxFit.contain,
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

  Widget _buildBannerImage() {
    if (thumbnail.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: thumbnail,
        fit: BoxFit.cover,
        placeholder: (_, __) => Image.asset(
          'assets/png/banner.png',
          fit: BoxFit.cover,
        ),
        errorWidget: (_, __, ___) => Image.asset(
          'assets/png/banner.png',
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      'assets/png/banner.png',
      fit: BoxFit.cover,
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
        color: isActive
            ? Colors.white
            : Colors.white.withOpacity(0.45),
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
