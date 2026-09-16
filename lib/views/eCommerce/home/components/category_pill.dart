import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../config/app_color.dart';
import '../../../../config/app_text_style.dart';

class CategoryPill extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSelected;

  const CategoryPill({
    required this.title,
    required this.imageUrl,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.fromLTRB(isSelected?0.w:10.w, 0, 10.w, 0),
      decoration: BoxDecoration(
        color: isSelected
            ? EcommerceAppColor.carrotOrange
            : Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Avatar (only when selected)
          if (isSelected) ...[
            CircleAvatar(
              radius: 14.r,
              backgroundImage: NetworkImage(imageUrl),
            ),
            Gap(8.w),
          ],

          /// Title
          Text(
            title,
            style: AppTextStyle(context).bodyText.copyWith(
              color: isSelected
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 11
            ),
          ),
        ],
      ),
    );
  }
}
