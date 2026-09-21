import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/views/eCommerce/dashboard/layouts/dashboard_layout.dart';

/// Platform-specific bottom navigation:
/// - iOS: glass pill floating bar (existing design)
/// - Android: docked white rounded bar flush above system nav (image design)
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
  static bool get isAndroid => Platform.isAndroid;

  static const androidAccent = Color(0xFFFF8322); // same orange as iOS hover
  static const androidSellOrange = Color(0xFFF57C00);
  static const androidInactive = Color(0xFF1A1A1A);

  static double horizontalMargin(BuildContext context) => isIOS ? 16.w : 0;

  static double sellCenterGap(BuildContext context) => isIOS ? 54.w : 64.w;

  static double systemBottomInset(BuildContext context) {
    return MediaQuery.viewPaddingOf(context).bottom;
  }

  /// iOS: float above home indicator.
  /// Android: exactly the system nav height so the app bar sits flush on it.
  static double bottomSafeMargin(BuildContext context) {
    final inset = systemBottomInset(context);
    if (isIOS) {
      return inset > 0 ? inset + 8.h : 12.h;
    }
    return inset; // flush above Android system nav stripe
  }

  static double barHeight(BuildContext context) => isIOS ? 75.h : 64.h;

  static double shellHeight(BuildContext context) {
    if (isIOS) {
      return 25.h + barHeight(context) + bottomSafeMargin(context);
    }
    // Android: only white bar + system nav inset (no extra gap above).
    return barHeight(context) + bottomSafeMargin(context);
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
    return _AndroidDockedBottomNavbar(
      bottomItem: bottomItem,
      onSelect: onSelect,
      onSellTap: onSellTap,
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
                  child: _IosNavTap(
                    bottomItem: bottomItem[0],
                    index: 0,
                    onSelect: onSelect,
                  ),
                ),
                Expanded(
                  child: _IosNavTap(
                    bottomItem: bottomItem[1],
                    index: 1,
                    onSelect: onSelect,
                  ),
                ),
                SizedBox(width: sellGap),
                Expanded(
                  child: _IosNavTap(
                    bottomItem: bottomItem[2],
                    index: 2,
                    onSelect: onSelect,
                  ),
                ),
                Expanded(
                  child: _IosNavTap(
                    bottomItem: bottomItem[3],
                    index: 3,
                    onSelect: onSelect,
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

class _IosNavTap extends ConsumerWidget {
  const _IosNavTap({
    required this.bottomItem,
    required this.index,
    required this.onSelect,
  });

  final BottomItem bottomItem;
  final int index;
  final Function(int? index) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelect(index),
      child: Center(
        child: _IosNavItem(bottomItem: bottomItem, index: index),
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

// -----------------------------------------------------------------------------
// Android — docked white bar flush above system nav (matches reference image)
// -----------------------------------------------------------------------------
class _AndroidDockedBottomNavbar extends ConsumerWidget {
  const _AndroidDockedBottomNavbar({
    required this.bottomItem,
    required this.onSelect,
    this.onSellTap,
  });

  final List<BottomItem> bottomItem;
  final Function(int? index) onSelect;
  final VoidCallback? onSellTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemInset = AppBottomNavbar.systemBottomInset(context);
    final barH = AppBottomNavbar.barHeight(context);

    return SizedBox(
      height: barH + systemInset,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Dark strip behind Android system nav buttons.
          if (systemInset > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: systemInset,
              child: const ColoredBox(color: Color(0xFF000000)),
            ),

          // White app nav bar — flush above the dark system nav area.
          Positioned(
            left: 0,
            right: 0,
            bottom: systemInset,
            child: Container(
              height: barH,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _AndroidNavItem(
                      bottomItem: bottomItem[0],
                      index: 0,
                      onSelect: onSelect,
                    ),
                  ),
                  Expanded(
                    child: _AndroidNavItem(
                      bottomItem: bottomItem[1],
                      index: 1,
                      onSelect: onSelect,
                    ),
                  ),
                  SizedBox(width: AppBottomNavbar.sellCenterGap(context)),
                  Expanded(
                    child: _AndroidNavItem(
                      bottomItem: bottomItem[2],
                      index: 2,
                      onSelect: onSelect,
                    ),
                  ),
                  Expanded(
                    child: _AndroidNavItem(
                      bottomItem: bottomItem[3],
                      index: 3,
                      onSelect: onSelect,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sell FAB — raised slightly; overflows without reserving extra height.
          Positioned(
            bottom: systemInset + 6.h,
            left: 0,
            right: 0,
            child: Center(
              child: Transform.translate(
                offset: Offset(0, -18.h),
                child: _AndroidSellFab(onTap: onSellTap),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AndroidSellFab extends StatelessWidget {
  const _AndroidSellFab({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: AppBottomNavbar.androidSellOrange.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppBottomNavbar.androidSellOrange,
              ),
              child: Center(
                child: SvgPicture.asset(
                  Assets.svg.camera,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Sell',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppBottomNavbar.androidInactive,
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
    required this.onSelect,
  });

  final BottomItem bottomItem;
  final int index;
  final Function(int? index) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final isSelected = index == selectedIndex;
    // Uses activeIcon (rocket when home scrolled) — same as iOS.
    final iconPath = isSelected ? bottomItem.activeIcon : bottomItem.icon;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelect(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Same orange circle hover/selected background as iOS.
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                height: 37.h,
                width: 37.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppBottomNavbar.androidAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              SizedBox(
                height: 37.h,
                width: 37.w,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
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
                      height: 24.h,
                      width: 24.w,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? Colors.white
                            : AppBottomNavbar.androidInactive,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            bottomItem.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
