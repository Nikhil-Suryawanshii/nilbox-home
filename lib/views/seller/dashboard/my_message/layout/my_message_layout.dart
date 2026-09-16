// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:razin_commerce_seller_flutter/config/app_color.dart';
// import 'package:razin_commerce_seller_flutter/config/routes.dart';
// import 'package:razin_commerce_seller_flutter/config/theme.dart';
// import 'package:razin_commerce_seller_flutter/features/common/widgets/custom_text_field.dart';
// import 'package:razin_commerce_seller_flutter/features/my_message/controller/message/message_controller.dart';
// import 'package:razin_commerce_seller_flutter/features/my_message/controller/pusher/pusher_controller.dart';
// import 'package:razin_commerce_seller_flutter/gen/assets.gen.dart';
// import 'package:razin_commerce_seller_flutter/generated/l10n.dart';
// import 'package:razin_commerce_seller_flutter/utils/global_function.dart';
// import 'package:ready_ecommerce/controllers/seller/message/message_controller.dart';
// import 'package:ready_ecommerce/controllers/seller/pusher/pusher_controller.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';

// class MyMessageLayout extends ConsumerStatefulWidget {
//   const MyMessageLayout({super.key});

//   static TextEditingController nameController = TextEditingController();
//   static TextEditingController phoneController = TextEditingController();
//   static TextEditingController emailController = TextEditingController();

//   @override
//   ConsumerState<MyMessageLayout> createState() => _MyMessageLayoutState();
// }

// class _MyMessageLayoutState extends ConsumerState<MyMessageLayout> {
//   final messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(pusherControllerProvider.notifier).init();
//       ref.read(getCustomerControllerProvider.notifier).getCustomer();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvokedWithResult: (didPop, result) {
//         ref.read(getTotalUnreadMessagesControllerProvider);
//       },
//       child: Scaffold(
//         backgroundColor: GlobalFunction.getContainerColor(),
//         // backgroundColor: colors(context).light,
//         //  backgroundColor: colors(context).accentColor,
//         appBar: AppBar(
//           title: Text(S.of(context).message),
//           surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(0),
//             child: Divider(height: 1.h, color: colors(context).accentColor),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: CustomTextFormField(
//                     showName: false,
//                     name: '',
//                     hintText: S.of(context).searchCustomer,
//                     textInputType: TextInputType.text,
//                     textInputAction: TextInputAction.search,
//                     controller: messageController,
//                     borderRadius: 30.r,
//                     fillColor: colors(context).hintTextColor!.withOpacity(0.08),

