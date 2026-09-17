import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/confirmation_dialog.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/authentication/authentication_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/cart/cart_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/message/message_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/authentication/user.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/shop.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/dashboard/components/app_bottom_navbar.dart';
import 'package:ready_ecommerce/views/eCommerce/dashboard/layouts/dashboard_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../providers/seller/common_provider.dart';
import '../../../common/authentication/facebook/facebook_auth_service.dart';
import '../../../common/authentication/google/google_auth_service.dart';

class EcommerceMoreLayout extends ConsumerStatefulWidget {
  const EcommerceMoreLayout({super.key});

  @override
  ConsumerState<EcommerceMoreLayout> createState() =>
      _EcommerceMoreLayoutState();
}

class _EcommerceMoreLayoutState extends ConsumerState<EcommerceMoreLayout> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getTotalUnreadMessagesControllerProvider.notifier)
          .getTotalUnreadMessages();
    });
  }

  Future<void> _performLogout(BuildContext context) async {
    // Show confirmation dialog first
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierColor: colors(context).accentColor!.withOpacity(0.8),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          return ConfirmationDialog(
            title: S.of(context).logoutDialogTitle,
            des: S.of(context).logoutDialogDes,
            confirmButtonText: S.of(context).confirm,
            cancelButtonText: S.of(context).cancel,
            onPressed: () => Navigator.of(context).pop(true),
            isLoading: ref.watch(authControllerProvider),
          );
        },
      ),
    );

    if (shouldLogout != true) return;

    try {
      // Sign out from Google if using Google Auth
      await ref.read(googleAuthServiceProvider).signOut();
      try {
        await ref.read(facebookAuthServiceProvider).logout();
      } catch (e) {
        debugPrint('Facebook logout skipped: $e');
      }

      // Perform logout from API
      final response = await ref.read(authControllerProvider.notifier).logout();

      if (response.isSuccess) {
        // Clear all local data
        await ref.read(hiveServiceProvider).removeAllData();

        // Clear cart
        ref.read(cartController).cartItems.clear();

        // Reset tab index
        ref.read(selectedTabIndexProvider.notifier).state = 0;

        // Navigate to login screen
        // ignore: use_build_context_synchronously
        context.nav.pushNamedAndRemoveUntil(
          Routes.login,
              (route) => false,
        );
      } else {
        // Show error message if logout failed
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Logout failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Row(
          children: [
            Gap(20.w),
            Center(
              child: SizedBox(
                height: 42.h,
                width: 42.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors(context).accentColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18.sp,
                    onPressed: () {
                      context.nav.pop();
                    },
                    icon: const Icon(Icons.dangerous_outlined),
                  ),
                ),
              ),
            ),
            Gap(20.w),
            Text("Settings",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ))
          ],
        ),
      ),
      // bottomNavigationBar: Consumer(
      //   builder: (context, ref, child) {
      //     final isScrolled = ref.watch(isHomeScrolledProvider);
      //     // Watch this to rebuild navbar colors
      //     ref.watch(selectedTabIndexProvider);

      //     return AppBottomNavbar(
      //       bottomItem:
      //           getBottomItems(context: context, isScrolled: isScrolled),
      //       onSelect: (index) {},
      //     );
      //   },
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: GlobalFunction.getContainerColor(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w)
                      .copyWith(top: 20.h),
                  child: ref.read(hiveServiceProvider).userIsLoggedIn()
                      ? _buildProfileContainer(context)
                      : userInfoWidget(
                          user: User(
                              id: null,
                              name: S.of(context).guest,
                              phone: '01472*****',
                              email: '',
                              isActive: true,
                              profilePhoto:
                                  'https://m.media-amazon.com/images/I/31jPSK41kEL._AC_UF1000,1000_QL80_.jpg',
                              gender: 'Male',
                              dateOfBirth: ''),
                          context: context,
                          onLogin: () async {
                            context.nav.pushNamedAndRemoveUntil(
                                Routes.login, (route) => false);
                          },
                          onLogout: () async {
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            showDialog(
                                context: context,
                                barrierColor: colors(context)
                                    .accentColor!
                                    .withOpacity(0.8),
                                builder: (context) =>
                                    Consumer(builder: (context, ref, _) {
                                      return ConfirmationDialog(
                                          title:
                                              S.of(context).logoutDialogTitle,
                                          des: S.of(context).logoutDialogDes,
                                          confirmButtonText:
                                              S.of(context).confirm,
                                          onPressed: () {
                                            ref
                                                .read(authControllerProvider
                                                    .notifier)
                                                .logout()
                                                .then((response) {
                                              if (response.isSuccess) {
                                                ref
                                                    .read(hiveServiceProvider)
                                                    .removeAllData()
                                                    .then((value) async {
                                                  ref
                                                      .watch(cartController)
                                                      .cartItems
                                                      .clear();
                                                  ref
                                                      .refresh(
                                                          selectedTabIndexProvider
                                                              .notifier)
                                                      .state;
                                                  // ignore: use_build_context_synchronously
                                                  context.nav.pop();
                                                  // ignore: use_build_context_synchronously
                                                  context.nav
                                                      .pushReplacementNamed(
                                                          Routes.login);
                                                });
                                              }
                                            });
                                          });
                                    }));
                          },
                        ),
                ),

                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
                //     top: ref.read(hiveServiceProvider).userIsLoggedIn()
                //         ? 20.h
                //         : 40.h,
                //   ),
                //   color: GlobalFunction.getContainerColor(),
                //   child: AnimationLimiter(
                //     child: Column(
                //       children: AnimationConfiguration.toStaggeredList(
                //         duration: const Duration(milliseconds: 375),
                //         childAnimationBuilder: (widget) => SlideAnimation(
                //             verticalOffset: 50.h,
                //             child: FadeInAnimation(child: widget)),
                //         children: [
                //           ValueListenableBuilder(
                //               valueListenable:
                //                   Hive.box(AppConstants.appSettingsBox)
                //                       .listenable(),
                //               builder: (context, box, _) {
                //                 final isDark = box.get(
                //                     AppConstants.isDarkTheme,
                //                     defaultValue: false) as bool;
                //                 return Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   children: [
                //                     Text(
                //                       S.of(context).themeMode,
                //                       style: AppTextStyle(context)
                //                           .bodyTextSmall
                //                           .copyWith(fontSize: 16.sp),
                //                     ),
                //                     Gap(8.w),
                //                     Switch(
                //                         value: isDark,
                //                         onChanged: (value) {
                //                           ref
                //                               .read(hiveServiceProvider)
                //                               .setAppTheme(
                //                                   isDarkTheme: value);
                //                         }),
                //                   ],
                //                 );
                //               }),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.profile,
                //                 text: S.of(context).myProfile,
                //                 onTap: () {
                //                   context.nav.pushNamed(
                //                       Routes.getProfileViewRouteName(
                //                           AppConstants.appServiceName));
                //                 },
                //               ),
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.bag,
                //                 text: S.of(context).orders,
                //                 onTap: () {
                //                   context.nav.pushNamed(
                //                       Routes.getMyOrderViewRouteName(
                //                           AppConstants.appServiceName));
                //                 },
                //               ),
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.bag,
                //                 text: S.of(context).myDigitalProducts,
                //                 onTap: () {
                //                   context.nav.pushNamed(
                //                       Routes.getMyOrderViewRouteName(
                //                           AppConstants.appServiceName),
                //                       arguments: 'digital');
                //                 },
                //               ),
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: "assets/svg/money-change.svg",
                //                 text: S.of(context).returnOrders,
                //                 onTap: () {
                //                   context.nav.pushNamed(
                //                       Routes.getReturnOrderListViewRouteName(
                //                           AppConstants.appServiceName));
                //                 },
                //               ),
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: Stack(
                //                 children: [
                //                   _buildProfileItem(
                //                     context: context,
                //                     icon: Assets.svg.message,
                //                     text: S.of(context).message,
                //                     onTap: () {
                //                       context.nav.pushNamed(
                //                           Routes.getMyMessageViewRouteName(
                //                               AppConstants.appServiceName));
                //                     },
                //                   ),
                //                   ref
                //                       .watch(
                //                           getTotalUnreadMessagesControllerProvider)
                //                       .when(
                //                         data: (data) {
                //                           if (data == 0) return Container();
                //                           return Positioned(
                //                             top: 0,
                //                             right: 60.w,
                //                             // left: 0,
                //                             bottom: 0,
                //                             child: Container(
                //                               // width: 10.w,
                //                               // height: 10.w,
                //                               padding: EdgeInsets.all(6.w),
                //                               decoration: BoxDecoration(
                //                                 color: colors(context)
                //                                     .primaryColor!
                //                                     .withValues(alpha: 0.2),
                //                                 shape: BoxShape.circle,
                //                               ),
                //                               child: Center(
                //                                 child: Text(
                //                                   data.toString(),
                //                                   style: AppTextStyle(context)
                //                                       .bodyText
                //                                       .copyWith(
                //                                           color: colors(
                //                                                   context)
                //                                               .primaryColor!),
                //                                 ),
                //                               ),
                //                             ),
                //                           );
                //                         },
                //                         error: (error, stackTrace) =>
                //                             const SizedBox(),
                //                         loading: () => const SizedBox(),
                //                       ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //           // Visibility(
                //           //   visible: ref
                //           //       .read(hiveServiceProvider)
                //           //       .userIsLoggedIn(),
                //           //   child: Padding(
                //           //     padding: EdgeInsets.only(top: 8.h),
                //           //     child: _buildProfileItem(
                //           //       context: context,
                //           //       icon: Assets.svg.notification,
                //           //       text: 'Notifications',
                //           //       onTap: () {
                //           //         context.nav.pushNamed(
                //           //             Routes.getNotificationRouteName(
                //           //                 AppConstants.appServiceName));
                //           //       },
                //           //     ),
                //           //   ),
                //           // ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.support,
                //                 text: S.of(context).support,
                //                 onTap: () {
                //                   context.nav.pushNamed(Routes.supportView);
                //                 },
                //               ),
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.heart,
                //                 text: S.of(context).wishlist,
                //                 onTap: () {
                //                   context.nav.pushNamed(Routes
                //                       .getFavouritesProductsViewRouteName(
                //                           AppConstants.appServiceName));
                //                 },
                //               ),
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.location,
                //                 text: S.of(context).manageAddress,
                //                 onTap: () {
                //                   context.nav.pushNamed(
                //                       Routes.getManageAddressViewRouteName(
                //                           AppConstants.appServiceName));
                //                 },
                //               ),
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.only(top: 8.h),
                //             child: _buildProfileItem(
                //               context: context,
                //               icon: Assets.svg.blog,
                //               text: 'Blog',
                //               onTap: () {
                //                 context.nav.pushNamed(Routes.bogs);
                //               },
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.only(top: 8.h),
                //             child: _buildProfileItem(
                //               context: context,
                //               icon: Assets.svg.translate,
                //               text: S.of(context).language,
                //               onTap: () {
                //                 context.nav.pushNamed(Routes.languageView);
                //               },
                //             ),
                //           ),
                //           Padding(
                //             padding: EdgeInsets.only(top: 8.h),
                //             child: _buildProfileItem(
                //               context: context,
                //               icon: Assets.svg.currency,
                //               text: S.of(context).currency,
                //               onTap: () {
                //                 context.nav.pushNamed(Routes.currencyView);
                //               },
                //             ),
                //           ),
                //           Visibility(
                //             visible: ref
                //                 .read(hiveServiceProvider)
                //                 .userIsLoggedIn(),
                //             child: Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.key,
                //                 text: S.of(context).changePassword,
                //                 onTap: () {
                //                   context.nav
                //                       .pushNamed(Routes.changePassword);
                //                 },
                //               ),
                //             ),
                //           ),
                //           Gap(8.h),
                //           _buildProfileItem(
                //             context: context,
                //             icon: Assets.svg.refund,
                //             text: S.of(context).refundPolicy,
                //             onTap: () {
                //               context.nav.pushNamed(Routes.refundPolicyView);
                //             },
                //           ),
                //           Gap(8.h),
                //           _buildProfileItem(
                //             context: context,
                //             icon: Assets.svg.terms,
                //             text: S.of(context).termsCondistions,
                //             onTap: () {
                //               context.nav
                //                   .pushNamed(Routes.termsAndConditionsView);
                //             },
                //           ),
                //           Gap(8.h),
                //           _buildProfileItem(
                //             context: context,
                //             icon: Assets.svg.privacy,
                //             text: S.of(context).privacyPolicy,
                //             onTap: () {
                //               context.nav.pushNamed(Routes.privacyPolicyView);
                //             },
                //           ),
                //           Gap(20.h),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
                    top: ref.read(hiveServiceProvider).userIsLoggedIn()
                        ? 20.h
                        : 40.h,
                  ),
                  color: GlobalFunction.getContainerColor(),
                  child: Column(
                    children: [
                      // ValueListenableBuilder(
                      //   valueListenable: Hive.box(AppConstants.appSettingsBox)
                      //       .listenable(),
                      //   builder: (context, box, _) {
                      //     final isDark = box.get(AppConstants.isDarkTheme,
                      //         defaultValue: false) as bool;
                      //     // return Row(
                      //     //   mainAxisAlignment: MainAxisAlignment.end,
                      //     //   children: [
                      //     //     Text(
                      //     //       S.of(context).themeMode,
                      //     //       style: AppTextStyle(context)
                      //     //           .bodyTextSmall
                      //     //           .copyWith(fontSize: 16.sp),
                      //     //     ),
                      //     //     Gap(8.w),
                      //     //     // Switch(
                      //     //     //   value: isDark,
                      //     //     //   onChanged: (value) {
                      //     //     //     ref
                      //     //     //         .read(hiveServiceProvider)
                      //     //     //         .setAppTheme(isDarkTheme: value);
                      //     //     //   },
                      //     //     // ),
                      //     //   ],
                      //     // );
                      //   },
                      // ),
                      _buildProfileGrid(context),
                      Gap(20.h),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 10.h)
                //       .copyWith(bottom: 30.h),
                //   color: Theme.of(context).scaffoldBackgroundColor,
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 20.w,
                //     vertical: 20.h,
                //   ),
                //   child: ref.read(hiveServiceProvider).userIsLoggedIn() == false
                //       ? Text("")
                //       : Column(
                //           children: [
                //             _buildProfileItem(
                //               context: context,
                //               icon: Assets.svg.logout,
                //               text: S.of(context).logout,
                //               onTap: () {
                //                 showDialog(
                //                   context: context,
                //                   barrierColor: colors(context)
                //                       .accentColor!
                //                       .withOpacity(0.8),
                //                   builder: (context) =>
                //                       Consumer(builder: (context, ref, _) {
                //                     return ConfirmationDialog(
                //                       title: S.of(context).logoutDialogTitle,
                //                       des: S.of(context).logoutDialogDes,
                //                       confirmButtonText: S.of(context).confirm,
                //                       onPressed: () {
                //                         ref
                //                             .read(
                //                                 authControllerProvider.notifier)
                //                             .logout()
                //                             .then((response) {
                //                           if (response.isSuccess) {
                //                             ref
                //                                 .read(hiveServiceProvider)
                //                                 .removeAllData()
                //                                 .then(
                //                               (value) async {
                //                                 ref
                //                                     .watch(cartController)
                //                                     .cartItems
                //                                     .clear();
                //                                 ref
                //                                     .refresh(
                //                                         selectedTabIndexProvider
                //                                             .notifier)
                //                                     .state;
                //                                 // ignore: use_build_context_synchronously
                //                                 context.nav.pop();
                //                                 // ignore: use_build_context_synchronously
                //                                 context.nav
                //                                     .pushReplacementNamed(
                //                                         Routes.login);
                //                               },
                //                             );
                //                           }
                //                         });
                //                       },
                //                       isLoading:
                //                           ref.watch(authControllerProvider),
                //                     );
                //                   }),
                //                 );
                //               },
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(top: 8.h),
                //               child: _buildProfileItem(
                //                 context: context,
                //                 icon: Assets.svg.trash,
                //                 text: S.of(context).deleteAccount,
                //                 onTap: () {
                //                   showDialog(
                //                     context: context,
                //                     barrierColor: colors(context)
                //                         .accentColor!
                //                         .withOpacity(0.8),
                //                     builder: (context) =>
                //                         Consumer(builder: (context, ref, _) {
                //                       return ConfirmationDialog(
                //                         title: S.of(context).deleteAccount,
                //                         des: S.of(context).deleteAccountDes,
                //                         confirmButtonText:
                //                             S.of(context).confirm,
                //                         onPressed: () =>
                //                             _confirmDeleteAccount(context),
                //                         isLoading:
                //                             ref.watch(authControllerProvider),
                //                       );
                //                     }),
                //                   );
                //                 },
                //               ),
                //             ),
                //           ],
                //         ),
                // )
              ],
            ),
          ),
          // Positioned(
          //   top: 30.h,
          //   left: 20.w,
          //   right: 20.w,
          //   child: _buildProfileContainer(context),
          // )
        ],
      ),
    );
  }

  // Widget _buildProfileContainer(BuildContext context) {
  //   final isLoggedIn = ref.read(hiveServiceProvider).userIsLoggedIn();
  //   return ValueListenableBuilder(
  //       valueListenable: Hive.box(AppConstants.userBox).listenable(),
  //       builder: (context, box, _) {
  //         Map<dynamic, dynamic>? userInfo = box.get(AppConstants.userData);
  //         Map<String, dynamic> userInfoStringKeys =
  //             userInfo!.cast<String, dynamic>();
  //         final User user = User.fromMap(userInfoStringKeys);
  //
  //         return userInfoWidget(
  //           context: context,
  //           user: user,
  //           isLoggedIn: isLoggedIn,
  //           onLogin: () {
  //             context.nav.pushNamed(Routes.login);
  //           },
  //           onLogout: () {
  //             context.nav.pushNamedAndRemoveUntil(Routes.login, (_) => false);
  //           },
  //         );
  //       });
  // }

  Widget _buildProfileContainer(BuildContext context) {
    final isLoggedIn = ref.read(hiveServiceProvider).userIsLoggedIn();
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppConstants.userBox).listenable(),
        builder: (context, box, _) {
          Map<dynamic, dynamic>? userInfo = box.get(AppConstants.userData);
          if (userInfo == null) {
            return userInfoWidget(
              context: context,
              user: User(
                id: null,
                name: S.of(context).guest,
                phone: '',
                email: '',
                isActive: false,
                profilePhoto: '',
                gender: '',
                dateOfBirth: '',
              ),
              isLoggedIn: false,
              onLogin: () {
                context.nav.pushNamed(Routes.login);
              },
              onLogout: () => _performLogout(context),
            );
          }

          Map<String, dynamic> userInfoStringKeys =
          userInfo.cast<String, dynamic>();
          final User user = User.fromMap(userInfoStringKeys);

          return userInfoWidget(
            context: context,
            user: user,
            isLoggedIn: isLoggedIn,
            onLogin: () {
              context.nav.pushNamed(Routes.login);
            },
            onLogout: () => _performLogout(context),
          );
        });
  }

  // Container _userInfoWidget(User user, BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16),
  //       gradient: LinearGradient(
  //         colors: [EcommerceAppColor.primary, const Color(0xFFB822FF)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         transform: const GradientRotation(263 * (3.14159265359 / 30)),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Flexible(
  //           flex: 2,
  //           child: CircleAvatar(
  //             radius: 36.sp,
  //             backgroundImage: CachedNetworkImageProvider(user.profilePhoto!),
  //           ),
  //         ),
  //         Gap(10.w),
  //         Flexible(
  //           flex: 5,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 user.name!,
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //                 style: AppTextStyle(context)
  //                     .subTitle
  //                     .copyWith(color: EcommerceAppColor.white),
  //               ),
  //               Gap(8.h),
  //               Text(
  //                 user.phone!,
  //                 style: AppTextStyle(context).bodyTextSmall.copyWith(
  //                       color: EcommerceAppColor.white,
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //               )
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget userInfoWidget({
    required BuildContext context,
    User? user,
    bool? isLoggedIn,
    VoidCallback? onLogin,
    VoidCallback? onLogout,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          /// Profile Image
          Container(
            height: 115.h,
            width: 115.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: EcommerceAppColor.black,
                width: 0.4.w,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: EcommerceAppColor.black,
                      width: 0.4.w,
                    ),
                  ),
                  child: isLoggedIn ?? false || user?.profilePhoto != null
                      ? Icon(
                          Icons.person,
                          size: 32.sp,
                          color: EcommerceAppColor.primary,
                        )
                      : null,
                ),
              ),
            ),
          ),

          Gap(22.w),

          /// User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn ?? false ? user!.name! : 'Guest User',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context)
                      .subTitle
                      .copyWith(color: EcommerceAppColor.black),
                ),
                Gap(6.h),
                Text(
                  isLoggedIn ?? false
                      ? user?.phone ?? user?.email ?? ''
                      : 'Please login',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: EcommerceAppColor.black,
                      ),
                ),
                Gap(8.h),
                _AuthActionButton(
                  isLoggedIn: isLoggedIn,
                  onLogin: onLogin,
                  onLogout: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required BuildContext context,
    required String icon,
    required String text,
    Color? color,
    required void Function()? onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(24.r),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              // Decorative circles in background
              Positioned(
                right: -30.w,
                bottom: -30.w,
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(42, 0, 0, 0),
                      width: 1.w,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -20.w,
                top: -20.w,
                child: Container(
                  width: 55.w,
                  height: 125.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(42, 0, 0, 0),
                      width: 1.w,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon at the top
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      icon,
                      width: 20.w,
                      height: 20.w,
                      colorFilter: ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  // Text at the bottom
                  Text(
                    text,
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: Colors.black,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String profieImge =
      'https://media.istockphoto.com/id/1336647287/photo/portrait-of-handsome-indian-businessman-with-mustache-wearing-hat-against-plain-wall.jpg?s=612x612&w=0&k=20&c=XOuLIyFb2DBO8voUXecWkYNxwRrIMYcTRU4QlK9ILks=';

  void _confirmDeleteAccount(BuildContext context) {
    Navigator.of(context).pop(); // Dismiss the first dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Deletion Scheduled'),
          content: const Text(
              'Your account will be deleted automatically after 3 days.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.nav.pushNamedAndRemoveUntil(Routes.login,
                    (route) => false); // Dismiss the confirmation dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileGrid(BuildContext context) {
    final isLoggedIn = ref.read(hiveServiceProvider).userIsLoggedIn();
    final bool isSellerLoggedIn =  ref.read(sellerHiveServiceProvider).sellerIsLoggedIn();


    final List<Map<String, dynamic>> items = [
      if (isLoggedIn)
        {
          'icon': Assets.svg.profile,
          'text': S.of(context).myProfile,
          'color': Color(0xFFF3E5F5), // Light pink
          'onTap': () => context.nav.pushNamed(
              Routes.getProfileViewRouteName(AppConstants.appServiceName)),
        },
      if (isLoggedIn)
        {
          'icon': Assets.svg.bag,
          'text': S.of(context).orders,
          'color': Color(0xFFE8E3F3), // Light purple
          'onTap': () => context.nav.pushNamed(
              Routes.getMyOrderViewRouteName(AppConstants.appServiceName)),
        },
      if (isLoggedIn)
        {
          'icon': Assets.svg.bag,
          'text': S.of(context).myDigitalProducts,
          'color': Color(0xFFDFF5F2), // Light cyan
          'onTap': () => context.nav.pushNamed(
              Routes.getMyOrderViewRouteName(AppConstants.appServiceName),
              arguments: 'digital'),
        },
      if (isLoggedIn)
        {
          'icon': "assets/svg/money-change.svg",
          'text': S.of(context).returnOrders,
          'color': Color(0xFFE3EDFC), // Light blue
          'onTap': () => context.nav.pushNamed(
              Routes.getReturnOrderListViewRouteName(
                  AppConstants.appServiceName)),
        },
      if (isSellerLoggedIn)
        {
          'icon': "assets/svg/money-change.svg",
          'text': 'Seller Dashboard',
          'color': Color(0xFFFCF5E3), // Light blue
          'onTap': () => context.nav.pushNamed(
              Routes.sellerDashboard),
        },
      if (isLoggedIn)
        {
          'icon': Assets.svg.message,
          'text': S.of(context).message,
          'color': Color(0xFFFDE8E8), // Light peach
          'onTap': () => context.nav.pushNamed(
              Routes.getMyMessageViewRouteName(AppConstants.appServiceName)),
        },
      if (isLoggedIn)
        {
          'icon': Assets.svg.support,
          'text': S.of(context).support,
          'color': Color(0xFFF0E8F5), // Light lavender
          'onTap': () => context.nav.pushNamed(Routes.supportView),
        },
      if (isLoggedIn)
        {
          'icon': Assets.svg.heart,
          'text': S.of(context).wishlist,
          'color': Color(0xFFE0F5E8), // Light green
          'onTap': () => context.nav.pushNamed(
              Routes.getFavouritesProductsViewRouteName(
                  AppConstants.appServiceName)),
        },
      if (isLoggedIn)
        {
          'icon': Assets.svg.location,
          'text': S.of(context).manageAddress,
          'color': Color(0xFFFDE8F5), // Light pink
          'onTap': () => context.nav.pushNamed(
              Routes.getManageAddressViewRouteName(
                  AppConstants.appServiceName)),
        },
      {
        'icon': Assets.svg.blog,
        'text': 'Blog',
        'color': Color(0xFFE3F3FC), // Light sky blue
        'onTap': () => context.nav.pushNamed(Routes.bogs),
      },
      {
        'icon': Assets.svg.translate,
        'text': S.of(context).language,
        'color': Color(0xFFFFF4E0), // Light yellow
        'onTap': () => context.nav.pushNamed(Routes.languageView),
      },
      {
        'icon': Assets.svg.currency,
        'text': S.of(context).currency,
        'color': Color(0xFFE0F2F1), // Light teal
        'onTap': () => context.nav.pushNamed(Routes.currencyView),
      },
      if (isLoggedIn)
        {
          'icon': Assets.svg.key,
          'text': S.of(context).changePassword,
          'color': Color(0xFFFCE4EC), // Light rose
          'onTap': () => context.nav.pushNamed(Routes.changePassword),
        },
      {
        'icon': Assets.svg.refund,
        'text': S.of(context).refundPolicy,
        'color': Color(0xFFE8F5E9), // Light green
        'onTap': () => context.nav.pushNamed(Routes.refundPolicyView),
      },
      {
        'icon': Assets.svg.terms,
        'text': S.of(context).termsCondistions,
        'color': Color(0xFFE1F5FE), // Light blue
        'onTap': () => context.nav.pushNamed(Routes.termsAndConditionsView),
      },
      {
        'icon': Assets.svg.privacy,
        'text': S.of(context).privacyPolicy,
        'color': Color(0xFFF3E5F5), // Light purple
        'onTap': () => context.nav.pushNamed(Routes.privacyPolicyView),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildProfileItem(
          context: context,
          icon: items[index]['icon'] as String,
          text: items[index]['text'] as String,
          color: items[index]['color'] as Color,
          onTap: items[index]['onTap'] as void Function()?,
        );
      },
    );
  }
}

class _AuthActionButton extends StatelessWidget {
  final bool? isLoggedIn;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;

  const _AuthActionButton({
    super.key,
    required this.isLoggedIn,
    required this.onLogin,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoggedIn ?? false ? onLogout : onLogin,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SizedBox(
          width: 100.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLoggedIn ?? false ? Icons.logout : Icons.login,
                size: 16.sp,
                color: EcommerceAppColor.red,
              ),
              Gap(10.w),
              Text(
                isLoggedIn ?? false ? 'Logout' : 'Login',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: EcommerceAppColor.black,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
