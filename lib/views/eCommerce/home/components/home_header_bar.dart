import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';

class HomeHeaderBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback? onLiveTap;

  const HomeHeaderBar({
    super.key,
    required this.onProfileTap,
    this.onLiveTap,
  });

  static const _accentOrange = Color(0xFFFF5722);

  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD4B8),
      Color(0xFFFFE0C8),
      Color(0xFFFFF0E6),
      Color(0xFFFFF8F4),
    ],
    stops: [0.0, 0.25, 0.6, 1.0],
  );

  static BoxDecoration decoration({bool roundedBottom = false}) {
    return BoxDecoration(
      gradient: headerGradient,
      borderRadius: roundedBottom
          ? BorderRadius.only(
              bottomLeft: Radius.circular(22.r),
              bottomRight: Radius.circular(22.r),
            )
          : null,
    );
  }

  /// Fills the notch / status-bar area with the same header gradient.
  static Widget statusBarFill(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    if (topInset <= 0) return const SizedBox.shrink();

    return SizedBox(
      height: topInset,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0xFFFFD4B8),
              Color(0xFFFFE0C8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      decoration: decoration(),
      padding: EdgeInsets.only(top: topInset),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -topInset - 10.h,
            right: -30.w,
            child: _DecorBlob(size: 130.w, opacity: 0.2),
          ),
          Positioned(
            top: -topInset + 8.h,
            left: -25.w,
            child: _DecorBlob(size: 90.w, opacity: 0.14),
          ),
          Positioned(
            bottom: -10.h,
            left: -20.w,
            child: _DecorBlob(size: 80.w, opacity: 0.12),
          ),
          HomeLogoRow(
            onProfileTap: onProfileTap,
            onLiveTap: onLiveTap,
          ),
        ],
      ),
    );
  }
}

class HomeLogoRow extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback? onLiveTap;

  const HomeLogoRow({
    super.key,
    required this.onProfileTap,
    this.onLiveTap,
  });

  /// Total vertical space: top padding + content + bottom padding.
  static double get preferredHeight => 6.h + 88.h + 10.h;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 10.h),
      child: SizedBox(
        height: 88.h,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: const _NilboxBrandLogo(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: _LiveBadgeButton(onTap: onLiveTap),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: HeaderGlassButton(
                icon: Assets.svg.profileIcon,
                onTap: onProfileTap,
                animationDelay: 180.ms,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorBlob extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorBlob({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: HomeHeaderBar._accentOrange.withOpacity(opacity),
      ),
    );
  }
}

class _NilboxBrandLogo extends StatelessWidget {
  const _NilboxBrandLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/png/app_logo.png',
          height: 36.h,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
        ),
        Gap(3.h),
        Text(
          'SHOP · DISCOVER · LIVE',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 1.4,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 60.ms)
        .slideX(
          begin: -0.12,
          end: 0,
          duration: 420.ms,
          delay: 60.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _LiveBadgeButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _LiveBadgeButton({this.onTap});

  @override
  State<_LiveBadgeButton> createState() => _LiveBadgeButtonState();
}

class _LiveBadgeButtonState extends State<_LiveBadgeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: Image.asset(
          'assets/png/live_badge.png',
          height: 74.h,
          width: 74.w,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms, delay: 100.ms)
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          duration: 450.ms,
          delay: 100.ms,
          curve: Curves.easeOutBack,
        );
  }
}

class HeaderGlassButton extends StatefulWidget {
  final String icon;
  final VoidCallback onTap;
  final Duration animationDelay;
  final bool showDot;
  final Widget? child;

  const HeaderGlassButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.animationDelay = Duration.zero,
    this.showDot = false,
    this.child,
  });

  @override
  State<HeaderGlassButton> createState() => _HeaderGlassButtonState();
}

class _HeaderGlassButtonState extends State<HeaderGlassButton> {
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
        scale: _pressed ? 0.9 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xFFFFF8F3),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: widget.child ??
                    SvgPicture.asset(
                      widget.icon,
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        colors(context).dark!,
                        BlendMode.srcIn,
                      ),
                    ),
              ),
            ),
            if (widget.showDot)
              Positioned(
                top: 8.h,
                right: 9.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5722),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 380.ms, delay: widget.animationDelay)
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: widget.animationDelay,
          curve: Curves.easeOutBack,
        );
  }
}
