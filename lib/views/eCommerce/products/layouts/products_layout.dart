import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_cart.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
import 'package:ready_ecommerce/components/ecommerce/product_not_found.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/category/category.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/product_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/filter_modal_bottom_sheet.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/list_product_card.dart';

import '../../home/components/popular_product_card.dart';

final isListProvider = StateProvider<bool>((ref) => true);

class EcommerceProductsLayout extends ConsumerStatefulWidget {
  final int? categoryId;
  final String? sortType;
  final String categoryName;
  final int? subCategoryId;
  final String? shopName;
  final List<SubCategory>? subCategories;

  const EcommerceProductsLayout({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.sortType,
    this.subCategoryId,
    this.shopName,
    this.subCategories,
  });

  @override
  ConsumerState<EcommerceProductsLayout> createState() =>
      _EcommerceProductsLayoutState();
}

// class _EcommerceProductsLayoutState
//     extends ConsumerState<EcommerceProductsLayout> {
//   final ScrollController scrollController = ScrollController();
//   final ScrollController productScrollController = ScrollController();
//   final TextEditingController searchController = TextEditingController();
//
//   bool isHeaderVisible = true;
//   // bool isList = true;
//   int page = 1;
//   int perPage = 20;
//   List<FilterCategory> filterCategoryList = [
//     FilterCategory(id: 0, name: 'All')
//   ];
//   double scrollPossition = 0.0;
//   bool isLastPosition = false;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.watch(productControllerProvider.notifier).products.clear();
//       _setselectedSubCategory(id: widget.subCategoryId ?? 0).then((_) {
//         _fetchProducts(isPagination: false);
//       });
//     });
//     _setSubCotegory(subCategories: widget.subCategories ?? []);
//
//     scrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() {
//     debugPrint("listener");
//     if (scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent) {
//       setState(() {
//         isLastPosition = true;
//         scrollPossition = scrollController.position.pixels;
//       });
//       print('Call fetch more products');
//       _fetchMoreProducts();
//     }
//   }
//
//   void _fetchProducts({required bool isPagination}) {
//     ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
//           productFilterModel: ProductFilterModel(
//             categoryId: widget.categoryId,
//             page: page,
//             perPage: perPage,
//             search: searchController.text,
//             sortType: widget.sortType,
//             subCategoryId: ref.watch(selectedSubCategory) != 0
//                 ? ref.watch(selectedSubCategory)
//                 : null,
//           ),
//           isPagination: isPagination,
//         );
//   }
//
//   void _fetchMoreProducts() {
//     final productNotifier = ref.read(productControllerProvider.notifier);
//     if (productNotifier.products.length < productNotifier.total! &&
//         !ref.watch(productControllerProvider)) {
//       page++;
//       _fetchProducts(isPagination: true);
//     }
//   }
//
//   void _setSubCotegory({required List<SubCategory> subCategories}) {
//     for (SubCategory category in subCategories) {
//       filterCategoryList.add(
//         FilterCategory(id: category.id, name: category.name),
//       );
//     }
//   }
//
//   Future<void> _setselectedSubCategory({required int id}) {
//     ref.read(selectedSubCategory.notifier).state = id;
//     return Future.value();
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("isList ${ref.watch(isListProvider)}");
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//         statusBarColor: GlobalFunction.getContainerColor()));
//     return SafeArea(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(0),
//           child: AppBar(
//             elevation: 0,
//             automaticallyImplyLeading: false,
//           ),
//         ),
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor ==
//                 const Color.fromARGB(255, 1, 1, 2)
//             ? colors(context).dark
//             : colors(context).accentColor,
//         body: NestedScrollView(
//           floatHeaderSlivers: false,
//           physics: NeverScrollableScrollPhysics(),
//           headerSliverBuilder: (context, value) {
//             return [
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     _customHeaderAppBarWidget(),
//                   ],
//                 ),
//               ),
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _SliverAppBarDelegate(
//                   maxExtentS: widget.subCategories!.isNotEmpty ? 110.h : 60.h,
//                   child: _buildFilterRow(context),
//                 ),
//               )
//             ];
//           },
//           body: _buildProductsWidget(context),
//         ),
//       ),
//     );
//   }
//
//   Widget _customHeaderAppBarWidget() {
//     return _buildHeaderRow(context);
//   }
//
//   Widget _buildHeaderRow(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(right: 16.w, bottom: 20.h),
//       color: GlobalFunction.getContainerColor(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildLeftRow(context),
//           _buildRightRow(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLeftRow(BuildContext context) {
//     return Expanded(
//       child: Row(
//         children: [
//           IconButton(
//             visualDensity: VisualDensity.compact,
//             onPressed: () => context.nav.pop(context),
//             icon: Icon(Icons.arrow_back, size: 26.sp),
//           ),
//           Gap(16.w),
//           Expanded(
//             child: Text(
//               widget.shopName ?? widget.categoryName,
//               overflow: TextOverflow.ellipsis,
//               style: AppTextStyle(context).subTitle,
//             ),
//           ),
//           Gap(4.w),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRightRow(BuildContext context) {
//     return Row(
//       children: [
//         CustomCartWidget(context: context),
//         Gap(16.w),
//         GestureDetector(
//           onTap: () => _showFilterModal(context),
//           child: SvgPicture.asset(Assets.svg.filter, width: 40.sp),
//         ),
//       ],
//     );
//   }
//
//   void _showFilterModal(BuildContext context) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       backgroundColor: GlobalFunction.getContainerColor(),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12.r),
//           topRight: Radius.circular(12.r),
//         ),
//       ),
//       context: context,
//       builder: (_) => FilterModalBottomSheet(
//         productFilterModel: ProductFilterModel(
//           page: 1,
//           perPage: 20,
//           categoryId: widget.categoryId,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilterRow(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       color: GlobalFunction.getContainerColor(),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Flexible(
//                 flex: 5,
//                 fit: FlexFit.tight,
//                 child: CustomSearchField(
//                   name: 'searchProduct',
//                   hintText: S.of(context).searchProduct,
//                   textInputType: TextInputType.text,
//                   controller: searchController,
//                   onChanged: (value) {
//                     page = 1;
//                     _fetchProducts(isPagination: false);
//                   },
//                   widget: Container(
//                     margin: EdgeInsets.all(10.sp),
//                     child: SvgPicture.asset(Assets.svg.searchHome),
//                   ),
//                 ),
//               ),
//               Gap(20.w),
//               Consumer(
//                 builder: (context, ref, child) {
//                   final isList = ref.watch(isListProvider);
//                   return GestureDetector(
//                     onTap: () =>
//                         ref.read(isListProvider.notifier).state = !isList,
//                     child: SvgPicture.asset(
//                         // isList ? Assets.svg.grid : Assets.svg.list,
//                         !isList ? Assets.svg.grid : Assets.svg.list,
//                         width: 26.w),
//                   );
//                 },
//               ),
//             ],
//           ),
//           Gap(8.h),
//           Visibility(
//               visible: widget.sortType != null,
//               child: Divider(
//                   color: colors(context).accentColor, height: 2, thickness: 2)),
//           Visibility(
//             visible:
//                 widget.sortType == null && widget.subCategories!.isNotEmpty,
//             child: _buildFilterListWidget(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterListWidget() {
//     return Consumer(builder: (context, ref, _) {
//       return Container(
//         margin: EdgeInsets.only(top: 8.h),
//         height: 35.h,
//         color: GlobalFunction.getContainerColor(),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: filterCategoryList.length,
//           itemBuilder: (context, index) {
//             debugPrint("selected category1 ${ref.watch(selectedSubCategory)}");
//             debugPrint(
//                 "selected category2 ${ref.watch(selectedSubCategory) == filterCategoryList[index].id}");
//             final isSelected =
//                 ref.watch(selectedSubCategory) == filterCategoryList[index].id;
//
//             debugPrint("isSelected $isSelected");
//
//             return GestureDetector(
//               onTap: () {
//                 if (searchController.text.isNotEmpty) {
//                   searchController.clear();
//                 }
//                 page = 1;
//                 if (ref.watch(selectedSubCategory.notifier).state !=
//                     filterCategoryList[index].id) {
//                   debugPrint(
//                       "selected category3 ${filterCategoryList[index].id}");
//
//                   _setselectedSubCategory(id: filterCategoryList[index].id!)
//                       .then((_) {
//                     _fetchProducts(isPagination: false);
//                   });
//                 }
//               },
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 5.w),
//                 padding: EdgeInsets.symmetric(horizontal: 10.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.r),
//                   border: Border.all(
//                       color: isSelected
//                           ? colors(context).primaryColor!
//                           : colors(context).accentColor!),
//                 ),
//                 child: Center(
//                   child: Text(filterCategoryList[index].name,
//                       style: AppTextStyle(context).bodyTextSmall),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }
//   // Widget _buildFilterListWidget() {
//   //   return Consumer(builder: (context, ref, _) {
//   //     return Container(
//   //       height: 90.h,
//   //       color: GlobalFunction.getContainerColor(),
//   //       child: ListView.builder(
//   //         scrollDirection: Axis.horizontal,
//   //         padding: EdgeInsets.symmetric(horizontal: 12.w),
//   //         itemCount: filterCategoryList.length,
//   //         itemBuilder: (context, index) {
//   //           final category = filterCategoryList[index];
//   //           final isSelected =
//   //               ref.watch(selectedSubCategory) == category.id;
//   //
//   //           /// 🔑 FIND REAL SUBCATEGORY IMAGE
//   //           final subCategoryImage = widget.subCategories
//   //               ?.firstWhere(
//   //                 (e) => e.id == category.id,
//   //             orElse: () => SubCategory(id: 0, name: '', thumbnail: ''),
//   //           )
//   //               .thumbnail;
//   //
//   //           return GestureDetector(
//   //             onTap: () {
//   //               if (searchController.text.isNotEmpty) {
//   //                 searchController.clear();
//   //               }
//   //               page = 1;
//   //
//   //               if (ref.read(selectedSubCategory.notifier).state !=
//   //                   category.id) {
//   //                 _setselectedSubCategory(id: category.id!)
//   //                     .then((_) => _fetchProducts(isPagination: false));
//   //               }
//   //             },
//   //             child: Padding(
//   //               padding: EdgeInsets.only(right: 16.w),
//   //               child: Column(
//   //                 children: [
//   //                   /// 🟣 IMAGE CIRCLE
//   //                   Container(
//   //                     padding: EdgeInsets.all(3.w),
//   //                     decoration: BoxDecoration(
//   //                       shape: BoxShape.circle,
//   //                       border: Border.all(
//   //                         color: isSelected
//   //                             ? colors(context).primaryColor!
//   //                             : Colors.grey.shade300,
//   //                         width: 2,
//   //                       ),
//   //                     ),
//   //                     child: Container(
//   //                       width: 52.w,
//   //                       height: 52.w,
//   //                       decoration: BoxDecoration(
//   //                         shape: BoxShape.circle,
//   //                         color: _pastelColor(index),
//   //                       ),
//   //                       child: ClipOval(
//   //                         child: subCategoryImage != null &&
//   //                             subCategoryImage.isNotEmpty
//   //                             ? Image.network(
//   //                           subCategoryImage,
//   //                           fit: BoxFit.cover,
//   //                         )
//   //                             : Icon(
//   //                           Icons.category,
//   //                           size: 22.sp,
//   //                           color: Colors.grey,
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //
//   //                   Gap(8.h),
//   //
//   //                   /// 📝 NAME
//   //                   SizedBox(
//   //                     width: 70.w,
//   //                     child: Text(
//   //                       category.name,
//   //                       textAlign: TextAlign.center,
//   //                       maxLines: 1,
//   //                       overflow: TextOverflow.ellipsis,
//   //                       style: AppTextStyle(context).bodyTextSmall.copyWith(
//   //                         fontWeight:
//   //                         isSelected ? FontWeight.w600 : FontWeight.w400,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           );
//   //         },
//   //       ),
//   //     );
//   //   });
//   // }
//
//   Color _pastelColor(int index) {
//     final colors = [
//       const Color(0xFFF3E5F5), // lavender
//       const Color(0xFFE3F2FD), // light blue
//       const Color(0xFFEDE7F6), // soft purple
//       const Color(0xFFFCE4EC), // pink
//       const Color(0xFFFFF3E0), // peach
//     ];
//     return colors[index % colors.length];
//   }
//
//   Widget _buildProductsWidget(BuildContext context) {
//     final productController = ref.watch(productControllerProvider.notifier);
//     final products = productController.products;
//
//     if (ref.watch(productControllerProvider)) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     if (products.isEmpty) {
//       return const ProductNotFoundWidget();
//     }
//
//     return ref.watch(isListProvider)
//         ? _buildListProductsWidget(context)
//         : _buildGridProductsWidget(context);
//   }
//
//   Widget _buildListProductsWidget(BuildContext context) {
//     final products = ref.watch(productControllerProvider.notifier).products;
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 500),
//       child: AnimationLimiter(
//         child: ListView.builder(
//           controller: scrollController,
//           // physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: EdgeInsets.symmetric(vertical: 10.h),
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             if (isLastPosition && scrollController.hasClients) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 scrollController.jumpTo(scrollPossition);
//                 setState(() {
//                   isLastPosition = false;
//                 });
//               });
//             }
//             final product = products[index];
//             return AnimationConfiguration.staggeredList(
//               position: index,
//               duration: const Duration(milliseconds: 500),
//               child: SlideAnimation(
//                 verticalOffset: 50.0,
//                 child: FadeInAnimation(
//                   child: ListProductCard(
//                     product: product,
//                     onTap: () => context.nav.pushNamed(
//                       Routes.getProductDetailsRouteName(
//                           AppConstants.appServiceName),
//                       arguments: product.id,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGridProductsWidget(BuildContext context) {
//     final products = ref.watch(productControllerProvider.notifier).products;
//
//     return AnimationLimiter(
//       child:
//       // GridView.builder(
//       //   controller: scrollController,
//       //
//       //   // physics: NeverScrollableScrollPhysics(),
//       //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//       //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       //     crossAxisCount: 2,
//       //     crossAxisSpacing: 16.w,
//       //     mainAxisSpacing: 16.h,
//       //     childAspectRatio: 0.66,
//       //   ),
//       //   itemCount: products.length,
//       //   itemBuilder: (context, index) {
//       //     if (isLastPosition && scrollController.hasClients) {
//       //       WidgetsBinding.instance.addPostFrameCallback((_) {
//       //         scrollController.jumpTo(scrollPossition);
//       //         setState(() {
//       //           isLastPosition = false;
//       //         });
//       //       });
//       //     }
//       //     final product = products[index];
//       //     return AnimationConfiguration.staggeredGrid(
//       //       duration: const Duration(milliseconds: 375),
//       //       position: index,
//       //       columnCount: 2,
//       //       child: ScaleAnimation(
//       //         child: ProductCard(
//       //           product: product,
//       //           onTap: () => context.nav.pushNamed(
//       //             Routes.getProductDetailsRouteName(
//       //                 AppConstants.appServiceName),
//       //             arguments: product.id,
//       //           ),
//       //         ),
//       //       ),
//       //     );
//       //   },
//       // ),
//       SizedBox(
//         // height: MediaQuery.of(context).size.height / 1.31,
//         // height: MediaQuery.of(context).size.height *1.21,
//         child: MasonryGridView.count(
//           padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 10),
//           // padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
//           crossAxisCount: 2,
//           controller: scrollController,
//           mainAxisSpacing: 20.h,
//           crossAxisSpacing: 15.w,
//           // physics: const NeverScrollableScrollPhysics(),
//           itemCount: products.length,
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             if (isLastPosition && scrollController.hasClients) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 scrollController.jumpTo(scrollPossition);
//                 setState(() {
//                   isLastPosition = false;
//                 });
//               });
//             }
//             final product = products[index];
//             return AnimationConfiguration.staggeredGrid(
//               duration: const Duration(milliseconds: 375),
//               position: index,
//               columnCount: 2,
//               child: ScaleAnimation(
//                 child:  Padding(
//                   // THE TRICK: Add top padding ONLY to the second item (index 1).
//                   // This pushes the entire right column down by 40 pixels.
//                   // padding: EdgeInsets.only(top: index == 1 ? 0 : 31.h,bottom: 0),
//                   padding: EdgeInsets.only(top: index == 1 ? 31.h : 0.h,bottom: 0),
//                   child:  ProductCard(
//                     product: product,
//                     onTap: () => context.nav.pushNamed(
//                       Routes.getProductDetailsRouteName(
//                           AppConstants.appServiceName),
//                       arguments: products[index].id,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   final selectedSubCategory = StateProvider<int>((value) => 0);
// }
//
// class FilterCategory {
//   final int? id;
//   final String name;
//
//   FilterCategory({this.id, required this.name});
// }
//
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     required this.child,
//     this.maxExtentS = 80.0,
//   });
//
//   final Widget child;
//   final double maxExtentS;
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }
//
//   @override
//   double get maxExtent => maxExtentS;
//
//   @override
//   double get minExtent => maxExtentS;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
///
class _EcommerceProductsLayoutState
    extends ConsumerState<EcommerceProductsLayout> {
  static const Color _pageBackground = Color(0xFFF5F5F5);
  static const Color _headerBackground = Colors.white;

  final ScrollController scrollController = ScrollController();
  final ScrollController productScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool isHeaderVisible = true;
  // bool isList = true;
  int page = 1;
  int perPage = 20;
  List<FilterCategory> filterCategoryList = [
    FilterCategory(id: 0, name: 'All')
  ];
  double scrollPossition = 0.0;
  bool isLastPosition = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(productControllerProvider.notifier).products.clear();
      _setselectedSubCategory(id: widget.subCategoryId ?? 0).then((_) {
        _fetchProducts(isPagination: false);
      });
    });
    _setSubCotegory(subCategories: widget.subCategories ?? []);

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    debugPrint("listener");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLastPosition = true;
        scrollPossition = scrollController.position.pixels;
      });
      print('Call fetch more products');
      _fetchMoreProducts();
    }
  }

  void _fetchProducts({required bool isPagination}) {
    ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
      productFilterModel: ProductFilterModel(
        categoryId: widget.categoryId,
        page: page,
        perPage: perPage,
        search: searchController.text,
        sortType: widget.sortType,
        subCategoryId: ref.watch(selectedSubCategory) != 0
            ? ref.watch(selectedSubCategory)
            : null,
      ),
      isPagination: isPagination,
    );
  }

  void _fetchMoreProducts() {
    final productNotifier = ref.read(productControllerProvider.notifier);
    if (productNotifier.products.length < productNotifier.total! &&
        !ref.watch(productControllerProvider).isLoading) {
      page++;
      _fetchProducts(isPagination: true);
    }
  }

  void _setSubCotegory({required List<SubCategory> subCategories}) {
    for (SubCategory category in subCategories) {
      filterCategoryList.add(
        FilterCategory(id: category.id, name: category.name),
      );
    }
  }

  Future<void> _setselectedSubCategory({required int id}) {
    ref.read(selectedSubCategory.notifier).state = id;
    return Future.value();
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSubCategories = widget.subCategories?.isNotEmpty ?? false;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: _pageBackground,
        body: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: _buildHeaderRow(context),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  maxExtentS: hasSubCategories ? 185.h : 72.h,
                  child: _buildFilterRow(context),
                ),
              ),
            ];
          },
          body: _buildProductsWidget(context),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, topInset + 8.h, 16.w, 12.h),
      color: _headerBackground,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftRow(context),
          // _buildRightRow(context),
        ],
      ),
    );
  }

  Widget _buildLeftRow(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          // IconButton(
          //   visualDensity: VisualDensity.compact,
          //   onPressed: () => context.nav.pop(context),
          //   icon: Icon(Icons.arrow_back, size: 26.sp),
          // ),
          CircleAvatar(
            radius: 19.r,
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
          Gap(16.w),
          Expanded(
            child: Text(
              widget.shopName ?? widget.categoryName,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context).subTitle,
            ),
          ),
          Gap(4.w),
        ],
      ),
    );
  }

  Widget _buildRightRow(BuildContext context) {
    return Row(
      children: [
        CustomCartWidget(context: context),
        // Gap(16.w),
        Gap(5.w),
        GestureDetector(
          onTap: () => _showFilterModal(context),
          child: SvgPicture.asset(Assets.svg.filter, width: 38.sp),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: GlobalFunction.getContainerColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      context: context,
      builder: (_) => FilterModalBottomSheet(
        productFilterModel: ProductFilterModel(
          page: 1,
          perPage: 20,
          categoryId: widget.categoryId,
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      color: _headerBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(

              children: [
                SizedBox(
                  height: 44,
                  width: MediaQuery.of(context).size.width*0.695,
                  child: CustomSearchField(
                    name: 'searchProduct',
                    hintText: S.of(context).searchProduct,
                    textInputType: TextInputType.text,
                    controller: searchController,
                    onChanged: (value) {
                      page = 1;
                      _fetchProducts(isPagination: false);
                    },
                    widget: Container(
                      // height: 5,
                      // width: 5,
                      // color: Colors.red,
                      margin: EdgeInsets.all(10.sp),
                      child: SvgPicture.asset(Assets.svg.searchHome,
                        // width: 18.w,
                        // height: 18.h,
                      ),
                    ),
                  ),
                ),
                Gap(5.w),
                // Consumer(
                //   builder: (context, ref, child) {
                //     final isList = ref.watch(isListProvider);
                //     return GestureDetector(
                //       onTap: () =>
                //       ref.read(isListProvider.notifier).state = !isList,
                //       child: SvgPicture.asset(
                //           !isList ? Assets.svg.grid : Assets.svg.list,
                //           width: 26.w),
                //     );
                //   },
                // ),
                _buildRightRow(context),
              ],
            ),
          ),
          // Gap(8.h),
          // Visibility(
          //     visible: widget.sortType != null,
          //     child: Divider(
          //         color: colors(context).accentColor, height: 2, thickness: 2)),

          Visibility(
            visible: widget.sortType == null && widget.subCategories!.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 8.h),
                  child: Text(
                    "Categories",
                    style: AppTextStyle(context).subTitle.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _buildFilterListWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterListWidget() {
    return Consumer(builder: (context, ref, _) {
      return Container(
        height: 90.h,
        color: _headerBackground,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemCount: filterCategoryList.length,
          itemBuilder: (context, index) {
            final category = filterCategoryList[index];
            final isSelected =
                ref.watch(selectedSubCategory) == category.id;

            final subCategoryImage = widget.subCategories
                ?.firstWhere(
                  (e) => e.id == category.id,
              orElse: () => SubCategory(id: 0, name: '', thumbnail: '',displayOrder: 0),
            )
                .thumbnail;

            return GestureDetector(
              onTap: () {
                if (searchController.text.isNotEmpty) {
                  searchController.clear();
                }
                page = 1;

                if (ref.read(selectedSubCategory.notifier).state !=
                    category.id) {
                  _setselectedSubCategory(id: category.id!)
                      .then((_) => _fetchProducts(isPagination: false));
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? colors(context).primaryColor!
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _pastelColor(index),
                        ),
                        child: ClipOval(
                          child: subCategoryImage != null &&
                              subCategoryImage.isNotEmpty
                              ? Image.network(
                            subCategoryImage,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.category,
                            size: 22.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    Gap(8.h),

                    SizedBox(
                      width: 70.w,
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Color _pastelColor(int index) {
    final colors = [
      const Color(0xFFF3E5F5), // lavender
      const Color(0xFFE3F2FD), // light blue
      const Color(0xFFEDE7F6), // soft purple
      const Color(0xFFFCE4EC), // pink
      const Color(0xFFFFF3E0), // peach
    ];
    return colors[index % colors.length];
  }

  Widget _buildProductsWidget(BuildContext context) {
    final productsState = ref.watch(productControllerProvider);
    final products = productsState.valueOrNull ?? [];

    if (productsState.isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return const ProductNotFoundWidget();
    }

    return _buildGridProductsWidget(context, products);
  }

  Widget _buildListProductsWidget(BuildContext context) {
    final products = ref.watch(productControllerProvider.notifier).products;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: AnimationLimiter(
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: products.length,
          itemBuilder: (context, index) {
            if (isLastPosition && scrollController.hasClients) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                scrollController.jumpTo(scrollPossition);
                setState(() {
                  isLastPosition = false;
                });
              });
            }
            final product = products[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListProductCard(
                    product: product,
                    onTap: () => context.nav.pushNamed(
                      Routes.getProductDetailsRouteName(
                          AppConstants.appServiceName),
                      arguments: product.id,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridProductsWidget(
    BuildContext context,
    List<Product> products,
  ) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, bottomInset + 20.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.52,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (isLastPosition && scrollController.hasClients) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollController.jumpTo(scrollPossition);
                    setState(() {
                      isLastPosition = false;
                    });
                  });
                }

                final product = products[index];
                return ProductCard(
                  product: product,
                  index: index,
                  onTap: () => context.nav.pushNamed(
                    Routes.getProductDetailsRouteName(
                      AppConstants.appServiceName,
                    ),
                    arguments: product.id,
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  final selectedSubCategory = StateProvider<int>((value) => 0);
}

class FilterCategory {
  final int? id;
  final String name;

  FilterCategory({this.id, required this.name});
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.child,
    this.maxExtentS = 80.0,
  });

  final Widget child;
  final double maxExtentS;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxExtentS;

  @override
  double get minExtent => maxExtentS;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}