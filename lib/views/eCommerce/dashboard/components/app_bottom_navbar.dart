import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/views/eCommerce/dashboard/layouts/dashboard_layout.dart';

/// Platform-specific bottom navigation:
/// - iOS: glass pill floating bar (existing design)
/// - Android: simple Material docked bar (same tabs + Sell)
class AppBottomNavbar extends ConsumerWidget {
  const AppBottomNavbar({
    super.key,
    required this.bottomItem,
    required this.onSelect,
    this.onSellTap,
  });

  final List<BottomItem> bottomItem;
  final Function(int? index) onSelect;
  final VoidCallback? onSellTap;

  static bool get isIOS => Platform.isIOS;

  static double horizontalMargin(BuildContext context) => isIOS ? 16.w : 0;

  static double sellCenterGap(BuildContext context) => isIOS ? 54.w : 56.w;

  static double systemBottomInset(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom;
  }

  /// Space above the system navigation stripe / home indicator.
  static double bottomSafeMargin(BuildContext context) {
    final inset = systemBottomInset(context);
    if (isIOS) {
      return inset > 0 ? inset + 8.h : 12.h;
    }
    // Android: sit flush above nav stripe with a small breathing gap.
    return inset > 0 ? inset + 4.h : 8.h;
  }

  static double barHeight(BuildContext context) => isIOS ? 75.h : 62.h;

  static double shellHeight(BuildContext context) {
    if (isIOS) {
      return 25.h + barHeight(context) + bottomSafeMargin(context);
    }
    // Android: room for slightly elevated Sell FAB above the bar.
    return 18.h + barHeight(context) + bottomSafeMargin(context);
  }

  static double sellFabBottom(BuildContext context) {
    if (isIOS) {
      return bottomSafeMargin(context) + 12.h;
    }
    return bottomSafeMargin(context) + 6.h;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isIOS) {
      return _IosGlassBottomNavbar(
        bottomItem: bottomItem,
        onSelect: onSelect,
      );
    }
    return _AndroidSimpleBottomNavbar(
      bottomItem: bottomItem,
      onSelect: onSelect,
    );
  }
}

// -----------------------------------------------------------------------------
// iOS — keep existing glass pill design
// -----------------------------------------------------------------------------
class _IosGlassBottomNavbar extends ConsumerWidget {
  const _IosGlassBottomNavbar({
    required this.bottomItem,
    required this.onSelect,
  });

  final List<BottomItem> bottomItem;
  final Function(int? index) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideMargin = AppBottomNavbar.horizontalMargin(context);
    final sellGap = AppBottomNavbar.sellCenterGap(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sideMargin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            height: AppBottomNavbar.barHeight(context),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(40.r),
              border: Border.all(
                color: const Color(0xFFF97316),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _NavTap(
                    bottomItem: bottomItem[0],
                    index: 0,
                    onSelect: onSelect,
                    style: _NavItemStyle.ios,
                  ),
                ),
                Expanded(
                  child: _NavTap(
                    bottomItem: bottomItem[1],
                    index: 1,
                    onSelect: onSelect,
                    style: _NavItemStyle.ios,
                  ),
                ),
                SizedBox(width: sellGap),
                Expanded(
                  child: _NavTap(
                    bottomItem: bottomItem[2],
                    index: 2,
                    onSelect: onSelect,
                    style: _NavItemStyle.ios,
                  ),
                ),
                Expanded(
                  child: _NavTap(
                    bottomItem: bottomItem[3],
                    index: 3,
                    onSelect: onSelect,
                    style: _NavItemStyle.ios,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Android — simple Material docked bar, same tabs + Sell gap
// -----------------------------------------------------------------------------
class _AndroidSimpleBottomNavbar extends ConsumerWidget {
  const _AndroidSimpleBottomNavbar({
    required this.bottomItem,
    required this.onSelect,
  });

  final List<BottomItem> bottomItem;
  final Function(int? index) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellGap = AppBottomNavbar.sellCenterGap(context);

    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.12),
      child: Container(
        height: AppBottomNavbar.barHeight(context),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.black.withOpacity(0.08),
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavTap(
                bottomItem: bottomItem[0],
                index: 0,
                onSelect: onSelect,
                style: _NavItemStyle.android,
              ),
            ),
            Expanded(
              child: _NavTap(
                bottomItem: bottomItem[1],
                index: 1,
                onSelect: onSelect,
                style: _NavItemStyle.android,
              ),
            ),
            SizedBox(width: sellGap),
            Expanded(
              child: _NavTap(
                bottomItem: bottomItem[2],
                index: 2,
                onSelect: onSelect,
                style: _NavItemStyle.android,
              ),
            ),
            Expanded(
              child: _NavTap(
                bottomItem: bottomItem[3],
                index: 3,
                onSelect: onSelect,
                style: _NavItemStyle.android,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _NavItemStyle { ios, android }

class _NavTap extends ConsumerWidget {
  const _NavTap({
    required this.bottomItem,
    required this.index,
    required this.onSelect,
    required this.style,
  });

  final BottomItem bottomItem;
  final int index;
  final Function(int? index) onSelect;
  final _NavItemStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelect(index),
      child: Center(
        child: style == _NavItemStyle.ios
            ? _IosNavItem(bottomItem: bottomItem, index: index)
            : _AndroidNavItem(bottomItem: bottomItem, index: index),
      ),
    );
  }
}

class _IosNavItem extends ConsumerWidget {
  const _IosNavItem({
    required this.bottomItem,
    required this.index,
  });

  final BottomItem bottomItem;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final isSelected = index == selectedIndex;
    final iconPath = isSelected ? bottomItem.activeIcon : bottomItem.icon;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 37.h,
                width: 37.w,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              SizedBox(
                height: 37.h,
                width: 37.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeInBack,
                      transitionBuilder: (child, animation) {
                        if (index == 0 && isSelected) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 1.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        }
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: SvgPicture.asset(
                        iconPath,
                        key: ValueKey<String>(iconPath),
                        colorFilter: isSelected
                            ? ColorFilter.mode(
                                colors(context).light!, BlendMode.srcIn)
                            : ColorFilter.mode(
                                colors(context).dark!, BlendMode.srcIn),
                        height: index == 2 ? 20 : 26.h,
                        width: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 75.w),
            child: Text(
              bottomItem.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontSize: 10.sp,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AndroidNavItem extends ConsumerWidget {
  const _AndroidNavItem({
    required this.bottomItem,
    required this.index,
  });

  final BottomItem bottomItem;
  final int index;

  static const _accent = Color(0xFFF57C00);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final isSelected = index == selectedIndex;
    final iconPath = isSelected ? bottomItem.activeIcon : bottomItem.icon;
    final color = isSelected ? _accent : const Color(0xFF6B7280);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          height: 24.h,
          width: 24.w,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        SizedBox(height: 4.h),
        Text(
          bottomItem.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyle(context).bodyTextSmall.copyWith(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
        ),
        SizedBox(height: 2.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 3.h,
          width: isSelected ? 18.w : 0,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}
