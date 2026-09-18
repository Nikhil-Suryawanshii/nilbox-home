import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/home_header_bar.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/home_search_action_bar.dart';

/// Lifestyle image + warm gradient used behind the home header.
class HomeHeaderBackground extends StatelessWidget {
  const HomeHeaderBackground({super.key});

  static const headerBgAsset = 'assets/png/home_header_bg.png';

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Image.asset(
            headerBgAsset,
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFFE0C8).withOpacity(0.55),
                const Color(0xFFFFF0E6).withOpacity(0.45),
                const Color(0xFFFFF8F4).withOpacity(0.35),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

/// Unified home header with full-bleed lifestyle background behind the notch.
class HomeHeaderSection extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback? onLiveTap;
  final VoidCallback onSearchTap;
  final VoidCallback? onNotificationTap;

  const HomeHeaderSection({
    super.key,
    required this.onProfileTap,
    this.onLiveTap,
    required this.onSearchTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(22.r),
        bottomRight: Radius.circular(22.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: HomeHeaderBackground()),
          Padding(
            padding: EdgeInsets.only(top: topInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeLogoRow(
                  onProfileTap: onProfileTap,
                  onLiveTap: onLiveTap,
                ),
                HomeSearchActionBar(
                  onSearchTap: onSearchTap,
                  onNotificationTap: onNotificationTap,
                  embedInHeader: true,
                  searchStyle: HomeSearchBarStyle.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