//                     prefixwidget: Container(
//                       margin: EdgeInsets.only(
//                         left: 16.w,
//                         right: 8.w,
//                         top: 8.h,
//                         bottom: 8.h,
//                       ),
//                       child: SvgPicture.asset(Assets.svg.searchHome),
//                     ),
//                     onChanged: (value) async {
//                       await Future.delayed(const Duration(milliseconds: 300));
//                       ref
//                           .read(getCustomerControllerProvider.notifier)
//                           .getCustomer(search: value);
//                     },
//                     validator: (value) {
//                       return null;
//                     },
//                   ),
//                 ),
//                 Gap(8.h),
//                 ref
//                     .watch(getCustomerControllerProvider)
//                     .when(
//                       data: (data) {
//                         return ListView.separated(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: data?.data?.data?.length ?? 0,
//                           separatorBuilder:
//                               (context, index) =>
//                                   Gap(1.h, color: Colors.grey.shade200),
//                           itemBuilder: (context, index) {
//                             final message = data?.data?.data?[index];
//                             // PusherService()
//                             //     .subscribeToUserChannel(message?.shop?.id ?? 0);
//                             return ListTile(
//                               titleAlignment: ListTileTitleAlignment.top,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               tileColor:
//                                   message?.unreadMessageUser == 0
//                                       ? Colors.transparent
//                                       : colors(
//                                         context,
//                                       ).primaryColor!.withValues(alpha: 0.2),
//                               onTap: () {
//                                 context.push(
//                                   Routes.sellerMyChatView,
//                                   extra: message?.user,
//                                 );
//                                 // context.nav.pushNamed(
//                                 //   Routes.getChatViewRouteName(
//                                 //     AppConstants.appServiceName,
//                                 //   ),
//                                 //   arguments: message?.shop,
//                                 // );
//                               },
//                               leading: CachedNetworkImage(
//                                 fit: BoxFit.cover,
//                                 width: 50.w,
//                                 height: 50.h,
//                                 imageUrl: message?.user?.profilePhoto ?? "",
//                                 errorWidget: (context, url, error) {
//                                   return const Icon(Icons.person);
//                                 },
//                               ),
//                               title: Text(
//                                 message?.user?.name ?? "",
//                                 style: Theme.of(
//                                   context,
//                                 ).textTheme.bodyLarge?.copyWith(
//                                   fontSize: 16.sp,
//                                   color:
//                                       message?.unreadMessageUser == 0
//                                           ? colors(
//                                             context,
//                                           ).textColor!.withValues(alpha: 0.7)
//                                           : colors(context).textColor,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 message?.lastMessage ?? "",
//                                 style: Theme.of(
//                                   context,
//                                 ).textTheme.bodyMedium?.copyWith(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w400,
//                                   color: colors(context).hintTextColor,
//                                 ),
//                               ),
//                               trailing: Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   message?.lastMessageTime ?? "",
//                                   style: Theme.of(context).textTheme.bodySmall
//                                       ?.copyWith(color: AppStaticColor.gray),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       error:
//                           (error, stk) => Center(child: Text(error.toString())),
//                       loading: () {
//                         return const Center(child: CircularProgressIndicator());
//                       },
//                     ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// enum OrderStatus {
//   all,
//   pending,
//   confirm,
//   processing,
//   onTheWay,
//   delivered,
//   canceled,
// }

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/seller/message/message_controller.dart';
import 'package:ready_ecommerce/controllers/seller/pusher/pusher_controller.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../components/ecommerce/custom_search_field.dart';
import '../../../../../config/app_color.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../models/seller/auth/login_response_model.dart/user.dart';
import '../../../../../models/seller/dashboard/my_message.dart';
import '../../../../../providers/seller/common_provider.dart';
import '../../../../../utils/context_less_navigation.dart';

class SellerMyMessageLayout extends ConsumerStatefulWidget {
  const SellerMyMessageLayout({super.key});

  @override
  ConsumerState<SellerMyMessageLayout> createState() => _MyMessageLayoutState();
}

