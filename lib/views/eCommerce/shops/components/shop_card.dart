import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/eCommerce/shop/shop.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

import '../../../../controllers/eCommerce/shop/shop_controller.dart';

// class ShopCard extends StatelessWidget {
//   final Shop shop;
//
//   const ShopCard({
//     super.key,
//     required this.shop,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.nav.pushNamed(
//           Routes.getShopViewRouteName(AppConstants.appServiceName),
//           arguments: shop.id,
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(80.r),
//             bottomLeft: Radius.circular(10.r),
//             bottomRight: Radius.circular(10.r),
//             topRight: Radius.circular(80.r),
//           ),
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.grey.withOpacity(0.2),
//               width: 1,
//             ),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     height: 150.w,
//                     width: 150.w,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 3.w,
//                       ),
//                       image: DecorationImage(
//                         fit: BoxFit.cover,
//                         image: CachedNetworkImageProvider(
//                           shop.logo,
//                           errorListener: (error) =>
//                               debugPrint(error.toString()),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 10.h,
//                     right: 10.w,
//                     child: Container(
//                       height: 32.h,
//                       width: 32.w,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.favorite,
//                         size: 16.sp,
//
//                         color: Color(0xffF27A1A),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: -2.h,
//                     left: -8.w,
//                     child: GestureDetector(
//                       onTap: () {
//                         // Handle follow shop action
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 4.w, vertical: 2.h),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               height: 16.h,
//                               width: 16.w,
//                               child: Image.asset('assets/png/person_shop.png',
//                                   fit: BoxFit.contain),
//                             ),
//                             SizedBox(width: 3.w),
//                             SizedBox(
//                               height: 16.h,
//                               width: 16.w,
//                               child:
//                                   Icon(Icons.add_circle_rounded, size: 16.sp),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 08.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     shop.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.center,
//                     style: AppTextStyle(context).bodyText.copyWith(
//                           fontWeight: FontWeight.w600,
//                           fontStyle: FontStyle.italic,
//                           fontSize: 13.sp,
//                         ),
//                   ),
//                   Gap(4.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: List.generate(
//                           5,
//                           (index) => Icon(
//                             Icons.star_rounded,
//                             color: Colors.orange,
//                             size: 12.sp,
//                           ),
//                         ),
//                       ),
//                       Gap(3.w),
//                       Text(
//                         '${shop.rating ?? 4.5}',
//                         style: AppTextStyle(context).bodyTextSmall.copyWith(
//                               fontSize: 10.sp,
//                           color: EcommerceAppColor.black
//                             ),
//                       ),
//                       Text(
//                         '(${shop.totalReviews ?? ''})',
//                         style: AppTextStyle(context).bodyTextSmall.copyWith(
//                               fontSize: 10.sp,
//                             ),
//                       ),
//                     ],
//                   ),
//                   Gap(4.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 17.h,
//                         width: 17.w,
//                         child: Image.asset('assets/png/box_shop.png'),
//                       ),
//                       Gap(3.w),
//                       Text(
//                         '${shop.totalProducts} items',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 12.sp),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ShopCard extends ConsumerWidget {
  final Shop shop;

  const ShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isFollowed = ref.watch(shopFollowProvider(shop.id));
    final isLoading = ref.watch(shopControllerProvider);

    return GestureDetector(
      onTap: () {
        context.nav.pushNamed(
          Routes.getShopViewRouteName(AppConstants.appServiceName),
          arguments: shop.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80.r),
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
            topRight: Radius.circular(80.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// SHOP LOGO
                  Container(
                    height: 150.w,
                    width: 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.w),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(shop.logo),
                      ),
                    ),
                  ),

                  /// ❤️ FAVORITE ICON (OPTIONAL)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.favorite,
                        size: 16.sp,
                        color: const Color(0xffF27A1A),
                      ),
                    ),
                  ),

                  /// ➕ FOLLOW / FOLLOWING BUTTON
                  Positioned(
                    bottom: -2.h,
                    left: -8.w,
                    child: GestureDetector(
                      // onTap: isLoading
                      //     ? null
                      //     : () {
                      //   // 🔥 Optimistic UI
                      //   // ref
                      //   //     .read(
                      //   //     shopFollowProvider(shop.id).notifier)
                      //   //     .toggle();
                      //
                      //   // 🔥 API call
                      //   ref
                      //       .read(shopControllerProvider.notifier)
                      //       .followUnfollowShop( shopId: shop.id,);
                      // },
                      onTap: isLoading
                          ? null
                          : () {
                        showFollowConfirmDialog(
                          context: context,
                          isFollowed: shop.isFollowed,
                          onConfirm: () {
                            ref
                                .read(shopControllerProvider.notifier)
                                .followUnfollowShop(
                              shopId: shop.id,
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 16.h,
                              width: 16.w,
                              child: Image.asset(
                                'assets/png/person_shop.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Gap(3.w),
                            Icon(
                              shop.isFollowed
                                  ? Icons.check_circle
                                  : Icons.add_circle_rounded,
                              size: 16.sp,
                              color: EcommerceAppColor.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// SHOP INFO
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                children: [
                  Text(
                    shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyle(context).bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                  Gap(4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 12.sp),
                      Gap(3.w),
                      Text(
                        '${shop.rating ?? 4.5}',
                        style: AppTextStyle(context)
                            .bodyTextSmall
                            .copyWith(fontSize: 10.sp),
                      ),
                      Text(
                        ' (${shop.totalReviews ?? 0})',
                        style: AppTextStyle(context)
                            .bodyTextSmall
                            .copyWith(fontSize: 10.sp),
                      ),
                    ],
                  ),
                  Gap(4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/png/box_shop.png',
                        height: 17.h,
                        width: 17.w,
                      ),
                      Gap(3.w),
                      Text(
                        '${shop.totalProducts} items',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> showFollowConfirmDialog({
    required BuildContext context,
    required bool isFollowed,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ICON
                CircleAvatar(
                  radius: 26,
                  backgroundColor: isFollowed
                      ? Colors.red.withOpacity(.15)
                      : Colors.green.withOpacity(.15),
                  child: Icon(
                    isFollowed
                        ? Icons.person_remove_alt_1
                        : Icons.person_add_alt_1,
                    color: isFollowed ? Colors.red : Colors.green,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 14),

                /// TITLE
                Text(
                  isFollowed ? 'Unfollow Shop?' : 'Follow Shop?',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                /// MESSAGE
                Text(
                  isFollowed
                      ? 'You will stop seeing updates from this shop.'
                      : 'You will start seeing updates from this shop.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                /// ACTIONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.withOpacity(0.2))
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isFollowed ? Colors.red : Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(isFollowed ? 'Unfollow' : 'Follow',
                        style: TextStyle(
                          color: Colors.white
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
