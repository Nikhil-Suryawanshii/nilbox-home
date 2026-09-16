import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/list_product_card.dart';

import '../../../../components/ecommerce/custom_cart.dart';
import 'favourite_list_product_card.dart';

class FavouritesProductsLayout extends ConsumerStatefulWidget {
  const FavouritesProductsLayout({super.key});

  static late ScrollController scrollController;

  @override
  ConsumerState<FavouritesProductsLayout> createState() =>
      _FavouritesProductsLayoutState();
}

// class _FavouritesProductsLayoutState
//     extends ConsumerState<FavouritesProductsLayout> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       FavouritesProductsLayout.scrollController = ScrollController();
//       ref.read(productControllerProvider.notifier).getFavoriteProducts();
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     FavouritesProductsLayout.scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: colors(context).accentColor,
//       appBar: AppBar(
//         title: Text(S.of(context).favorites),
//         surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
//         // leading: IconButton(
//         //   onPressed: () {
//         //     context.nav.pop();
//         //   },
//         //   icon: Icon(
//         //     Icons.arrow_back,
//         //     color: colors(context).dark,
//         //   ),
//         // ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: CustomCartWidget(context: context,backgroundColor:Color(0x41d9d9d9) ,),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Divider(
//             color: Colors.black.withOpacity(0.4), // Subtle light color
//             height: 1.0,
//             indent: 18,
//             endIndent: 18,
//             thickness: 0.5, // Thin line for a clean look
//           ),
//         ),
//       ),
//       body: _buildListProductsWidget(context: context),
//     );
//   }
//
//   Widget _buildListProductsWidget({required BuildContext context}) {
//     return AnimationLimiter(
//       child: ref.watch(productControllerProvider).isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ref
//                   .watch(productControllerProvider.notifier)
//                   .favoriteProducts
//                   .isEmpty
//               ? Center(
//                   child: Text(
//                     'Favorite products not found!',
//                     style: AppTextStyle(context).subTitle,
//                   ),
//                 )
//               : ListView.builder(
//                   padding: EdgeInsets.symmetric(vertical: 10.h),
//                   controller: FavouritesProductsLayout.scrollController,
//                   itemCount: ref
//                       .watch(productControllerProvider.notifier)
//                       .favoriteProducts
//                       .length,
//                   itemBuilder: (context, index) {
//                     final product = ref
//                         .watch(productControllerProvider.notifier)
//                         .favoriteProducts[index];
//                     return AnimationConfiguration.staggeredList(
//                       position: index,
//                       duration: const Duration(milliseconds: 500),
//                       child: SlideAnimation(
//                         verticalOffset: 50.0,
//                         child: FadeInAnimation(
//                           child: FavouriteListProductCard(
//                             product: product,
//                             onTap: () {
//                               print("tap");
//                               context.nav.pushNamed(
//                                   Routes.getProductDetailsRouteName(
//                                     AppConstants.appServiceName,
//                                   ),
//                                   arguments: product.id);
//                             },
//                             onTapRemove: () {
//                               debugPrint(product.id.toString());
//                               ref
//                                   .read(productControllerProvider.notifier)
//                                   .favoriteProducts
//                                   .removeWhere(
//                                     (element) => element.id == product.id,
//                                   );
//                               ref
//                                   .read(productControllerProvider.notifier)
//                                   .favoriteProductAddRemove(
//                                       productId: product.id);
//                               setState(() {});
//                             },
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }


class _FavouritesProductsLayoutState
    extends ConsumerState<FavouritesProductsLayout> {

  @override
  void initState() {
    super.initState();
    FavouritesProductsLayout.scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // FIX: Call the NEW provider
      ref.read(favoriteProductsControllerProvider.notifier).getFavoriteProducts();
    });
  }

  @override
  void dispose() {
    FavouritesProductsLayout.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).favorites),
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CustomCartWidget(context: context, backgroundColor: const Color(0x41d9d9d9)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            color: Colors.black.withOpacity(0.4),
            height: 1.0,
            indent: 18,
            endIndent: 18,
            thickness: 0.5,
          ),
        ),
      ),
      body: _buildListProductsWidget(context: context),
    );
  }

  Widget _buildListProductsWidget({required BuildContext context}) {
    // FIX: Watch the NEW provider state directly
    final favoriteState = ref.watch(favoriteProductsControllerProvider);

    return AnimationLimiter(
      child: favoriteState.when(
        // 1. Loading State
        loading: () => const Center(child: CircularProgressIndicator()),

        // 2. Error State
        error: (err, stack) => Center(child: Text('Error: $err')),

        // 3. Data State
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Text(
                'Favorite products not found!',
                style: AppTextStyle(context).subTitle,
              ),
            );
          }

          return ListView.builder(
            // padding: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.only(top: 10,bottom: 100),
            controller: FavouritesProductsLayout.scrollController,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: FavouriteListProductCard(
                      product: product,
                      onTap: () {
                        context.nav.pushNamed(
                            Routes.getProductDetailsRouteName(
                              AppConstants.appServiceName,
                            ),
                            arguments: product.id);
                      },
                      onTapRemove: () {
                        // FIX: Use the new remove logic (Optimistic update)
                        ref.read(favoriteProductsControllerProvider.notifier)
                            .removeFavorite(product.id);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}