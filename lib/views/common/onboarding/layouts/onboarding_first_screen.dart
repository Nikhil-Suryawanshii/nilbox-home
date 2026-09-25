import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'onboarding_view1.dart';

class OnboardingFirst extends ConsumerStatefulWidget {
  const OnboardingFirst({super.key});

  @override
  ConsumerState<OnboardingFirst> createState() => _OnboardingFirstState();
}

class _OnboardingFirstState extends ConsumerState<OnboardingFirst> {
  static const _coral = Color(0xFFF28B82);
  static const _coralSoft = Color(0xFFFFA69E);
  static const _coralAccent = Color(0xFFE86A5C);
  static const _bubbleWhite = Color(0xFFFFF8F6);
  static const _labelText = Color(0xFF2D2D2D);

  void _goNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingView1(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_coralSoft, _coral, Color(0xFFE87A6C)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
        child: Stack(
          children: [
            // Soft depth orbs (subtle, not decorative clutter)
            Positioned(
              top: -80,
              right: -60,
              child: _GlowOrb(
                  size: 220, color: Colors.white.withValues(alpha: 0.10)),
            ),
            Positioned(
              bottom: 40,
              left: -70,
              child: _GlowOrb(
                  size: 200, color: Colors.white.withValues(alpha: 0.08)),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  final bottomReserve = (h * 0.16).clamp(100.0, 140.0);
                  final headerReserve = (h * 0.17).clamp(108.0, 140.0);
                  final areaTop = headerReserve;
                  final areaH = h - headerReserve - bottomReserve;
                  final areaW = w;

                  final mainSize = (areaW * 0.46).clamp(150.0, 190.0);
                  final usersSize = (areaW * 0.22).clamp(78.0, 98.0);
                  final smallSize = (areaW * 0.20).clamp(70.0, 90.0);

                  Offset at(double nx, double ny) =>
                      Offset(areaW * nx, areaH * ny);

                  (double left, double top) fromCenter(Offset c, double size) =>
                      (c.dx - size / 2, c.dy - size / 2);

                  // Radial organic layout matching the reference
                  final audioPos = fromCenter(at(0.50, 0.04), smallSize);
                  final jacketPos = fromCenter(at(0.16, 0.18), smallSize);
                  final shoesPos = fromCenter(at(0.84, 0.16), smallSize);
                  final beautyPos =
                      fromCenter(at(0.10, 0.46), smallSize * 0.95);
                  final techPos = fromCenter(at(0.90, 0.42), smallSize * 0.95);
                  final mainPos = fromCenter(at(0.50, 0.42), mainSize);
                  final homePos = fromCenter(at(0.16, 0.72), smallSize);
                  final accessoriesPos =
                      fromCenter(at(0.86, 0.62), smallSize * 0.95);
                  final fashionPos = fromCenter(at(0.78, 0.84), smallSize);
                  // Users sits under main; label hangs below so reserve height
                  final usersExtra = usersSize * 0.32;
                  final usersPos = fromCenter(
                    at(0.42, 0.78),
                    usersSize + usersExtra,
                  );

                  return Stack(
                    children: [
                      Positioned(
                        top: areaTop,
                        left: 0,
                        right: 0,
                        height: areaH,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _ProductBubble(
                              image: 'assets/onboarding/headphones.png',
                              title: 'Audio',
                              size: smallSize,
                              left: audioPos.$1,
                              top: audioPos.$2,
                              enterDelay: 500.ms,
                              floatAmplitude: 3,
                              floatDuration: 2300.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/jacket.png',
                              title: 'Jackets',
                              size: smallSize,
                              left: jacketPos.$1,
                              top: jacketPos.$2,
                              enterDelay: 300.ms,
                              floatAmplitude: 4,
                              floatDuration: 2400.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/shoe.png',
                              title: 'Shoes',
                              size: smallSize,
                              left: shoesPos.$1,
                              top: shoesPos.$2,
                              enterDelay: 400.ms,
                              floatAmplitude: 4,
                              floatDuration: 2600.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/perfume.png',
                              title: 'Beauty',
                              size: smallSize * 0.95,
                              left: beautyPos.$1,
                              top: beautyPos.$2,
                              enterDelay: 800.ms,
                              floatAmplitude: 3,
                              floatDuration: 2500.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/smartwatch.png',
                              title: 'Tech',
                              size: smallSize * 0.95,
                              left: techPos.$1,
                              top: techPos.$2,
                              enterDelay: 1000.ms,
                              floatAmplitude: 3,
                              floatDuration: 2800.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            Positioned(
                              left: mainPos.$1,
                              top: mainPos.$2,
                              child: _MainProductsBubble(
                                size: mainSize,
                                accent: _coralAccent,
                              )
                                  .animate(delay: 600.ms)
                                  .fadeIn(
                                    duration: 450.ms,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .scale(
                                    begin: const Offset(0.85, 0.85),
                                    end: const Offset(1, 1),
                                    duration: 500.ms,
                                    curve: Curves.easeOutBack,
                                  )
                                  .moveY(
                                    begin: 14,
                                    end: 0,
                                    duration: 480.ms,
                                    curve: Curves.easeOutCubic,
                                  ),
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/furniture.png',
                              title: 'Home',
                              size: smallSize,
                              left: homePos.$1,
                              top: homePos.$2,
                              enterDelay: 1000.ms,
                              floatAmplitude: 3,
                              floatDuration: 2550.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/sunglasses.png',
                              title: 'Accessories',
                              size: smallSize * 0.95,
                              left: accessoriesPos.$1,
                              top: accessoriesPos.$2,
                              enterDelay: 900.ms,
                              floatAmplitude: 4,
                              floatDuration: 2700.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            _ProductBubble(
                              image: 'assets/onboarding/shopping_bag.png',
                              title: 'Fashion',
                              size: smallSize,
                              left: fashionPos.$1,
                              top: fashionPos.$2,
                              enterDelay: 1100.ms,
                              floatAmplitude: 4,
                              floatDuration: 2450.ms,
                              bubbleColor: _bubbleWhite,
                              labelColor: _labelText,
                            ),
                            Positioned(
                              left: usersPos.$1,
                              top: usersPos.$2,
                              child: _UsersBubble(size: usersSize)
                                  .animate(delay: 1200.ms)
                                  .fadeIn(
                                    duration: 420.ms,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .scale(
                                    begin: const Offset(0.82, 0.82),
                                    end: const Offset(1, 1),
                                    duration: 480.ms,
                                    curve: Curves.easeOutBack,
                                  )
                                  .moveY(
                                    begin: 12,
                                    end: 0,
                                    duration: 450.ms,
                                    curve: Curves.easeOutCubic,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Header
                      Positioned(
                        top: 4.h,
                        left: 22.w,
                        right: 22.w,
                        child: const _OnboardingHeader()
                            .animate()
                            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                            .moveY(
                              begin: -10,
                              end: 0,
                              duration: 420.ms,
                              curve: Curves.easeOutCubic,
                            ),
                      ),

                      // Bottom copy + Get Started
                      Positioned(
                        left: 22.w,
                        right: 20.w,
                        bottom: 12.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'Discover, shop and connect\nwith products you love.',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.35,
                                ),
                              )
                                  .animate(delay: 1400.ms)
                                  .fadeIn(
                                    duration: 420.ms,
                                    curve: Curves.easeOut,
                                  )
                                  .moveY(
                                    begin: 12,
                                    end: 0,
                                    duration: 450.ms,
                                    curve: Curves.easeOutCubic,
                                  ),
                            ),
                            Gap(12.w),
                            _GetStartedButton(onTap: _goNext)
                                .animate(delay: 1600.ms)
                                .fadeIn(
                                  duration: 400.ms,
                                  curve: Curves.easeOut,
                                )
                                .scale(
                                  begin: const Offset(0.88, 0.88),
                                  end: const Offset(1, 1),
                                  duration: 450.ms,
                                  curve: Curves.easeOutBack,
                                ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

    if (!kIsWeb && Platform.isAndroid) {
      content = SafeArea(
        top: false,
        bottom: true,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: (!kIsWeb && Platform.isAndroid) ? Colors.black : Colors.white,
      body: content,
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 26.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              'Nilbox',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
              ),
            ),
            SizedBox(width: 8.w),
            Text('👋', style: TextStyle(fontSize: 26.sp)),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Your marketplace for every lifestyle.',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.88),
          ),
        ),
      ],
    );
  }
}

class _ProductBubble extends StatelessWidget {
  const _ProductBubble({
    required this.image,
    required this.title,
    required this.size,
    required this.left,
    required this.top,
    required this.enterDelay,
    required this.floatAmplitude,
    required this.floatDuration,
    required this.bubbleColor,
    required this.labelColor,
  });

  final String image;
  final String title;
  final double size;
  final double left;
  final double top;
  final Duration enterDelay;
  final double floatAmplitude;
  final Duration floatDuration;
  final Color bubbleColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final labelHeight = (size * 0.28).clamp(22.0, 28.0);

    return Positioned(
      left: left,
      top: top,
      child: Animate(
        delay: enterDelay + 480.ms,
        onPlay: (controller) => controller.repeat(reverse: true),
        effects: [
          MoveEffect(
            begin: Offset(0, -floatAmplitude),
            end: Offset(0, floatAmplitude),
            duration: floatDuration,
            curve: Curves.easeInOut,
          ),
        ],
        child: SizedBox(
          width: size,
          height: size + labelHeight * 0.45,
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: bubbleColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(size * 0.16),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: (size * 0.14).clamp(8.0, 14.0),
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: labelColor,
                      fontSize: (size * 0.12).clamp(9.0, 11.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(delay: enterDelay)
            .fadeIn(duration: 420.ms, curve: Curves.easeOutCubic)
            .scale(
              begin: const Offset(0.78, 0.78),
              end: const Offset(1, 1),
              duration: 480.ms,
              curve: Curves.easeOutBack,
            )
            .moveY(
              begin: 14,
              end: 0,
              duration: 460.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }
}

class _MainProductsBubble extends StatelessWidget {
  const _MainProductsBubble({
    required this.size,
    required this.accent,
  });

  final double size;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final thumb = size * 0.30;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: thumb * 1.7,
            width: size * 0.78,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: size * 0.02,
                  top: thumb * 0.25,
                  child: _ProductThumb(
                    asset: 'assets/onboarding/shopping_bag.png',
                    size: thumb * 1.05,
                  ),
                ),
                Positioned(
                  right: size * 0.02,
                  top: thumb * 0.15,
                  child: _ProductThumb(
                    asset: 'assets/onboarding/headphones.png',
                    size: thumb * 1.05,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: size * 0.14,
                  child: _ProductThumb(
                    asset: 'assets/onboarding/shoe.png',
                    size: thumb * 1.12,
                  ),
                ),
                Positioned(
                  bottom: thumb * 0.05,
                  right: size * 0.10,
                  child: _ProductThumb(
                    asset: 'assets/onboarding/smartwatch.png',
                    size: thumb * 0.95,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size * 0.03),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '34k',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    color: accent,
                    fontSize: (size * 0.105).clamp(14.0, 18.0),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' Products',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    color: const Color(0xFF2D2D2D),
                    fontSize: (size * 0.095).clamp(13.0, 16.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Discover products you love',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Mulish',
              color: const Color(0xFF6B6B6B),
              fontSize: (size * 0.055).clamp(9.0, 11.0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
      ),
    );
  }
}

class _UsersBubble extends StatelessWidget {
  const _UsersBubble({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final avatar = size * 0.34;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: SizedBox(
            height: avatar,
            width: avatar * 2.35,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: _UserAvatar(
                    size: avatar,
                    asset: 'assets/png/onboarding_user.png',
                  ),
                ),
                Positioned(
                  left: avatar * 0.52,
                  child: _UserAvatar(
                    size: avatar,
                    asset: 'assets/png/onboarding_user.png',
                  ),
                ),
                Positioned(
                  left: avatar * 1.04,
                  child: Container(
                    width: avatar,
                    height: avatar,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28B82),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: avatar * 0.55,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '1.4k Users',
          style: TextStyle(
            fontFamily: 'Mulish',
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.size, required this.asset});

  final double size;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.w,
        height: 72.w,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 26.sp),
            Gap(3.h),
            Text(
              'Get started',
              style: TextStyle(
                fontFamily: 'Mulish',
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
