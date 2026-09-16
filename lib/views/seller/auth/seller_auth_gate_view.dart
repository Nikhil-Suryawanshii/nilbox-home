// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/providers/seller/common_provider.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';

// class SellerAuthGateView extends ConsumerWidget {
//   const SellerAuthGateView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Check if seller token exists in the sellerAuthBox
//     final hiveService = ref.read(sellerHiveServiceProvider);

//     return FutureBuilder<String?>(
//       future: hiveService.getToken(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // If seller is already logged in, show the actual dashboard content
//         if (snapshot.hasData && snapshot.data != null) {
//           // Replace this with your actual Seller Dashboard View later
//           return const Center(child: Text("Welcome to Seller Dashboard"));
//         }

//         // Otherwise, show the Prompt Screen
//         return Padding(
//           padding: EdgeInsets.all(20.r),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 120.h,
//                 alignment: Alignment.center,
//                 child: const AppLogo(isAnimation: true, centerAlign: true),
//               ),
//               Gap(20.h),
//               Text(
//                 "Start Selling",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle(context).text24B700,
//               ),
//               Gap(16.h),
//               Text(
//                 "Join thousands of merchants and grow your business today.",
//                 textAlign: TextAlign.center,
//                 style: AppTextStyle(context).text16B400,
//               ),
//               Gap(40.h),
//               CustomButton(
//                 buttonName: "Login as Seller",
//                 onTap: () => Navigator.pushNamed(context, Routes.sellerLogin),
//               ),
//               Gap(16.h),
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 50.h),
//                   side: BorderSide(color: colors(context).primaryColor!),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//                 ),
//                 onPressed: () => Navigator.pushNamed(context, Routes.sellerRegistration),
//                 child: Text("Become a Seller", style: TextStyle(color: colors(context).primaryColor)),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/providers/seller/common_provider.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
// import 'package:ready_ecommerce/views/seller/dashboard/dashboard.dart'; // Import your dashboard

// class SellerAuthGateView extends ConsumerWidget {
//   const SellerAuthGateView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // We watch the token directly via a provider if available,
//     // or use a FutureBuilder to check the Hive box.
//     final hiveService = ref.read(sellerHiveServiceProvider);

//     return FutureBuilder<String?>(
//       future: hiveService.getToken(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // Check if snapshot has data and it's not empty
//         final bool isSellerLoggedIn = snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty;

//         if (isSellerLoggedIn) {
//           // If logged in, return the actual Seller Dashboard UI
//           return const SellerDashboard();
//         }

//         // If not logged in, show the "Start Selling" Prompt
//         return Scaffold(
//           backgroundColor: colors(context).accentColor,
//           body: Padding(
//             padding: EdgeInsets.all(20.r),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 120.h,
//                   alignment: Alignment.center,
//                   child: const AppLogo(isAnimation: true, centerAlign: true),
//                 ),
//                 Gap(20.h),
//                 Text(
//                   "Start Selling",
//                   textAlign: TextAlign.center,
//                   style: AppTextStyle(context).text24B700,
//                 ),
//                 Gap(16.h),
//                 Text(
//                   "Join thousands of merchants and grow your business today.",
//                   textAlign: TextAlign.center,
//                   style: AppTextStyle(context).text16B400,
//                 ),
//                 Gap(40.h),
//                 CustomButton(
//                   buttonName: "Login as Seller",
//                   onTap: () => Navigator.pushNamed(context, Routes.sellerLogin),
//                 ),
//                 Gap(16.h),
//                 OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 56.h),
//                     side: BorderSide(color: colors(context).primaryColor!),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//                   ),
//                   onPressed: () => Navigator.pushNamed(context, Routes.sellerRegistration),
//                   child: Text(
//                     "Become a Seller",
//                     style: TextStyle(color: colors(context).primaryColor, fontWeight: FontWeight.bold)
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';

class SellerAuthGateView extends ConsumerWidget {
  const SellerAuthGateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: colors(context).accentColor,
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gap(26.h),
            Container(
              alignment: Alignment.center,
              child: const AppLogo(
                height: 90,
                width: 150,
                isAnimation: true,
              ),
            ),
            Gap(36.h),
            Text(
              "Start Selling",
              textAlign: TextAlign.center,
              style: AppTextStyle(context).TitleBold,
            ),
            Gap(16.h),
            Text(
              "Join thousands of merchants\n and grow your business today.",
              textAlign: TextAlign.center,
              style: AppTextStyle(context).text16B400,
            ),
            Container(
              child: Image.asset('assets/png/sellerAuthIMage.png'),
            ),
            // CustomButton(
            //   buttonName: "Login as Seller",
            //   onTap: () => Navigator.pushNamed(context, Routes.sellerLogin),
            // ),
            Container(
              height: 56.h,
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Navigator.pushNamed(context, Routes.sellerLogin),
                  child: Center(
                    child: Text(
                      "Login as Seller",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gap(16.h),
            Container(
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E3A8A),
                    Color(0xFF3B82F6),
                    Color(0xFF60A5FA),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.sellerRegistration),
                  child: Center(
                    child: Text(
                      "Become a Seller",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
