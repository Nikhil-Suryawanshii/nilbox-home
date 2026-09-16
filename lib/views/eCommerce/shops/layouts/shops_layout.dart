// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/eCommerce/shop/shop_controller.dart';
// import 'package:ready_ecommerce/models/eCommerce/shop/shop.dart';
// import 'package:ready_ecommerce/views/eCommerce/shops/components/shop_card.dart';

// import '../../../../components/ecommerce/custom_cart.dart';
// import '../../../../components/ecommerce/custom_search_field.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../../models/eCommerce/common/product_filter_model.dart';
// import '../../../../utils/context_less_navigation.dart';

// class EcommerceShopsLayout extends ConsumerStatefulWidget {
//   const EcommerceShopsLayout({super.key});

//   @override
//   ConsumerState<EcommerceShopsLayout> createState() =>
//       _EcommerceShopsLayoutState();
// }

// class _EcommerceShopsLayoutState extends ConsumerState<EcommerceShopsLayout> {
//   final ScrollController scrollController = ScrollController();
//   final TextEditingController textEditingController = TextEditingController();

//   int page = 1;
//   final int perPage = 20;
//   bool scrollLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (ref.read(shopControllerProvider.notifier).shops.isEmpty) {
//         _fetchShops(isPagination: false);
//       }
//     });
//     scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     textEditingController.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     if (scrollController.offset >= scrollController.position.maxScrollExtent &&
//         ref.read(shopControllerProvider.notifier).shops.length <
//             ref.read(shopControllerProvider.notifier).total! &&
//         !ref.read(shopControllerProvider)) {
//       scrollLoading = true;
//       page++;
//       _fetchShops(isPagination: true);
//     }
//   }

//   void _fetchShops({required bool isPagination}) {
//     ref.read(shopControllerProvider.notifier).getShops(
//           page: page,
//           perPage: perPage,
//           isPagination: isPagination,
//         );
//   }

