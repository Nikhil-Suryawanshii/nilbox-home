import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/category/category_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/flash_sales/flash_sales_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/category/category.dart';
import 'package:ready_ecommerce/models/eCommerce/order/order_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart'
    as product;
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/categories/components/sub_categories_bottom_sheet.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/components/address_modal_bottom_sheet.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/category_card.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/popular_product_card.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/product_card.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/shop_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/layouts/product_details_layout.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../components/ecommerce/custom_cart.dart';
import '../../../../components/ecommerce/custom_search_field.dart';
import '../../../../controllers/common/master_controller.dart';
import '../../../../controllers/eCommerce/dashboard/dashboard_controller.dart';
import '../../../../controllers/eCommerce/product/product_controller.dart';
import '../../../../models/eCommerce/common/product_filter_model.dart';
import '../../../../models/eCommerce/shop/shop.dart';
import '../../../seller/dashboard/seller_dashboard_wrapper.dart';
import '../../more/more_view.dart';
import '../components/banner_widget.dart';
import '../components/home_collapsing_header.dart';
import 'package:badges/badges.dart' as badges;

import '../components/category_pill.dart';
import '../components/category_filter_tab.dart';


class EcommerceHomeViewLayout extends ConsumerStatefulWidget {
  const EcommerceHomeViewLayout({super.key});

  @override
  ConsumerState<EcommerceHomeViewLayout> createState() =>
      _EcommerceHomeViewLayoutState();
}

