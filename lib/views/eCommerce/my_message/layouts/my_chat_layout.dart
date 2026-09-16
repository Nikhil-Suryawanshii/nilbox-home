import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/message/message_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/pusher/pusher_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/messages.dart';
import 'package:ready_ecommerce/models/eCommerce/message_model/user.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/product.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/shop.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/my_message/components/product_card_widget.dart';

import '../../../../models/eCommerce/common/common_response.dart';

// class MyChatLayout extends ConsumerStatefulWidget {
//   final Shop shop;
//   const MyChatLayout({super.key, required this.shop});
//
//   @override
//   ConsumerState<MyChatLayout> createState() => _MyChatLayoutState();
// }
// class _MyChatLayoutState extends ConsumerState<MyChatLayout> {
//   final TextEditingController messageController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(pusherControllerProvider.notifier).init();
//       ref
//           .read(getMessageControllerProvider.notifier)
//           .getMessage(shopId: widget.shop.id ?? 0, isInitial: true);
//       _scrollToBottom();
//     });
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 20) {
//         ref.read(getMessageControllerProvider.notifier).getMessage(
//           shopId: widget.shop.id ?? 0,
//         );
//       }
//     });
//   }
//
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ref.watch(getMessageControllerProvider).when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, _) => Center(child: Text(error.toString())),
//         data: (messages) {
//           return Column(
//             children: [
//               /// 🔶 ORANGE HEADER
//               Stack(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).padding.top + 16.h,
//                       bottom: 24.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: EcommerceAppColor.carrotOrange,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(50.r),
//                         bottomRight: Radius.circular(50.r),
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             _headerAction(Assets.svg.deleteIcon, 'Remove',16,16),
//                             Gap(24.w),
//                             _headerAction(Assets.svg.block, 'Block',20,20),
//                           ],
//                         ),
//                         Gap(16.h),
//                         ClipOval(
//                           child: CachedNetworkImage(
//                             imageUrl: widget.shop.logo ?? '',
//                             width: 60.w,
//                             height: 60.w,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Gap(8.h),
//                         Text(
//                           widget.shop.name ?? '',
//                           style: AppTextStyle(context).title.copyWith(
//                             color: Colors.white,
//                             fontSize: 15.sp,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     top: MediaQuery.of(context).padding.top + 12.h,
//                     left: 16.w,
//                     child: orangeBackButton(context),
//                   ),
//                 ],
//               ),
//               Gap(30.h),
//               /// WHITE CHAT BODY
//               Expanded(
//                 child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(50.r),
//                         topRight: Radius.circular(50.r),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08), // soft shadow
//                           blurRadius: 15,
//                           offset: const Offset(0, -4), // shadow upwards
//                         ),
//                       ],
//                     ),
//
//                     child: Column(children: [
//                       Gap(8.h),
//
//                       /// DRAG INDICATOR
//                       Container(
//                         width: 40.w,
//                         height: 4.h,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(10.r),
//                         ),
//                       ),
//
//                       Gap(8.h),
//
//                       /// MESSAGES
//                       Expanded(
//                         child: messages == null || messages.isEmpty
//                             ? const Center(
//                           child: Text(
//                             "No messages yet",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         )
//                             : ListView.builder(
//                           controller: _scrollController,
//                           reverse: true,
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 4.w,
//                             vertical: 8.h,
//                           ),
//                           itemCount: messages.length,
//                           itemBuilder: (context, index) {
//                             final message = messages[index];
//                             final bool isMe = message.type == "user";
//
//                             bool showAvatar = true;
//                             if (index < messages.length - 1) {
//                               final next = messages[index + 1];
//                               showAvatar = message.type != next.type;
//                             }
//
//                             return _buildMessage(
//                               isMe: isMe,
//                               text: message.message ?? "",
//                               product: message.product,
//                               showAvatar: showAvatar,
//                               imageUrl: isMe
//                                   ? message.user?.profilePhoto ?? ''
//                                   : message.shop?.logo,
//                               dateTime:
//                               message.createdAt ?? DateTime.now(),
//                             );
//                           },
//                         ),
//                       ),
//                     ])),
//               ),
//
//               /// INPUT FIELD
//               Container(
//                 padding:
//                 EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     top: BorderSide(color: Colors.grey.shade300),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Form(
//                         key: _formKey,
//                         child: TextFormField(
//                           controller: messageController,
//                           validator: (value) =>
//                           value == null || value.isEmpty
//                               ? "Value cannot be empty"
//                               : null,
//                           decoration: InputDecoration(
//                             hintText: "Type a message",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(25.r),
//                               borderSide:
//                               BorderSide(color: Colors.grey.shade300),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(25.r),
//                               borderSide:
//                               BorderSide(color: Colors.grey.shade300),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(25.r),
//                               borderSide: BorderSide(
//                                 color: colors(context).primaryColor!,
//                               ),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16.w,
//                               vertical: 10.h,
//                             ),
//                             suffixIcon: IconButton(
//                               icon: SvgPicture.asset(
//                                 Assets.svg.sendRight,
//                               ),
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   final messageText =
//                                       messageController.text;
//
//                                   messageController.clear();
//
//                                   await ref
//                                       .read(sendMessageControllerProvider
//                                       .notifier)
//                                       .sendMessage(
//                                     shopId: widget.shop.id ?? 0,
//                                     message: messageText,
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget orangeBackButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context),
//       child: CircleAvatar(
//         radius: 18.r,
//         backgroundColor: Colors.white,
//         child: Icon(
//           Icons.arrow_back_ios_new,
//           size: 16.sp,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
//
//
//   /// 🔹 MESSAGE BUBBLE UI
//   Widget _buildMessage({
//     required bool isMe,
//     String? text,
//     ProductMessage? product,
//     required bool showAvatar,
//     String? imageUrl,
//     required DateTime dateTime,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
//       child: Align(
//         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Row(
//           mainAxisAlignment:
//           isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (!isMe && showAvatar)
//               Padding(
//                 padding: EdgeInsets.only(right: 6.w),
//                 child: ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl ?? '',
//                     width: 34.w,
//                     height: 34.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             Column(
//               crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   constraints: BoxConstraints(maxWidth: 260.w),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 10.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color:
//                     isMe ? Colors.grey.shade200 : const Color(0xFFFFE3CC),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(18.r),
//                       topRight: Radius.circular(18.r),
//                       bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
//                       bottomRight: Radius.circular(isMe ? 4.r : 18.r),
//                     ),
//                   ),
//                   child: Text(
//                     text ?? '',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 Gap(4.h),
//                 Text(
//                   GlobalFunction.formatMessageDateTime(dateTime),
//                   style: AppTextStyle(context).bodyText.copyWith(
//                     fontSize: 9.sp,
//                     color: EcommerceAppColor.gray,
//                   ),
//                 ),
//               ],
//             ),
//             if (isMe && showAvatar)
//               Padding(
//                 padding: EdgeInsets.only(left: 6.w),
//                 child: ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl ?? '',
//                     width: 34.w,
//                     height: 34.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _headerAction(String svgPath, String label,double height,double width) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 18,
//           backgroundColor: Colors.white,
//           child: SvgPicture.asset(
//             svgPath,
//             width: width.w,
//             height: height.w,
//             colorFilter: const ColorFilter.mode(
//               Colors.black,
//               BlendMode.srcIn,
//             ),
//           ),
//         ),
//         Gap(4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 11.sp,
//           ),
//         ),
//       ],
//     );
//   }
//
// }
///
class MyChatLayout extends ConsumerStatefulWidget {
  final Shop shop;
  const MyChatLayout({super.key, required this.shop});

