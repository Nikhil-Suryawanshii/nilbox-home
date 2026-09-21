import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/iframe_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/video_player.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../components/ecommerce/confirmation_dialog.dart';
import '../../../../config/app_constants.dart';
import '../../../../controllers/eCommerce/product/product_controller.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../routes.dart';
import '../../../../services/common/hive_service_provider.dart';
import '../../../../utils/context_less_navigation.dart';

class ProductImagePageView extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  const ProductImagePageView({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ProductImagePageView> createState() =>
      _ProductImagePageViewState();
}
///----old just previous--------
// class _ProductImagePageViewState extends ConsumerState<ProductImagePageView> {
//   PageController pageController = PageController();
//   late bool isFavorite;
//   @override
//   void initState() {
//     // ignore: unused_result
//     ref.refresh(currentPageController);
//     pageController.addListener(() {
//       int? newPage = pageController.page?.round();
//       if (newPage != ref.read(currentPageController)) {
//         setState(() {
//           ref.read(currentPageController.notifier).state = newPage!;
//         });
//       }
//     });
//     super.initState();
//     isFavorite = widget.productDetails.product.isFavorite == true;
//   }
//
//   Widget _plainAction({
//     required String svgPath,
//     required String count,
//   }) {
//     return Column(
//       children: [
//         SvgPicture.asset(
//           svgPath,
//           width: 28.w,
//           height: 28.w,
//           colorFilter: const ColorFilter.mode(
//             Colors.black,
//             BlendMode.srcIn,
//           ),
//         ),
//         Gap(6.h),
//         Text(
//           count,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   Widget _heartAction({
//     required String count,
//     required bool isFavorite,
//   }) {
//     return Container(
//       // decoration: BoxDecoration(
//       //   color: Colors.white.withOpacity(0.25),
//       //   borderRadius: BorderRadius.circular(20.r),
//       //   // border: Border.all(color: const Color(0xffAE0BFF)),
//       // ),
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       child: Column(
//         children: [
//           Icon(
//             isFavorite ? Icons.favorite : Icons.favorite_outline_rounded,
//             size: 25.sp,
//             color: const Color(0xffAE0BFF),
//           ),
//           Text(
//             count,
//             style: TextStyle(
//               color: const Color(0xffAE0BFF),
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Sort the thumbnails: Images first, then others
//     final sortedThumbnails = [...widget.productDetails.product.thumbnails];
//     sortedThumbnails.sort((a, b) {
//       if (a.type == FileSystem.image.name && b.type != FileSystem.image.name)
//         return -1;
//       if (a.type != FileSystem.image.name && b.type == FileSystem.image.name)
//         return 1;
//       return 0;
//     });
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Gap(110.h),
//         Padding(
//           // padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//           padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15.r),
//             child: SizedBox(
//               // height: 355.h,
//               height: 445.h,
//               child: PageView.builder(
//                 controller: pageController,
//                 itemCount: sortedThumbnails.length,
//                 itemBuilder: (context, index) {
//                   final item = sortedThumbnails[index];
//                   final fileSystem = item.type;
//
//                   if (fileSystem == FileSystem.image.name) {
//                     return CachedNetworkImage(
//                       imageUrl: item.thumbnail ?? '',
//                       fit: BoxFit.contain,
//                     );
//                   } else if (fileSystem == FileSystem.file.name) {
//                     return VideoPlayer(
//                       videoUrl: item.url ?? '',
//                     );
//                   } else {
//                     return Container(
//                       padding: EdgeInsets.only(top: 100.h),
//                       width: double.infinity,
//                       child: IframeCard(
//                         iframeUrl: item.url ?? '',
//                       ),
//                     );
//                   }
//                 },
//               ),
//               // PageView.builder(
//               //   controller: pageController,
//               //   // reverse: true,
//               //   itemCount: widget.productDetails.product.thumbnails.length,
//               //   itemBuilder: (context, index) {
//               //     final fileSystem =
//               //         widget.productDetails.product.thumbnails[index].type;
//               //     if (fileSystem == FileSystem.image.name) {
//               //       return CachedNetworkImage(
//               //         imageUrl: widget
//               //                 .productDetails.product.thumbnails[index].thumbnail ??
//               //             '',
//               //         fit: BoxFit.cover,
//               //       );
//               //     }
//               //     else if (fileSystem == FileSystem.file.name) {
//               //       return VideoPlayer(
//               //         videoUrl:
//               //             // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
//               //             widget.productDetails.product.thumbnails[index].url ?? '',
//               //       );
//               //     }
//               //     else {
//               //       return Container(
//               //         padding: EdgeInsets.only(top: 100.h),
//               //         width: double.infinity,
//               //         child: IframeCard(
//               //           iframeUrl:
//               //               widget.productDetails.product.thumbnails[index].url ??
//               //                   '',
//               //         ),
//               //       );
//               //     }
//               //     return null;
//               //   },
//               // ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 40,
//           left: 18,
//           child: CircleAvatar(
//             radius: 20.r,
//             backgroundColor: colors(context).accentColor,
//             // backgroundColor: Colors.white,
//             child: IconButton(
//               padding: EdgeInsets.zero,
//               icon: const Icon(
//                 Icons.keyboard_arrow_left,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 // ref.read(shopControllerProvider.notifier).review.clear();
//                 context.nav.pop();
//               },
//             ),
//           ),
//         ),
//         /// 📌 RIGHT ACTION BAR
//         Positioned(
//           right: 20.w,
//           top: 120.h,
//           child: Column(
//             children: [
//               /// 💬 CHAT
//               _plainAction(
//                 svgPath: Assets.svg.productPageChat,
//                 count: widget.productDetails.product.totalReviews,
//               ),
//
//               Gap(22.h),
//
//               /// ✈️ SEND
//               GestureDetector(
//                 onTap: (){
//                       final websiteUrl =
//                           AppConstants.baseUrl.replaceAll("api", "products");
//                       Share.share(
//                           "check out my website $websiteUrl/${widget.productDetails.product.id}/details");
//
//                 },
//                 child: _plainAction(
//                   svgPath: Assets.svg.productPageShare,
//                   count: '256',
//                 ),
//               ),
//
//               Gap(22.h),
//
//               /// ❤️ LIKE (ONLY THIS HAS BG)
//               GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: () {
//                   if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//
//                     setState(() {
//                       isFavorite = !isFavorite; // 🔥 UI updates instantly
//                     });
//
//                     ref
//                         .read(productControllerProvider.notifier)
//                         .favoriteProductAddRemove(
//                       productId: widget.productDetails.product.id,
//                     );
//                   } else {
//                     showDialog(
//                       context: context,
//                       builder: (_) => ConfirmationDialog(
//                         title: 'You must login to favorite products',
//                         confirmButtonText: 'Login',
//                         onPressed: () {
//                           context.nav.pushNamedAndRemoveUntil(
//                             Routes.login,
//                                 (route) => false,
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 },
//                 child: _heartAction(
//                   count: '4.2k',
//                   isFavorite: isFavorite,
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//
//         // Positioned(
//         //   bottom: 16.h,
//         //   child: Container(
//         //     padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
//         //     decoration: BoxDecoration(
//         //       borderRadius: BorderRadius.circular(8.r),
//         //       color: EcommerceAppColor.lightGray,
//         //     ),
//         //     child: Wrap(
//         //       alignment: WrapAlignment.center,
//         //       children: List.generate(
//         //         widget.productDetails.product.thumbnails.length,
//         //         (index) => AnimatedContainer(
//         //           duration: const Duration(milliseconds: 300),
//         //           margin: const EdgeInsets.symmetric(horizontal: 2),
//         //           decoration: BoxDecoration(
//         //             color:
//         //                 ref.read(currentPageController.notifier).state == index
//         //                     ? colors(context).light
//         //                     : colors(context).accentColor!.withOpacity(0.5),
//         //             borderRadius: BorderRadius.circular(30.sp),
//         //           ),
//         //           height: 8.h,
//         //           width: 8.w,
//         //         ),
//         //       ).toList(),
//         //     ),
//         //   ),
//         // ),
//
//         // Positioned(
//         //   top: 25,
//         //   right: 40,
//         //   child: CircleAvatar(
//         //     radius: 23.r,
//         //     backgroundColor: Colors.white,
//         //     child: Padding(
//         //       padding: const EdgeInsets.only(top: 5),
//         //       child: AnimatedSize(
//         //         duration: const Duration(milliseconds: 250),
//         //         child: IconButton(
//         //           padding: EdgeInsets.zero,
//         //           visualDensity: VisualDensity.compact,
//         //           onPressed: () {
//         //             if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
//         //               setState(() {
//         //                 isFavorite = !isFavorite;
//         //               });
//         //               ref
//         //                   .read(productControllerProvider.notifier)
//         //                   .favoriteProductAddRemove(
//         //                     productId: widget.productDetails.product.id,
//         //                   );
//         //             } else {
//         //               showDialog(
//         //                   context: context,
//         //                   builder: (_) => ConfirmationDialog(
//         //                         title:
//         //                             'You are unable to favorite products without login!',
//         //                         confirmButtonText: 'Login',
//         //                         onPressed: () {
//         //                           context.nav.pushNamedAndRemoveUntil(
//         //                               Routes.login, (route) => false);
//         //                         },
//         //                       ));
//         //             }
//         //           },
//         //           icon: Icon(
//         //             isFavorite
//         //                 ? Icons.favorite
//         //                 : Icons.favorite_outline_rounded,
//         //             size: isFavorite ? 36.sp : 35.sp,
//         //             color: isFavorite
//         //                 ? colors(context).errorColor
//         //                 : colors(context).bodyTextSmallColor,
//         //           ),
//         //         ),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         // Positioned(
//         //   bottom: 15,
//         //   right: 30,
//         //   child: InkWell(
//         //     onTap: () {
//         //       final websiteUrl =
//         //           AppConstants.baseUrl.replaceAll("api", "products");
//         //       Share.share(
//         //           "check out my website $websiteUrl/${widget.productDetails.product.id}/details");
//         //     },
//         //     child: Card(
//         //         child: Padding(
//         //       padding: const EdgeInsets.all(6.0),
//         //       child: Icon(Icons.share, color: colors(context).primaryColor),
//         //     )),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
///----old just previous--------
class _ProductImagePageViewState extends ConsumerState<ProductImagePageView> {
  PageController pageController = PageController();
  late bool isFavorite;
  @override
  void initState() {
    ref.refresh(currentPageController);
    pageController.addListener(() {
      int? newPage = pageController.page?.round();
      if (newPage != ref.read(currentPageController)) {
        setState(() {
          ref.read(currentPageController.notifier).state = newPage!;
        });
      }
    });
    super.initState();
    isFavorite = widget.productDetails.product.isFavorite == true;
  }


  @override
  Widget build(BuildContext context) {
    // Sort the thumbnails: Images first, then others
    final sortedThumbnails = [...widget.productDetails.product.thumbnails];
    sortedThumbnails.sort((a, b) {
      if (a.type == FileSystem.image.name && b.type != FileSystem.image.name)
        return -1;
      if (a.type != FileSystem.image.name && b.type == FileSystem.image.name)
        return 1;
      return 0;
    });
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Gap(110.h),
        Padding(
          // padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: SizedBox(
              height: 480.h,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: pageController,
                itemCount: sortedThumbnails.length,
                itemBuilder: (context, index) {
                  final item = sortedThumbnails[index];
                  final fileSystem = item.type;

                  if (fileSystem == FileSystem.image.name) {
                    return CachedNetworkImage(
                      imageUrl: item.thumbnail ?? '',
                      fit: BoxFit.contain,
                    );
                  } else if (fileSystem == FileSystem.file.name) {
                    return VideoPlayer(
                      videoUrl: item.url ?? '',
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.only(top: 100.h),
                      width: double.infinity,
                      child: IframeCard(
                        iframeUrl: item.url ?? '',
                      ),
                    );
                  }
                },
              ),
              // PageView.builder(
              //   controller: pageController,
              //   // reverse: true,
              //   itemCount: widget.productDetails.product.thumbnails.length,
              //   itemBuilder: (context, index) {
              //     final fileSystem =
              //         widget.productDetails.product.thumbnails[index].type;
              //     if (fileSystem == FileSystem.image.name) {
              //       return CachedNetworkImage(
              //         imageUrl: widget
              //                 .productDetails.product.thumbnails[index].thumbnail ??
              //             '',
              //         fit: BoxFit.cover,
              //       );
              //     }
              //     else if (fileSystem == FileSystem.file.name) {
              //       return VideoPlayer(
              //         videoUrl:
              //             // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
              //             widget.productDetails.product.thumbnails[index].url ?? '',
              //       );
              //     }
              //     else {
              //       return Container(
              //         padding: EdgeInsets.only(top: 100.h),
              //         width: double.infinity,
              //         child: IframeCard(
              //           iframeUrl:
              //               widget.productDetails.product.thumbnails[index].url ??
              //                   '',
              //         ),
              //       );
              //     }
              //     return null;
              //   },
              // ),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 16.h,
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8.r),
        //       color: EcommerceAppColor.lightGray,
        //     ),
        //     child: Wrap(
        //       alignment: WrapAlignment.center,
        //       children: List.generate(
        //         widget.productDetails.product.thumbnails.length,
        //         (index) => AnimatedContainer(
        //           duration: const Duration(milliseconds: 300),
        //           margin: const EdgeInsets.symmetric(horizontal: 2),
        //           decoration: BoxDecoration(
        //             color:
        //                 ref.read(currentPageController.notifier).state == index
        //                     ? colors(context).light
        //                     : colors(context).accentColor!.withOpacity(0.5),
        //             borderRadius: BorderRadius.circular(30.sp),
        //           ),
        //           height: 8.h,
        //           width: 8.w,
        //         ),
        //       ).toList(),
        //     ),
        //   ),
        // ),
        if (widget.productDetails.product.discountPrice > 0)
         Positioned(
          top: -19,
          left: -10,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 🔴 DISCOUNT TAG PNG
                Transform.rotate(
                  angle: 0.0, // tilt like image
                  child: Image.asset(
                    'assets/png/discount_logo.png',
                    height: 75.h,
                    fit: BoxFit.contain,
                  ),
                ),

                /// 🏷️ DISCOUNT TEXT
                Transform.rotate(
                  angle: 0.7, // SAME tilt as image
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.w,top: 8),
                    child: Text(
                      '${widget.productDetails.product.discountPercentage.toInt()}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 20,
          child: CircleAvatar(
            radius: 17.r,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 4,),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      ref
                          .read(productControllerProvider.notifier)
                          .favoriteProductAddRemove(
                        productId: widget.productDetails.product.id,
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => ConfirmationDialog(
                            title:
                            'You are unable to favorite products without login!',
                            confirmButtonText: 'Login',
                            onPressed: () {
                              context.nav.pushNamedAndRemoveUntil(
                                  Routes.login, (route) => false);
                            },
                          ));
                    }
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline_rounded,
                    size: isFavorite ? 26.sp : 25.sp,
                    color: isFavorite
                        ? colors(context).errorColor
                        : colors(context).bodyTextSmallColor,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Positioned(
        //   top: 25,
        //   right: 40,
        //   child: CircleAvatar(
        //     radius: 23.r,
        //     backgroundColor: Colors.white,
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 5),
        //       child: AnimatedSize(
        //         duration: const Duration(milliseconds: 250),
        //         child: IconButton(
        //           padding: EdgeInsets.zero,
        //           visualDensity: VisualDensity.compact,
        //           onPressed: () {
        //             if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
        //               setState(() {
        //                 isFavorite = !isFavorite;
        //               });
        //               ref
        //                   .read(productControllerProvider.notifier)
        //                   .favoriteProductAddRemove(
        //                     productId: widget.productDetails.product.id,
        //                   );
        //             } else {
        //               showDialog(
        //                   context: context,
        //                   builder: (_) => ConfirmationDialog(
        //                         title:
        //                             'You are unable to favorite products without login!',
        //                         confirmButtonText: 'Login',
        //                         onPressed: () {
        //                           context.nav.pushNamedAndRemoveUntil(
        //                               Routes.login, (route) => false);
        //                         },
        //                       ));
        //             }
        //           },
        //           icon: Icon(
        //             isFavorite
        //                 ? Icons.favorite
        //                 : Icons.favorite_outline_rounded,
        //             size: isFavorite ? 36.sp : 35.sp,
        //             color: isFavorite
        //                 ? colors(context).errorColor
        //                 : colors(context).bodyTextSmallColor,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

      ],
    );
  }
}