class _EcommerceHomeViewLayoutState
    extends ConsumerState<EcommerceHomeViewLayout>with AutomaticKeepAliveClientMixin,RouteAware  {
  final TextEditingController productSearchController = TextEditingController();
  PageController pageController = PageController();

  final List<SubCategory> subCategories = [];


  late ScrollController? _scrollController;
  int _filterAnimationKey = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();
  //   _scrollController!.addListener(_scrollListener);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.refresh(currentPageController.notifier).state;
  //     ref.read(flashSalesListControllerProvider.notifier).getFlashSalesList();
  //
  //     // Initialize the controller from Provider
  //     // scrollController = ref.read(homeScrollControllerProvider);
  //     // // Attach listener strictly after frame callback
  //     // scrollController?.removeListener(_scrollListener);
  //     // scrollController?.addListener(_scrollListener);
  //     // 🔥 ADD THIS BLOCK: Fetch initial "All" products
  //
  //   });
  //
  //   pageController.addListener(_pageListener);
  // }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // ✅ FIX

      ref.read(currentPageController.notifier).state;

      ref.read(flashSalesListControllerProvider.notifier)
          .getFlashSalesList();
    });

    pageController.addListener(_pageListener);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // IMPORTANT: Remove listener to prevent lag on re-entry
    // scrollController?.removeListener(_scrollListener);
    routeObserver.unsubscribe(this);
    _scrollController!.removeListener(_scrollListener);
    _scrollController?.dispose();
    pageController.dispose();
    super.dispose();
  }

  // ---------------- ROUTE AWARE ----------------
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  /// 🔥 THIS IS THE MAGIC
  @override
  void didPopNext() {
    _resetHomeToAllProducts();
  }
  // ---------------- RESET HOME ----------------
  void _resetHomeToAllProducts() {
    /// Reset category selection
    ref.read(selectedMainCategoryIndexProvider.notifier).state = 0;
    ref.read(selectedSubCategoryIndexProvider.notifier).state = -1;

    /// Reload ALL products
    ref.read(productControllerProvider.notifier).refreshProducts(
      filter: ProductFilterModel(
        categoryId: null,      // ✅ ALL
        subCategoryId: null,
        page: 1,
        perPage: 20,
        search: null,
        sortType: null,
      ),
    );
  }

  // We attach this to the controller in the build method
  void _onScroll(ScrollController controller) {
    if (!controller.hasClients) return;

    // Threshold of 100px prevents flickering at the very top
    final bool scrolledDown = controller.offset > 100;

    if (ref.read(isHomeScrolledProvider) != scrolledDown) {
      ref.read(isHomeScrolledProvider.notifier).state = scrolledDown;
    }
  }

  void _pageListener() {
    int? newPage = pageController.page?.round();
    if (newPage != ref.read(currentPageController)) {
      setState(() {

        ref.read(currentPageController.notifier).state = newPage!;
      });
    }
  }

  // void _scrollListener() {
  //   if (!mounted) return;
  //   if (scrollController == null || !scrollController!.hasClients) return;
  //
  //   // Threshold of 100px prevents flickering at the very top
  //   final bool scrolledDown = scrollController!.offset > 100;
  //
  //   // Use ref.read to check current state.
  //   // This prevents unnecessary rebuilds if the state hasn't actually changed.
  //   if (ref.read(isHomeScrolledProvider) != scrolledDown) {
  //     ref.read(isHomeScrolledProvider.notifier).state = scrolledDown;
  //   }
  // }


  // void _scrollListener() {
  //   if (!_scrollController!.hasClients) return;
  //
  //   final bool scrolledDown = _scrollController!.offset > 100;
  //   // Only update provider if value changes to avoid rebuilds
  //   if (ref.read(isHomeScrolledProvider) != scrolledDown) {
  //     ref.read(isHomeScrolledProvider.notifier).state = scrolledDown;
  //   }
  // }
  void _scrollListener() {
    if (_scrollController == null || !_scrollController!.hasClients) return;

    final offset = _scrollController!.offset;
    final scrolledDown = offset > 100;

    if (ref.read(isHomeScrolledProvider) != scrolledDown) {
      ref.read(isHomeScrolledProvider.notifier).state = scrolledDown;
    }
  }
  // 4. LISTEN FOR DASHBOARD TRIGGER
  void _scrollToTop() {
    if (_scrollController!.hasClients) {
      _scrollController!.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
      );
    }
  }

  Widget _buildSellFab(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: GestureDetector(
          onTap: () {
            // 🔥 Open sell bottom sheet / page
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.svg.camera, // camera icon like image
                    width: 28,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sell',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 5. REGISTER LISTENER
    // Whenever 'homeScrollTriggerProvider' changes, run _scrollToTop
    ref.listen(homeScrollTriggerProvider, (previous, next) {
      _scrollToTop();
    });

    // ref.listen(dashboardControllerProvider, (previous, next) {
    //   // 1. Check if dashboard data is loaded successfully
    //   if (next.hasValue && next.value != null) {
    //     final categories = next.value!.categories;
    //
    //     // 2. If we have categories, fetch products for the FIRST one (Index 0)
    //     // We add a check to ensure we don't re-fetch if products are already there
    //     if (categories.isNotEmpty) {
    //       final firstCategory = categories[0];
    //
    //       // Only fetch if the product list is empty (first launch)
    //       if (ref.read(productControllerProvider).valueOrNull?.isEmpty ?? true) {
    //
    //         final initialFilter = ProductFilterModel(
    //           page: 1,
    //           perPage: 20,
    //           categoryId: firstCategory.id, // ✅ Use the REAL ID of the first tab
    //           search: null,
    //           sortType: null,
    //           subCategoryId: null,
    //         );
    //
    //         ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
    //           productFilterModel: initialFilter,
    //           isPagination: false,
    //         );
    //       }
    //     }
    //   }
    // });
    ref.listen(dashboardControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        final rawCategories = next.value!.categories;

        if (rawCategories.isEmpty) return;

        /// ✅ ADD "ALL" CATEGORY
        final categories = _buildAllCategory(rawCategories);

        /// ✅ FORCE SELECT "ALL"
        ref.read(selectedMainCategoryIndexProvider.notifier).state = 0;
        ref.read(selectedSubCategoryIndexProvider.notifier).state = -1;

        /// ✅ FETCH ALL PRODUCTS ON FIRST LOAD
        if (ref.read(productControllerProvider).valueOrNull?.isEmpty ?? true) {
          ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
            productFilterModel: ProductFilterModel(
              page: 1,
              perPage: 20,
              categoryId: null,      // 🔥 THIS IS THE FIX
              subCategoryId: null,   // 🔥
              search: null,
              sortType: null,
            ),
            isPagination: false,
          );
        }
      }
    });


    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: LoadingWrapperWidget(
        isLoading: ref.watch(subCategoryControllerProvider),
        child: Scaffold(
          backgroundColor: const Color(0xFFFFD4B8),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8F4),
                  Color(0xFFFFFFFF),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.0, 0.14, 1.0],
              ),
            ),
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, value) {
                final topInset = MediaQuery.paddingOf(context).top;
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: HomeCollapsingHeaderDelegate(
                      topInset: topInset,
                      onProfileTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const EcommerceMoreView(),
                          ),
                        );
                      },
                      onLiveTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => SellerDashboardWrapper(),
                          ),
                        );
                      },
                      onSearchTap: () => context.nav.pushNamed(
                        Routes.getProductsViewRouteName(
                          AppConstants.appServiceName,
                        ),
                        arguments: [
                          null,
                          'All Product',
                          null,
                          null,
                          null,
                          subCategories,
                        ],
                      ),
                      onNotificationTap: () {},
                    ),
                  ),
                ];
              },
            body: ref.watch(dashboardControllerProvider).when(
                  data: (dashboardData) {

                    // final updatedCategories =
                    // categoriesWithAll(dashboardData.categories);
                    return
                    RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(dashboardControllerProvider).value;
                      ref
                          .refresh(flashSalesListControllerProvider.notifier)
                          .stream;
                      ///------------------productList---------------
                      // 2. 🔥 ADD THIS: Refresh the Products List for the currently selected Category
                      final dashboardState = ref.read(dashboardControllerProvider);

                      if (dashboardState.hasValue && dashboardState.value != null) {
                        final categories = dashboardState.value!.categories;
                        final selectedIndex = ref.read(selectedMainCategoryIndexProvider);

                        // Ensure we have a valid category selected
                        if (selectedIndex >= 0 && selectedIndex < categories.length) {
                          final category = categories[selectedIndex];

                          // Check if a sub-category is selected
                          final subIndex = ref.read(selectedSubCategoryIndexProvider);
                          int? subCatId;
                          if (subIndex >= 0 && subIndex < category.subCategories.length) {
                            subCatId = category.subCategories[subIndex].id;
                          }

                          // Fetch fresh products from API (this will update favorite icons)
                          await ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
                            productFilterModel: ProductFilterModel(
                              categoryId: category.id,
                              page: 1,
                              perPage: 20,
                              search: null,
                              sortType: null,
                              subCategoryId: subCatId,
                            ),
                            isPagination: false,
                          );
                        }
                      }
                      ///--------------productList---------

                    },
                    child: AnimationLimiter(
                      child: SingleChildScrollView(
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 375),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50.h,
                              child: FadeInAnimation(child: widget),
                            ),
                            children: [
                              // Gap(20.h),
                              Gap(10.h),
                              Column(
                                children: [

                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.h),
                                        child: _buildisonbuildCategoriesWidget(
                                          context,
                                          dashboardData.categories,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(6.h),
                                  /// DescriptionContentView comment for now
                                  // _buildDescriptionContentView(context, dashboardData.categories)
                                ],
                              ),
                              BannerWidget(dashboardData: dashboardData),

                              // Gap(1.h),
                              DealOfTheDayWidget(),
                              // _buildScrollingContainers(),
                              Gap(10.h),
                              // _buildPopularProductWidget(
                              //     context, dashboardData.popularProducts),
                              _buildAnimatedFilterProducts(context),

                              // if (ref
                              //     .read(masterControllerProvider.notifier)
                              //     .materModel
                              //     .data
                              //     .isMultiVendor) ...[
                              //   _buildShopsWidget(context, dashboardData.shops),
                              //   Divider(
                              //       color: colors(context).accentColor,
                              //       thickness: 2),
                              // ],
                              // Gap(10.h),
                              // _buildBeautyProductWidget(
                              //     products: dashboardData.justForYou.products),
                              // Gap(20.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );},
                  error: (error, stackTrace) => Center(
                    child: Text(error.toString(),
                        style: AppTextStyle(context).subTitle),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildBeautyProductWidget({required List<product.Product> products}) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0.h),
          child:
          SizedBox(
            height: MediaQuery.of(context).size.height *1.71,
            child: MasonryGridView.count(
              padding: EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 5),
              // padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
              crossAxisCount: 2,
              mainAxisSpacing: 1.h,
              crossAxisSpacing: 15.w,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  // THE TRICK: Add top padding ONLY to the second item (index 1).
                  // This pushes the entire right column down by 40 pixels.
                  // padding: EdgeInsets.only(top: index == 1 ? 0 : 31.h,bottom: 0),
                  padding: EdgeInsets.only(top: index == 0 ? 0 : 31.h,bottom: 0),
                  child:  PopularProductCard(
                    product: products[index],
                    index: index,
                    onTap: () => context.nav.pushNamed(
                      Routes.getProductDetailsRouteName(AppConstants.appServiceName),
                      arguments: products[index].id,
                    ),
                  ),
                );
              },
            ),
          ),
          // GridView.builder(
          //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h)
          //       .copyWith(top: 34.h, bottom: 80.h),
          //   physics: const NeverScrollableScrollPhysics(),
          //   shrinkWrap: true,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     // crossAxisCount: _calculateCrossAxisCount(context),
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 16.w,
          //     mainAxisSpacing: 16.h,
          //     // childAspectRatio: 0.66,
          //     childAspectRatio: 0.62,
          //
          //   ),
          //   itemCount: products.length,
          //   itemBuilder: (context, index) => Padding(
          //     padding: EdgeInsets.only(top: index % 2 != 0 ? 0 : 30.h),
          //     child: ProductCard(
          //       product: products[index],
          //       onTap: () => context.nav.pushNamed(
          //         Routes.getProductDetailsRouteName(AppConstants.appServiceName),
          //         arguments: products[index].id,
          //       ),
          //     ),
          //   ),
          // ),
        ),
        // Positioned(
        //     left: 20.w,
        //     child: Text(S.of(context).justForYou,
        //         style: AppTextStyle(context).subTitle),),
        // Positioned(
        //   bottom: 20.h,
        //   left: 20.w,
        //   right: 20.w,
        //   child: _buildViewMoreButton(context, 'Just For You', 'just_for_you'),
        // ),
      ],
    );
  }
  final selectedCategoryIndexProvider = StateProvider<int>((ref) => 0);

  // Widget _buildCategoriesWidget(
  //     BuildContext context, List<Category> categories) {
  //   return Column(
  //     children: [
  //       _buildSectionHeader(context, S.of(context).categories,
  //           Routes.getCategoriesViewRouteName(AppConstants.appServiceName)),
  //       Gap(10.h),
  //       SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: Row(
  //           children: [
  //             Gap(10.w),
  //             ...categories.map(
  //               (category) => CategoryCard(
  //                 category: category,
  //                 onTap: () {
  //                   if (category.subCategories.isNotEmpty) {
  //                     showModalBottomSheet(
  //                       context: context,
  //                       builder: (context) => SubCategoriesBottomSheet(
  //                         category: category,
  //                       ),
  //                     );
  //                   } else {
  //                     GlobalFunction.navigatorKey.currentContext!.nav.pushNamed(
  //                       Routes.getProductsViewRouteName(
  //                         AppConstants.appServiceName,
  //                       ),
  //                       arguments: [
  //                         category.id,
  //                         category.name,
  //                         null,
  //                         null,
  //                         null,
  //                         category.subCategories,
  //                       ],
  //                     );
  //                   }
  //                 },
  //               ),
  //             ),
  //             Gap(10.w),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
  ///--------------
  // Widget _buildCategoriesWidget(
  //     BuildContext context, List<Category> categories) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       /// HEADER
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               S.of(context).categories,
  //               style: AppTextStyle(context).subTitle,
  //
  //             ),
  //             GestureDetector(
  //               onTap: () => context.nav.pushNamed(
  //                 Routes.getCategoriesViewRouteName(
  //                     AppConstants.appServiceName),
  //               ),
  //               child: Text(
  //                 // S.of(context).viewMore,
  //                 'See All',
  //                 style: AppTextStyle(context)
  //                     .bodyText
  //                     .copyWith(fontWeight: FontWeight.w500,
  //                     fontSize: 12,
  //                 letterSpacing: 0),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //       Gap(12.h),
  //
  //       /// CATEGORY PILLS
  //       SizedBox(
  //         height: 30.h,
  //         child: Consumer(
  //           builder: (context, ref, _) {
  //             final selectedIndex =
  //             ref.watch(selectedCategoryIndexProvider);
  //
  //             return ListView.separated(
  //               padding: EdgeInsets.symmetric(horizontal: 16.w),
  //               scrollDirection: Axis.horizontal,
  //               itemCount: categories.length,
  //               separatorBuilder: (_, __) => Gap(10.w),
  //               itemBuilder: (context, index) {
  //                 final category = categories[index];
  //                 final isSelected = selectedIndex == index;
  //
  //                 return GestureDetector(
  //                   // onTap: () {
  //                   //   ref
  //                   //       .read(selectedCategoryIndexProvider.notifier)
  //                   //       .state = index;
  //                   //
  //                   //   /// navigation logic (same as before)
  //                   //   if (category.subCategories.isNotEmpty) {
  //                   //     showModalBottomSheet(
  //                   //       context: context,
  //                   //       builder: (_) => SubCategoriesBottomSheet(
  //                   //         category: category,
  //                   //       ),
  //                   //     );
  //                   //   } else {
  //                   //     context.nav.pushNamed(
  //                   //       Routes.getProductsViewRouteName(
  //                   //           AppConstants.appServiceName),
  //                   //       arguments: [
  //                   //         category.id,
  //                   //         category.name,
  //                   //         null,
  //                   //         null,
  //                   //         null,
  //                   //         category.subCategories,
  //                   //       ],
  //                   //     );
  //                   //   }
  //                   // },
  //                   child: CategoryPill(
  //                     title: category.name,
  //                     imageUrl: category.thumbnail,
  //                     isSelected: isSelected,
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildCategoriesWidget(
      BuildContext context,
      List<Category> categories,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: GlobalFunction.getContainerColor(),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).categories,
                style: AppTextStyle(context)
                    .subTitle
                    .copyWith(fontSize: 18.sp),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          Gap(16.h),

          /// CATEGORY GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 3.2,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryButton(
                context: context,
                category: category,
              );
            },
          ),

          Gap(16.h),

          _buildViewMoreButton1(context: context),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required Category category,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pop(context);

        context.nav.pushNamed(
          Routes.getProductsViewRouteName(
            AppConstants.appServiceName,
          ),
          arguments: [
            category.id,
            category.name,
            null,
            null,
            null,
            category.subCategories,
          ],
        );
      },
      icon: CachedNetworkImage(
        imageUrl: category.thumbnail,
        width: 26.w,
        height: 26.w,
        fit: BoxFit.contain,
      ),
      label: Text(category.name),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        backgroundColor: Colors.transparent,
        foregroundColor: colors(context).bodyTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(
            color: EcommerceAppColor.primary.withOpacity(0.3),
          ),
        ),
        textStyle: AppTextStyle(context)
            .bodyText
            .copyWith(fontSize: 13.sp),
      ),
    );
  }

  Widget _buildViewMoreButton1({required BuildContext context}) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
        context.nav.pushNamed(
          Routes.getCategoriesViewRouteName(
            AppConstants.appServiceName,
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: EcommerceAppColor.primary),
        minimumSize: Size(double.infinity, 45.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).viewMore,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
              color: EcommerceAppColor.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(6.w),
          SvgPicture.asset(
            Assets.svg.arrowRight,
            height: 14.h,
            colorFilter: ColorFilter.mode(
              EcommerceAppColor.primary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  final selectedMainCategoryIndexProvider = StateProvider<int>((ref) => 0);
  final selectedSubCategoryIndexProvider = StateProvider<int>((ref) => 0);

  // List<Category> categoriesWithAll(List<Category> categories) {
  //   final allSubCategories =
  //   categories.expand((c) => c.subCategories).toList();
  //
  //   return [
  //     Category(
  //       id: -1,
  //       name: 'All',
  //       thumbnail: '',
  //       subCategories: allSubCategories,
  //     ),
  //     ...categories,
  //   ];
  // }


///----old---
//   Widget _buildisonbuildCategoriesWidget(
//       BuildContext context, List<Category> categories) {
//     final selectedIndex =
//     ref.watch(selectedMainCategoryIndexProvider);
//
//     final safeIndex = selectedIndex.clamp(
//       0,
//       categories.isEmpty ? 0 : categories.length - 1,
//     );
//
//     return Row(
//       children: [
//         SizedBox(
//           height: 27.h,
//           width: MediaQuery.of(context).size.width * .84,
//           child: Consumer(
//             builder: (context, ref, _) {
//               final selectedIndex =
//               ref.watch(selectedMainCategoryIndexProvider);
//
//               return ListView.separated(
//                 padding: EdgeInsets.symmetric(horizontal: 32.w,),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: categories.length,
//                 // reverse: true,
//                 separatorBuilder: (_, __) => Gap(45.w),
//                 itemBuilder: (context, index) {
//                   final category = categories[index];
//                   final isSelected = selectedIndex == index;
//
//                   return GestureDetector(
//                     onTap: () {
//                       if (selectedIndex == index) return;
//
//                       ref
//                           .read(selectedMainCategoryIndexProvider.notifier)
//                           .state = index;
//
//                       /// reset subcategory selection
//                       ref
//                           .read(selectedSubCategoryIndexProvider.notifier)
//                           .state = -1;
//
//                       final filter = ProductFilterModel(
//                         categoryId: category.id,
//                         page: 1,
//                         perPage: 20, // or your default
//                         search: null,
//                         sortType: null,
//                         subCategoryId: null,
//                       );
//                       // final category = categories[index];
//                       ref.read(productControllerProvider.notifier)
//                           .getCategoryWiseProducts(
//                         // categoryId: category.id,
//                         productFilterModel: filter,
//                         isPagination: false,
//                       );
//                     },
//                     child: _buildTabItem(
//                       context: context,
//                       title: category.name,
//                       isActive: isSelected,
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//
//         /// FILTER ICON
//         // Consumer(
//         //   builder: (context, ref, _) {
//         //     final index =
//         //     ref.watch(selectedMainCategoryIndexProvider);
//         //     final category = categories[index];
//         //
//         //     return GestureDetector(
//         //       onTap: () {
//         //         if (category.subCategories.isNotEmpty) {
//         //           showModalBottomSheet(
//         //             context: context,
//         //             shape: RoundedRectangleBorder(
//         //               borderRadius:
//         //               BorderRadius.vertical(top: Radius.circular(16.r)),
//         //             ),
//         //             builder: (_) =>
//         //                 SubCategoriesBottomSheet(category: category),
//         //           );
//         //         }
//         //       },
//         //       child: Padding(
//         //         padding: EdgeInsets.only(left: 10.w,bottom: 10),
//         //         child: CircleAvatar(
//         //           radius: 18.r,
//         //           backgroundColor:
//         //           EcommerceAppColor.primary.withOpacity(.2),
//         //           child: SvgPicture.asset(
//         //             Assets.svg.categoryMenu,
//         //             height: 20.h,
//         //             colorFilter: const ColorFilter.mode(
//         //               Colors.orange,
//         //               BlendMode.srcIn,
//         //             ),
//         //           ),
//         //         ),
//         //       ),
//         //     );
//         //   },
//         // ),
//       ],
//     );
//   }
  ///------old----
  Category _buildAllCategory(List<Category> categories) {
    final allSubCategories = categories
        .expand((c) => c.subCategories)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return Category(
      id: -1, // 🔴 virtual ID
      name: 'All',
      thumbnail: '',
      displayOrder: -1, // always first
      subCategories: allSubCategories,
    );
  }

  // Widget _buildisonbuildCategoriesWidget(
  //     BuildContext context,
  //     List<Category> categories,
  //     ) {
  //   /// 🔹 SORT BY displayOrder
  //   final sortedCategories = [...categories]
  //     ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  //
  //   final selectedIndex =
  //   ref.watch(selectedMainCategoryIndexProvider);
  //
  //   final safeIndex = selectedIndex.clamp(
  //     0,
  //     sortedCategories.isEmpty ? 0 : sortedCategories.length - 1,
  //   );
  //
  //   return Row(
  //     children: [
  //       SizedBox(
  //         height: 27.h,
  //         width: MediaQuery.of(context).size.width * .84,
  //         child: Consumer(
  //           builder: (context, ref, _) {
  //             final selectedIndex =
  //             ref.watch(selectedMainCategoryIndexProvider);
  //
  //             return ListView.separated(
  //               padding: EdgeInsets.symmetric(horizontal: 32.w),
  //               scrollDirection: Axis.horizontal,
  //               itemCount: sortedCategories.length,
  //               separatorBuilder: (_, __) => Gap(45.w),
  //               itemBuilder: (context, index) {
  //                 final category = sortedCategories[index];
  //                 final isSelected = selectedIndex == index;
  //
  //                 return GestureDetector(
  //                   onTap: () {
  //                     if (selectedIndex == index) return;
  //
  //                     /// update selected index
  //                     ref
  //                         .read(selectedMainCategoryIndexProvider.notifier)
  //                         .state = index;
  //
  //                     /// reset subcategory selection
  //                     ref
  //                         .read(selectedSubCategoryIndexProvider.notifier)
  //                         .state = -1;
  //
  //                     /// filter using category id
  //                     final filter = ProductFilterModel(
  //                       categoryId: category.id,
  //                       page: 1,
  //                       perPage: 20,
  //                       search: null,
  //                       sortType: null,
  //                       subCategoryId: null,
  //                     );
  //
  //                     ref
  //                         .read(productControllerProvider.notifier)
  //                         .getCategoryWiseProducts(
  //                       productFilterModel: filter,
  //                       isPagination: false,
  //                     );
  //                   },
  //                   child: _buildTabItem(
  //                     context: context,
  //                     title: category.name,
  //                     isActive: isSelected,
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildisonbuildCategoriesWidget(
  //     BuildContext context,
  //     List<Category> categories,
  //     ) {
  //   /// 1️⃣ Sort API categories
  //   final sorted = [...categories]
  //     ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  //
  //   /// 2️⃣ Add "All" category at start
  //   final finalCategories = [
  //     _buildAllCategory(sorted),
  //     ...sorted,
  //   ];
  //
  //   final selectedIndex = ref.watch(selectedMainCategoryIndexProvider);
  //
  //   return Row(
  //     children: [
  //       SizedBox(
  //         height: 27.h,
  //         width: MediaQuery.of(context).size.width * .84,
  //         child: ListView.separated(
  //           padding: EdgeInsets.symmetric(horizontal: 32.w),
  //           scrollDirection: Axis.horizontal,
  //           itemCount: finalCategories.length,
  //           separatorBuilder: (_, __) => Gap(45.w),
  //           itemBuilder: (context, index) {
  //             final category = finalCategories[index];
  //             final isSelected = selectedIndex == index;
  //
  //             return GestureDetector(
  //               onTap: () {
  //                 // if (selectedIndex == index) return;
  //
  //                 ref
  //                     .read(selectedMainCategoryIndexProvider.notifier)
  //                     .state = index;
  //
  //                 /// reset subcategory
  //                 ref
  //                     .read(selectedSubCategoryIndexProvider.notifier)
  //                     .state = -1;
  //
  //                 final isAll = category.id == -1;
  //
  //                 /// 3️⃣ CLEAR previous products (important for refresh)
  //                 /// 🔥 SAFE REFRESH CALL
  //                  ref.read(productControllerProvider.notifier).refreshProducts(
  //                   filter: ProductFilterModel(
  //                     categoryId: isAll ? null : category.id, // ALL = null
  //                     subCategoryId: null,
  //                     page: 1,
  //                     perPage: 20,
  //                     search: null,
  //                     sortType: null,
  //                   ),
  //                 );
  //
  //                 /// 🔥 ALL category → no categoryId
  //                 // final filter = ProductFilterModel(
  //                 //   // categoryId: category.id == -1 ? null : category.id,
  //                 //   categoryId: isAll ? null : category.id,
  //                 //   page: 1,
  //                 //   perPage: 20,
  //                 //   search: null,
  //                 //   sortType: null,
  //                 //   subCategoryId: null,
  //                 // );
  //                 //
  //                 // ref
  //                 //     .read(productControllerProvider.notifier)
  //                 //     .getCategoryWiseProducts(
  //                 //   productFilterModel: filter,
  //                 //   isPagination: false,
  //                 // );
  //               },
  //               child: _buildTabItem(
  //                 context: context,
  //                 title: category.name,
  //                 isActive: isSelected,
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildisonbuildCategoriesWidget(
      BuildContext context,
      List<Category> categories,
      ) {
    /// SORT CATEGORIES IN FIXED ORDER
    final sorted = [...categories];

    sorted.sort((a, b) {
      const order = ['Men', 'Women', 'Kids'];

      final aIndex = order.indexWhere(
            (e) => a.name.toLowerCase().contains(e.toLowerCase()),
      );

      final bIndex = order.indexWhere(
            (e) => b.name.toLowerCase().contains(e.toLowerCase()),
      );

      /// fallback API order
      if (aIndex == -1 && bIndex == -1) {
        return a.displayOrder.compareTo(b.displayOrder);
      }

      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;

      return aIndex.compareTo(bIndex);
    });

    /// ADD ALL TAB FIRST
    final finalCategories = [
      _buildAllCategory(sorted),
      ...sorted,
    ];

    final selectedIndex =
    ref.watch(selectedMainCategoryIndexProvider);

    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: ListView.separated(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: finalCategories.length + 1,
        separatorBuilder: (_, __) => Gap(10.w),
        itemBuilder: (context, index) {
          if (index == finalCategories.length) {
            return CategoryMenuTab(
              index: index,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                  ),
                  builder: (_) =>
                      _buildCategoriesWidget(context, categories),
                );
              },
            );
          }

          final category = finalCategories[index];
          final isSelected = selectedIndex == index;

          return CategoryFilterTab(
            title: category.name,
            imageUrl: category.id == -1 ? null : category.thumbnail,
            isSelected: isSelected,
            index: index,
            onTap: () {
              if (selectedIndex == index) return;

              setState(() => _filterAnimationKey++);

              ref.read(selectedMainCategoryIndexProvider.notifier).state =
                  index;

              ref.read(selectedSubCategoryIndexProvider.notifier).state = -1;

              final isAll = category.id == -1;

              ref.read(productControllerProvider.notifier).refreshProducts(
                    filter: ProductFilterModel(
                      categoryId: isAll ? null : category.id,
                      subCategoryId: null,
                      page: 1,
                      perPage: 20,
                      search: null,
                      sortType: null,
                    ),
                  );
            },
          );
        },
      ),
    );
  }

  // Widget _buildTabItem({
  //
  //   required BuildContext context,
  //   required String title,
  //   required bool isActive,
  // }) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         title,
  //         style: AppTextStyle(context).bodyText.copyWith(
  //           fontWeight: isActive ? FontWeight.w600 : FontWeight.bold,
  //           color: isActive
  //               ? EcommerceAppColor.carrotOrange
  //               : Colors.black,
  //           fontSize: 11
  //         ),
  //       ),
  //       Gap(6.h),
  //
  //       AnimatedContainer(
  //         duration: const Duration(milliseconds: 300),
  //         height: 2.h,
  //         width: isActive ? title.toString().length.w*9 : 0,
  //         decoration: BoxDecoration(
  //           color: EcommerceAppColor.carrotOrange,
  //           borderRadius: BorderRadius.circular(2),
  //         ),
  //       ),
  //
  //     ],
  //   );
  // }

  // Widget _buildTabItem({
  //   required BuildContext context,
  //   required String title,
  //   required bool isActive,
  // }) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         title,
  //         style: AppTextStyle(context).bodyText.copyWith(
  //           fontWeight: isActive ? FontWeight.w600 : FontWeight.bold,
  //           color: isActive
  //               ? EcommerceAppColor.carrotOrange
  //               : Colors.black,
  //           fontSize: 11,
  //         ),
  //       ),
  //
  //       // Gap(5.h),
  //
  //       Transform.translate(
  //         offset: const Offset(0, 8), // niche move karega
  //         child: AnimatedContainer(
  //           duration: const Duration(milliseconds: 300),
  //           height: 2.5.h,
  //           width: isActive ? title.length * 11.w : 0,
  //           // width: isActive ? (title.length * 8.5).w : 0,
  //
  //           decoration: BoxDecoration(
  //             color: EcommerceAppColor.carrotOrange,
  //             borderRadius: BorderRadius.circular(2),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildTabItem({
    required BuildContext context,
    required String title,
    required bool isActive,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: AppTextStyle(context).bodyText.copyWith(
              fontWeight:
              isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? EcommerceAppColor.carrotOrange
                  : Colors.black87,
              fontSize: 12.5.sp,
              letterSpacing: 0.2,
            ),
            child: Text(title),
          ),

          Gap(7.h),

          Transform.translate(
            offset: const Offset(0, 8), // niche move karega

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 2.5.h,
              width: isActive ? (title.length * 8.5).w : 0,
              decoration: BoxDecoration(
                color: EcommerceAppColor.carrotOrange,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDescriptionContentView(
  //     BuildContext context, List<Category> categories) {
  //   return Consumer(
  //     builder: (context, ref, _) {
  //       final mainIndex =
  //       ref.watch(selectedMainCategoryIndexProvider);
  //       final subIndex =
  //       ref.watch(selectedSubCategoryIndexProvider);
  //
  //       final subCategories = categories[mainIndex].subCategories;
  //
  //       if (subCategories.isEmpty) {
  //         return const SizedBox.shrink();
  //       }
  //
  //       return SizedBox(
  //         height: 110.h,
  //         child: ListView.separated(
  //           padding: EdgeInsets.symmetric(horizontal: 16.w),
  //           scrollDirection: Axis.horizontal,
  //           itemCount: subCategories.length,
  //           separatorBuilder: (_, __) => Gap(33.w),
  //           itemBuilder: (context, index) {
  //             final subCategory = subCategories[index];
  //             final isSelected = subIndex == index;
  //
  //             return GestureDetector(
  //               onTap: () {
  //                 ref
  //                     .read(selectedSubCategoryIndexProvider.notifier)
  //                     .state = index;
  //
  //                 context.nav.pushNamed(
  //                   Routes.getProductsViewRouteName(
  //                       AppConstants.appServiceName),
  //                   arguments: [
  //                     categories[mainIndex].id == -1
  //                         ? null
  //                         : categories[mainIndex].id,
  //                     categories[mainIndex].name,
  //                     null,
  //                     subCategory.id,
  //                     null,
  //                     subCategories,
  //                   ],
  //                 );
  //               },
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     height: 66.h,
  //                     width: 64.h,
  //                     decoration: BoxDecoration(
  //                       color: isSelected
  //                           ? const Color(0xFFFFF1E6) // soft orange background
  //                           : const Color(0xFFF8F3EE), // light beige
  //                       borderRadius: BorderRadius.circular(15.r),
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(15.r),
  //                       child: CachedNetworkImage(
  //                         imageUrl: subCategory.thumbnail,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //
  //                   Gap(5.h),
  //
  //                   Text(
  //                     subCategory.name,
  //                     textAlign: TextAlign.start,
  //                     style: AppTextStyle(context).bodyTextSmall.copyWith(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 9.sp,
  //                       color: isSelected
  //                           ? EcommerceAppColor.carrotOrange
  //                           : Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  ///---old-----
  // Widget _buildDescriptionContentView(
  //     BuildContext context,
  //     List<Category> categories,
  //     ) {
  //   return Consumer(
  //     builder: (context, ref, _) {
  //       int mainIndex = ref.watch(selectedMainCategoryIndexProvider);
  //       int subIndex = ref.watch(selectedSubCategoryIndexProvider);
  //
  //       /// SAFETY: categories empty
  //       if (categories.isEmpty) {
  //         return const SizedBox.shrink();
  //       }
  //
  //       /// SAFETY: clamp mainIndex
  //       if (mainIndex < 0 || mainIndex >= categories.length) {
  //         mainIndex = 0;
  //
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           ref
  //               .read(selectedMainCategoryIndexProvider.notifier)
  //               .state = 0;
  //         });
  //       }
  //
  //       // final subCategories = categories[mainIndex].subCategories;
  //       final subCategories = [...categories[mainIndex].subCategories]
  //         ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  //       /// SAFETY: no subcategories
  //       if (subCategories.isEmpty) {
  //         return const SizedBox.shrink();
  //       }
  //
  //       /// SAFETY: clamp subIndex
  //       if (subIndex < -1 || subIndex >= subCategories.length) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           ref
  //               .read(selectedSubCategoryIndexProvider.notifier)
  //               .state = -1;
  //         });
  //       }
  //
  //       return SizedBox(
  //         height: 96.h,
  //         child: ListView.separated(
  //           padding: EdgeInsets.symmetric(horizontal: 16.w),
  //           scrollDirection: Axis.horizontal,
  //           itemCount: subCategories.length,
  //           separatorBuilder: (_, __) => Gap(33.w),
  //           itemBuilder: (context, index) {
  //             final subCategory = subCategories[index];
  //             final isSelected = subIndex == index;
  //
  //             return GestureDetector(
  //               onTap: () {
  //                 ref
  //                     .read(selectedSubCategoryIndexProvider.notifier)
  //                     .state = index;
  //
  //                 context.nav.pushNamed(
  //                   Routes.getProductsViewRouteName(
  //                       AppConstants.appServiceName),
  //                   arguments: [
  //                     categories[mainIndex].id == -1
  //                         ? null
  //                         : categories[mainIndex].id,
  //                     categories[mainIndex].name,
  //                     null,
  //                     subCategory.id,
  //                     null,
  //                     subCategories,
  //                   ],
  //                 );
  //               },
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     height: 66.h,
  //                     width: 64.h,
  //                     decoration: BoxDecoration(
  //                       color: isSelected
  //                           ? const Color(0xFFFFF1E6)
  //                           : const Color(0xFFF8F3EE),
  //                       borderRadius: BorderRadius.circular(15.r),
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(15.r),
  //                       child: CachedNetworkImage(
  //                         imageUrl: subCategory.thumbnail,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                   Gap(5.h),
  //                   Text(
  //                     subCategory.name,
  //                     textAlign: TextAlign.center,
  //                     style: AppTextStyle(context)
  //                         .bodyTextSmall
  //                         .copyWith(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 9.sp,
  //                       color: isSelected
  //                           ? EcommerceAppColor.carrotOrange
  //                           : Colors.grey.shade600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

///---old--- DescriptionContentView comment for now please don't remove
  Widget _buildDescriptionContentView(
      BuildContext context,
      List<Category> categories,
      ) {
    return Consumer(
      builder: (context, ref, _) {
        int mainIndex = ref.watch(selectedMainCategoryIndexProvider);
        int subIndex = ref.watch(selectedSubCategoryIndexProvider);

        if (categories.isEmpty) return const SizedBox.shrink();

        /// Build categories with ALL
        final sorted = [...categories]
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        final finalCategories = [
          _buildAllCategory(sorted),
          ...sorted,
        ];

        /// SAFETY
        if (mainIndex < 0 || mainIndex >= finalCategories.length) {
          mainIndex = 0;
        }

        final currentCategory = finalCategories[mainIndex];

        /// 🔥 SubCategories (All OR Single)
        final subCategories = [...currentCategory.subCategories]
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

        if (subCategories.isEmpty) return const SizedBox.shrink();

        if (subIndex >= subCategories.length) {
          ref.read(selectedSubCategoryIndexProvider.notifier).state = -1;
        }

        return SizedBox(
          height: 96.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: subCategories.length,
            separatorBuilder: (_, __) => Gap(33.w),
            itemBuilder: (context, index) {
              final subCategory = subCategories[index];
              final isSelected = subIndex == index;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(selectedSubCategoryIndexProvider.notifier)
                      .state = index;

                  context.nav.pushNamed(
                    Routes.getProductsViewRouteName(
                        AppConstants.appServiceName),
                    arguments: [
                      currentCategory.id == -1 ? null : currentCategory.id,
                      currentCategory.name,
                      null,
                      subCategory.id,
                      null,
                      subCategories,
                    ],
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 66.h,
                      width: 64.h,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF1E6)
                            : const Color(0xFFF8F3EE),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: CachedNetworkImage(
                          imageUrl: subCategory.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(5.h),
                    Text(
                      subCategory.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyle(context)
                          .bodyTextSmall
                          .copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                        color: isSelected
                            ? EcommerceAppColor.carrotOrange
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildShopsWidget(BuildContext context, List<Shop> shops) {
    return Column(
      children: [
        _buildSectionHeader(context, S.of(context).shops,
            Routes.getShopsViewRouteName(AppConstants.appServiceName)),
        SizedBox(
          height: MediaQuery.of(context).size.height / 8.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: shops.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: ShopCardCircle(
                callback: () => context.nav.pushNamed(
                  Routes.getShopViewRouteName(AppConstants.appServiceName),
                  arguments: shops[index].id,
                ),
                shop: shops[index],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProductWidget(
      BuildContext context, List<product.Product> products) {
    return Column(
      children: [
        // _buildSectionHeader(context, S.of(context).popularProducts,
        //     Routes.getProductsViewRouteName(AppConstants.appServiceName),
        //     arguments: [
        //       null,
        //       'Popular',
        //       'popular',
        //       null,
        //       null,
        //       subCategories
        //     ]),
    SizedBox(
      // height: MediaQuery.of(context).size.height / 1.31,
      // height: MediaQuery.of(context).size.height *1.21,
      child: MasonryGridView.count(
        padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 0),
        // padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
        crossAxisCount: 2,
        mainAxisSpacing: 1.h,
        crossAxisSpacing: 15.w,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            // THE TRICK: Add top padding ONLY to the second item (index 1).
            // This pushes the entire right column down by 40 pixels.
            padding: EdgeInsets.only(top: index == 1 ? 0 : 31.h,bottom: 0),
            // padding: EdgeInsets.only(top: index == 1 ? 31.h : 0.h,bottom: 0),

            child:  PopularProductCard(
            product: products[index],
            index: index,
            onTap: () => context.nav.pushNamed(
              Routes.getProductDetailsRouteName(
                  AppConstants.appServiceName),
              arguments: products[index].id,
            ),
          ),
          );
        },
      ),
    ),
        // SizedBox(
        //   // height: MediaQuery.of(context).size.height / 2.9,
        //   child:
        //   GridView.builder(
        //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h)
        //         .copyWith(top: 34.h, bottom: 80.h),
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       // crossAxisCount: _calculateCrossAxisCount(context),
        //       crossAxisCount: 2,
        //       crossAxisSpacing: 16.w,
        //       mainAxisSpacing: 16.h,
        //       // childAspectRatio: 0.66,
        //       childAspectRatio: 170 / 275,
        //
        //     ),
        //     itemCount: products.length,
        //     itemBuilder: (context, index) => Padding(
        //       padding: EdgeInsets.only(top: index % 2 != 0 ? 0 : 30.h),
        //       child: ProductCard(
        //         product: products[index],
        //         onTap: () => context.nav.pushNamed(
        //           Routes.getProductDetailsRouteName(AppConstants.appServiceName),
        //           arguments: products[index].id,
        //         ),
        //       ),
        //     ),
        //   ),
        //   // ListView.builder(
        //   //   padding: EdgeInsets.only(left: 16.w),
        //   //   scrollDirection: Axis.vertical,
        //   //   itemCount: products.length,
        //   //   itemBuilder: (context, index) => PopularProductCard(
        //   //     product: products[index],
        //   //     onTap: () => context.nav.pushNamed(
        //   //       Routes.getProductDetailsRouteName(
        //   //           AppConstants.appServiceName),
        //   //       arguments: products[index].id,
        //   //     ),
        //   //   ),
        //   // ),
        //
        // ),
        Gap(20.h),
      ],
    );
  }

  Widget _buildAnimatedFilterProducts(BuildContext context) {
    final selectedIndex = ref.watch(selectedMainCategoryIndexProvider);

    return _buildGridProductsWidget(
      context,
      animationKey: ValueKey('filter-$selectedIndex-$_filterAnimationKey'),
    )
        .animate(key: ValueKey('filter-$selectedIndex-$_filterAnimationKey'))
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildGridProductsWidget(
    BuildContext context, {
    Key? animationKey,
  }) {
    // 1. FIX: Watch the provider STATE, not the notifier
    // This forces the widget to rebuild when data arrives
    final productState = ref.watch(productControllerProvider);

    return productState.when(
      loading: () => SizedBox(
        key: animationKey,
        child: popularProductShimmer(context),
      ),
      error: (error, stackTrace) => Center(
        key: animationKey,
        child: Text("Error loading products", style: AppTextStyle(context).bodyTextSmall),
      ),
      data: (products) {
        if (products.isEmpty) {
          return SizedBox(
            key: animationKey,
            height: 100.h,
            child: Center(
                child: Text("No products found", style: AppTextStyle(context).bodyText)),
          );
        }

        return AnimationLimiter(
          key: animationKey,
          child: SizedBox(
            child: MasonryGridView.count(
              padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 100),
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final product = products[index];
                return AnimationConfiguration.staggeredGrid(
                  duration: const Duration(milliseconds: 375),
                  position: index,
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 0),
                      child: PopularProductCard(
                        product: product,
                        index: index,
                        onTap: () => context.nav.pushNamed(
                          Routes.getProductDetailsRouteName(AppConstants.appServiceName),
                          arguments: products[index].id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget popularProductShimmer(BuildContext context) {
    return MasonryGridView.count(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 100),
      crossAxisCount: 2,
      mainAxisSpacing: 5.h,
      crossAxisSpacing: 15.w,
      itemCount: 6, // ✅ important
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final imageHeight = index.isEven ? 260.h : 180.h;

        return Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                    child: Container(
                      height: imageHeight,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Container(
                          height: 12.h,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Gap(8.h),

                        /// PRICE
                        Container(
                          height: 12.h,
                          width: 80.w,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildAppBarWidget(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(AppConstants.userBox).listenable(),
      builder: (context, userBox, _) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xD36600),
                Color(0xD36600),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 3.h),
          child: Row(
            children: [
              const AppLogo(isAnimation: true, centerAlign: false),
              const Spacer(),
              liveImageWithText(text: 'Live', height: 55),
              const Spacer(),
              Gap(14.w),
              _buildProfileIcon(context),
            ],
          ),
        );
      },
    );
  }

  Widget liveImageWithText({
    required String text,
    double height = 55,
  }) {
    return SizedBox(
      height: height.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// 🔥 ORIGINAL IMAGE (UNCHANGED)
          Image.asset(
            "assets/png/live.png",
            height: height.h,
            fit: BoxFit.contain,
          ),

          /// ✏️ CUSTOM TEXT ON TOP
          Positioned(
            top: height.h * 0.35, // adjust if needed
            left: 7,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalePill() {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) =>  SellerDashboardWrapper(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: EcommerceAppColor.carrotOrange,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Text(
              'Sale',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(6.w),
            SvgPicture.asset(
              Assets.svg.plusSign, // ✅ bell SVG
              height: 10.h,
              // colorFilter: ColorFilter.mode(
              //   colors(context).hintTextColor!,
              //   // Colors.black,
              //   BlendMode.srcIn,
              //
              // ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCartIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: badges.Badge(
        showBadge: false,
        badgeContent: Text(
          '1', // later bind with provider
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: EcommerceAppColor.carrotOrange,
        ),
        position: badges.BadgePosition.topEnd(top: -6, end: -6),
        child: SvgPicture.asset(
          Assets.svg.shoppingCart, // ✅ your SVG
          height: 35.h,
          colorFilter: ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
    );


  }
  Widget _buildNotificationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        radius: 19.r,
        backgroundColor: colors(context).light,
        child: SvgPicture.asset(
          Assets.svg.homePageNotification, // ✅ bell SVG
          height: 19.h,
          colorFilter: ColorFilter.mode(
            colors(context).dark!,
            // Colors.black,
            BlendMode.srcIn,

          ),
        ),
      ),
    );
  }
  Widget _buildProfileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const EcommerceMoreView(),
          ),
        );
      },
      child: CircleAvatar(
        radius: 18.5.r,
        backgroundColor: colors(context).light,
        child: SvgPicture.asset(
          Assets.svg.profileIcon, //
          height: 22.h,
          colorFilter: ColorFilter.mode(
            // colors(context).hintTextColor!,
            Colors.black,
            BlendMode.srcIn,

          ),
        ),
      ),
    );
  }



  Widget _buildSectionHeader(BuildContext context, String title, String route,
      {List<dynamic>? arguments}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h).copyWith(right: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle(context).buttonText,),
          // TextButton(
          //   onPressed: () => context.nav.pushNamed(route, arguments: arguments),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(S.of(context).viewMore,
          //           style: AppTextStyle(context)
          //               .bodyText
          //               .copyWith(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
          //       Gap(3.w),
          //       // SvgPicture.asset(
          //       //   Assets.svg.arrowRight,
          //       //   colorFilter: ColorFilter.mode(
          //       //       colors(context).primaryColor!, BlendMode.srcIn),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildViewMoreButton(
      BuildContext context, String title, String argument) {
    return OutlinedButton(
      onPressed: () => context.nav.pushNamed(
        Routes.getProductsViewRouteName(AppConstants.appServiceName),
        arguments: [null, title, argument, null, null, subCategories],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: GlobalFunction.getBackgroundColor(context: context) !=
                colors(context).dark
            ? EcommerceAppColor.primary.withOpacity(0.1)
            : colors(context).accentColor,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        side: BorderSide(color: EcommerceAppColor.primary, width: 1),
        minimumSize: Size(MediaQuery.of(context).size.width, 45.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).viewMore,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                  color: colors(context).primaryColor,
                  fontWeight: FontWeight.w600)),
          Gap(3.w),
          SvgPicture.asset(
            Assets.svg.arrowRight,
            colorFilter: ColorFilter.mode(
                colors(context).primaryColor!, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }


  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeftRow(context),
        Icon(Icons.expand_more, color: colors(context).hintTextColor),
      ],
    );
  }

  Widget _buildLeftRow(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          const AppLogo(withAppName: false, isAnimation: true),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).deliverTo,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontWeight: FontWeight.w700)),
                ValueListenableBuilder(
                  valueListenable: Hive.box(AppConstants.userBox).listenable(),
                  builder: (context, box, _) {
                    final addressData =
                        box.get(AppConstants.defaultAddress, defaultValue: "");
                    print(
                        "Retrieved addressData: $addressData, Type: ${addressData.runtimeType}");

                    return Text(
                      addressData.isNotEmpty
                          ? _defaultAddress(context, addressData)
                          : "",
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle(context)
                          .bodyText
                          .copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _defaultAddress(BuildContext context, dynamic data) {
    if (data == null) return '';

    try {
      Address address = Address.fromJson(data);

      return GlobalFunction.formatDeliveryAddress(
          context: context, address: address);
    } catch (e) {
      print("Error parsing address data: $e");
      return '';
    }
  }

  Decoration _buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xD36600),
          Color(0xD36600),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 60.h;

  @override
  double get minExtent => 60.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

int _calculateCrossAxisCount(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  return screenWidth > 600 ? 3 : 2;
}

class DealOfTheDayWidget extends ConsumerWidget {
  final bool showViewMore;
  const DealOfTheDayWidget({
    super.key,
    this.showViewMore = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? endDate;
    final runningSaleData =
        ref.watch(flashSalesListControllerProvider.notifier).runningFlashSale;
    if (runningSaleData != null) {
      endDate = DateTime.parse(runningSaleData.endDate ?? "");
    }

    return runningSaleData != null
        ? Container(
            margin: EdgeInsets.all(showViewMore ? 10.w : 0.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(colors: [
                  const Color(0xFFB822FF),
                  EcommerceAppColor.primary,
                ])),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        runningSaleData.name ?? "",
                        style: AppTextStyle(context)
                            .subTitle
                            .copyWith(color: EcommerceAppColor.white),
                      ),
                      Gap(10.h),
                      Row(
                        children: [
                          Text(
                            S.of(context).endingIn,
                            style: AppTextStyle(context).bodyText.copyWith(
                                fontSize: 16.sp,
                                color: EcommerceAppColor.white),
                          ),
                          Gap(10.w),
                          if (endDate != null)
                            SlideCountdownSeparated(
                              separatorStyle: AppTextStyle(context)
                                  .bodyText
                                  .copyWith(color: FoodAppColor.white),
                              style: AppTextStyle(context).title.copyWith(
                                  color: FoodAppColor.carrotOrange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: EcommerceAppColor.white),
                              duration: endDate.isAfter(DateTime.now())
                                  ? endDate.difference(DateTime.now())
                                  : Duration.zero,
                            ),
                        ],
                      )
                    ],
                  ),
                  if (showViewMore)
                    _buildViewMoreButton(
                      context,
                      ref,
                      runningSaleData.id,
                      runningSaleData.name ?? "",
                    ),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildViewMoreButton(
      BuildContext context, WidgetRef ref, id, String title) {
    return OutlinedButton(
      onPressed: () {
        ref
            .read(flashSaleDetailsControllerProvider.notifier)
            .getFlashSalesDetails(id: id);
        context.nav.pushNamed(Routes.flashSaleDetails, arguments: title);
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        side: const BorderSide(color: EcommerceAppColor.white, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).viewMore,
            style: AppTextStyle(context)
                .bodyTextSmall
                .copyWith(color: colors(context).light),
          ),
          Gap(3.w),
          SvgPicture.asset(
            Assets.svg.arrowRight,
            colorFilter:
                ColorFilter.mode(colors(context).light!, BlendMode.srcIn),
          )
        ],
      ),
    );
  }
}

Widget _buildScrollingContainers() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const NeverScrollableScrollPhysics(),
    child: Row(
      children: List.generate(
        60,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: 2.h,
          width: 5.w,
          color: EcommerceAppColor.lightGray.withOpacity(0.5),
        ),
      ),
    ),
  );
}

