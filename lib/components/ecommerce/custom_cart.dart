import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

class CustomCartWidget extends StatelessWidget {
  const CustomCartWidget({
    super.key,
    required this.context,
    this.iconColor,
    this.backgroundColor,
  });

  final BuildContext context;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensures taps on empty space in the stack are caught
      onTap: () {
        context.nav.pushNamed(
          Routes.getMyCartViewRouteName(AppConstants.appServiceName),
          arguments: [false, false],
        );
      },
      child: Stack(
        alignment: Alignment.center, // Optional: helps center things if needed
        children: [
          /// 1. The Cart Icon
          CircleAvatar(
            radius: 19.r,
            backgroundColor: backgroundColor ?? colors(context).light,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SvgPicture.asset(
                Assets.svg.shoppingCart,
                height: 21.h,
                width: 21.sp,
                colorFilter: ColorFilter.mode(
                    iconColor ?? colors(context).dark!,
                    BlendMode.srcIn),
              ),
            ),
          ),

          /// 2. The Badge (Now clickable because the parent is the detector)
          Positioned(
            right: 5.w,
            top: 5.h,
            child: Consumer(builder: (context, ref, _) {
              return ref.watch(cartController).cartItems.isNotEmpty
                  ? CircleAvatar(
                radius: 8.r,
                backgroundColor: colors(context).errorColor,
                child: Center(
                  child: Text(
                    ref.watch(cartController).cartItems.length.toString(),
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: colors(context).light, fontSize: 10.sp),
                  ),
                ),
              )
                  : const SizedBox();
            }),
          )
        ],
      ),
    );
  }
}