class _MyMessageLayoutState extends ConsumerState<SellerMyMessageLayout> {
  final messageController = TextEditingController();
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pusherControllerProvider.notifier).init();
      ref.read(getCustomerControllerProvider.notifier).getCustomer();
    });
  }

  Widget _buildProfileContainer(BuildContext context) {
    return FutureBuilder<LoginUser?>(
      future: ref.read(sellerHiveServiceProvider).getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Hello Seller",
            style: AppTextStyle(context).subTitle.copyWith(
                  color: EcommerceAppColor.white,
                  fontSize: 18.sp,
                ),
          );
        }

        final seller = snapshot.data;

        return Text(
          seller != null
              ? "Hello ${seller.shop?.name ?? seller.firstName ?? 'Seller'}"
              : "Hello Seller",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle(context).subTitle.copyWith(
                color: EcommerceAppColor.white,
                fontSize: 18.sp,
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(getTotalUnreadMessagesControllerProvider);
      },
      child: Scaffold(
        backgroundColor: GlobalFunction.getContainerColor(),
        // appBar: AppBar(
        //   title: Text("Messages", style: style.appBarText),
        //   surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        //   bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(0),
        //     child: Divider(height: 1.h, color: colors(context).accentColor),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: Column(
              children: [
                // Gap(12.h),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12.r),
                //   child: CustomTextFormField(
                //     showName: false,
                //     name: '',
                //     hintText: "Search Customer",
                //     textInputType: TextInputType.text,
                //     textInputAction: TextInputAction.search,
                //     controller: messageController,
                //     borderRadius: 30.r,
                //     fillColor: colors(context).hintTextColor!.withOpacity(0.08),
                //     prefixwidget: Icon(
                //       Icons.search,
                //       color: colors(context).hintTextColor,
                //       size: 20.sp,
                //     ),
                //     onChanged: (value) async {
                //       await Future.delayed(const Duration(milliseconds: 300));
                //       ref
                //           .read(getCustomerControllerProvider.notifier)
                //           .getCustomer(search: value);
                //     },
                //     validator: (value) => null,
                //   ),
                // ),
                messageHeader(context),
                // Gap(8.h),
                ref.watch(getCustomerControllerProvider).when(
                      data: (data) {
                        final items = data?.data?.data ?? [];
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          padding: EdgeInsets.only(top: 15),
                          separatorBuilder: (context, index) => Divider(
                              height: 1.h, color: colors(context).accentColor),
                          itemBuilder: (context, index) {
                            final message = items[index];
                            final bool isUnread =
                                (message.unreadMessageUser ?? 0) > 0;

                            // return ListTile(
                            //   tileColor: isUnread
                            //       ? colors(context).primaryColor!.withOpacity(0.05)
                            //       : Colors.transparent,
                            //   onTap: () {
                            //     // Standardized navigation using generated routes
                            //     Navigator.pushNamed(
                            //       context,
                            //       Routes.getSellerChatViewRouteName('ecommerce'),
                            //       arguments: message.user,
                            //     );
                            //   },
                            //   leading: ClipOval(
                            //     child: CachedNetworkImage(
                            //       fit: BoxFit.cover,
                            //       width: 50.w,
                            //       height: 50.h,
                            //       imageUrl: message.user?.profilePhoto ?? "",
                            //       errorWidget: (context, url, error) => Container(
                            //         color: colors(context).accentColor,
                            //         child: const Icon(Icons.person),
                            //       ),
                            //     ),
                            //   ),
                            //   title: Text(
                            //     message.user?.name ?? "",
                            //     style: style.text16B700.copyWith(
                            //       color: isUnread
                            //           ? colors(context).primaryColor
                            //           : colors(context).bodyTextColor,
                            //     ),
                            //   ),
                            //   subtitle: Text(
                            //     message.lastMessage ?? "",
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: style.bodyText.copyWith(
                            //       color: colors(context).hintTextColor,
                            //     ),
                            //   ),
                            //   trailing: Text(
                            //     message.lastMessageTime ?? "",
                            //     style: style.bodyTextSmall,
                            //   ),
                            // );
                            return chatBody(message);
                          },
                        );
                      },
                      error: (error, stk) =>
                          Center(child: Text(error.toString())),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget messageHeader(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.only(
  //       top: MediaQuery.of(context).padding.top + 14.h,
  //       left: 20.w,
  //       right: 20.w,
  //       bottom: 5.h,
  //     ),
  //     decoration: BoxDecoration(
  //       color: EcommerceAppColor.carrotOrange,
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(50.r),
  //         bottomRight: Radius.circular(50.r),
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// Top Row
  //         Row(
  //           children: [
  //             /// LEFT SIDE (Title OR Search)
  //             Expanded(
  //               child: AnimatedSwitcher(
  //                 duration: const Duration(milliseconds: 250),
  //                 transitionBuilder: (child, animation) =>
  //                     FadeTransition(opacity: animation, child: child),
  //                 child: isSearchActive
  //                     ? CustomSearchField(
  //                         key: const ValueKey('search'),
  //                         name: 'search',
  //                         hintText: S.of(context).seachSeller,
  //                         textInputType: TextInputType.text,
  //                         controller: messageController,
  //                         widget: IconButton(
  //                           icon: const Icon(Icons.close),
  //                           onPressed: () {
  //                             setState(() {
  //                               isSearchActive = false;
  //                               messageController.clear();
  //                             });
  //                             ref
  //                                 .read(getCustomerControllerProvider.notifier)
  //                                 .getCustomer();
  //                           },
  //                         ),
  //                         onChanged: (value) async {
  //                           await Future.delayed(
  //                               const Duration(milliseconds: 300));
  //                           ref
  //                               .read(getCustomerControllerProvider.notifier)
  //                               .getCustomer(search: value);
  //                         },
  //                       )
  //                     : Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Column(
  //                           key: const ValueKey('title'),
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             _buildProfileContainer(context),
  //                             // Text(
  //                             //   userName == '' || userName == null
  //                             //       ? ''
  //                             //       : "Hello ${userName.toString()}",
  //                             //   style: Theme.of(context)
  //                             //       .textTheme
  //                             //       .titleLarge
  //                             //       ?.copyWith(
  //                             //           color: Colors.white,
  //                             //           fontWeight: FontWeight.bold,
  //                             //           fontSize: 18.sp),
  //                             // ),
  //                             Gap(4.h),
  //                             Text(
  //                               'Welcome back',
  //                               style: Theme.of(context)
  //                                   .textTheme
  //                                   .bodyMedium
  //                                   ?.copyWith(
  //                                       color: Colors.white.withOpacity(0.9),
  //                                       fontSize: 13.sp),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //               ),
  //             ),
  //
  //             /// RIGHT SEARCH ICON (only when search inactive)
  //             if (!isSearchActive) ...[
  //               Gap(12.w),
  //               GestureDetector(
  //                 onTap: () {
  //                   setState(() {
  //                     isSearchActive = true;
  //                   });
  //                 },
  //                 child: CircleAvatar(
  //                   radius: 22.r,
  //                   backgroundColor: Colors.white.withOpacity(0.2),
  //                   child: const Icon(
  //                     Icons.search,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ],
  //         ),
  //
  //         Gap(20.h),
  //
  //         /// Status List
  //         // ref.watch(getCustomerControllerProvider).when(
  //         //   data: (data) {
  //         //     final list = data?.data?.data ?? [];
  //         //
  //         //     if (list.isEmpty) {
  //         //       return const SizedBox.shrink();
  //         //     }
  //         //
  //         //     return SizedBox(
  //         //       height: 95.h,
  //         //       child: ListView.builder(
  //         //         scrollDirection: Axis.horizontal,
  //         //         padding: EdgeInsets.symmetric(horizontal: 12.w),
  //         //         itemCount: list.length,
  //         //         itemBuilder: (context, index) {
  //         //           final message = list[index];
  //         //
  //         //           return _statusItem(
  //         //             context,
  //         //             imageUrl: message.user?.profilePhoto ?? '',
  //         //             name: message.user?.name ?? '',
  //         //             isActive:
  //         //             index == 3, // example active like image (Grace)
  //         //             showAdd: index == 0,
  //         //           );
  //         //         },
  //         //       ),
  //         //     );
  //         //   },
  //         //   error: (_, __) => const SizedBox.shrink(),
  //         //   loading: () => const SizedBox.shrink(), // ❌ removed loader
  //         // ),
  //         ref.watch(sellerPostControllerProvider).when(
  //           data: (posts) {
  //             return SizedBox(
  //               height: 95.h,
  //               child: ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                 itemCount: posts.length + 1,
  //                 itemBuilder: (context, index) {
  //
  //                   /// 👤 SELLER SELF STATUS (FIRST)
  //                   if (index == 0) {
  //                     return _sellerSelfStatus(context);
  //                   }
  //
  //                   final post = posts[index - 1];
  //
  //                   return _statusItem(
  //                     context,
  //                     imageUrl: post.media.isNotEmpty ? post.media.first : '',
  //                     name: 'Post',
  //                     isActive: true,
  //                     onTap: () => _openStatusViewer(context, post),
  //                   );
  //                 },
  //               ),
  //             );
  //           },
  //           loading: () => SizedBox(
  //             height: 95.h,
  //             child: ListView.builder(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: 4,
  //               padding: EdgeInsets.symmetric(horizontal: 12.w),
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: EdgeInsets.only(right: 15.w),
  //                   child: Column(
  //                     children: [
  //                       Shimmer.fromColors(
  //                         baseColor: Colors.white.withOpacity(0.25),
  //                         highlightColor: Colors.white.withOpacity(0.45),
  //                         child: Container(
  //                           width: 44.w,
  //                           height: 44.w,
  //                           decoration: BoxDecoration(
  //                             shape: BoxShape.circle,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                       Gap(6.h),
  //                       Shimmer.fromColors(
  //                         baseColor: Colors.white.withOpacity(0.25),
  //                         highlightColor: Colors.white.withOpacity(0.45),
  //                         child: Container(
  //                           width: 45.w,
  //                           height: 8.h,
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             borderRadius: BorderRadius.circular(4.r),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //           error: (_, __) => const SizedBox.shrink(),
  //         )
  //       ],
  //     ),
  //   );
  // }
  Widget messageHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14.h,
        left: 20.w,
        right: 20.w,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: EcommerceAppColor.carrotOrange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.r),
          bottomRight: Radius.circular(50.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15.r,
                backgroundColor: colors(context).accentColor,
                // backgroundColor: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                  ),
                  onPressed: () => context.nav.pop(context),
                ),
              ),
              Gap(15.w),
              _buildProfileContainer(context),
            ],
          ),
          Gap(20.h),

          /// STATUS LIST
          ref.watch(sellerPostControllerProvider).when(
            data: (posts) {
              return SizedBox(
                height: 95.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _sellerSelfStatus(context);

                    final post = posts[index - 1];
                    return _statusItem(
                      context,
                      imageUrl: post.media.isNotEmpty ? post.media.first : '',
                      name: 'Post',
                      isActive: true,
                      onTap: () => _openStatusViewer(context, post),
                    );
                  },
                ),
              );
            },
            loading: () => SizedBox(
              height: 95.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.white.withOpacity(0.25),
                          highlightColor: Colors.white.withOpacity(0.45),
                          child: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Gap(6.h),
                        Shimmer.fromColors(
                          baseColor: Colors.white.withOpacity(0.25),
                          highlightColor: Colors.white.withOpacity(0.45),
                          child: Container(
                            width: 45.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _sellerSelfStatus(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final sellerAsync = ref.watch(sellerUserProvider);

        return sellerAsync.when(
          data: (seller) {
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundImage:
                        // NetworkImage('https://img.freepik.com/premium-vector/free-vector-beautiful-flying-hummingbird-design-element-banners-posters-leaflets-brochur_1009653-1.jpg?semt=ais_user_personalization&w=740&q=80'),
                        NetworkImage(seller?.shop?.logo ?? ''),
                      ),
                      GestureDetector(
                        onTap: () => _openCreatePostDialog(context),
                        child: CircleAvatar(
                          radius: 9.r,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            size: 14,
                            color: EcommerceAppColor.carrotOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(6.h),
                  Text(
                    seller?.shop?.name ?? 'You',
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  ),
                ],
              ),
            );
          },
          loading: () => SizedBox(
            height: 95.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              // padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: Column(
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.25),
                        highlightColor: Colors.white.withOpacity(0.45),
                        child: Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Gap(6.h),
                      Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.25),
                        highlightColor: Colors.white.withOpacity(0.45),
                        child: Container(
                          width: 45.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }



  // void _openCreatePostDialog(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (_) => CreateSellerPostSheet(),
  //   );
  // }
  void _openCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap cancel or close
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w), // Margin from screen edges
        child: const CreateSellerPostSheet(),
      ),
    );
  }

  void _openStatusViewer(BuildContext context, SellerPost post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatusViewerScreen(post: post),
      ),
    );
  }


  Widget _statusItem(
    BuildContext context, {
    required String imageUrl,
    required String name,
    bool showAdd = false,
    bool isActive = false,
    VoidCallback? onTap,
      }) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isActive ? Colors.white : Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 24.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),

                /// PLUS ICON (optional – keep commented if not needed)
                if (showAdd)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: GestureDetector(
                      // onTap: () => _openCreatePostDialog(context),
                      child: Container(
                        height: 18.w,
                        width: 18.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: EcommerceAppColor.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Gap(6.h),
            SizedBox(
              width: 65.w,
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBody(message) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.getSellerChatViewRouteName('ecommerce'),
          arguments: message.user,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center items vertically
              children: [
                // 1. Avatar
                ClipOval(
                  child: CachedNetworkImage(
                    width: 55.w, // Slightly larger to match image
                    height: 55.w,
                    fit: BoxFit.cover,
                    imageUrl: message.user?.profilePhoto ?? "",
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.person, size: 30),
                  ),
                ),

                Gap(15.w),

                // 2. Name and Last Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message?.user?.name ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(4.h),
                      Text(
                        message?.lastMessage ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 10.sp,
                              color: Colors.black87,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // 3. Time and Badge Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message?.lastMessageTime ?? "",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                    ),
                    Gap(8.h),
                    if ((message?.unreadMessageShop ?? 0) > 0)
                      Container(
                        height: 22.w,
                        width: 22.w,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: EcommerceAppColor.carrotOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          message!.unreadMessageShop.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      // Keeps vertical alignment consistent if no badge
                      SizedBox(height: 24.w),
                  ],
                ),

                Gap(25.w), // Space before delete icon

                // 4. Delete Icon
                GestureDetector(
                  // onTap: () async {
                  //   final shopId = message?.shop?.id;
                  //   if (shopId != null) {
                  //     // Call the delete function from the controller
                  //     final response = await ref
                  //         .read(getCustomerControllerProvider.notifier)
                  //         .deleteChatList(shopId);
                  //
                  //     // Show Feedback
                  //     if (context.mounted) {
                  //       if (response.isSuccess) {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: Text(response.message),
                  //             backgroundColor: Colors.green,
                  //           ),
                  //         );
                  //       } else {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //             content: Text(response.message),
                  //             backgroundColor: Colors.red,
                  //           ),
                  //         );
                  //       }
                  //     }
                  //   }
                  // },
                  onTap: () {},
                  child: SvgPicture.asset(
                    Assets.svg
                        .deleteIcon, // Replace with your actual trash SVG asset path
                    height: 20.sp,
                    width: 20.sp,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(10.h),
          Divider(
            height: 1,
            thickness: 1,
            indent: 16.w,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

enum OrderStatus {
  all,
  pending,
  confirm,
  processing,
  onTheWay,
  delivered,
  canceled,
}


// class CreateSellerPostSheet extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<CreateSellerPostSheet> createState() =>
//       _CreateSellerPostSheetState();
// }
//
// class _CreateSellerPostSheetState
//     extends ConsumerState<CreateSellerPostSheet> {
//   final controller = TextEditingController();
//   final picker = ImagePicker();
//   final List<File> mediaFiles = [];
//
//   Future<void> _submit() async {
//     if (controller.text.isEmpty && mediaFiles.isEmpty) return;
//
//     await ref.read(sellerPostControllerProvider.notifier).addPost(
//       content: controller.text,
//       images: mediaFiles.map((e) => e.path).toList(),
//     );
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: controller,
//             maxLines: 3,
//             decoration: const InputDecoration(hintText: 'Write something...'),
//           ),
//           Gap(10),
//           SizedBox(
//             height: 70,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: mediaFiles.length,
//               itemBuilder: (_, i) =>
//                   Image.file(mediaFiles[i], width: 70),
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.image),
//                 onPressed: () async {
//                   final img =
//                   await picker.pickImage(source: ImageSource.gallery);
//                   if (img != null) {
//                     setState(() => mediaFiles.add(File(img.path)));
//                   }
//                 },
//               ),
//               const Spacer(),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: const Text('Post'),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
class CreateSellerPostSheet extends ConsumerStatefulWidget {
  const CreateSellerPostSheet({super.key});

  @override
  ConsumerState<CreateSellerPostSheet> createState() =>
      _CreateSellerPostSheetState();
}

// class _CreateSellerPostSheetState extends ConsumerState<CreateSellerPostSheet> {
//   final TextEditingController _controller = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   final List<File> _mediaFiles = [];
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
//       if (img != null) {
//         setState(() {
//           _mediaFiles.add(File(img.path));
//         });
//       }
//     } catch (e) {
//       debugPrint("Error picking image: $e");
//     }
//   }
//
//   void _removeImage(int index) {
//     setState(() {
//       _mediaFiles.removeAt(index);
//     });
//   }
//
//   Future<void> _submit() async {
//     if (_controller.text.trim().isEmpty && _mediaFiles.isEmpty) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       // Simulate submission or call your provider
//       await ref.read(sellerPostControllerProvider.notifier).addPost(
//         content: _controller.text.trim(),
//         images: _mediaFiles.map((e) => e.path).toList(),
//       );
//
//       if (mounted) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Post created successfully!")),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Failed to post: $e")),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isButtonEnabled =
//         _controller.text.trim().isNotEmpty || _mediaFiles.isNotEmpty;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
//         left: 20.w,
//         right: 20.w,
//         top: 12.h,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 1. Drag Handle
//           Center(
//             child: Container(
//               width: 40.w,
//               height: 4.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//             ),
//           ),
//           Gap(20.h),
//
//           // 2. Header
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20.r,
//                 backgroundColor: colors(context).primaryColor!.withOpacity(0.1),
//                 // Replace with user profile image if available
//                 child: Icon(Icons.person, color: colors(context).primaryColor),
//               ),
//               Gap(12.w),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Create Post",
//                     style: AppTextStyle(context).bodyText.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.sp,
//                     ),
//                   ),
//                   Text(
//                     "Share with your followers",
//                     style: AppTextStyle(context).bodyTextSmall.copyWith(
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Gap(16.h),
//
//           // 3. Text Input
//           TextField(
//             controller: _controller,
//             maxLines: 5,
//             minLines: 1,
//             autofocus: true,
//             onChanged: (val) => setState(() {}),
//             style: AppTextStyle(context).bodyText.copyWith(fontSize: 16.sp),
//             decoration: InputDecoration(
//               hintText: "What's on your mind?",
//               hintStyle: AppTextStyle(context).bodyText.copyWith(
//                 color: Colors.grey.shade400,
//                 fontSize: 16.sp,
//               ),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.zero,
//             ),
//           ),
//           Gap(16.h),
//
//           // 4. Selected Images Preview
//           if (_mediaFiles.isNotEmpty)
//             SizedBox(
//               height: 100.h,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _mediaFiles.length,
//                 separatorBuilder: (_, __) => Gap(10.w),
//                 itemBuilder: (_, index) {
//                   return Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12.r),
//                         child: Image.file(
//                           _mediaFiles[index],
//                           width: 100.w,
//                           height: 100.h,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         top: 4,
//                         right: 4,
//                         child: GestureDetector(
//                           onTap: () => _removeImage(index),
//                           child: Container(
//                             padding: EdgeInsets.all(4.w),
//                             decoration: const BoxDecoration(
//                               color: Colors.black54,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.close,
//                               size: 14.sp,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           if (_mediaFiles.isNotEmpty) Gap(16.h),
//
//           // 5. Bottom Actions
//           Row(
//             children: [
//               // Add Photo Button
//               InkWell(
//                 onTap: _pickImage,
//                 borderRadius: BorderRadius.circular(8.r),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                   decoration: BoxDecoration(
//                     color: colors(context).primaryColor!.withOpacity(0.08),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.image_outlined,
//                         color: colors(context).primaryColor,
//                         size: 20.sp,
//                       ),
//                       Gap(6.w),
//                       Text(
//                         "Add Photo",
//                         style: AppTextStyle(context).bodyTextSmall.copyWith(
//                           color: colors(context).primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const Spacer(),
//
//               // Post Button
//               SizedBox(
//                 height: 40.h,
//                 child: ElevatedButton(
//                   onPressed: isButtonEnabled && !_isLoading ? _submit : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: colors(context).primaryColor,
//                     disabledBackgroundColor: Colors.grey.shade200,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 24.w),
//                   ),
//                   child: _isLoading
//                       ? SizedBox(
//                     height: 16.h,
//                     width: 16.h,
//                     child: const CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                       : Text(
//                     "Post",
//                     style: AppTextStyle(context).buttonText.copyWith(
//                       color: isButtonEnabled
//                           ? Colors.white
//                           : Colors.grey.shade500,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Gap(10.h),
//         ],
//       ),
//     );
//   }
// }

class _CreateSellerPostSheetState extends ConsumerState<CreateSellerPostSheet> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _mediaFiles = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          _mediaFiles.add(File(img.path));
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty && _mediaFiles.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(sellerPostControllerProvider.notifier).addPost(
        content: _controller.text.trim(),
        images: _mediaFiles.map((e) => e.path).toList(),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post created successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to post: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled =
        _controller.text.trim().isNotEmpty || _mediaFiles.isNotEmpty;

    // Wrap in SingleChildScrollView to handle small screens / landscape
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r), // Circular radius for Dialog
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Title + Close Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Post",
                  style: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 20.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Gap(16.h),

            // 2. User Info Row
            Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: colors(context).primaryColor!.withOpacity(0.1),
                  child: Icon(Icons.person, color: colors(context).primaryColor, size: 20.sp),
                ),
                Gap(10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Posting as Seller",
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Public",
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Gap(12.h),

            // 3. Text Input Area
            Container(
              constraints: BoxConstraints(
                maxHeight: 150.h, // Limit height so dialog doesn't get too tall
              ),
              child: TextField(
                controller: _controller,
                maxLines: null, // Grows automatically
                minLines: 3,
                onChanged: (val) => setState(() {}),
                style: AppTextStyle(context).bodyText.copyWith(fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: AppTextStyle(context).bodyText.copyWith(
                    color: Colors.grey.shade400,
                    fontSize: 16.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Gap(16.h),

            // 4. Selected Images
            if (_mediaFiles.isNotEmpty)
              SizedBox(
                height: 90.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _mediaFiles.length,
                  separatorBuilder: (_, __) => Gap(10.w),
                  itemBuilder: (_, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            _mediaFiles[index],
                            width: 90.w,
                            height: 90.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            if (_mediaFiles.isNotEmpty) Gap(20.h),

            // 5. Divider
            Divider(color: Colors.grey.shade200),
            Gap(10.h),

            // 6. Actions (Photo + Post)
            Row(
              children: [
                IconButton(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.image_outlined,
                    color: colors(context).primaryColor,
                    size: 26.sp,
                  ),
                  tooltip: "Add Photo",
                ),
                Text(
                  "Add to your post",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
                const Spacer(),
                SizedBox(
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled && !_isLoading ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors(context).primaryColor,
                      disabledBackgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 14.h,
                      width: 14.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Post",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class StatusViewerScreen extends StatefulWidget {
  final SellerPost post;

  const StatusViewerScreen({super.key, required this.post});

  @override
  State<StatusViewerScreen> createState() => _StatusViewerScreenState();
}

class _StatusViewerScreenState extends State<StatusViewerScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// MEDIA
          PageView.builder(
            itemCount: widget.post.media.length,
            onPageChanged: (i) => setState(() => currentIndex = i),
            itemBuilder: (_, index) {
              return Image.network(
                widget.post.media[index],
                fit: BoxFit.contain,
              );
            },
          ),

          /// TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  /// PROGRESS
                  Row(
                    children: List.generate(
                      widget.post.media.length,
                          (i) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 3,
                          decoration: BoxDecoration(
                            color: i <= currentIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage:
                        NetworkImage(widget.post.media.toString() ?? ''),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          // widget.post.content ?? 'My Status',
                          'My Status',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /// 🗑 DELETE ICON
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => _confirmDelete(context),
                      ),

                      /// ❌ CLOSE
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  if ((widget.post.content ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.post.content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🧨 CONFIRM DELETE
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Status'),
        content: const Text('Are you sure you want to delete this status?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () async {
                await ref
                    .read(sellerPostControllerProvider.notifier)
                    .deletePost(widget.post.id);

                Navigator.pop(context); // dialog
                Navigator.pop(context); // status screen
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

