import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../config/app_color.dart';
import '../../../../config/app_text_style.dart';
import '../../../../gen/assets.gen.dart';

class CategoryFilterTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const CategoryFilterTab({
    super.key,
    required this.title,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  _CategoryStyle _styleForTitle() {
    final name = title.toLowerCase();
    if (name.contains('women') || name.contains('woman')) {
      return const _CategoryStyle(
        icon: Icons.female_rounded,
        accent: Color(0xFFE91E8C),
      );
    }
    if (name.contains('kid') || name.contains('child')) {
      return const _CategoryStyle(
        icon: Icons.child_care_rounded,
        accent: Color(0xFF0EA5E9),
      );
    }
    if (name.contains('men') || name.contains('man')) {
      return const _CategoryStyle(
        icon: Icons.male_rounded,
        accent: Color(0xFF2563EB),
      );
    }
    return const _CategoryStyle(
      icon: Icons.apps_rounded,
      accent: Color(0xFFFF8322),
    );
  }

  void _handleTap() {
    if (isSelected) return;
    HapticFeedback.selectionClick();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleForTitle();
    final stagger = (index * 70).ms;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? EcommerceAppColor.carrotOrange : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? EcommerceAppColor.carrotOrange
                : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: EcommerceAppColor.carrotOrange.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              style.icon,
              size: 18.sp,
              color: isSelected ? Colors.white : style.accent,
            )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.25, 1.25),
                  duration: 450.ms,
                  curve: Curves.elasticOut,
                ),
            Gap(6.w),
            Text(
              title,
              style: AppTextStyle(context).bodyText.copyWith(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 12.sp,
                  ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 350.ms, delay: stagger)
          .slideX(
            begin: 0.2,
            end: 0,
            duration: 400.ms,
            delay: stagger,
            curve: Curves.easeOutCubic,
          )
          .animate(target: isSelected ? 1 : 0)
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.06, 1.06),
            duration: 300.ms,
            curve: Curves.easeOutBack,
          )
          .moveY(
            begin: 0,
            end: -4,
            duration: 300.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

class _CategoryStyle {
  final IconData icon;
  final Color accent;

  const _CategoryStyle({
    required this.icon,
    required this.accent,
  });
}

class CategoryMenuTab extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const CategoryMenuTab({
    super.key,
    required this.index,
    required this.onTap,
  });

  void _handleTap() {
    HapticFeedback.selectionClick();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final stagger = (index * 70).ms;
    const accent = Color(0xFFFF8322);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              Assets.svg.categoryMenu,
              height: 18.h,
              width: 18.h,
              colorFilter: const ColorFilter.mode(
                accent,
                BlendMode.srcIn,
              ),
            ),
            Gap(6.w),
            Text(
              'Menu',
              style: AppTextStyle(context).bodyText.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 350.ms, delay: stagger)
          .slideX(
            begin: 0.2,
            end: 0,
            duration: 400.ms,
            delay: stagger,
            curve: Curves.easeOutCubic,
          )
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: 350.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }
}