  @override
  ConsumerState<MyChatLayout> createState() => _MyChatLayoutState();
}

class _MyChatLayoutState extends ConsumerState<MyChatLayout> {
  final TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // 1. Local variable to track block state
  bool isBlocked=false;

  @override
  void initState() {
    super.initState();

    // Initialize block status from the passed shop object
    // Ensure your Shop model has an 'isBlocked' or 'is_blocked' field
    // isBlocked =  false;
    // isBlocked = widget.shop.isBlocked ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(pusherControllerProvider.notifier).init(); // Uncomment if you have this
      ref
          .read(getMessageControllerProvider.notifier)
          .getMessage(shopId: widget.shop.id ?? 0, isInitial: true);
      _scrollToBottom();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        ref.read(getMessageControllerProvider.notifier).getMessage(
          shopId: widget.shop.id ?? 0,
        );
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

    final response = await ref
        .read(getShopsControllerProvider.notifier)
        .deleteChat(widget.shop.id ?? 0);

    if (mounted) {
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Redirect to previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- 3. Handle Block/Unblock Logic ---
  Future<void> _handleBlockToggle() async {
    // Optimistic UI Update
    setState(() {
      isBlocked = !isBlocked;
    });

    CommonResponse response;

    // Check new state to decide which API to call
    if (isBlocked) {
      response = await ref
          .read(getShopsControllerProvider.notifier)
          .blockSeller(widget.shop.id ?? 0);
    } else {
      response = await ref
          .read(getShopsControllerProvider.notifier)
          .unblockSeller(widget.shop.id ?? 0);
    }

    if (mounted) {
      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message), backgroundColor: Colors.green),
        );
      } else {
        // Revert UI if API fails
        setState(() {
          isBlocked = !isBlocked;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: ref.watch(getMessageControllerProvider).when(
  //       loading: () => const Center(child: CircularProgressIndicator()),
  //       error: (error, _) => Center(child: Text(error.toString())),
  //       data: (messages) {
  //         return Column(
  //           children: [
  //             /// 🔶 ORANGE HEADER
  //             Stack(
  //               children: [
  //                 Container(
  //                   width: double.infinity,
  //                   padding: EdgeInsets.only(
  //                     top: MediaQuery.of(context).padding.top + 16.h,
  //                     bottom: 24.h,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: EcommerceAppColor.carrotOrange,
  //                     borderRadius: BorderRadius.only(
  //                       bottomLeft: Radius.circular(50.r),
  //                       bottomRight: Radius.circular(50.r),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           // --- REMOVE BUTTON ---
  //                           _headerAction(
  //                             Assets.svg.deleteIcon,
  //                             'Remove',
  //                             16,
  //                             16,
  //                             onTap: _handleDeleteChat,
  //                           ),
  //                           Gap(24.w),
  //                           // --- BLOCK / UNBLOCK BUTTON ---
  //                           _headerAction(
  //                             // You might want an 'unlock' icon for the unblocked state
  //                             isBlocked ? Assets.svg.block : Assets.svg.block,
  //                             isBlocked ? 'Unblock' : 'Block', // Text changes dynamically
  //                             20,
  //                             20,
  //                             onTap: _handleBlockToggle,
  //                           ),
  //                         ],
  //                       ),
  //                       Gap(16.h),
  //                       ClipOval(
  //                         child: CachedNetworkImage(
  //                           imageUrl: widget.shop.logo ?? '',
  //                           width: 60.w,
  //                           height: 60.w,
  //                           fit: BoxFit.cover,
  //                           errorWidget: (context, url, error) =>
  //                           const Icon(Icons.person, color: Colors.white),
  //                         ),
  //                       ),
  //                       Gap(8.h),
  //                       Text(
  //                         widget.shop.name ?? '',
  //                         style: AppTextStyle(context).title.copyWith(
  //                           color: Colors.white,
  //                           fontSize: 15.sp,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: MediaQuery.of(context).padding.top + 12.h,
  //                   left: 16.w,
  //                   child: orangeBackButton(context),
  //                 ),
  //               ],
  //             ),
  //             Gap(30.h),
  //
  //             /// WHITE CHAT BODY
  //             Expanded(
  //               child: Container(
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(50.r),
  //                       topRight: Radius.circular(50.r),
  //                     ),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.08),
  //                         blurRadius: 15,
  //                         offset: const Offset(0, -4),
  //                       ),
  //                     ],
  //                   ),
  //                   child: Column(children: [
  //                     Gap(8.h),
  //
  //                     /// DRAG INDICATOR
  //                     Container(
  //                       width: 40.w,
  //                       height: 4.h,
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey.shade300,
  //                         borderRadius: BorderRadius.circular(10.r),
  //                       ),
  //                     ),
  //
  //                     Gap(8.h),
  //
  //                     /// MESSAGES
  //                     Expanded(
  //                       child: messages == null || messages.isEmpty
  //                           ? const Center(
  //                         child: Text(
  //                           "No messages yet",
  //                           style: TextStyle(color: Colors.grey),
  //                         ),
  //                       )
  //                           : ListView.builder(
  //                         controller: _scrollController,
  //                         reverse: true,
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 4.w,
  //                           vertical: 8.h,
  //                         ),
  //                         itemCount: messages.length,
  //                         itemBuilder: (context, index) {
  //                           final message = messages[index];
  //                           final bool isMe = message.type == "user";
  //
  //                           bool showAvatar = true;
  //                           if (index < messages.length - 1) {
  //                             final next = messages[index + 1];
  //                             showAvatar = message.type != next.type;
  //                           }
  //
  //                           return _buildMessage(
  //                             isMe: isMe,
  //                             text: message.message ?? "",
  //                             product: message.product,
  //                             showAvatar: showAvatar,
  //                             imageUrl: isMe
  //                                 ? message.user?.profilePhoto ?? ''
  //                                 : message.shop?.logo,
  //                             dateTime:
  //                             message.createdAt ?? DateTime.now(),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ])),
  //             ),
  //
  //             /// INPUT FIELD
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
  //               decoration: BoxDecoration(
  //                 border: Border(
  //                   top: BorderSide(color: Colors.grey.shade300),
  //                 ),
  //               ),
  //               // 4. Check Block status for Input Field
  //               child: isBlocked
  //                   ? Container(
  //                 width: double.infinity,
  //                 padding: EdgeInsets.all(12),
  //                 child: Text(
  //                   "You have blocked this seller.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 14.sp,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               )
  //                   : Row(
  //                 children: [
  //                   Expanded(
  //                     child: Form(
  //                       key: _formKey,
  //                       child: TextFormField(
  //                         controller: messageController,
  //                         validator: (value) =>
  //                         value == null || value.isEmpty
  //                             ? "Value cannot be empty"
  //                             : null,
  //                         decoration: InputDecoration(
  //                           hintText: "Type a message",
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(25.r),
  //                             borderSide:
  //                             BorderSide(color: Colors.grey.shade300),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(25.r),
  //                             borderSide:
  //                             BorderSide(color: Colors.grey.shade300),
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(25.r),
  //                             borderSide: BorderSide(
  //                               color: colors(context).primaryColor!,
  //                             ),
  //                           ),
  //                           contentPadding: EdgeInsets.symmetric(
  //                             horizontal: 16.w,
  //                             vertical: 10.h,
  //                           ),
  //                           // suffixIcon: IconButton(
  //                           //   icon: SvgPicture.asset(
  //                           //     Assets.svg.sendRight,
  //                           //   ),
  //                           //   onPressed: () async {
  //                           //     if (_formKey.currentState!.validate()) {
  //                           //       final messageText =
  //                           //           messageController.text;
  //                           //
  //                           //       messageController.clear();
  //                           //
  //                           //       await ref
  //                           //           .read(sendMessageControllerProvider
  //                           //           .notifier)
  //                           //           .sendMessage(
  //                           //         shopId: widget.shop.id ?? 0,
  //                           //         message: messageText,
  //                           //       );
  //                           //     }
  //                           //   },
  //                           // ),
  //                           suffixIcon: IconButton(
  //                             icon: SvgPicture.asset(
  //                               Assets.svg.sendRight,
  //                             ),
  //                             onPressed: () async {
  //                               if (_formKey.currentState!.validate()) {
  //                                 final messageText = messageController.text;
  //
  //                                 // 1. Clear input immediately
  //                                 messageController.clear();
  //
  //                                 // 2. OPTIMISTIC UPDATE: Add message to list IMMEDIATELY
  //                                 // Create a temporary message object to show on screen right now
  //                                 final tempMessage = Messages(
  //                                   message: messageText,
  //                                   type: "user", // It's from the user
  //                                   createdAt: DateTime.now(),
  //                                   // Add other fields if required by your model, e.g., userId
  //                                 );
  //
  //                                 // Use the method already in your controller to update the UI instantly
  //                                 ref.read(getMessageControllerProvider.notifier).addNewMessage(tempMessage);
  //
  //                                 // Scroll to bottom to see the new message
  //                                 _scrollToBottom();
  //
  //                                 // 3. Send to Server (Background)
  //                                 final response = await ref
  //                                     .read(sendMessageControllerProvider.notifier)
  //                                     .sendMessage(
  //                                   shopId: widget.shop.id ?? 0,
  //                                   message: messageText,
  //                                 );
  //
  //                                 // 4. Handle Failure (Optional)
  //                                 // If server fails, you might want to show an error or remove the message
  //                                 if (!response.isSuccess) {
  //                                   ScaffoldMessenger.of(context).showSnackBar(
  //                                     SnackBar(content: Text("Failed to send message"), backgroundColor: Colors.red),
  //                                   );
  //                                 }
  //                               }
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // We watch the provider here just to trigger rebuilds if needed,
    // OR better yet, we handle the async state specifically inside the list area.
    final messageState = ref.watch(getMessageControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. REMOVED the top-level .when(). The Column is now the direct body.
      body: Column(
        children: [
          /// 🔶 ORANGE HEADER (Always Visible)
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
                        imageUrl: widget.shop.logo ?? '',
                        width: 60.w,
                        height: 60.w,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      widget.shop.name ?? '',
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

          /// WHITE CHAT BODY (Contains the State Logic)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Gap(8.h),

                  /// DRAG INDICATOR
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Gap(8.h),

                  /// 2. APPLY STATE LOGIC ONLY HERE
                  /// If loading/error happens, it only affects this middle section
                  Expanded(
                    child: messageState.when(
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      // 3. ERROR STATE: Show error but keep layout intact
                      error: (error, _) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Could not load history",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(getMessageControllerProvider.notifier)
                                    .getMessage(
                                    shopId: widget.shop.id ?? 0,
                                    isInitial: true);
                              },
                              child: Text("Retry"),
                            )
                          ],
                        ),
                      ),
                      data: (messages) {
                        return messages == null || messages.isEmpty
                            ? const Center(
                          child: Text(
                            "No messages yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                            : ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 8.h,
                          ),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final bool isMe = message.type == "user";

                            bool showAvatar = true;
                            if (index < messages.length - 1) {
                              final next = messages[index + 1];
                              showAvatar = message.type != next.type;
                            }

                            return _buildMessage(
                              isMe: isMe,
                              text: message.message ?? "",
                              product: message.product,
                              showAvatar: showAvatar,
                              imageUrl: isMe
                                  ? message.user?.profilePhoto ?? ''
                                  : message.shop?.logo,
                              dateTime:
                              message.createdAt ?? DateTime.now(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

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
                      validator: (value) => value == null || value.isEmpty
                          ? "Value cannot be empty"
                          : null,
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide:
                          BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide:
                          BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide(
                            color: colors(context).primaryColor!,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            Assets.svg.sendRight,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final messageText = messageController.text;

                              // 1. Clear input immediately
                              messageController.clear();

                              // 2. OPTIMISTIC UPDATE
                              final tempMessage = Messages(
                                message: messageText,
                                type: "user",
                                createdAt: DateTime.now(),
                              );

                              ref
                                  .read(getMessageControllerProvider
                                  .notifier)
                                  .addNewMessage(tempMessage);

                              _scrollToBottom();

                              // 3. Send to Server (Background)
                              final response = await ref
                                  .read(sendMessageControllerProvider
                                  .notifier)
                                  .sendMessage(
                                shopId: widget.shop.id ?? 0,
                                message: messageText,
                              );

                              if (!response.isSuccess) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                      content:
                                      Text("Failed to send message"),
                                      backgroundColor: Colors.red),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
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

  /// 🔹 MESSAGE BUBBLE UI
  Widget _buildMessage({
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

  // 5. Updated Header Action to accept onTap
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
}
// class _MyChatLayoutState extends ConsumerState<MyChatLayout> {
//   final TextEditingController messageController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(pusherControllerProvider.notifier).init();
//       ref
//           .read(getMessageControllerProvider.notifier)
//           .getMessage(shopId: widget.shop.id ?? 0, isInitial: true);
//       _scrollToBottom();
//     });
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 20) {
//         ref.read(getMessageControllerProvider.notifier).getMessage(
//               shopId: widget.shop.id ?? 0,
//             );
//       }
//     });
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.minScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return PopScope(
//       onPopInvokedWithResult: (result, t) {
//         ref.read(getShopsControllerProvider.notifier).getShops();
//       },
//       child: Scaffold(
//         backgroundColor: isDark ? Colors.black : Colors.white,
//         // appBar: AppBar(
//         //   titleSpacing: 0,
//         //   surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//         //   bottom: PreferredSize(
//         //     preferredSize: Size.fromHeight(0),
//         //     child: Divider(
//         //       color: Colors.grey.shade100,
//         //       height: 0.5.h,
//         //     ),
//         //   ),
//         //   title: Row(
//         //     children: [
//         //       ClipOval(
//         //         child: CachedNetworkImage(
//         //             fit: BoxFit.cover,
//         //             imageUrl: widget.shop.logo ?? '',
//         //             width: 40.w,
//         //             height: 40.h),
//         //       ),
//         //       SizedBox(width: 10.w),
//         //       Column(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           Text(widget.shop.name ?? '',
//         //               style: AppTextStyle(context).title.copyWith(
//         //                   fontSize: 16.sp,
//         //                   color: colors(context).headingColor)),
//         //           Text(widget.shop.lastOnline == true ? "Active" : "Inactive",
//         //               style: AppTextStyle(context).bodyText.copyWith(
//         //                   fontSize: 12.sp,
//         //                   color: widget.shop.lastOnline == true
//         //                       ? Colors.green
//         //                       : Colors.grey)),
//         //         ],
//         //       ),
//         //     ],
//         //   ),
//         // ),
//         body: ref.watch(getMessageControllerProvider).when(
//             loading: () => Center(
//                   child: CircularProgressIndicator(),
//                 ),
//             error: (error, stackTrace) => Center(
//                   child: Text(
//                     error.toString(),
//
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//             data: (data) {
//               // _scrollToBottom();
//               final messages = data ?? [];
//               return Column(
//                 children: [
//
//                   // Messages
//                   Expanded(
//                     child: messages.isEmpty
//                         ? Center(
//                             child: Text(
//                               "No messages yet",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           )
//                         : ListView.builder(
//                             controller: _scrollController,
//                             reverse: true,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 2.w, vertical: 8.h),
//                             itemCount: messages.length,
//                             itemBuilder: (context, index) {
//                               final message = messages[index];
//                               final bool isMe = message.type == "user";
//                               bool isFirstOfGroup = true;
//                               if (index < messages.length - 1) {
//                                 final next = messages[index + 1];
//                                 isFirstOfGroup = message.type != next.type;
//                               }
//                               debugPrint(
//                                   "product: ${message.product?.toJson()}");
//
//                               return Padding(
//                                 padding: EdgeInsets.only(bottom: 8.0.h),
//                                 child: _buildMessage(
//                                   isMe: isMe,
//                                   text: message.message ?? "",
//                                   showAvatar: isFirstOfGroup,
//                                   imageUrl: isMe
//                                       ? message.user?.profilePhoto ?? ''
//                                       : message.shop?.logo,
//                                   product: message.product,
//                                   dateTime: message.createdAt ?? DateTime.now(),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//
//                   // Input Field
//                   Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                     decoration: BoxDecoration(
//                       border:
//                           Border(top: BorderSide(color: Colors.grey.shade300)),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Form(
//                             key: _formKey,
//                             child: TextFormField(
//                               controller: messageController,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return "Value cannot be empty";
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                 hintText: "Type a message",
//                                 hintStyle: TextStyle(fontSize: 14.sp),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.r),
//                                   borderSide: BorderSide(color: Colors.red),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.r),
//                                   borderSide:
//                                       BorderSide(color: Colors.grey.shade300),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.r),
//                                   borderSide: BorderSide(
//                                       color: colors(context).primaryColor!),
//                                 ),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 16.w, vertical: 10.h),
//                                 suffixIcon:
//                                     //  ref
//                                     //         .watch(sendMessageControllerProvider)
//                                     //     ? SizedBox(
//                                     //         width: 20.w,
//                                     //         height: 20.h,
//                                     //         child: Padding(
//                                     //           padding: const EdgeInsets.all(8.0),
//                                     //           child: CircularProgressIndicator(),
//                                     //         ))
//                                     //     :
//                                     IconButton(
//                                   icon: SvgPicture.asset(
//                                     Assets.svg.sendRight,
//                                     // width: 20.w,
//                                     // height: 20.h,
//                                   ),
//                                   onPressed: () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       final saveUser = await ref
//                                           .read(hiveServiceProvider)
//                                           .getUserInfo();
//                                       UserMessage? users;
//                                       if (saveUser != null) {
//                                         users = UserMessage(
//                                           name: saveUser.name,
//                                           id: saveUser.id,
//                                           profilePhoto: saveUser.profilePhoto,
//                                         );
//                                       }
//                                       final messageText =
//                                           messageController.text;
//                                       final messageModel = Messages(
//                                           type: "user",
//                                           message: messageController.text,
//                                           user: users);
//                                       ref
//                                           .read(getMessageControllerProvider
//                                               .notifier)
//                                           .addNewMessage(messageModel)
//                                           .then((val) async {
//                                         messageController.clear();
//                                         await ref
//                                             .read(sendMessageControllerProvider
//                                                 .notifier)
//                                             .sendMessage(
//                                               shopId: widget.shop.id ?? 0,
//                                               message: messageText,
//                                             );
//                                       });
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//
//             }),
//       ),
//     );
//   }
//
//
//   Widget _buildMessage({
//     required bool isMe,
//     String? text,
//     ProductMessage? product,
//     required bool showAvatar,
//     String? imageUrl,
//     required DateTime dateTime,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 20),
//       child: Align(
//         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Row(
//           mainAxisAlignment:
//           isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             /// LEFT AVATAR (Receiver)
//             if (!isMe && showAvatar)
//               Padding(
//                 padding: EdgeInsets.only(left: 16.w, right: 8.w),
//                 child: ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl ?? '',
//                     width: 34.w,
//                     height: 34.w,
//                     fit: BoxFit.cover,
//                     errorWidget: (_, __, ___) => const SizedBox(),
//                   ),
//                 ),
//               ),
//
//             /// MESSAGE / PRODUCT
//             product != null && (text == null || text.isEmpty)
//                 ? ProductMessageCard(product: product)
//                 : Column(
//               crossAxisAlignment:
//               isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   constraints: BoxConstraints(maxWidth: 260.w),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 10.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isMe
//                         ? Colors.grey.shade200
//                         : const Color(0xFFFFE3CC), // peach bubble
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(18.r),
//                       topRight: Radius.circular(18.r),
//                       bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
//                       bottomRight: Radius.circular(isMe ? 4.r : 18.r),
//                     ),
//                   ),
//                   child: Text(
//                     text ?? '',
//                     style: TextStyle(
//                       color: Colors.black87,
//                       fontSize: 13.sp,
//                     ),
//                   ),
//                 ),
//                 // Gap(4.h),
//                 Text(
//                   GlobalFunction.formatMessageDateTime(dateTime),
//                   style: AppTextStyle(context).bodyText.copyWith(
//                     fontSize: 9.sp,
//                     color: EcommerceAppColor.gray,
//                   ),
//                 ),
//               ],
//             ),
//
//             /// RIGHT AVATAR (Sender)
//             if (isMe && showAvatar)
//               Padding(
//                 padding: EdgeInsets.only(left: 8.w, right: 16.w),
//                 child: ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: imageUrl ?? '',
//                     width: 34.w,
//                     height: 34.w,
//                     fit: BoxFit.cover,
//                     errorWidget: (_, __, ___) => const SizedBox(),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }

