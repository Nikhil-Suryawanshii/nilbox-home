// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/providers/seller/common_provider.dart';
// import 'package:ready_ecommerce/views/seller/dashboard/my_message/components/product_card_widget.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/seller/message/message_controller.dart';
// import 'package:ready_ecommerce/controllers/seller/pusher/pusher_controller.dart';
// import 'package:ready_ecommerce/models/eCommerce/message_model/messages.dart';
// import 'package:ready_ecommerce/models/eCommerce/shop_message_model/product.dart';
// import 'package:ready_ecommerce/models/eCommerce/shop_message_model/shop.dart';
// import 'package:ready_ecommerce/models/eCommerce/shop_message_model/user.dart';
// import 'package:ready_ecommerce/providers/seller/common_provider.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';

// class MyChatLayout extends ConsumerStatefulWidget {
//   final User user;
//   const MyChatLayout({super.key, required this.user});

//   @override
//   ConsumerState<MyChatLayout> createState() => _MyChatLayoutState();
// }

// class _MyChatLayoutState extends ConsumerState<MyChatLayout> {
//   final TextEditingController messageController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(pusherControllerProvider.notifier).init();
//       ref
//           .read(getMessageControllerProvider.notifier)
//           .getMessage(userId: widget.user.id ?? 0, isInitial: true);
//       _scrollToBottom();
//     });

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 20) {
//         ref
//             .read(getMessageControllerProvider.notifier)
//             .getMessage(userId: widget.user.id ?? 0);
//       }
//     });
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.minScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvokedWithResult: (result, t) {
//         ref.read(getCustomerControllerProvider.notifier).getCustomer();
//         ref.invalidate(getTotalUnreadMessagesControllerProvider);
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           titleSpacing: 0,
//           surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(0),
//             child: Divider(color: Colors.grey.shade100, height: 0.5.h),
//           ),
//           title: Row(
//             children: [
//               ClipOval(
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: widget.user.profilePhoto ?? '',
//                   width: 40.w,
//                   height: 40.h,
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.user.name ?? '',
//                     style: AppTextStyle(context: context).text16B400.copyWith(
//                       fontSize: 16.sp,
//                       color: colors(context).textColor,
//                     ),
//                   ),
//                   Text(
//                     widget.user.lastOnline == true ? "Active" : "Inactive",
//                     style: AppTextStyle(context: context).text16B400.copyWith(
//                       fontSize: 12.sp,
//                       color:
//                           widget.user.lastOnline == true
//                               ? Colors.green
//                               : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body: ref
//             .watch(getMessageControllerProvider)
//             .when(
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error:
//                   (error, stackTrace) => Center(
//                     child: Text(
//                       error.toString(),
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//               data: (data) {
//                 // _scrollToBottom();
//                 final messages = data ?? [];
//                 return Column(
//                   children: [
//                     // Messages
//                     Expanded(
//                       child:
//                           messages.isEmpty
//                               ? const Center(
//                                 child: Text(
//                                   "No messages yet",
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               )
//                               : ListView.builder(
//                                 controller: _scrollController,
//                                 reverse: true,
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 2.w,
//                                   vertical: 8.h,
//                                 ),
//                                 itemCount: messages.length,
//                                 itemBuilder: (context, index) {
//                                   final message = messages[index];
//                                   final bool isMe = message.type == "shop";
//                                   bool isFirstOfGroup = true;
//                                   if (index < messages.length - 1) {
//                                     final next = messages[index + 1];
//                                     isFirstOfGroup = message.type != next.type;
//                                   }
//                                   debugPrint(
//                                     "product: ${message.product?.toJson()}",
//                                   );

//                                   return Padding(
//                                     padding: EdgeInsets.only(bottom: 8.0.h),
//                                     child: _buildMessage(
//                                       isMe: isMe,
//                                       text: message.message ?? "",
//                                       showAvatar: isFirstOfGroup,
//                                       imageUrl:
//                                           isMe
//                                               ? message.shop?.logo ?? ''
//                                               : message.user?.profilePhoto,
//                                       product: message.product,
//                                       dateTime:
//                                           message.createdAt ?? DateTime.now(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                     ),

//                     // Input Field
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 8.h,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border(
//                           top: BorderSide(color: Colors.grey.shade300),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Form(
//                               key: _formKey,
//                               child: TextFormField(
//                                 controller: messageController,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return "Value cannot be empty";
//                                   }
//                                   return null;
//                                 },
//                                 decoration: InputDecoration(
//                                   hintText: "Type a message",
//                                   hintStyle: TextStyle(fontSize: 14.sp),
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(25.r),
//                                     borderSide: const BorderSide(
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(25.r),
//                                     borderSide: BorderSide(
//                                       color: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(25.r),
//                                     borderSide: BorderSide(
//                                       color: colors(context).primaryColor!,
//                                     ),
//                                   ),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 16.w,
//                                     vertical: 10.h,
//                                   ),
//                                   suffixIcon:
//                                   //  ref
//                                   //         .watch(sendMessageControllerProvider)
//                                   //     ? SizedBox(
//                                   //         width: 20.w,
//                                   //         height: 20.h,
//                                   //         child: Padding(
//                                   //           padding: const EdgeInsets.all(8.0),
//                                   //           child: CircularProgressIndicator(),
//                                   //         ))
//                                   //     :
//                                   IconButton(
//                                     icon: SvgPicture.asset(
//                                       Assets.svg.sendRight,
//                                       // width: 20.w,
//                                       // height: 20.h,
//                                     ),
//                                     onPressed: () async {
//                                       if (_formKey.currentState!.validate()) {
//                                         final saveUser =
//                                             await ref
//                                                 .read(sellerHiveServiceProvider)
//                                                 .getUserInfo();
//                                         Shop? shop;
//                                         if (saveUser != null) {
//                                           shop = Shop(
//                                             name: saveUser.shop?.name,
//                                             id: saveUser.shop?.id,
//                                             logo: saveUser.shop?.logo,
//                                           );
//                                         }
//                                         final messageText =
//                                             messageController.text;
//                                         final messageModel = Messages(
//                                           type: "shop",
//                                           message: messageController.text,
//                                           shop: shop,
//                                         );
//                                         ref
//                                             .read(
//                                               getMessageControllerProvider
//                                                   .notifier,
//                                             )
//                                             .addNewMessage(messageModel)
//                                             .then((val) async {
//                                               messageController.clear();
//                                               await ref
//                                                   .read(
//                                                     sendMessageControllerProvider
//                                                         .notifier,
//                                                   )
//                                                   .sendMessage(
//                                                     shopId: widget.user.id ?? 0,
//                                                     message: messageText,
//                                                   );
//                                             });
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//       ),
//     );
//   }

//   Widget _buildMessage({
//     required bool isMe,
//     String? text,
//     ProductMessage? product,
//     required bool showAvatar,
//     String? imageUrl,
//     required DateTime dateTime,
//   }) {
//     debugPrint("productisnull: ${product?.thumbnail}");
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Row(
//         mainAxisAlignment:
//             isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isMe && showAvatar) ...[
//             Padding(
//               padding: EdgeInsets.only(left: 16.0, right: 8.0.w, top: 4.h),
//               child: ClipOval(
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: imageUrl ?? '',
//                   width: 30.w,
//                   height: 30.h,
//                   errorWidget: (context, url, error) => const SizedBox(),
//                 ),
//               ),
//             ),
//           ] else ...{
//             SizedBox(width: 8.w),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: SizedBox(width: 30.w, height: 30.h),
//             ),
//           },
//           product != null && (text == null || text.isEmpty)
//               ? ProductMessageCard(product: product)
//               : Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment:
//                     isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 4.h),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 14.w,
//                       vertical: 10.h,
//                     ),
//                     constraints: BoxConstraints(maxWidth: 260.w),
//                     decoration: BoxDecoration(
//                       color:
//                           isMe
//                               ? colors(context).primaryColor!
//                               : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(16.r),
//                     ),
//                     child: Text(
//                       text ?? '',
//                       style: TextStyle(
//                         color: isMe ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     GlobalFunction.formatMessageDateTime(dateTime),
//                     style: AppTextStyle(context: context).text14B400.copyWith(
//                       fontSize: 10.sp,
//                       color: AppStaticColor.gray,
//                     ),
//                   ),
//                 ],
//               ),
//           if (isMe && showAvatar) ...[
//             SizedBox(width: 8.w),
//             Padding(
//               padding: EdgeInsets.only(right: 16.0, top: 4.h),
//               child: ClipOval(
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   imageUrl: imageUrl ?? '',
//                   width: 30.w,
//                   height: 30.h,
//                   errorWidget: (context, url, error) => const SizedBox(),
//                 ),
//               ),
//             ),
//           ] else ...{
//             SizedBox(width: 8.w),
//             Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: SizedBox(width: 30.w, height: 30.h),
//             ),
//           },
//         ],
//       ),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/controllers/seller/message/message_controller.dart';
import 'package:ready_ecommerce/controllers/seller/pusher/pusher_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/messages.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/shop.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/product.dart';

import 'package:ready_ecommerce/models/eCommerce/shop_message_model/user.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/dashboard/my_message/components/product_card_widget.dart';

import '../../../../../config/app_color.dart';
import '../../../../../gen/assets.gen.dart';

class SellerMyChatLayout extends ConsumerStatefulWidget {
  final User user;
  const SellerMyChatLayout({super.key, required this.user});

  @override
  ConsumerState<SellerMyChatLayout> createState() => _MyChatLayoutState();
}

class _MyChatLayoutState extends ConsumerState<SellerMyChatLayout> {
  final TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool isBlocked=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pusherControllerProvider.notifier).init();
      ref
          .read(getMessageControllerProvider.notifier)
          .getMessage(userId: widget.user.id ?? 0, isInitial: true);
      _scrollToBottom();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        ref
            .read(getMessageControllerProvider.notifier)
            .getMessage(userId: widget.user.id ?? 0);
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- 2. Handle Delete Chat ---
  Future<void> _handleDeleteChat() async {

    // final response = await ref
    //     .read(getShopsControllerProvider.notifier)
    //     .deleteChat(widget.shop.id ?? 0);
    //
    // if (mounted) {
    //   if (response.isSuccess) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text(response.message), backgroundColor: Colors.green),
    //     );
    //     Navigator.pop(context); // Redirect to previous page
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text(response.message), backgroundColor: Colors.red),
    //     );
    //   }
    // }
  }

  // --- 3. Handle Block/Unblock Logic ---
  Future<void> _handleBlockToggle() async {
    // // Optimistic UI Update
    // setState(() {
    //   isBlocked = !isBlocked;
    // });
    //
    // CommonResponse response;
    //
    // // Check new state to decide which API to call
    // if (isBlocked) {
    //   response = await ref
    //       .read(getShopsControllerProvider.notifier)
    //       .blockSeller(widget.shop.id ?? 0);
    // } else {
    //   response = await ref
    //       .read(getShopsControllerProvider.notifier)
    //       .unblockSeller(widget.shop.id ?? 0);
    // }
    //
    // if (mounted) {
    //   if (response.isSuccess) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text(response.message), backgroundColor: Colors.green),
    //     );
    //   } else {
    //     // Revert UI if API fails
    //     setState(() {
    //       isBlocked = !isBlocked;
    //     });
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text(response.message), backgroundColor: Colors.red),
    //     );
    //   }
    // }
  }

  Widget orangeBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 16.sp,
          color: Colors.black,
        ),
      ),
    );
  }
  Widget _headerAction(String svgPath, String label, double height, double width,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(
              svgPath,
              width: width.w,
              height: height.w,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
          Gap(4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return PopScope(
      onPopInvokedWithResult: (result, t) {
        ref.read(getCustomerControllerProvider.notifier).getCustomer();
        ref.invalidate(getTotalUnreadMessagesControllerProvider);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // appBar: AppBar(
        //   titleSpacing: 0,
        //   surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        //   bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(0),
        //     child: Divider(color: colors(context).accentColor, height: 0.5.h),
        //   ),
        //   title: Row(
        //     children: [
        //       ClipOval(
        //         child: CachedNetworkImage(
        //           fit: BoxFit.cover,
        //           imageUrl: widget.user.profilePhoto ?? '',
        //           width: 40.w,
        //           height: 40.h,
        //           errorWidget: (context, url, error) => const Icon(Icons.person),
        //         ),
        //       ),
        //       SizedBox(width: 10.w),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             widget.user.name ?? '',
        //             style: style.text16B700,
        //           ),
        //           Text(
        //             widget.user.lastOnline == true ? "Active" : "Inactive",
        //             style: style.bodyTextSmall.copyWith(
        //               color: widget.user.lastOnline == true
        //                   ? Colors.green
        //                   : colors(context).bodyTextSmallColor,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        body: ref.watch(getMessageControllerProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                  style: style.bodyText.copyWith(color: colors(context).errorColor),
                ),
              ),
              data: (data) {
                final messages = data ?? [];
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 16.h,
                            bottom: 24.h,
                          ),
                          decoration: BoxDecoration(
                            color: EcommerceAppColor.carrotOrange,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.r),
                              bottomRight: Radius.circular(50.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _headerAction(
                                    Assets.svg.deleteIcon,
                                    'Remove',
                                    16,
                                    16,
                                    onTap: _handleDeleteChat,
                                  ),
                                  Gap(24.w),
                                  _headerAction(
                                    isBlocked ? Assets.svg.block : Assets.svg.block,
                                    isBlocked ? 'Unblock' : 'Block',
                                    20,
                                    20,
                                    onTap: _handleBlockToggle,
                                  ),
                                ],
                              ),
                              Gap(16.h),
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.user.profilePhoto ?? '',
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.person, color: Colors.white),
                                ),
                              ),
                              Gap(8.h),
                              Text(
                                widget.user.name ?? '',
                                style: AppTextStyle(context).title.copyWith(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 12.h,
                          left: 16.w,
                          child: orangeBackButton(context),
                        ),
                      ],
                    ),
                    Gap(30.h),
                    Expanded(
                      child: messages.isEmpty
                          ? Center(
                              child: Text(
                                "No messages yet",
                                style: style.hintText16B400,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 8.h,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final bool isMe = message.type == "shop";
                                bool isFirstOfGroup = true;
                                if (index < messages.length - 1) {
                                  final next = messages[index + 1];
                                  isFirstOfGroup = message.type != next.type;
                                }

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: _buildMessage(
                                    context: context,
                                    isMe: isMe,
                                    text: message.message ?? "",
                                    showAvatar: isFirstOfGroup,
                                    imageUrl: isMe
                                        ? message.shop?.logo ?? ''
                                        : message.user?.profilePhoto,
                                    product: message.product,
                                    dateTime: message.createdAt ?? DateTime.now(),
                                  ),
                                );
                              },
                            ),
                    ),
                    // _buildInputArea(context),
                    /// INPUT FIELD (Always Visible)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      // Check Block status for Input Field
                      child: isBlocked
                          ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "You have blocked this seller.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: messageController,
                                style: style.bodyText,
                                validator: (value) => (value == null || value.isEmpty) ? "Empty" : null,
                                decoration: InputDecoration(
                                  hintText: "Type a message",
                                  hintStyle: style.hintText16B400,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide(color: colors(context).accentColor!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide(color: colors(context).accentColor!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                    borderSide: BorderSide(color: colors(context).primaryColor!),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: colors(context).primaryColor,
                                    ),
                                    onPressed: () => _handleSendMessage(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final style = AppTextStyle(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: colors(context).accentColor!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: messageController,
                style: style.bodyText,
                validator: (value) => (value == null || value.isEmpty) ? "Empty" : null,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: style.hintText16B400,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: colors(context).accentColor!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: colors(context).accentColor!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide(color: colors(context).primaryColor!),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: colors(context).primaryColor,
                    ),
                    onPressed: () => _handleSendMessage(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendMessage() async {
    if (_formKey.currentState!.validate()) {
      final saveUser = await ref.read(sellerHiveServiceProvider).getUserInfo();
      Shop? shop;
      if (saveUser != null) {
        shop = Shop(
          name: saveUser.shop?.name,
          id: saveUser.shop?.id,
          logo: saveUser.shop?.logo,
        );
      }
      final messageText = messageController.text;
      final messageModel = Messages(
        type: "shop",
        message: messageText,
        shop: shop,
      );

      ref.read(getMessageControllerProvider.notifier).addNewMessage(messageModel).then((val) async {
        messageController.clear();
        await ref.read(sendMessageControllerProvider.notifier).sendMessage(
              shopId: widget.user.id ?? 0,
              message: messageText,
            );
      });
    }
  }

  // Widget _buildMessage({
  //   required BuildContext context,
  //   required bool isMe,
  //   String? text,
  //   ProductMessage? product,
  //   required bool showAvatar,
  //   String? imageUrl,
  //   required DateTime dateTime,
  // }) {
  //   final style = AppTextStyle(context);
  //   return Align(
  //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Row(
  //       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (!isMe)
  //           _buildAvatar(imageUrl, showAvatar, isMe)
  //         else
  //           const SizedBox(width: 46), // Padding to offset missing avatar on right
  //
  //         product != null && (text == null || text.isEmpty)
  //             ? ProductMessageCard(product: product)
  //             : Column(
  //                 crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     margin: EdgeInsets.symmetric(vertical: 4.h),
  //                     padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
  //                     constraints: BoxConstraints(maxWidth: 260.w),
  //                     decoration: BoxDecoration(
  //                       color: isMe ? colors(context).primaryColor : colors(context).accentColor,
  //                       borderRadius: BorderRadius.circular(16.r),
  //                     ),
  //                     child: Text(
  //                       text ?? '',
  //                       style: style.bodyText.copyWith(
  //                         color: isMe ? Colors.white : colors(context).bodyTextColor,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(
  //                     GlobalFunction.formatMessageDateTime(dateTime),
  //                     style: style.bodyTextSmall.copyWith(fontSize: 10.sp),
  //                   ),
  //                 ],
  //               ),
  //
  //         if (isMe)
  //           _buildAvatar(imageUrl, showAvatar, isMe)
  //         else
  //           const SizedBox(width: 46),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMessage({
    required BuildContext context,
    required bool isMe,
    String? text,
    ProductMessage? product,
    required bool showAvatar,
    String? imageUrl,
    required DateTime dateTime,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe && showAvatar)
              Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl ?? '',
                    width: 34.w,
                    height: 34.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            product != null && (text == null || text.isEmpty)
                ? ProductMessageCard(product: product)
                :
            Column(
              crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 260.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                    isMe ? Colors.grey.shade200 : const Color(0xFFFFE3CC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.r),
                      topRight: Radius.circular(18.r),
                      bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                      bottomRight: Radius.circular(isMe ? 4.r : 18.r),
                    ),
                  ),
                  child: Text(
                    text ?? '',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Gap(4.h),
                Text(
                  GlobalFunction.formatMessageDateTime(dateTime),
                  style: AppTextStyle(context).bodyText.copyWith(
                    fontSize: 9.sp,
                    color: EcommerceAppColor.gray,
                  ),
                ),
              ],
            ),
            if (isMe && showAvatar)
              Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl ?? '',
                    width: 34.w,
                    height: 34.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? url, bool show, bool isMe) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: SizedBox(
        width: 30.w,
        height: 30.h,
        child: show
            ? ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: url ?? '',
                  errorWidget: (context, url, error) => const Icon(Icons.person, size: 20),
                ),
              )
            : null,
      ),
    );
  }
}