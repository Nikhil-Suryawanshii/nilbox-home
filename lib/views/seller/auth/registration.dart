// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
// import 'package:ready_ecommerce/views/seller/auth/forget_password.dart';
// import 'package:ready_ecommerce/views/seller/auth/shop_details_widget.dart';
// import 'package:ready_ecommerce/views/seller/auth/shop_owner_widget.dart';
// import 'package:ready_ecommerce/views/seller/widgets/seller_otp_bottom_sheet.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';

// class SellerRegistration extends ConsumerStatefulWidget {
//   const SellerRegistration({super.key});

//   @override
//   ConsumerState<SellerRegistration> createState() => _SellerRegistrationState();
// }

// class _SellerRegistrationState extends ConsumerState<SellerRegistration>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//     tabController.addListener(() {
//       // Sync the provider with the tab index
//       ref.read(sellerTabIndex.notifier).state = tabController.index + 1;
//     });
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final slref = ref;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         title: const Text('Registration'),
//         automaticallyImplyLeading: true,
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 16.w),
//             child: Center(
//               child: Text(
//                 '${slref.watch(sellerTabIndex)}/2',
//                 style: AppTextStyle(context).text16B400.copyWith(fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(slref),
//       body: TabBarView(
//         controller: tabController,
//         physics: !slref.watch(isEmailVerified)
//             ? const NeverScrollableScrollPhysics()
//             : null,
//         children: [
//           const ShopOwnerWidget(),
//           const ShopDetailsWidget(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar(WidgetRef slref) {
//     final isTermsAccepted = slref.watch(isAcceptTermsAndConditions);
//     final currentTab = slref.watch(sellerTabIndex);

//     return Container(
//       color: colors(context).light,
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//       child: CustomButton(
//         // Visual feedback if terms aren't accepted
//         color: !isTermsAccepted ? Colors.grey.shade400 : colors(context).primaryColor,
//         buttonName: currentTab == 1 ? 'Proceed Next' : 'Submit',
//         onTap: isTermsAccepted
//             ? () => currentTab == 1 ? executeShopOwnerForm(slref) : executeShopDetailsForm(slref)
//             : null,
//       ),
//     );
//   }

//   // --- Step 1 Validation & OTP ---
//   void executeShopOwnerForm(WidgetRef slref) async {
//     final formKey = slref.read(shopOwnerFormKey);

//     if (formKey.currentState!.validate()) {
//       if (slref.read(selectedProfileImage) != null) {
//         // Check if user already exists
//         var checkData = await slref.read(sellerAuthServiceProvider.notifier).checkPhoneAndEmail(
//               email: slref.read(emailController).text.trim(),
//               phone: slref.read(phoneController).text.trim(),
//             );

//         if (checkData.status == false) {
//            GlobalFunction.showCustomSnackbar(message: checkData.message, isSuccess: false);
//            return;
//         }

//         // Send OTP
//         slref.read(sellerAuthServiceProvider.notifier).sendOTP(
//               email: slref.read(emailController).text.trim(),
//               isForgotPassword: false,
//             ).then((response) {
//           if (response.status == true) {
//             final String otp = response.data['data']['otp'].toString();
//             showModalBottomSheet(
//               isDismissible: false,
//               isScrollControlled: true,
//               enableDrag: false,
//               context: context,
//               builder: (_) => SellerConfirmOTPBottomSheet(
//                 tabController: tabController,
//                 otp: otp,
//               ),
//             );
//           }
//         });
//       } else {
//         GlobalFunction.showCustomSnackbar(message: 'Profile image is required', isSuccess: false);
//       }
//     }
//   }

//   // --- Step 2 Validation & Redirect ---
//   void executeShopDetailsForm(WidgetRef slref) {
//     final formKey = slref.read(shopDetailsFormKey);

//     if (formKey.currentState!.validate()) {
//       if (slref.read(selectedShopLogo) == null) {
//         GlobalFunction.showCustomSnackbar(message: 'Shop logo is required', isSuccess: false);
//       } else if (slref.read(selectedShopBanner) == null) {
//         GlobalFunction.showCustomSnackbar(message: 'Shop banner is required', isSuccess: false);
//       } else {
//         // All validated, move to final password creation
//         Navigator.pushNamed(context, Routes.sellerCreatePassword);
//       }
//     }
//   }
// }

