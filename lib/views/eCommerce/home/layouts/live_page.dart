import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../../config/app_constants.dart';
import '../../../../config/app_text_style.dart';
import '../../../../config/theme.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../routes.dart';
import '../../../../services/common/hive_service_provider.dart';
import '../../../../utils/context_less_navigation.dart';

class LiveStreamPage extends StatelessWidget {
  const LiveStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Top Bar (Back, Search, Filter)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: TopSearchBar(),
                  ),
                ),

                // 2. Horizontal Streamer Cards
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 190,
                    child: HorizontalStreamerList(),
                  ),
                ),

                // 3. "Reels" Title
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Text(
                      "Reels",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // 4. Horizontal Reels List
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 110,
                    child: HorizontalReelsList(),
                  ),
                ),

                // 5. Staggered Grid Feed
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                //   sliver: SliverMasonryGrid.count(
                //     crossAxisCount: 2,
                //     mainAxisSpacing: 16,
                //     crossAxisSpacing: 16,
                //     childCount: feedItems.length,
                //     itemBuilder: (context, index) {
                //       return FeedCard(item: feedItems[index % feedItems.length]);
                //     },
                //   ),
                // ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childCount: feedItems.length,
                    itemBuilder: (context, index) {
                      final item = feedItems[index];

                      // Right side large, left side small
                      final bool isLargeCard = index % 2 != 0;

                      return FeedCard1(
                        key: ValueKey(item.id),
                        item: item,
                        height: isLargeCard ? 242 : 190, // 👈 MAGIC
                      );
                    },
                  ),
                ),

                // AnimationLimiter(
                //   child: SizedBox(
                //     // height: MediaQuery.of(context).size.height * 1.55,
                //     child: MasonryGridView.count(
                //       padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 100),
                //       crossAxisCount: 2,
                //       mainAxisSpacing: 5.h,
                //       crossAxisSpacing: 15.w,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemCount: feedItems.length,
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         final product = feedItems[index];
                //         return AnimationConfiguration.staggeredGrid(
                //           duration: const Duration(milliseconds: 375),
                //           position: index,
                //           columnCount: 2,
                //           child: ScaleAnimation(
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 20.h, bottom: 0),
                //                 child:  FeedCard(item: feedItems[index % feedItems.length]),
                //             ),
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),

                // Bottom padding for the FAB
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),

            // 6. Floating Live Button
            Positioned(
              bottom: 20,
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.orange, width: 1.5),
                ),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,

                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// 🔥 ORIGINAL IMAGE (UNCHANGED)
                        Image.asset(
                          "assets/png/live.png",
                          height: 50.h,
                          fit: BoxFit.contain,
                        ),

                        /// ✏️ CUSTOM TEXT ON TOP
                        // Positioned(
                        //   top: 50.h * 0.35, // adjust if needed
                        //   left: 7,
                        //   child: Text(
                        //     "Live",
                        //     style: TextStyle(
                        //         fontSize: 13.sp,
                        //         fontWeight: FontWeight.w900,
                        //         color: Colors.white,
                        //         letterSpacing: 1,
                        //         fontStyle: FontStyle.italic
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Widgets ---

class TopSearchBar extends StatelessWidget {
  const TopSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: colors(context).accentColor,
          // backgroundColor: Colors.white,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black,
            ),
            onPressed: () {
              // ref.read(shopControllerProvider.notifier).review.clear();
              context.nav.pop();
            },
          ),
        ),
        Gap(10.w),
        Expanded(
          child: GestureDetector(
            onTap: () => context.nav.pushNamed(
              Routes.getProductsViewRouteName(
                AppConstants.appServiceName,
              ),
              arguments: [
                null,
                'All Product',
                null,
                null,
                null,
                null,
              ],
            ),
            child: Container(
              height: 35.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: colors(context).light!,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    Assets.svg.searchHome,
                    height: 16.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap(10.w),
                  Text(
                    S.of(context).searchProduct,
                    style: AppTextStyle(context)
                        .bodyText
                        .copyWith(color: Colors.grey,fontSize: 12),
                  ),

                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.tune, size: 18, color: Colors.black),
        ),
      ],
    );
  }
}

