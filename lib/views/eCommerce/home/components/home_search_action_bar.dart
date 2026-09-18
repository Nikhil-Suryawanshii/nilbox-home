import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/home_header_bar.dart';

enum HomeSearchBarStyle { transparent, frosted }

class HomeSearchActionBar extends ConsumerWidget {
  final VoidCallback onSearchTap;
  final VoidCallback? onNotificationTap;
  final bool embedInHeader;
  final HomeSearchBarStyle searchStyle;
  final bool enableAnimations;

  const HomeSearchActionBar({
    super.key,
    required this.onSearchTap,
    this.onNotificationTap,
    this.embedInHeader = false,
    this.searchStyle = HomeSearchBarStyle.transparent,
    this.enableAnimations = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartController).cartItems.length;

    Widget searchField = _SearchField(
      onTap: onSearchTap,
      style: searchStyle,
    );
    if (enableAnimations) {
      searchField = searchField
          .animate()
          .fadeIn(duration: 380.ms, delay: 80.ms)
          .slideY(
            begin: -0.15,
            end: 0,
            duration: 400.ms,
            delay: 80.ms,
            curve: Curves.easeOutCubic,
          );
    }

    final content = Row(
      children: [
        Expanded(child: searchField),
        Gap(10.w),
        HeaderGlassButton(
          icon: Assets.svg.homePageNotification,
          onTap: onNotificationTap ?? () {},
          showDot: true,
          animationDelay: enableAnimations ? 160.ms : Duration.zero,
        ),
        Gap(8.w),
        _CartGlassButton(
          cartCount: cartCount,
          animationDelay: enableAnimations ? 240.ms : Duration.zero,
          enableAnimations: enableAnimations,
        ),
      ],
    );

    if (embedInHeader) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        child: content,
      );
    }

    return Container(
      decoration: HomeHeaderBar.decoration(roundedBottom: true),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: content,
    );
  }
}

class _SearchField extends StatefulWidget {
  final VoidCallback onTap;
  final HomeSearchBarStyle style;

  const _SearchField({
    required this.onTap,
    this.style = HomeSearchBarStyle.transparent,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.style == HomeSearchBarStyle.frosted ? 14 : 8,
              sigmaY: widget.style == HomeSearchBarStyle.frosted ? 14 : 8,
            ),
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: widget.style == HomeSearchBarStyle.frosted
                    ? Colors.white.withOpacity(0.78)
                    : Colors.white.withOpacity(0.52),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.65),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.svg.searchHome,
                    height: 18.h,
                    colorFilter: ColorFilter.mode(
                      EcommerceAppColor.carrotOrange.withOpacity(0.9),
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      'Search for products, brands...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context).bodyText.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 20.sp,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartGlassButton extends StatelessWidget {
  final int cartCount;
  final Duration animationDelay;
  final bool enableAnimations;

  const _CartGlassButton({
    required this.cartCount,
    required this.animationDelay,
    this.enableAnimations = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = HeaderGlassButton(
      icon: Assets.svg.shoppingBag,
      animationDelay: animationDelay,
      onTap: () {
        context.nav.pushNamed(
          Routes.getMyCartViewRouteName(AppConstants.appServiceName),
          arguments: [false, false],
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            Assets.svg.shoppingBag,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              colors(context).dark!,
              BlendMode.srcIn,
            ),
          ),
          if (cartCount > 0)
            Positioned(
              top: -2.h,
              right: -2.w,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: EcommerceAppColor.carrotOrange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                child: Center(
                  child: Text(
                    cartCount > 9 ? '9+' : '$cartCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (!enableAnimations) return button;

    return button
        .animate(key: ValueKey('cart-badge-$cartCount'))
        .scale(
          begin: const Offset(1.1, 1.1),
          end: const Offset(1, 1),
          duration: 320.ms,
          curve: Curves.elasticOut,
        );
  }
}