// // Ensure these match the providers used in your widgets
// final sellerTabIndex = StateProvider<int>((slref) => 1);
// final isEmailVerified = StateProvider<bool>((slref) => false);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/views/seller/auth/forget_password.dart';
import 'package:ready_ecommerce/views/seller/auth/shop_details_widget.dart';
import 'package:ready_ecommerce/views/seller/auth/shop_owner_widget.dart';
import 'package:ready_ecommerce/views/seller/widgets/seller_otp_bottom_sheet.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class SellerRegistration extends ConsumerStatefulWidget {
  const SellerRegistration({super.key});

  @override
  ConsumerState<SellerRegistration> createState() => _SellerRegistrationState();
}

class _SellerRegistrationState extends ConsumerState<SellerRegistration>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController
    tabController = TabController(length: 2, vsync: this);

    // Reset index to 1 when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sellerTabIndex.notifier).state = 1;
    });

    // Listen to tab changes to update the progress text (1/2 or 2/2)
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        ref.read(sellerTabIndex.notifier).state = tabController.index + 1;
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slref = ref;
    // Watch the tab index to update button text and progress
    final currentStep = slref.watch(sellerTabIndex);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   title: const Text('Registration'),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(right: 16.w),
      //       child: Center(
      //         child: Text(
      //           '$currentStep/2',
      //           style: AppTextStyle(context).text16B400.copyWith(fontWeight: FontWeight.w500),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      bottomNavigationBar: _buildBottomNavigationBar(slref, currentStep),
      body: TabBarView(
        controller: tabController,
        // Disable swiping if email isn't verified yet
        physics: !slref.watch(isEmailVerified)
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        children: [
          const ShopOwnerWidget(),
          const ShopDetailsWidget(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(WidgetRef slref, int currentStep) {
    final bool isTermsAccepted = slref.watch(isAcceptTermsAndConditions);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colors(context).light,
        border: Border(top: BorderSide(color: colors(context).accentColor!)),
      ),
      child: CustomButton(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE87722), // Orange left
              Color(0xFFF89B4D), // Orange middle
              Color(0xFFFFB366), // Orange right
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE87722).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        // Dynamic button name based on the currentStep provider
        buttonName: currentStep == 1 ? 'Proceed Next' : 'Submit',
        color: !isTermsAccepted ? Colors.grey : colors(context).primaryColor,
        onTap: isTermsAccepted
            ? () {
                if (currentStep == 1) {
                  executeShopOwnerForm(slref);
                } else {
                  executeShopDetailsForm(slref);
                }
              }
            : null,
      ),
    );
  }

  // --- Logic for Step 1 ---
  void executeShopOwnerForm(WidgetRef slref) async {
    if (slref.watch(shopOwnerFormKey).currentState!.validate()) {
      if (slref.read(selectedProfileImage) != null) {
        var data = await slref
            .read(sellerAuthServiceProvider.notifier)
            .checkPhoneAndEmail(
              email: slref.read(emailController).text,
              phone: slref.read(phoneController).text,
            );
        if (data.status == false) return;
        slref
            .read(sellerAuthServiceProvider.notifier)
            .sendOTP(
              email: slref.read(emailController).text.trim(),
              isForgotPassword: false,
            )
            .then((response) {
          if (response.status == true) {
            final String otp = response.data['data']['otp'].toString();
            showModalBottomSheet(
              isDismissible: false,
              isScrollControlled: true,
              enableDrag: false,
              context: GlobalFunction.navigatorKey.currentContext!,
              builder: (_) => ConfirmOTPBottomSheet(
                tabController: tabController,
                otp: otp,
              ),
            );
          }
        });
      } else {
        GlobalFunction.showCustomSnackbar(
          message: 'Profile image is required',
          isSuccess: false,
        );
      }
    }
  }

  // --- Logic for Step 2 ---
  void executeShopDetailsForm(WidgetRef slref) {
    final formKey = slref.read(shopDetailsFormKey);

    if (formKey.currentState?.validate() ?? false) {
      if (slref.read(selectedShopLogo) == null) {
        GlobalFunction.showCustomSnackbar(
            message: 'Shop logo is required', isSuccess: false);
      } else if (slref.read(selectedShopBanner) == null) {
        GlobalFunction.showCustomSnackbar(
            message: 'Shop banner is required', isSuccess: false);
      } else {
        // Final navigation
        Navigator.pushNamed(context, Routes.sellerCreatePassword);
      }
    }
  }
}

final sellerTabIndex = StateProvider<int>((slref) => 1);
final isEmailVerified = StateProvider<bool>((slref) => false);
