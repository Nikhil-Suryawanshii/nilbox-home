import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/message/message_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/pusher/pusher_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/app_text_style.dart';
import '../../../../models/eCommerce/authentication/user.dart';
import '../../../../services/common/hive_service_provider.dart';
import '../../../../services/eCommerce/message/message_service.dart';

class MyMessageLayout extends ConsumerStatefulWidget {
  const MyMessageLayout({super.key});

  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController emailController = TextEditingController();

  @override
  ConsumerState<MyMessageLayout> createState() => _MyMessageLayoutState();
}

class _MyMessageLayoutState extends ConsumerState<MyMessageLayout> {
  final messageController = TextEditingController();
  bool isSearchActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pusherControllerProvider.notifier).init();
      ref.read(getShopsControllerProvider.notifier).getShops();
    });
  }

  Widget _buildProfileContainer(BuildContext context) {
    final isLoggedIn = ref.read(hiveServiceProvider).userIsLoggedIn();
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppConstants.userBox).listenable(),
        builder: (context, box, _) {
          Map<dynamic, dynamic>? userInfo = box.get(AppConstants.userData);
          Map<String, dynamic> userInfoStringKeys =
              userInfo!.cast<String, dynamic>();
          final User user = User.fromMap(userInfoStringKeys);

          return Text(
            isLoggedIn ?? false ? "Hello ${user.name!}" : ' Hello Guest User',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle(context)
                .subTitle
                .copyWith(color: EcommerceAppColor.white,fontSize: 18.sp),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.refresh(getTotalUnreadMessagesControllerProvider);
      },
      child: Scaffold(
        //  backgroundColor: colors(context).accentColor,
        // appBar: AppBar(
        //   title: Text(S.of(context).message),
        //   surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              messageHeader(context),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CustomSearchField(
                    //   name: 'search',
                    //   hintText: S.of(context).seachSeller,
                    //   textInputType: TextInputType.text,
                    //   controller: messageController,
                    //   widget: Container(
                    //     margin: EdgeInsets.all(10.sp),
                    //     child: SvgPicture.asset(Assets.svg.searchHome),
                    //   ),
                    //   onChanged: (value) async {
                    //     await Future.delayed(const Duration(milliseconds: 300));
                    //     ref
                    //         .read(getShopsControllerProvider.notifier)
                    //         .getShops(search: value);
                    //   },
                    // ),
                    // Gap(8.h),
                    ref.watch(getShopsControllerProvider).when(
                        data: (data) {
                          return ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data?.data?.data?.length ?? 0,
                            separatorBuilder: (context, index) => Gap(
                              1.h,
                              color: Colors.grey.shade200,
                            ),
                            itemBuilder: (context, index) {
                              final message = data?.data?.data?[index];
                              // PusherService()
                              //     .subscribeToUserChannel(message?.shop?.id ?? 0);
                              // return ListTile(
                              //   titleAlignment: ListTileTitleAlignment.top,
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(8),
                              //   ),
                              //   tileColor: message?.unreadMessageShop == 0
                              //       ? Colors.transparent
                              //       : colors(context)
                              //           .primaryColor!
                              //           .withValues(alpha: 0.2),
                              //   onTap: () {
                              //     context.nav.pushNamed(
                              //         Routes.getChatViewRouteName(
                              //             AppConstants.appServiceName),
                              //         arguments: message?.shop);
                              //   },
                              //   leading: CachedNetworkImage(
                              //     fit: BoxFit.cover,
                              //     width: 50.w,
                              //     height: 50.h,
                              //     imageUrl: message?.shop?.logo ?? "",
                              //     errorWidget: (context, url, error) {
                              //       return Icon(
                              //         Icons.person,
                              //       );
                              //     },
                              //   ),
                              //   title: Text(
                              //     message?.shop?.name ?? "",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .bodyLarge
                              //         ?.copyWith(
                              //           fontSize: 16.sp,
                              //           fontWeight: FontWeight.w600,
                              //         ),
                              //   ),
                              //   subtitle: Text(
                              //     message?.lastMessage ?? "",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .bodyMedium
                              //         ?.copyWith(
                              //           fontSize: 14.sp,
                              //           fontWeight: FontWeight.w400,
                              //           color: colors(context).hintTextColor,
                              //         ),
                              //   ),
                              //   trailing: Padding(
                              //     padding: const EdgeInsets.only(top: 8.0),
                              //     child: Text(
                              //       message?.lastMessageTime ?? "",
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .bodySmall
                              //           ?.copyWith(color: EcommerceAppColor.gray),
                              //     ),
                              //   ),
                              // );
                              return chatBody(message);
                            },
                          );
                        },
                        error: (error, stk) =>
                            Center(child: Text(error.toString())),
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBody(message) {
    return InkWell(
      onTap: () {
        context.nav.pushNamed(
          Routes.getChatViewRouteName(AppConstants.appServiceName),
          arguments: message?.shop,
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
                    imageUrl: message?.shop?.logo ?? "",
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
                        message?.shop?.name ?? "",
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
                  onTap: () async {
                    final shopId = message?.shop?.id;
                    if (shopId != null) {
                      // Call the delete function from the controller
                      final response = await ref
                          .read(getShopsControllerProvider.notifier)
                          .deleteChatList(shopId);

                      ///
                      // Show Feedback
                      if (context.mounted) {
                        if (response.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response.message),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.fixed,
                              // margin: EdgeInsets.only(
                              //   bottom: 100.h, // 👈 2. Push it ABOVE your Bottom Nav (adjust height as needed)
                              //   left: 20.w,
                              //   right: 20.w,
                              // ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Optional: Make it look nicer
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response.message),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.fixed,
                              // margin: EdgeInsets.only(
                              //   bottom: 100.h, // 👈 2. Push it ABOVE your Bottom Nav (adjust height as needed)
                              //   left: 20.w,
                              //   right: 20.w,
                              // ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Optional: Make it look nicer
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
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

  Widget messageHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14.h,
        left: 20.w,
        right: 20.w,
        bottom: 5.h,
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
          /// Top Row
          Row(
            children: [
              /// LEFT SIDE (Title OR Search)
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: isSearchActive
                      ? CustomSearchField(
                          key: const ValueKey('search'),
                          name: 'search',
                          hintText: S.of(context).seachSeller,
                          textInputType: TextInputType.text,
                          controller: messageController,
                          widget: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                isSearchActive = false;
                                messageController.clear();
                              });
                              ref
                                  .read(getShopsControllerProvider.notifier)
                                  .getShops();
                            },
                          ),
                          onChanged: (value) async {
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            ref
                                .read(getShopsControllerProvider.notifier)
                                .getShops(search: value);
                          },
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            key: const ValueKey('title'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildProfileContainer(context),
                              // Text(
                              //   userName == '' || userName == null
                              //       ? ''
                              //       : "Hello ${userName.toString()}",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .titleLarge
                              //       ?.copyWith(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 18.sp),
                              // ),
                              Gap(4.h),
                              Text(
                                'Welcome back',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13.sp),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              /// RIGHT SEARCH ICON (only when search inactive)
              if (!isSearchActive) ...[
                Gap(12.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSearchActive = true;
                    });
                  },
                  child: CircleAvatar(
                    radius: 22.r,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),

          Gap(20.h),

          // /// Status List
          // ref.watch(getShopsControllerProvider).when(
          //       data: (data) {
          //         final list = data?.data?.data ?? [];
          //
          //         if (list.isEmpty) {
          //           return const SizedBox.shrink();
          //         }
          //
          //         return SizedBox(
          //           height: 95.h,
          //           child: ListView.builder(
          //             scrollDirection: Axis.horizontal,
          //             padding: EdgeInsets.symmetric(horizontal: 12.w),
          //             itemCount: list.length,
          //             itemBuilder: (context, index) {
          //               final message = list[index];
          //
          //               return _statusItem(
          //                 context,
          //                 imageUrl: message.shop?.logo ?? '',
          //                 name: message.shop?.name ?? '',
          //                 isActive:
          //                     index == 3, // example active like image (Grace)
          //                 showAdd: index == 0,
          //               );
          //             },
          //           ),
          //         );
          //       },
          //       error: (_, __) => const SizedBox.shrink(),
          //       loading: () => const SizedBox.shrink(), // ❌ removed loader
          //     ),
          /// Status List
          ref.watch(followingShopsControllerProvider).when(
            data: (shops) {
              if (shops.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 95.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];

                    return _statusItem(
                      context,
                      imageUrl: shop.logo,
                      name: shop.name,
                      isActive: index == 0, // optional highlight
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

  Widget _statusItem(
    BuildContext context, {
    required String imageUrl,
    required String name,
    bool showAdd = false,
    bool isActive = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
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
              // if (showAdd)
              //   Positioned(
              //     bottom: 2,
              //     right: 2,
              //     child: Container(
              //       height: 18.w,
              //       width: 18.w,
              //       decoration: const BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.white,
              //       ),
              //       child: const Icon(
              //         Icons.add,
              //         size: 14,
              //         color: EcommerceAppColor.carrotOrange,
              //       ),
              //     ),
              //   ),
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