// class HorizontalStreamerList extends StatelessWidget {
//   const HorizontalStreamerList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       scrollDirection: Axis.horizontal,
//       itemCount: 3,
//       separatorBuilder: (_, __) => const SizedBox(width: 16),
//       itemBuilder: (context, index) {
//         return Container(
//           width: 280,
//           // height: 173,
//           padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Stack(
//                     children: [
//                       const CircleAvatar(
//                         radius: 24,
//                         backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
//                       ),
//                       Positioned(
//                         right: 0,
//                         bottom: 0,
//                         child: Container(
//                           height: 10,
//                           width: 10,
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 1.5),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Michael Kors",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                         ),
//                         Text(
//                           "📍 Online",
//                           style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.circle, color: Colors.white, size: 8),
//                         SizedBox(width: 4),
//                         Text("Live", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Row(
//                         children: [
//                           Icon(Icons.flag, size: 16, color: Colors.blue), // Placeholder for flag
//                           SizedBox(width: 4),
//                           Text("Micheal C....", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "6.9k orders - 13.0k fans",
//                         style: TextStyle(color: Color(0xff4A4A4A), fontSize: 10),
//                       ),
//                     ],
//                   ),
//                   // Container(
//                   //   height: 36,
//                   //   width: 36,
//                   //   decoration: BoxDecoration(
//                   //     color: const Color(0xFF9747FF), // Purple
//                   //     borderRadius: BorderRadius.circular(8),
//                   //   ),
//                   //   child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
//                   // ),
//                   InkWell(
//                     borderRadius: BorderRadius.circular(10.r),
//                     // onTap: () async {
//                     //   if (ref
//                     //       .read(hiveServiceProvider)
//                     //       .userIsLoggedIn()) {
//                     //     final saveUser = await ref
//                     //         .read(hiveServiceProvider)
//                     //         .getUserInfo();
//                     //
//                     //     final shop = Shop(
//                     //       id: productDetails.product.shop.id,
//                     //       name: productDetails
//                     //           .product.shop.name,
//                     //       logo: productDetails
//                     //           .product.shop.logo,
//                     //     );
//                     //
//                     //     ref
//                     //         .read(
//                     //         storeMessageControllerProvider
//                     //             .notifier)
//                     //         .storeMessage(
//                     //       shopId: productDetails
//                     //           .product.shop.id,
//                     //       userId: saveUser!.id!,
//                     //       productId:
//                     //       productDetails.product.id,
//                     //     );
//                     //
//                     //     context.nav.pushNamed(
//                     //       Routes.getChatViewRouteName(
//                     //           AppConstants.appServiceName),
//                     //       arguments: shop,
//                     //     );
//                     //   } else {
//                     //     showDialog(
//                     //       context: context,
//                     //       builder: (_) => ConfirmationDialog(
//                     //         title:
//                     //         'You can\'t send message without login!',
//                     //         confirmButtonText: 'Login',
//                     //         onPressed: () {
//                     //           context.nav
//                     //               .pushNamedAndRemoveUntil(
//                     //               Routes.login,
//                     //                   (route) => false);
//                     //         },
//                     //       ),
//                     //     );
//                     //   }
//                     // },
//                     child: Container(
//                       width: 46.w,
//                       height: 46.h,
//                       decoration: BoxDecoration(
//                         borderRadius:
//                         BorderRadius.circular(10.r),
//                         gradient: const LinearGradient(
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                           colors: [
//                             Color(0xFFAE0BFF),
//                             Color(0xFF2C0BFF),
//                           ],
//                         ),
//                         // boxShadow: [
//                         //   BoxShadow(
//                         //     color: const Color(0xFF6A00FF)
//                         //         .withOpacity(0.35),
//                         //     blurRadius: 14,
//                         //     offset: const Offset(0, 8),
//                         //   ),
//                         // ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment:
//                         MainAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset(
//                             Assets.svg.chat,
//                             width: 17.w,
//                             colorFilter:
//                             const ColorFilter.mode(
//                               Colors.white,
//                               BlendMode.srcIn,
//                             ),
//                           ),
//                           Gap(4.h),
//                           Text(
//                             'Chats',
//                             style: TextStyle(
//                               fontSize: 7.sp,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Divider(color: Color(0xffD9D9D9),),
//               Text(
//                 "Hello, today I'm wearing Michael Kors.",
//                 style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
class HorizontalStreamerList extends StatelessWidget {
  const HorizontalStreamerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        // 🔁 Alternating pattern: MAN → WOMAN → MAN → WOMAN
        final bool isMan = index % 2 == 0;

        final avatarUrl = isMan
            ? 'https://i.pravatar.cc/150?img=11' // 👨 MAN
            : 'https://i.pravatar.cc/150?img=47'; // 👩 WOMAN

        final topName = isMan ? 'Michael Kors' : 'Serravall';
        final shortName = isMan ? 'Micheal C....' : 'Helly A...';

        return Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ───── TOP ROW ─────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "📍 Online",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle,
                            color: Colors.white, size: 8),
                        SizedBox(width: 4),
                        Text(
                          "Live",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ───── MIDDLE ROW ─────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag,
                              size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(
                            shortName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "6.9k orders - 13.0k fans",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),

                  /// CHAT BUTTON
                  InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    // onTap: () async {
                    //   if (ref
                    //       .read(hiveServiceProvider)
                    //       .userIsLoggedIn()) {
                    //     final saveUser = await ref
                    //         .read(hiveServiceProvider)
                    //         .getUserInfo();
                    //
                    //     final shop = Shop(
                    //       id: productDetails.product.shop.id,
                    //       name: productDetails
                    //           .product.shop.name,
                    //       logo: productDetails
                    //           .product.shop.logo,
                    //     );
                    //
                    //     ref
                    //         .read(
                    //         storeMessageControllerProvider
                    //             .notifier)
                    //         .storeMessage(
                    //       shopId: productDetails
                    //           .product.shop.id,
                    //       userId: saveUser!.id!,
                    //       productId:
                    //       productDetails.product.id,
                    //     );
                    //
                    //     context.nav.pushNamed(
                    //       Routes.getChatViewRouteName(
                    //           AppConstants.appServiceName),
                    //       arguments: shop,
                    //     );
                    //   } else {
                    //     showDialog(
                    //       context: context,
                    //       builder: (_) => ConfirmationDialog(
                    //         title:
                    //         'You can\'t send message without login!',
                    //         confirmButtonText: 'Login',
                    //         onPressed: () {
                    //           context.nav
                    //               .pushNamedAndRemoveUntil(
                    //               Routes.login,
                    //                   (route) => false);
                    //         },
                    //       ),
                    //     );
                    //   }
                    // },
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFFAE0BFF),
                            Color(0xFF2C0BFF),
                          ],
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: const Color(0xFF6A00FF)
                        //         .withOpacity(0.35),
                        //     blurRadius: 14,
                        //     offset: const Offset(0, 8),
                        //   ),
                        // ],
                      ),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.chat,
                            width: 17.w,
                            colorFilter:
                            const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            'Chats',
                            style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xffD9D9D9)),

              /// ───── MESSAGE ─────
              Text(
                isMan
                    ? "Hello, today I'm wearing Michael Kors."
                    : "Who wants to go shopping today?",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}