//   void _showRatingFilterDialog(BuildContext context) {
//     double selectedRating = 0;
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: EdgeInsets.all(20.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Filter by Rating',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Gap(20.h),
//                     ...List.generate(6, (index) {
//                       double rating = index.toDouble();
//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8.h),
//                         child: GestureDetector(
//                           onTap: () {
//                             selectedRating = rating;
//                             setState(() {});
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16.w,
//                               vertical: 12.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: selectedRating == rating
//                                   ? colors(context).primaryColor
//                                   : colors(context)
//                                       .accentColor
//                                       ?.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8.r),
//                               border: selectedRating == rating
//                                   ? Border.all(
//                                       color: colors(context).primaryColor ??
//                                           Colors.blue,
//                                       width: 2,
//                                     )
//                                   : null,
//                             ),
//                             child: Row(
//                               children: [
//                                 ...List.generate(
//                                   5,
//                                   (starIndex) => Icon(
//                                     starIndex < rating
//                                         ? Icons.star
//                                         : Icons.star_outline,
//                                     color: Colors.orange,
//                                     size: 18.sp,
//                                   ),
//                                 ),
//                                 Gap(8.w),
//                                 Text(
//                                   rating == 0
//                                       ? 'All Ratings'
//                                       : '${rating.toInt()} Star${rating.toInt() > 1 ? 's' : ''}',
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     fontWeight: selectedRating == rating
//                                         ? FontWeight.bold
//                                         : FontWeight.normal,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                     Gap(20.h),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               selectedRating = 0;
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   colors(context).accentColor?.withOpacity(0.2),
//                             ),
//                             child: Text(
//                               'Clear',
//                               style: TextStyle(
//                                 color: colors(context).hintTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Gap(10.w),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               page = 1;
//                               ref
//                                   .read(shopControllerProvider.notifier)
//                                   .getShops(
//                                     page: page,
//                                     perPage: perPage,
//                                     isPagination: false,
//                                   );
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: colors(context).primaryColor,
//                             ),
//                             child: const Text(
//                               'Apply',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildAppBarWidget(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: 40.h,
//       ),
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () {
//               context.nav.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back),
//           ),
//           Gap(20.w),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 38.h,
//                 decoration: BoxDecoration(
//                   color: colors(context).accentColor?.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(29.r)),
//                   child: TextField(
//                     controller: textEditingController,
//                     onChanged: (value) {
//                       page = 1;
//                       ref.read(shopControllerProvider.notifier).getShops(
//                             page: page,
//                             perPage: perPage,
//                             // search: value,
//                             isPagination: false,
//                           );
//                     },
//                     textInputAction: TextInputAction.search,
//                     decoration: InputDecoration(
//                       hintText: 'Search shop',
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: 16.w, vertical: 14.h),
//                       prefixIcon: Icon(
//                         Icons.search,
//                         size: 20.sp,
//                         color: colors(context).hintTextColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Gap(10.w),
//           CustomCartWidget(context: context),
//           Gap(10.w),
//           GestureDetector(
//             onTap: () {
//               _showRatingFilterDialog(context);
//             },
//             child: CircleAvatar(
//               radius: 18.5.r,
//               backgroundColor: colors(context).light,
//               child: SvgPicture.asset(
//                 Assets.svg.homeFilter, //
//                 height: 22.h,
//                 colorFilter: ColorFilter.mode(
//                   // colors(context).hintTextColor!,
//                   Colors.black,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ),
//           ),
//           Gap(10.w),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(100.h),
//         child: _buildAppBarWidget(context),
//       ),
//       backgroundColor: const Color(0xFFFAE8D8),
//       body: AnimationLimiter(
//         child: Consumer(
//           builder: (context, ref, child) {
//             final shopProvider = ref.watch(shopControllerProvider);
//             final shops = ref.watch(shopControllerProvider.notifier).shops;

//             if (shopProvider && !scrollLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             return RefreshIndicator(
//               onRefresh: () async {
//                 page = 1;
//                 _fetchShops(isPagination: false);
//               },
//               child: GridView.builder(
//                 controller: scrollController,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12.w,
//                   mainAxisSpacing: 12.h,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: shops.length,
//                 itemBuilder: (context, index) {
//                   final Shop shop = shops[index];
//                   return AnimationConfiguration.staggeredGrid(
//                     position: index,
//                     duration: const Duration(milliseconds: 375),
//                     columnCount: 2,
//                     child: ScaleAnimation(
//                       child: FadeInAnimation(
//                         child: ShopCard(shop: shop),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/shop/shop_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/shop/shop.dart';
import 'package:ready_ecommerce/views/eCommerce/shops/components/shop_card.dart';

import '../../../../components/ecommerce/custom_cart.dart';
import '../../../../components/ecommerce/custom_search_field.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../models/eCommerce/common/product_filter_model.dart';
import '../../../../utils/context_less_navigation.dart';

// class EcommerceShopsLayout extends ConsumerStatefulWidget {
//   const EcommerceShopsLayout({super.key});
//
//   @override
//   ConsumerState<EcommerceShopsLayout> createState() =>
//       _EcommerceShopsLayoutState();
// }
//
// class _EcommerceShopsLayoutState extends ConsumerState<EcommerceShopsLayout> {
//   final ScrollController scrollController = ScrollController();
//   final TextEditingController textEditingController = TextEditingController();
//
//   int page = 1;
//   final int perPage = 20;
//   bool scrollLoading = false;
//
//   // Filter state variables
//   double selectedRating = 0;
//   String searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (ref.read(shopControllerProvider.notifier).shops.isEmpty) {
//         _fetchShops(isPagination: false);
//       }
//     });
//     scrollController.addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     textEditingController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     if (scrollController.offset >= scrollController.position.maxScrollExtent &&
//         ref.read(shopControllerProvider.notifier).shops.length <
//             ref.read(shopControllerProvider.notifier).total! &&
//         !ref.read(shopControllerProvider)) {
//       scrollLoading = true;
//       page++;
//       _fetchShops(isPagination: true);
//     }
//   }
//
//   void _fetchShops({required bool isPagination}) {
//     ref.read(shopControllerProvider.notifier).getShops(
//           page: page,
//           perPage: perPage,
//           isPagination: isPagination,
//         );
//   }
//
//   // Internal filtering logic
//   List<Shop> _getFilteredShops(List<Shop> allShops) {
//     List<Shop> filtered = allShops;
//
//     // Filter by search query
//     if (searchQuery.isNotEmpty) {
//       filtered = filtered.where((shop) {
//         return shop.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
//             false;
//       }).toList();
//     }
//
//     // Filter by rating
//     if (selectedRating > 0) {
//       filtered = filtered.where((shop) {
//         // Assuming shop has a rating field (adjust based on your Shop model)
//         // If rating is stored differently, adjust accordingly
//         final shopRating = shop.rating ?? 0;
//         return shopRating >= selectedRating &&
//             shopRating < (selectedRating + 1);
//       }).toList();
//     }
//
//     return filtered;
//   }
//
//   void _showRatingFilterDialog(BuildContext context) {
//     double tempSelectedRating = selectedRating;
//
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               padding: EdgeInsets.all(20.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Text(
//                     //   'Filter by Ratsng',
//                     //   style: TextStyle(
//                     //     fontSize: 18.sp,
//                     //     fontWeight: FontWeight.bold,
//                     //   ),
//                     // ),
//                     // Gap(20.h),
//                     ...List.generate(6, (index) {
//                       double rating = index.toDouble();
//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8.h),
//                         child: GestureDetector(
//                           onTap: () {
//                             tempSelectedRating = rating;
//                             setModalState(() {});
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16.w,
//                               vertical: 12.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: tempSelectedRating == rating
//                                   ? colors(context).primaryColor
//                                   : colors(context)
//                                       .accentColor
//                                       ?.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8.r),
//                               border: tempSelectedRating == rating
//                                   ? Border.all(
//                                       color: colors(context).primaryColor ??
//                                           Colors.blue,
//                                       width: 2,
//                                     )
//                                   : null,
//                             ),
//                             child: Row(
//                               children: [
//                                 ...List.generate(
//                                   5,
//                                   (starIndex) => Icon(
//                                     starIndex < rating
//                                         ? Icons.star
//                                         : Icons.star_outline,
//                                     color: Colors.orange,
//                                     size: 18.sp,
//                                   ),
//                                 ),
//                                 Gap(8.w),
//                                 Text(
//                                   rating == 0
//                                       ? 'All Ratings'
//                                       : '${rating.toInt()} Star${rating.toInt() > 1 ? 's' : ''}',
//                                   style: TextStyle(
//                                     fontSize: 14.sp,
//                                     fontWeight: tempSelectedRating == rating
//                                         ? FontWeight.bold
//                                         : FontWeight.normal,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                     // Gap(20.h),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedRating = 0;
//                               });
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   colors(context).accentColor?.withOpacity(0.2),
//                             ),
//                             child: Text(
//                               'Clear',
//                               style: TextStyle(
//                                 color: colors(context).hintTextColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Gap(10.w),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedRating = tempSelectedRating;
//                               });
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: colors(context).primaryColor,
//                             ),
//                             child: const Text(
//                               'Apply',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   PreferredSizeWidget _buildAppBarWidget(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(50.h),
//       child: SafeArea(
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius:
//                 BorderRadius.circular(10.r), // Rounded corners (Pill shape)
//             // Optional: Add a subtle shadow if you want it to pop
//             // boxShadow: [
//             //   BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
//             // ]
//           ),
//           // color: Theme.of(context).scaffoldBackgroundColor,
//           child: Row(
//             children: [
//               // IconButton(
//               //   onPressed: () {
//               //     context.nav.pop(context);
//               //   },
//               //   icon: const Icon(Icons.arrow_back),
//               // ),
//               // Gap(20.w),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
//                   child: Container(
//                     height: 38.h,
//                     decoration: BoxDecoration(
//                       color: colors(context).accentColor?.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(30.r),
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(29.r)),
//                       // padding: EdgeInsets.only(top: 10),
//                       child: TextField(
//                         controller: textEditingController,
//                         onChanged: (value) {
//                           setState(() {
//                             searchQuery = value;
//                           });
//                         },
//                         textInputAction: TextInputAction.search,
//                         decoration: InputDecoration(
//                           hintText: 'Search',
//                           hintStyle: TextStyle(fontSize: 15),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(top: 0),
//                           prefixIcon: Icon(
//                             Icons.search,
//                             size: 20.sp,
//                             color: colors(context).hintTextColor,
//                           ),
//                           suffixIcon: searchQuery.isNotEmpty
//                               ? IconButton(
//                                   icon: Icon(
//                                     Icons.clear,
//                                     size: 20.sp,
//                                     color: colors(context).hintTextColor,
//                                   ),
//                                   onPressed: () {
//                                     textEditingController.clear();
//                                     setState(() {
//                                       searchQuery = '';
//                                     });
//                                   },
//                                 )
//                               : null,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(10.w),
//               CustomCartWidget(context: context),
//               Gap(10.w),
//               GestureDetector(
//                 onTap: () {
//                   _showRatingFilterDialog(context);
//                 },
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 18.5.r,
//                       backgroundColor: selectedRating > 0
//                           ? colors(context).primaryColor?.withOpacity(0.2)
//                           : colors(context).light,
//                       child: SvgPicture.asset(
//                         Assets.svg.homeFilter,
//                         height: 22.h,
//                         colorFilter: ColorFilter.mode(
//                           selectedRating > 0
//                               ? colors(context).primaryColor ?? Colors.blue
//                               : Colors.black,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                     if (selectedRating > 0)
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         child: Container(
//                           padding: EdgeInsets.all(4.w),
//                           decoration: BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle,
//                           ),
//                           constraints: BoxConstraints(
//                             minWidth: 16.w,
//                             minHeight: 16.h,
//                           ),
//                           child: Center(
//                             child: Text(
//                               '${selectedRating.toInt()}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               Gap(10.w),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   // PreferredSizeWidget _buildAppBar({
//   //   required BuildContext context,
//   //   required List<HiveCartModel> cartItems,
//   //   required bool isRoot,
//   //   required bool isBuynow,
//   // }) {
//   //   return PreferredSize(
//   //     // Increase height slightly to account for the pill shape and margins
//   //     preferredSize: Size.fromHeight(46.h),
//   //     child: SafeArea(
//   //       child: Container(
//   //         // Margins create the "floating" effect
//   //         margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
//   //         decoration: BoxDecoration(
//   //           color: Colors.white,
//   //           borderRadius: BorderRadius.circular(10.r), // Rounded corners (Pill shape)
//   //           // Optional: Add a subtle shadow if you want it to pop
//   //           // boxShadow: [
//   //           //   BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
//   //           // ]
//   //         ),
//   //         child: AppBar(
//   //           backgroundColor: Colors.transparent, // Transparent so Container color shows
//   //           elevation: 0,
//   //           scrolledUnderElevation: 0, // Prevents color change on scroll
//   //           primary: false, // We are already handling SafeArea
//   //
//   //           leading: isBuynow && !isRoot
//   //               ? IconButton(
//   //             onPressed: () {
//   //               ref.invalidate(cartController);
//   //               Navigator.of(context).pop();
//   //             },
//   //             icon: const Icon(Icons.arrow_back, color: Colors.black),
//   //           )
//   //               : null,
//   //           title: Text(
//   //             S.of(context).myCart,
//   //             style: AppTextStyle(context).appBarText.copyWith(
//   //                 fontSize: 15.sp,
//   //                 fontWeight: FontWeight.w700,
//   //                 color: Colors.black
//   //             ),
//   //           ),
//   //           centerTitle: true,
//   //
//   //           // Use ClipRRect or shape to ensure ripples don't overflow the rounded corners
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(30.r),
//   //           ),
//   //
//   //           actions: [
//   //             Visibility(
//   //               visible: checkMultivendor(),
//   //               child: Row(
//   //                 children: [
//   //                   Text(
//   //                     S.of(context).all,
//   //                     style: AppTextStyle(context).bodyText.copyWith(
//   //                       fontSize: 13.sp,
//   //                       fontWeight: FontWeight.w700,
//   //                       color: Colors.black,
//   //                     ),
//   //                   ),
//   //                   Transform.scale(
//   //                     scale: 0.9,
//   //                     child: Checkbox(
//   //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//   //                       // Circular Checkbox
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(50.r),
//   //                       ),
//   //                       side: BorderSide(color: colors(context).primaryColor ?? Colors.orange, width: 2),
//   //                       activeColor: colors(context).primaryColor, // Should be Orange
//   //                       value: ref.watch(shopIdsProvider).length ==
//   //                           ref.watch(cartController).cartItems.length,
//   //                       onChanged: (v) {
//   //                         ref.read(shopIdsProvider.notifier).toogleAllShopId();
//   //                         ref.read(cartSummeryController.notifier).calculateCartSummery(
//   //                           couponCode: promoCodeController.text,
//   //                           shopIds: ref.read(shopIdsProvider).toList(),
//   //                         );
//   //                       },
//   //                     ),
//   //                   ),
//   //                   Gap(12.w)
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBarWidget(context),
//       backgroundColor: const Color(0xFFFAE8D8),
//       body: AnimationLimiter(
//         child: Consumer(
//           builder: (context, ref, child) {
//             final shopProvider = ref.watch(shopControllerProvider);
//             final allShops = ref.watch(shopControllerProvider.notifier).shops;
//
//             // Apply internal filtering
//             final filteredShops = _getFilteredShops(allShops);
//
//             if (shopProvider && !scrollLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (filteredShops.isEmpty && !shopProvider) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.search_off,
//                       size: 64.sp,
//                       color: colors(context).hintTextColor,
//                     ),
//                     Gap(16.h),
//                     Text(
//                       'No shops found',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         color: colors(context).hintTextColor,
//                       ),
//                     ),
//                     if (selectedRating > 0 || searchQuery.isNotEmpty) ...[
//                       Gap(8.h),
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             selectedRating = 0;
//                             searchQuery = '';
//                             textEditingController.clear();
//                           });
//                         },
//                         child: Text('Clear filters'),
//                       ),
//                     ],
//                   ],
//                 ),
//               );
//             }
//
//             return RefreshIndicator(
//               onRefresh: () async {
//                 page = 1;
//                 _fetchShops(isPagination: false);
//               },
//               child:
//               // SizedBox(
//               //   // height: MediaQuery.of(context).size.height / 1.31,
//               //   // height: MediaQuery.of(context).size.height *1.21,
//               //   child: MasonryGridView.count(
//               //     padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 10),
//               //     // padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
//               //     crossAxisCount: 2,
//               //     controller: scrollController,
//               //     mainAxisSpacing: .1.h,
//               //     crossAxisSpacing: 15.w,
//               //     // physics: const NeverScrollableScrollPhysics(),
//               //     itemCount: filteredShops.length,
//               //     shrinkWrap: true,
//               //     itemBuilder: (context, index) {
//               //
//               //       final Shop shop = filteredShops[index];
//               //       return AnimationConfiguration.staggeredGrid(
//               //         duration: const Duration(milliseconds: 375),
//               //         position: index,
//               //         columnCount: 2,
//               //         child: ScaleAnimation(
//               //           child:  Padding(
//               //             // THE TRICK: Add top padding ONLY to the second item (index 1).
//               //             // This pushes the entire right column down by 40 pixels.
//               //             padding: EdgeInsets.only(top: index == 1 ? 0 : 31.h,bottom: 0),
//               //             child:  ShopCard(shop: shop),
//               //           ),
//               //         ),
//               //       );
//               //     },
//               //   ),
//               // ),
//               GridView.builder(
//                 controller: scrollController,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12.w,
//                   mainAxisSpacing: 12.h,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: filteredShops.length,
//                 itemBuilder: (context, index) {
//                   final Shop shop = filteredShops[index];
//                   return AnimationConfiguration.staggeredGrid(
//                     position: index,
//                     duration: const Duration(milliseconds: 375),
//                     columnCount: 2,
//                     child: ScaleAnimation(
//                       child: FadeInAnimation(
//                         child: ShopCard(shop: shop),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// ✅ OPTIMIZED VERSION (SAFE)

class EcommerceShopsLayout extends ConsumerStatefulWidget {
  const EcommerceShopsLayout({super.key});

  @override
  ConsumerState<EcommerceShopsLayout> createState() =>
      _EcommerceShopsLayoutState();
}

class _EcommerceShopsLayoutState extends ConsumerState<EcommerceShopsLayout> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  int page = 1;
  final int perPage = 20;
  bool scrollLoading = false;

  double selectedRating = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // ✅ CRASH FIX

      final controller = ref.read(shopControllerProvider.notifier);

      if (controller.shops.isEmpty) {
        _fetchShops(isPagination: false);
      }
    });

    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final controller = ref.read(shopControllerProvider.notifier);
    final isLoading = ref.read(shopControllerProvider);

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100 &&
        controller.shops.length < (controller.total ?? 0) &&
        !isLoading &&
        !scrollLoading) {
      scrollLoading = true;
      page++;
      _fetchShops(isPagination: true);
    }
  }

   _fetchShops({required bool isPagination}) async {
    await ref.read(shopControllerProvider.notifier).getShops(
      page: page,
      perPage: perPage,
      isPagination: isPagination,
    );

    scrollLoading = false; // ✅ reset safely
  }

  // ✅ OPTIMIZED FILTER (single pass)
  List<Shop> _getFilteredShops(List<Shop> shops) {
    if (searchQuery.isEmpty && selectedRating == 0) return shops;

    return shops.where((shop) {
      final matchesSearch = searchQuery.isEmpty ||
          (shop.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false);

      final rating = shop.rating ?? 0;
      final matchesRating = selectedRating == 0 ||
          (rating >= selectedRating && rating < selectedRating + 1);

      return matchesSearch && matchesRating;
    }).toList();
  }

  PreferredSizeWidget _buildAppBarWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.h),
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                  child: TextField(
                    controller: textEditingController,
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          textEditingController.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                          : null,
                    ),
                  ),
                ),
              ),
              CustomCartWidget(context: context),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showRatingFilterDialog(context),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: selectedRating > 0
                      ? colors(context).primaryColor?.withOpacity(0.2)
                      : colors(context).light,
                  child: SvgPicture.asset(
                    Assets.svg.homeFilter,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingFilterDialog(BuildContext context) {
    double tempRating = selectedRating;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(6, (index) {
                  final rating = index.toDouble();
                  return ListTile(
                    title: Text(
                        rating == 0 ? "All Ratings" : "$rating Star"),
                    onTap: () {
                      tempRating = rating;
                      setModalState(() {});
                    },
                  );
                })
                  ..add(Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedRating = 0);
                            Navigator.pop(context);
                          },
                          child: const Text("Clear"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedRating = tempRating);
                            Navigator.pop(context);
                          },
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  )),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(shopControllerProvider);
    final controller = ref.watch(shopControllerProvider.notifier);

    final shops = controller.shops;
    final filteredShops = _getFilteredShops(shops);

    if (isLoading && shops.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBarWidget(context),
      backgroundColor: const Color(0xFFFAE8D8),
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          await _fetchShops(isPagination: false);
        },
        child: GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredShops.length,
          itemBuilder: (_, index) {
            return ShopCard(shop: filteredShops[index]);
          },
        ),
      ),
    );
  }
}