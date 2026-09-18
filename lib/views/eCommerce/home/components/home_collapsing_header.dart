import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/home_header_bar.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/home_header_section.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/home_search_action_bar.dart';

/// Collapsing home header: logo row scrolls away, search pins below the notch.
class HomeCollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomeCollapsingHeaderDelegate({
    required this.topInset,
    required this.onProfileTap,
    required this.onLiveTap,
    required this.onSearchTap,
    required this.onNotificationTap,
  });

  final double topInset;
  final VoidCallback onProfileTap;
  final VoidCallback? onLiveTap;
  final VoidCallback onSearchTap;
  final VoidCallback? onNotificationTap;

  double get _logoSectionHeight => HomeLogoRow.preferredHeight;
  double get _searchSectionHeight => 56.h;

  @override
  double get maxExtent =>
      topInset + _logoSectionHeight + _searchSectionHeight;

  @override
  double get minExtent => topInset + _searchSectionHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final range = maxExtent - minExtent;
    final progress = range > 0 ? (shrinkOffset / range).clamp(0.0, 1.0) : 0.0;
    final collapseFactor = (1 - progress).clamp(0.0, 1.0);
    final isCollapsed = progress > 0.92 || overlapsContent;
    final searchStyle = progress > 0.35
        ? HomeSearchBarStyle.frosted
        : HomeSearchBarStyle.transparent;

    return ClipRRect(
      borderRadius: isCollapsed
          ? BorderRadius.zero
          : BorderRadius.only(
              bottomLeft: Radius.circular(22.r),
              bottomRight: Radius.circular(22.r),
            ),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          Opacity(
            opacity: (1 - progress * 0.95).clamp(0.0, 1.0),
            child: const HomeHeaderBackground(),
          ),
          if (progress > 0.02)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10 + (progress * 8),
                sigmaY: 10 + (progress * 8),
              ),
              child: Container(
                color: Color.lerp(
                  const Color(0xFFFFF0E6).withOpacity(0.08),
                  const Color(0xFFFFF0E6).withOpacity(0.82),
                  progress,
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: topInset),
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: collapseFactor,
                  child: Opacity(
                    opacity: collapseFactor,
                    child: HomeLogoRow(
                      onProfileTap: onProfileTap,
                      onLiveTap: onLiveTap,
                    ),
                  ),
                ),
              ),
              HomeSearchActionBar(
                onSearchTap: onSearchTap,
                onNotificationTap: onNotificationTap,
                embedInHeader: true,
                searchStyle: searchStyle,
                enableAnimations: progress < 0.05,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeCollapsingHeaderDelegate oldDelegate) {
    return oldDelegate.topInset != topInset;
  }
}