class HorizontalReelsList extends StatelessWidget {
  const HorizontalReelsList({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=9',
      'https://i.pravatar.cc/150?img=20',
      'https://i.pravatar.cc/150?img=32',
      'https://i.pravatar.cc/150?img=1',
    ];
    final names = ['Victoria', 'Olivia', 'Maya', 'Sarah', 'Em'];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 80,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), // Rounded square look
                image: DecorationImage(
                  image: NetworkImage(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flag, size: 13, color: Colors.red), // Flag placeholder
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              names[index],
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
            ),
          ],
        );
      },
    );
  }
}

class FeedCard extends StatelessWidget {
  final FeedItem item;
  const FeedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ensure the container has the height to show the image aspect ratio
      decoration: BoxDecoration(
        color: Colors.transparent, // Background handled by image
        borderRadius: BorderRadius.circular(10), // Matches the card roundness
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // 1. Full Background Image
            // We use Positioned.fill or simply let the image take width
            // Since this is inside a Staggered Grid, the height is determined by the image content usually
            // but for fit: cover we might need an aspect ratio or specific constraints.
            // Assuming the images provide the aspect ratio:
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              // If images are random sizes, this preserves aspect ratio.
              // If you want fixed heights, wrap in SizedBox/Container.
            ),

            // 2. View Count Badge (Top Left)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent dark
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                        "1.2k",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ],
                ),
              ),
            ),

            // 3. Heart Button (Top Right)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Semi-transparent white
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.favorite_border, size: 18, color: Colors.black),
                ),
              ),
            ),

            // 4. Floating Info Box (Bottom)
            Positioned(
              bottom: 15,
              left: 10,
              right: 10,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the white box
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name and Flag
                    Expanded(
                      child: Row(
                        children: [
                          // Flag icon
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const Icon(Icons.flag, size: 16, color: Colors.red), // Replace with real flag image/icon
                          ),
                          const SizedBox(width: 6),
                          // Name
                          Flexible(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Join Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD872E), // Exact Orange color from image
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Join",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FeedCard1 extends StatelessWidget {
  final FeedItem item;
  final double height;

  const FeedCard1({
    Key? key,
    required this.item,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // 1. Full Background Image
            // We use Positioned.fill or simply let the image take width
            // Since this is inside a Staggered Grid, the height is determined by the image content usually
            // but for fit: cover we might need an aspect ratio or specific constraints.
            // Assuming the images provide the aspect ratio:
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              // If images are random sizes, this preserves aspect ratio.
              // If you want fixed heights, wrap in SizedBox/Container.
            ),

            // 2. View Count Badge (Top Left)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent dark
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                        "1.2k",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500
                        )
                    ),
                  ],
                ),
              ),
            ),

            // 3. Heart Button (Top Right)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Semi-transparent white
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.favorite_border, size: 18, color: Colors.black),
                ),
              ),
            ),

            // 4. Floating Info Box (Bottom)
            Positioned(
              bottom: 15,
              left: 10,
              right: 10,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the white box
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name and Flag
                    Expanded(
                      child: Row(
                        children: [
                          // Flag icon
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const Icon(Icons.flag, size: 16, color: Colors.red), // Replace with real flag image/icon
                          ),
                          const SizedBox(width: 6),
                          // Name
                          Flexible(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Join Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD872E), // Exact Orange color from image
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Join",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// --- Data Models ---

class FeedItem {
  final int id;
  final String imageUrl;
  final String name;

  FeedItem(this.id,this.imageUrl, this.name);
}

final List<FeedItem> feedItems = [
  FeedItem(0,'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=300', 'Ceyda B...'),
  FeedItem(1,'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300', 'Olivia B...'),
  FeedItem(2,'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?q=80&w=300', 'Heely B...'),
  FeedItem(3,'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=300', 'Sarah B...'),
  FeedItem(4,'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=300', 'Anna K...'),
  FeedItem(5,'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=300', 'Jane D...'),
];