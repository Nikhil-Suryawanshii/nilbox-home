// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
// import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
// import 'package:ready_ecommerce/views/eCommerce/dashboard/layouts/dashboard_layout.dart';

// class AppBottomNavbar extends ConsumerWidget {
//   const AppBottomNavbar({
//     super.key,
//     required this.bottomItem,
//     required this.onSelect,
//   });
//   final List<BottomItem> bottomItem;
//   final Function(int? index) onSelect;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       height: 80.h,
//       padding: EdgeInsets.symmetric(vertical: 5.h),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(
//           bottomItem.length,
//           (index) {
//             return GestureDetector(
//               onTap: () {
//                 onSelect(index);
//               },
//               child: Container(
//                 color: Colors.transparent,
//                 child: _buildBottomItem(
//                   bottomItem: bottomItem[index],
//                   index: index,
//                   context: context,
//                   ref: ref,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomItem({
//     required BottomItem bottomItem,
//     required int index,
//     required BuildContext context,
//     required WidgetRef ref,
//   }) {
//     final int selectedIndex = ref.watch(selectedTabIndexProvider);

//     final isSelected = index == selectedIndex;

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: isSelected
//           ? BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: colors(context).primaryColor?.withOpacity(0.1))
//           : null,
//       width: isSelected ? 100.w : 80.w,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.zero,
//                 height: 42.h,
//                 width: 42.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Center(
//                   child: SvgPicture.asset(
//                     colorFilter: isSelected
//                         ? ColorFilter.mode(
//                             colors(context).primaryColor!, BlendMode.srcIn)
//                         : null,
//                     isSelected ? bottomItem.activeIcon : bottomItem.icon,
//                     height: 26.h,
//                     width: 26.w,
//                   ),
//                 ),
//               ),
//               if (index == 1 && !isSelected) ...[
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Consumer(
//                     builder: (context, ref, _) {
//                       return ref.watch(cartController).cartItems.isNotEmpty
//                           ? CircleAvatar(
//                               radius: 7.r,
//                               backgroundColor: colors(context).errorColor,
//                               child: Center(
//                                 child: Text(
//                                   ref
//                                       .watch(cartController.notifier)
//                                       .cartItems
//                                       .length
//                                       .toString(),
//                                   style: AppTextStyle(context)
//                                       .bodyTextSmall
//                                       .copyWith(fontSize: 10)
//                                       .copyWith(color: colors(context).light),
//                                 ),
//                               ),
//                             )
//                           : const SizedBox();
//                     },
//                   ),
//                 )
//               ]
//             ],
//           ),
//           if (isSelected)
//             TweenAnimationBuilder<double>(
//               tween: Tween<double>(begin: -5, end: 1),
//               duration: const Duration(milliseconds: 300),
//               builder: (context, value, child) {
//                 return Text(
//                   bottomItem.name,
//                   style: AppTextStyle(context).bodyTextSmall.copyWith(
//                         fontWeight: FontWeight.w500,
//                         color: isSelected
//                             ? colors(context).primaryColor
//                             : colors(context).bodyTextSmallColor,
//                       ),
//                 );
//               },
//             )
//         ],
//       ),
//     );
//   }
// }


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';

import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/views/eCommerce/dashboard/layouts/dashboard_layout.dart';

import '../../../../gen/assets.gen.dart';
import '../../../seller/auth/seller_auth_gate_view.dart';
import '../../../seller/dashboard/product_management/add_product_view.dart';

class AppBottomNavbar extends ConsumerWidget {
  const AppBottomNavbar({
    super.key,
    required this.bottomItem,
    required this.onSelect,
  });
  final List<BottomItem> bottomItem;
  final Function(int? index) onSelect;



  static double horizontalMargin(BuildContext context) => 16.w;

  static double sellCenterGap(BuildContext context) => 54.w;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideMargin = horizontalMargin(context);
    final sellGap = sellCenterGap(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sideMargin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            height: 75.h,
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
                  child: _buildNavTap(
                    bottomItem: bottomItem[0],
                    index: 0,
                    context: context,
                    ref: ref,
                  ),
                ),
                Expanded(
                  child: _buildNavTap(
                    bottomItem: bottomItem[1],
                    index: 1,
                    context: context,
                    ref: ref,
                  ),
                ),
                SizedBox(width: sellGap),
                Expanded(
                  child: _buildNavTap(
                    bottomItem: bottomItem[2],
                    index: 2,
                    context: context,
                    ref: ref,
                  ),
                ),
                Expanded(
                  child: _buildNavTap(
                    bottomItem: bottomItem[3],
                    index: 3,
                    context: context,
                    ref: ref,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavTap({
    required BottomItem bottomItem,
    required int index,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelect(index),
      child: Center(
        child: _buildBottomItem(
          bottomItem: bottomItem,
          index: index,
          context: context,
          ref: ref,
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required BottomItem bottomItem,
    required int index,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final int selectedIndex = ref.watch(selectedTabIndexProvider);
    final isSelected = index == selectedIndex;

    // Determine the icon path dynamically
    final String iconPath = isSelected ? bottomItem.activeIcon : bottomItem.icon;
    // if (bottomItem.isSpacer) {
    //   return const SizedBox(width: 10); // 👈 controls spacing
    // }
    return AnimatedContainer(
      // 🛑 3. VISUAL PILL: This grows/shrinks, but because it is inside
      // the 'Center' widget above, it doesn't affect the neighbor's position.
      // color: Colors.red,
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
              // The Orange Circle
              Container(
                height: 37.h,
                width: 37.w,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),

              // The Icon
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
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        // Logic: Rocket slides up, others just fade/scale slightly
                        // This prevents visual glitches on normal tabs
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
                        key: ValueKey<String>(iconPath), // Triggers animation
                        colorFilter: isSelected
                            ? ColorFilter.mode(colors(context).light!, BlendMode.srcIn)
                            : ColorFilter.mode(colors(context).dark!, BlendMode.srcIn),
                        height: index == 2 ? 20 : 26.h, // Tweaked icon size slightly
                        width: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // The Text Label (Only shows when selected to save space, or keep your logic)
          // I constrained the width to prevent text from pushing layout
          Container(
            constraints: BoxConstraints(maxWidth: 75.w),
            child: Text(
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
          )
        ],
      ),
    );
  }
}