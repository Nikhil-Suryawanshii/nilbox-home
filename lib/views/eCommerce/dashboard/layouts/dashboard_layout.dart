// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
// import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
// import 'package:ready_ecommerce/gen/assets.gen.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
// import 'package:ready_ecommerce/utils/context_less_navigation.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';
// import 'package:ready_ecommerce/views/eCommerce/dashboard/components/app_bottom_navbar.dart';
// import 'package:ready_ecommerce/views/eCommerce/favourites/favourites_products_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/home/home_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/more/more_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/my_cart/my_cart_view.dart';

// class EcommerceDashboardLayout extends ConsumerStatefulWidget {
//   const EcommerceDashboardLayout({super.key});

//   @override
//   ConsumerState<EcommerceDashboardLayout> createState() =>
//       _EcommerceDashboardLayoutState();
// }

// class _EcommerceDashboardLayoutState
//     extends ConsumerState<EcommerceDashboardLayout> {
//   @override
//   void initState() {
//     _init();
//     super.initState();
//   }

//   _init() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(hiveServiceProvider).getAuthToken().then((token) {
//         if (token != null) {
//           print('This is a token: $token');
//           ref.read(cartController.notifier).getAllCarts();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pageController = ref.watch(bottomTabControllerProvider);

//     return PopScope(
//       canPop: true,
//       onPopInvoked: (onPop) {
//         if (ref.read(selectedTabIndexProvider) != 0) {
//           ref.read(selectedTabIndexProvider.notifier).state = 0;
//           pageController.jumpToPage(0);
//         } else {
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         bottomNavigationBar: AppBottomNavbar(
//             bottomItem: getBottomItems(context: context),
//             onSelect: (index) {
//               if (index != null) {
//                 if (index == 2 &&
//                     !ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                   _warningDialog(ref: ref);
//                 } else {
//                   pageController.jumpToPage(index);
//                 }
//               }
//             }),
//         body: PageView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: pageController,
//           onPageChanged: (index) {
//             ref.read(selectedTabIndexProvider.notifier).state = index;
//           },
//           children: const [
//             EcommerceHomeView(),
//             EcommerceMyCartView(
//               isRoot: true,
//               isBuyNow: false,
//             ),
//             FavouritesProductsView(),
//             EcommerceMoreView()
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _warningDialog({required WidgetRef ref}) {
//   showDialog(
//     barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
//         .accentColor!
//         .withOpacity(0.8),
//     context: GlobalFunction.navigatorKey.currentContext!,
//     builder: (_) => ConfirmationDialog(
//       title: S.of(ContextLess.context).youAreNotLoggedIn,
//       confirmButtonText:
//           S.of(GlobalFunction.navigatorKey.currentContext!).login,
//       onPressed: () {
//         ref.refresh(selectedTabIndexProvider.notifier).state;
//         GlobalFunction.navigatorKey.currentContext!.nav
//             .pushNamedAndRemoveUntil(Routes.login, (route) => false);
//       },
//     ),
//   );
// }

// List<BottomItem> getBottomItems({required BuildContext context}) {
//   return [
//     BottomItem(
//       icon: Assets.svg.inactiveHome,
//       activeIcon: Assets.svg.activeHome,
//       name: S.of(context).home,
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveBag,
//       activeIcon: Assets.svg.activeBag,
//       name: S.of(context).myCart,
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveFavorite,
//       activeIcon: Assets.svg.activeFavorite,
//       name: S.of(context).favorites,
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveMore,
//       activeIcon: Assets.svg.activeMore,
//       name: S.of(context).more,
//     ),
//   ];
// }

// class BottomItem {
//   final String icon;
//   final String activeIcon;
//   final String name;
//   BottomItem({
//     required this.icon,
//     required this.activeIcon,
//     required this.name,
//   });
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
// import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
// import 'package:ready_ecommerce/gen/assets.gen.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
// import 'package:ready_ecommerce/utils/context_less_navigation.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';
// import 'package:ready_ecommerce/views/eCommerce/dashboard/components/app_bottom_navbar.dart';
// import 'package:ready_ecommerce/views/eCommerce/favourites/favourites_products_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/home/home_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/more/more_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/my_cart/my_cart_view.dart';
// // Ensure this import exists based on where you created the Sell view
// import 'package:ready_ecommerce/views/eCommerce/sell/sell_view.dart'; 

// class EcommerceDashboardLayout extends ConsumerStatefulWidget {
//   const EcommerceDashboardLayout({super.key});

//   @override
//   ConsumerState<EcommerceDashboardLayout> createState() =>
//       _EcommerceDashboardLayoutState();
// }

// class _EcommerceDashboardLayoutState
//     extends ConsumerState<EcommerceDashboardLayout> {
//   @override
//   void initState() {
//     _init();
//     super.initState();
//   }

//   _init() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(hiveServiceProvider).getAuthToken().then((token) {
//         if (token != null) {
//           ref.read(cartController.notifier).getAllCarts();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pageController = ref.watch(bottomTabControllerProvider);

//     return PopScope(
//       canPop: false, // Changed to false to handle custom logic
//       onPopInvoked: (didPop) {
//         if (didPop) return;
//         if (ref.read(selectedTabIndexProvider) != 0) {
//           ref.read(selectedTabIndexProvider.notifier).state = 0;
//           pageController.jumpToPage(0);
//         } else {
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         bottomNavigationBar: AppBottomNavbar(
//             bottomItem: getBottomItems(context: context),
//             onSelect: (index) {
//               if (index != null) {
//                 // index 3 is now Favorites (shifted from 2)
//                 if ((index == 2 || index == 3) &&
//                     !ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                   _warningDialog(ref: ref);
//                 } else {
//                   pageController.jumpToPage(index);
//                 }
//               }
//             }),
//         body: PageView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: pageController,
//           onPageChanged: (index) {
//             ref.read(selectedTabIndexProvider.notifier).state = index;
//           },
//           children: const [
//             EcommerceHomeView(), // Index 0
//             EcommerceMyCartView( // Index 1
//               isRoot: true,
//               isBuyNow: false,
//             ),
//             EcommerceSellView(), // Index 2 (NEW)
//             FavouritesProductsView(), // Index 3 (Shifted)
//             EcommerceMoreView() // Index 4 (Shifted)
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _warningDialog({required WidgetRef ref}) {
//   showDialog(
//     barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
//         .accentColor!
//         .withOpacity(0.8),
//     context: GlobalFunction.navigatorKey.currentContext!,
//     builder: (_) => ConfirmationDialog(
//       title: S.of(ContextLess.context).youAreNotLoggedIn,
//       confirmButtonText:
//           S.of(GlobalFunction.navigatorKey.currentContext!).login,
//       onPressed: () {
//         ref.refresh(selectedTabIndexProvider.notifier).state;
//         GlobalFunction.navigatorKey.currentContext!.nav
//             .pushNamedAndRemoveUntil(Routes.login, (route) => false);
//       },
//     ),
//   );
// }

// List<BottomItem> getBottomItems({required BuildContext context}) {
//   return [
//     BottomItem(
//       icon: Assets.svg.inactiveHome,
//       activeIcon: Assets.svg.activeHome,
//       name: S.of(context).home,
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveBag,
//       activeIcon: Assets.svg.activeBag,
//       name: S.of(context).myCart,
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveSell, // Make sure these are in your Assets.gen
//       activeIcon: Assets.svg.activeSell,
//       name: "Sell", 
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveFavorite,
//       activeIcon: Assets.svg.activeFavorite,
//       name: S.of(context).favorites,
//     ),
//     BottomItem(
//       icon: Assets.svg.inactiveMore,
//       activeIcon: Assets.svg.activeMore,
//       name: S.of(context).more,
//     ),
//   ];
// }

// class BottomItem {
//   final String icon;
//   final String activeIcon;
//   final String name;
//   BottomItem({
//     required this.icon,
//     required this.activeIcon,
//     required this.name,
//   });
// }


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
// import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
// import 'package:ready_ecommerce/gen/assets.gen.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/providers/seller/common_provider.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
// import 'package:ready_ecommerce/utils/context_less_navigation.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/views/eCommerce/dashboard/components/app_bottom_navbar.dart';
// import 'package:ready_ecommerce/views/eCommerce/favourites/favourites_products_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/home/home_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/more/more_view.dart';
// import 'package:ready_ecommerce/views/eCommerce/my_cart/my_cart_view.dart';
// import 'package:ready_ecommerce/views/seller/auth/seller_auth_gate_view.dart'; // Ensure this path is correct

// class EcommerceDashboardLayout extends ConsumerStatefulWidget {
//   const EcommerceDashboardLayout({super.key});

//   @override
//   ConsumerState<EcommerceDashboardLayout> createState() =>
//       _EcommerceDashboardLayoutState();
// }

// class _EcommerceDashboardLayoutState
//     extends ConsumerState<EcommerceDashboardLayout> {
//   @override
//   void initState() {
//     _init();
//     super.initState();
//   }

//   _init() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(hiveServiceProvider).getAuthToken().then((token) {
//         if (token != null) {
//           ref.read(cartController.notifier).getAllCarts();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pageController = ref.watch(bottomTabControllerProvider);

//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         if (didPop) return;
//         if (ref.read(selectedTabIndexProvider) != 0) {
//           ref.read(selectedTabIndexProvider.notifier).state = 0;
//           pageController.jumpToPage(0);
//         } else {
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         bottomNavigationBar: AppBottomNavbar(
//             bottomItem: getBottomItems(context: context),
//             onSelect: (index) {
//               if (index != null) {
//                 // Index 3 is Favorites (Shifted). Requires Customer Login.
//                 if (index == 3 &&
//                     !ref.read(hiveServiceProvider).userIsLoggedIn()) {
//                   _warningDialog(ref: ref);
//                 } 
//                 else {
//                   pageController.jumpToPage(index);
//                 }
//               }
//             }),
//         body: PageView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: pageController,
//           onPageChanged: (index) {
//             ref.read(selectedTabIndexProvider.notifier).state = index;
//           },
//           children: const [
//             EcommerceHomeView(),        // Index 0
//             EcommerceMyCartView(       // Index 1
//               isRoot: true,
//               isBuyNow: false,
//             ),
//             SellerAuthGateView(),      // Index 2 (The new Seller entry point)
//             FavouritesProductsView(),  // Index 3
//             EcommerceMoreView()        // Index 4
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/views/eCommerce/dashboard/components/app_bottom_navbar.dart';
import 'package:ready_ecommerce/views/eCommerce/favourites/favourites_products_view.dart';
import 'package:ready_ecommerce/views/eCommerce/home/home_view.dart';
import 'package:ready_ecommerce/views/eCommerce/more/more_view.dart';
import 'package:ready_ecommerce/views/eCommerce/my_cart/my_cart_view.dart';
import 'package:ready_ecommerce/views/seller/dashboard/seller_dashboard_wrapper.dart';

import '../../../seller/auth/seller_auth_gate_view.dart';
import '../../../seller/dashboard/my_message/my_message_view.dart';
import '../../../seller/dashboard/product_management/add_product_view.dart';
import '../../home/layouts/home_view_layout.dart';
import '../../my_message/my_message_view.dart';
import '../../shops/shop_view.dart';
import '../../shops/shops_view.dart'; // Create this wrapper

class EcommerceDashboardLayout extends ConsumerStatefulWidget {
  const EcommerceDashboardLayout({super.key});

  @override
  ConsumerState<EcommerceDashboardLayout> createState() =>
      _EcommerceDashboardLayoutState();
}

// class _EcommerceDashboardLayoutState
//     extends ConsumerState<EcommerceDashboardLayout> {
//
//
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//
//   _init() {
//     // FIX: Reset the tab index to 0 explicitly when Dashboard loads
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(selectedTabIndexProvider.notifier).state = 0;
//
//       ref.read(hiveServiceProvider).getAuthToken().then((token) {
//         if (token != null) {
//           ref.read(cartController.notifier).getAllCarts();
//         }
//       });
//     });
//   }
//
//   // void _onItemTapped(int index, PageController pageController) {
//   //   final currentSelected = ref.read(selectedTabIndexProvider);
//   //
//   //   // 1. Logic for Home/Rocket Tab
//   //   if (index == 0) {
//   //     if (currentSelected == 0) {
//   //       // If already on Home, scroll to top
//   //       // FIX: Verify clients exist before animating to prevent errors
//   //       final homeScrollController = ref.read(homeScrollControllerProvider);
//   //       if (homeScrollController.hasClients) {
//   //         homeScrollController.animateTo(
//   //           0,
//   //           duration: const Duration(milliseconds: 500),
//   //           curve: Curves.easeOutQuart,
//   //         );
//   //       }
//   //     } else {
//   //       // Switching from another tab
//   //       pageController.jumpToPage(0);
//   //       ref.read(selectedTabIndexProvider.notifier).state = 0;
//   //     }
//   //     return;
//   //   }
//   //
//   //   // 2. Logic for Favorites/Chat (Auth Check)
//   //   // Assuming Chat is index 1 or 2, and Favorites is 3
//   //   if ((index == 1 || index == 3) && !ref.read(hiveServiceProvider).userIsLoggedIn()) {
//   //     // Add logic for Chat auth check if needed, otherwise just Favorites
//   //     if(index == 3) {
//   //       _warningDialog(ref: ref);
//   //       return;
//   //     }
//   //   }
//   //
//   //   // 3. Standard Navigation
//   //   ref.read(selectedTabIndexProvider.notifier).state = index;
//   //   pageController.jumpToPage(index);
//   // }
//   // ... inside _EcommerceDashboardLayoutState
//
//   void _onItemTapped(int index, PageController pageController) {
//     print('spider');
//     final currentSelected = ref.read(selectedTabIndexProvider);
//
//     // 1. Logic for Home/Rocket Tab
//     if (index == 0) {
//       if (currentSelected == 0) {
//         // If already on Home, trigger the scroll-to-top event
//         ref.read(homeScrollTriggerProvider.notifier).state++;
//       } else {
//         // Switching from another tab
//         pageController.jumpToPage(0);
//         ref.read(selectedTabIndexProvider.notifier).state = 0;
//       }
//       return;
//     }
//
//     // ... keep the rest of your existing logic for other tabs ...
//     if ((index == 1 || index == 3) && !ref.read(hiveServiceProvider).userIsLoggedIn()) {
//       if(index == 3) {
//         _warningDialog(ref: ref);
//         return;
//       }
//     }
//
//     ref.read(selectedTabIndexProvider.notifier).state = index;
//     pageController.jumpToPage(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final pageController = ref.watch(bottomTabControllerProvider);
//
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         if (didPop) return;
//         if (ref.read(selectedTabIndexProvider) != 0) {
//           ref.read(selectedTabIndexProvider.notifier).state = 0;
//           pageController.jumpToPage(0);
//         } else {
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         bottomNavigationBar: Consumer(
//           builder: (context, ref, child) {
//             final isScrolled = ref.watch(isHomeScrolledProvider);
//             // Watch index to rebuild navbar when tab changes
//             final currentIndex = ref.watch(selectedTabIndexProvider);
//
//             return AppBottomNavbar(
//               // Pass currentIndex if your AppBottomNavbar supports it to highlight icon
//               bottomItem: getBottomItems(context: context, isScrolled: isScrolled),
//               onSelect: (index) {
//                 if (index != null) _onItemTapped(index, pageController);
//               },
//             );
//           },
//         ),
//         body: PageView(
//           physics: const NeverScrollableScrollPhysics(),
//           controller: pageController,
//           onPageChanged: (index) {
//             // FIX: Ensure provider syncs if PageView is swiped (though physics is disabled here)
//             ref.read(selectedTabIndexProvider.notifier).state = index;
//           },
//           children: const [
//             EcommerceHomeViewLayout(), // Ensure this matches your Class name
//             MyMessageView(),
//             EcommerceShopsView(),
//             FavouritesProductsView(),
//           ],
//         ),
//       ),
//     );
//   }
// }



class _EcommerceDashboardLayoutState
    extends ConsumerState<EcommerceDashboardLayout> {

  // 1. Define Controller Locally
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // 2. Initialize it
    _pageController = PageController();
    _init();
  }

  @override
  void dispose() {
    // 3. Dispose it (Crucial to prevent memory leaks)
    _pageController.dispose();
    super.dispose();
  }

  _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Reset tab index to 0 on load
      ref.read(selectedTabIndexProvider.notifier).state = 0;

      ref.read(hiveServiceProvider).getAuthToken().then((token) {
        if (token != null) {
          ref.read(cartController.notifier).getAllCarts();
        }
      });
    });
  }



  void onItemTapped(int index) {
    final currentSelected = ref.read(selectedTabIndexProvider);

    // 1. Logic for Home/Rocket Tab
    if (index == 0) {
      if (currentSelected == 0) {
        // Trigger Scroll to Top using the provider we added earlier
        ref.read(homeScrollTriggerProvider.notifier).state++;
      } else {
        _pageController.jumpToPage(0);
        ref.read(selectedTabIndexProvider.notifier).state = 0;
      }
      return;
    }

    // 2. Logic for Favorites (Auth Check)
    if ((index == 1 || index == 3) && !ref.read(hiveServiceProvider).userIsLoggedIn()) {
      if(index == 1 || index == 3 ) {
        // Assuming you have this method defined somewhere in your file
        _warningDialog(ref: ref);
        return;
      }
    }

    // 3. Standard Navigation
    ref.read(selectedTabIndexProvider.notifier).state = index;
    _pageController.jumpToPage(index);
  }

  Future<void> _onSellTap(BuildContext context) async {
    final token = await ref.read(sellerHiveServiceProvider).getToken();
    final bool isSellerLoggedIn = token != null && token.isNotEmpty;

    if (!context.mounted) return;

    if (isSellerLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EcommerceAddProductView(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SellerAuthGateView(),
        ),
      );
    }
  }

  Widget _buildSellFab(BuildContext context) {
    // iOS-only overlay FAB (Android Sell is built into the docked bar).
    return GestureDetector(
      onTap: () => _onSellTap(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 4.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF57C00),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.svg.camera,
                    width: 22,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sell',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    // Remove the ref.watch(bottomTabControllerProvider)

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (ref.read(selectedTabIndexProvider) != 0) {
          ref.read(selectedTabIndexProvider.notifier).state = 0;
          _pageController.jumpToPage(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppBottomNavbar.isAndroid
            ? const SystemUiOverlayStyle(
                systemNavigationBarColor: Color(0xFF000000),
                systemNavigationBarDividerColor: Color(0xFF000000),
                systemNavigationBarIconBrightness: Brightness.light,
                systemNavigationBarContrastEnforced: false,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              )
            : const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
              ),
        child: Scaffold(
        // Allow Sell FAB to paint slightly above the bar without a spacer.
        extendBody: true,
        backgroundColor: AppBottomNavbar.isAndroid
            ? Colors.white
            : Colors.transparent,
        resizeToAvoidBottomInset: false,
        // floatingActionButtonLocation:
        // FloatingActionButtonLocation.centerDocked,
        //
        // floatingActionButton: _buildSellFab(context),
        bottomNavigationBar: Consumer(
          builder: (context, ref, child) {
            final isScrolled = ref.watch(isHomeScrolledProvider);
            ref.watch(selectedTabIndexProvider);

            final items = getBottomItems(
              context: context,
              isScrolled: isScrolled,
            );

            // Android: self-contained docked bar (Sell FAB included, flush on system nav)
            if (AppBottomNavbar.isAndroid) {
              return AppBottomNavbar(
                bottomItem: items,
                onSelect: (index) {
                  if (index != null) onItemTapped(index);
                },
                onSellTap: () => _onSellTap(context),
              );
            }

            // iOS: glass pill + separate raised Sell FAB
            final bottomMargin = AppBottomNavbar.bottomSafeMargin(context);
            return SizedBox(
              height: AppBottomNavbar.shellHeight(context),
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 25.h,
                      bottom: bottomMargin,
                    ),
                    child: AppBottomNavbar(
                      bottomItem: items,
                      onSelect: (index) {
                        if (index != null) onItemTapped(index);
                      },
                      onSellTap: () => _onSellTap(context),
                    ),
                  ),
                  Positioned(
                    bottom: AppBottomNavbar.sellFabBottom(context),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: _buildSellFab(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        body: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController, // Use local controller
              onPageChanged: (index) {
                ref.read(selectedTabIndexProvider.notifier).state = index;
              },
              children: const [
                EcommerceHomeViewLayout(),
                MyMessageView(),
                EcommerceShopsView(),
                FavouritesProductsView(),
              ],
            ),
            // Positioned(
            //   bottom: -55, // adjust for navbar height
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: _buildSellFab(context),
            //   ),
            // ),
          ],
        ),
      ),
      ),
    );
  }
}

void _warningDialog({required WidgetRef ref}) {
  showDialog(
    barrierColor: colors(GlobalFunction.navigatorKey.currentContext!)
        .accentColor!
        .withOpacity(0.8),
    context: GlobalFunction.navigatorKey.currentContext!,
    builder: (_) => ConfirmationDialog(
      title: S.of(ContextLess.context).youAreNotLoggedIn,
      confirmButtonText:
      S.of(GlobalFunction.navigatorKey.currentContext!).login,
      onPressed: () {
        ref.refresh(selectedTabIndexProvider.notifier).state;
        GlobalFunction.navigatorKey.currentContext!.nav
            .pushNamedAndRemoveUntil(Routes.login, (route) => false);
      },
    ),
  );
}

List<BottomItem> getBottomItems({required BuildContext context, required bool isScrolled}) {
  return [
    BottomItem(
      icon: Assets.svg.inactiveHome,
      activeIcon: isScrolled ? Assets.svg.inactiveRocket : Assets.svg.activeHome,
      name: S.of(context).home,
      // name: 'Products',
    ),
    BottomItem(
      icon: Assets.svg.shopChats,
      activeIcon: Assets.svg.shopChats,
      // name: S.of(context).home,
      name: 'Chats',
    ),
    BottomItem(
      icon: Assets.svg.activeShop,
      activeIcon: Assets.svg.activeShop,
      // name: S.of(context).myCart,
      name: 'Shops',
    ),
    // BottomItem(
    //   icon: Assets.svg.inactiveSell, // Verify these exist in your assets folder
    //   activeIcon: Assets.svg.activeSell,
    //   name: "Sell",
    // ),
    BottomItem(
      icon: Assets.svg.inactiveFavorite,
      activeIcon: Assets.svg.activeFavorite,
      name: S.of(context).favorites,
    ),
    // BottomItem(
    //   icon: Assets.svg.inactiveProfile,
    //   activeIcon: Assets.svg.inactiveProfile,
    //   // name: S.of(context).more,
    //   name: 'Profile',
    // ),
  ];
}

class BottomItem {
  final String icon;
  final String activeIcon;
  final String name;
  BottomItem({
    required this.icon,
    required this.activeIcon,
    required this.name,
  });
}