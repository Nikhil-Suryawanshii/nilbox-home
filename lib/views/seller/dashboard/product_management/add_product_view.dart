

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/providers/seller/product_provider.dart';
import 'package:ready_ecommerce/services/seller/product_service.dart';
import 'package:ready_ecommerce/views/seller/dashboard/product_management/add_product_section.dart';

import '../../../../models/seller/product/product_meta_data_model.dart';
import '../../../../utils/context_less_navigation.dart';

final addProductStepProvider = StateProvider<int>((ref) => 0);

final addProductFormKeyProvider =
    Provider.autoDispose<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

// class EcommerceAddProductView extends ConsumerWidget {
//   const EcommerceAddProductView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final formKey = ref.watch(addProductFormKeyProvider);
//     final isLoading = ref.watch(sellerProductServiceProvider);
//
//     return Scaffold(
//       backgroundColor: colors(context).accentColor,
//       appBar: AppBar(
//         title: Text("Add Product", style: AppTextStyle(context).appBarText),
//       ),
//       body: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             children: [
//               ProductInfoSection(),
//               Gap(16.h),
//               GeneralInfoSection(),
//               Gap(16.h),
//               PriceInfoSection(),
//               Gap(16.h),
//               ImagesSection(),
//               Gap(16.h),
//               VideoSection(),
//               Gap(16.h),
//               SEOSection(),
//               Gap(30.h),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//         color: colors(context).light,
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: isLoading ? null : () => ref.resetProductForm(),
//                 child: const Text("Reset"),
//               ),
//             ),
//             Gap(15.w),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: isLoading
//                     ? null
//                     : () async {
//                         if (formKey.currentState!.validate()) {
//                           final success = await ref
//                               .read(sellerProductServiceProvider.notifier)
//                               .submitProduct(context);
//                           if (success && context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text("Product added successfully")),
//                             );
//                             ref.resetProductForm(fullReset: true); // Full reset after success
//                             Navigator.pop(context);
//                           }
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: colors(context).primaryColor,
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text(
//                         "Submit",
//                         style: TextStyle(color: Colors.white),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
///--------------------------

// class EcommerceAddProductView extends ConsumerStatefulWidget {
//   const EcommerceAddProductView({super.key});
//
//   @override
//   ConsumerState<EcommerceAddProductView> createState() =>
//       _EcommerceAddProductViewState();
// }
//
// class _EcommerceAddProductViewState
//     extends ConsumerState<EcommerceAddProductView> {
//   late final PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }
//
//   Widget _buildStepProgressBar({
//     required int currentStep,
//     required int totalSteps,
//   }) {
//     return Container(
//       height: 4.h,
//       margin: EdgeInsets.only(bottom: 6.h),
//       child: Row(
//         children: List.generate(totalSteps, (index) {
//           final isCompleted = index < currentStep;
//           final isActive = index == currentStep;
//
//           return Expanded(
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: EdgeInsets.symmetric(horizontal: 3.w),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(6),
//                 color: isCompleted || isActive
//                     // ? Colors.white
//                     // : Colors.white.withOpacity(0.35),
//                   ? Color(0xffAE0BFF)
//                     : Color(0xffAE0BFF).withOpacity(0.15),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//
//   void _goToStep(int step) {
//     ref.read(addProductStepProvider.notifier).state = step;
//     _pageController.animateToPage(
//       step,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   String _stepTitle(int step) {
//     switch (step) {
//       case 0:
//         return "Add Images";
//       case 1:
//         return "Add Video";
//       case 2:
//         return "Product Info";
//       case 3:
//         return "General Info";
//       case 4:
//         return "Price Info";
//       case 5:
//         return "SEO";
//       default:
//         return "";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final step = ref.watch(addProductStepProvider);
//     final formKey = ref.watch(addProductFormKeyProvider);
//     final isLoading = ref.watch(sellerProductServiceProvider);
//
//     return Scaffold(
//       backgroundColor: Color(0xFFA9C9F7),
//       // appBar: AppBar(
//       //   elevation: 0,
//       //   backgroundColor: const Color(0xFFA9C9F7), // same as reference
//       //   automaticallyImplyLeading: false,
//       //   // titleSpacing: 12,
//       //   // title: Column(
//       //   //   crossAxisAlignment: CrossAxisAlignment.start,
//       //   //   children: [
//       //   //
//       //   //     /// 🔹 STEP PROGRESS INDICATOR (REFERENCE LINE)
//       //   //     _buildStepProgressBar(
//       //   //       currentStep: step,
//       //   //       totalSteps: 6,
//       //   //     ),
//       //   //
//       //   //     const SizedBox(height: 6),
//       //   //
//       //   //     /// 🔹 TITLE ROW
//       //   //     Row(
//       //   //       children: [
//       //   //         if (step > 0)
//       //   //           Container(
//       //   //             width: 38,
//       //   //             height: 38,
//       //   //             decoration: BoxDecoration(
//       //   //               color: Colors.white.withOpacity(0.35),
//       //   //               borderRadius: BorderRadius.circular(14),
//       //   //             ),
//       //   //             child: IconButton(
//       //   //               padding: EdgeInsets.zero,
//       //   //               icon: const Icon(
//       //   //                 Icons.arrow_back_ios_new_rounded,
//       //   //                 size: 18,
//       //   //                 color: Colors.black,
//       //   //               ),
//       //   //               onPressed: () => _goToStep(step - 1),
//       //   //             ),
//       //   //           ),
//       //   //
//       //   //         if (step > 0) const SizedBox(width: 12),
//       //   //
//       //   //         Text(
//       //   //           "Create Product",
//       //   //           style: TextStyle(
//       //   //             fontSize: 17.sp,
//       //   //             fontWeight: FontWeight.w700,
//       //   //             color: Colors.black,
//       //   //           ),
//       //   //         ),
//       //   //       ],
//       //   //     ),
//       //   //   ],
//       //   // ),
//       // ),
//     ///
//       // appBar: AppBar(
//       //   leading: step > 0
//       //       ? IconButton(
//       //     icon: const Icon(Icons.arrow_back),
//       //     onPressed: () => _goToStep(step - 1),
//       //   )
//       //       : null,
//       //   title: Text(_stepTitle(step), style: AppTextStyle(context).appBarText),
//       // ),
//
//       /// 🧩 BODY
//       body: Column(
//         children: [
//           Gap(30.h),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 /// 🔹 STEP PROGRESS INDICATOR (REFERENCE LINE)
//                 _buildStepProgressBar(
//                   currentStep: step,
//                   totalSteps: 6,
//                 ),
//
//                 const SizedBox(height: 6),
//
//                 /// 🔹 TITLE ROW
//                 Row(
//                   children: [
//                     if (step > 0)
//                       Container(
//                         width: 38,
//                         height: 38,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.35),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: const Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             size: 18,
//                             color: Colors.black,
//                           ),
//                           onPressed: () => _goToStep(step - 1),
//                         ),
//                       ),
//
//                     if (step > 0) const SizedBox(width: 12),
//                     if (step == 0)
//                     Container(
//                         width: 38,
//                         height: 38,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.35),
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: const Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             size: 18,
//                             color: Colors.black,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     if (step == 0) const SizedBox(width: 12),
//                     Text(
//                       "Create Product",
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Flexible(
//             child: Form(
//               key: formKey,
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: const [
//                   _AddImagesPage(),
//                   _AddVideoPage(),
//                   _ProductInfoPage(),
//                   _GeneralInfoPage(),
//                   _PriceInfoPage(),
//                   _SEOPage(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//
//       /// 🔘 BOTTOM BAR
//       bottomNavigationBar: SafeArea(
//         top: false,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.08),
//                 blurRadius: 12,
//                 offset: const Offset(0, -4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               if (step > 0)
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 14.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                     ),
//                     onPressed: () => _goToStep(step - 1),
//                     child: const Text("Back"),
//                   ),
//                 ),
//
//               if (step > 0) Gap(12.w),
//
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: colors(context).primaryColor,
//                     padding: EdgeInsets.symmetric(vertical: 14.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                   ),
//                   onPressed: isLoading
//                       ? null
//                       : () async {
//                     if (step < 5) {
//                       _goToStep(step + 1);
//                       // _showUnderReviewPopup(context);
//                     } else {
//                       if (formKey.currentState!.validate()) {
//                         final success = await ref
//                             .read(sellerProductServiceProvider.notifier)
//                             .submitProduct(context);
//
//                         // if (success && context.mounted) {
//                         //   ScaffoldMessenger.of(context).showSnackBar(
//                         //     const SnackBar(
//                         //       content: Text("Product added successfully"),
//                         //     ),
//                         //   );
//                         //   ref.resetProductForm(fullReset: true);
//                         //   Navigator.pop(context);
//                         // }
//                         if (success && context.mounted) {
//                           ref.resetProductForm(fullReset: true);
//
//                           _showUnderReviewPopup(context);
//                         }
//
//                       }
//                     }
//                   },
//                   child: isLoading
//                       ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                       : Text(
//                     step == 5 ? "Submit" : "Next",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
//
//   void _showUnderReviewPopup(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierLabel: "Product Submitted",
//       transitionDuration: const Duration(milliseconds: 400),
//       pageBuilder: (ctx, anim1, anim2) {
//         return Container(); // Not used, we use transitionBuilder
//       },
//       transitionBuilder: (ctx, anim1, anim2, child) {
//         // Curve the animation for a "pop" effect
//         final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
//
//         return Transform(
//           transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//           child: Opacity(
//             opacity: anim1.value,
//             child: Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               elevation: 10,
//               backgroundColor: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // 🔸 Animated Icon Container
//                     Container(
//                       height: 80,
//                       width: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.hourglass_top_rounded, // or Icons.check_circle
//                         size: 40,
//                         color: Colors.orange,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // 🔸 Title
//                     const Text(
//                       "Product Submitted!",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//
//                     // 🔸 Subtitle/Body
//                     Text(
//                       "Your product is currently under review by our team. It will be visible on the store once approved.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//
//                     // 🔸 Action Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 48,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           ref.read(addProductStepProvider.notifier).state = 0;
//                           Navigator.pop(context); // close dialog
//                           Navigator.pop(context); // exit add product screen
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Got it",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
// }
// class _AddImagesPage extends StatelessWidget {
//   const _AddImagesPage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Add Image & Video",
//               style: AppTextStyle(context).text16B700),
//           Gap(6.h),
//           Text(
//             "Edit images & videos and add music.\nYou can also set the order by dragging.",
//             style: AppTextStyle(context).bodyTextSmall,
//           ),
//           Gap(20.h),
//           ImagesSection(),
//         ],
//       ),
//     );
//   }
// }
// class _AddVideoPage extends StatelessWidget {
//   const _AddVideoPage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Add Video",
//               style: AppTextStyle(context).text16B700),
//           Gap(6.h),
//           Text(
//             "Upload a short product video to increase engagement.",
//             style: AppTextStyle(context).bodyTextSmall,
//           ),
//           Gap(20.h),
//           VideoSection(),
//         ],
//       ),
//     );
//   }
// }
// class _ProductInfoPage extends StatelessWidget {
//   const _ProductInfoPage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: const ProductInfoSection(),
//     );
//   }
// }
// class _GeneralInfoPage extends StatelessWidget {
//   const _GeneralInfoPage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: const GeneralInfoSection(),
//     );
//   }
// }
// class _PriceInfoPage extends StatelessWidget {
//   const _PriceInfoPage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: const PriceInfoSection(),
//     );
//   }
// }
// class _SEOPage extends StatelessWidget {
//   const _SEOPage();
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16.w),
//       child: const SEOSection(),
//     );
//   }
// }
///---new----------

class EcommerceAddProductView extends ConsumerWidget {
  const EcommerceAddProductView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = ref.watch(addProductFormKeyProvider);
    final isLoading = ref.watch(sellerProductServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: Colors.grey.shade100,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Upload Product",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                  // Placeholder to balance the back button
                  SizedBox(width: 44.r),
                ],
              ),
            ),
          Divider(color: Color(0xffDBDBDB),
          indent: 20,
          endIndent: 20,),
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  // padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(5.h),

                      // ---------------- PHOTOS & VIDEOS (GRID) ----------------
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 20.w),
                         child: Column(
                           children: [
                             Center(
                              child: Text(
                                "Product Photos & Videos",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                                                   ),
                             Gap(20.h),
                             const ImagesSectionGrid(), // New Grid Implementation
                             Gap(15.h),
                           ],
                         ),
                       ),

                      // ---------------- FORM FIELDS ----------------
                      // Combining all sections into one seamless list
                      Container(
                        decoration: const BoxDecoration(
                          color: EcommerceAppColor.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35),
                            topLeft: Radius.circular(35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xF000000),
                              blurRadius: 50,
                              spreadRadius: 15,
                              offset: Offset(0, 0),
                            ),
                          ],

                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                        child: Column(
                          children: [
                            const ProductInfoSection(),
                            Gap(15.h),
                            const PriceInfoSection(), // Buying/Selling logic mapped to rows
                            Gap(15.h),
                            const GeneralInfoSection(), // Category/Size/Brand logic mapped to rows
                            // Gap(15.h),

                            // Terms Checkbox (Visual only as per UI, add logic if needed)
                            Row(
                              children: [
                                Checkbox(
                                  value: true,
                                  onChanged: (v) {},
                                  activeColor: Colors.black,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                                      children: const [
                                        TextSpan(text: "I accept the "),
                                        TextSpan(
                                          text: "Terms & Conditions",
                                          style: TextStyle(color: Colors.orange),
                                        ),
                                        TextSpan(text: " and "),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: TextStyle(color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Gap(100.h), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------------- BOTTOM ACTIONS ----------------
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cancel Button
            Expanded(
              child: SizedBox(
                height: 45.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child:  Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      fontSize: 12.sp
                    ),
                  ),
                ),
              ),
            ),
            Gap(15.w),
            // Upload Button
            Expanded(
              child: SizedBox(
                height: 45.h,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (formKey.currentState!.validate()) {
                      final success = await ref
                          .read(sellerProductServiceProvider.notifier)
                          .submitProduct(context);

                      if (success && context.mounted) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //       content: Text("Product uploaded successfully")),
                        // );
                        _showUnderReviewPopup(context,ref);
                        ref.resetProductForm(fullReset: true);
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      :  Text(
                    "Upload Product",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                        fontSize: 12.sp
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showUnderReviewPopup(BuildContext context,WidgetRef ref) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Product Submitted",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (ctx, anim1, anim2) {
        return Container(); // Not used, we use transitionBuilder
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        // Curve the animation for a "pop" effect
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;

        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔸 Animated Icon Container
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hourglass_top_rounded, // or Icons.check_circle
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔸 Title
                    const Text(
                      "Product Submitted!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🔸 Subtitle/Body
                    Text(
                      "Your product is currently under review by our team. It will be visible on the store once approved.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🔸 Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(addProductStepProvider.notifier).state = 0;
                          Navigator.pop(context); // close dialog
                          Navigator.pop(context); // exit add product screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Got it",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// REFACTORED SECTIONS (UI MATCHING IMAGE)
// ==========================================

// 1. IMAGES SECTION (GRID LAYOUT)
class ImagesSectionGrid extends ConsumerWidget {
  const ImagesSectionGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumb = ref.watch(productThumbnailProvider);
    final gallery = ref.watch(additionalImagesProvider);

    // Combine thumbnail and gallery for display logic
    // Index 0 is always the "Add" button
    // Index 1 is Thumbnail (if exists)
    // Index 2+ are Gallery

    // Total count calculation for GridView
    int itemCount = 1; // Start with "Add" button
    if (thumb != null) itemCount++;
    itemCount += gallery.length;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // First Item: ADD BUTTON
        if (index == 0) {
          return GestureDetector(
            onTap: () => _pickImage(context, ref, isThumb: thumb == null),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2FF), // Light purple background
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      // color: Color(0xFF5D5FEF), // Purple button
                      shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0BA1FF),
                            Color(0xFF9500FF),
                          ],
                        ),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  Gap(8.h),
                   Text("Add", style: TextStyle(
                      fontWeight: FontWeight.w500,
                    fontSize: 13.sp
                  )),
                ],
              ),
            ),
          );
        }

        // Display Logic
        XFile? fileToDisplay;
        // If thumb exists, it's at index 1
        if (thumb != null) {
          if (index == 1) {
            fileToDisplay = thumb;
          } else {
            // Gallery items start at index 2
            fileToDisplay = gallery[index - 2];
          }
        } else {
          // If no thumb, gallery items start at index 1
          fileToDisplay = gallery[index - 1];
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            image: DecorationImage(
              image: FileImage(File(fileToDisplay!.path)),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref, {required bool isThumb}) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.orange),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.orange),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        if (isThumb) {
          ref.read(productThumbnailProvider.notifier).state = image;
        } else {
          ref.read(additionalImagesProvider.notifier).update((state) => [...state, image]);
        }
      }
    }
  }
}

// 2. PRODUCT INFO SECTION
class ProductInfoSection extends ConsumerWidget {
  const ProductInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildRoundedField(
          context,
          hintText: "product name",
          controller: ref.watch(nameCtrlProvider),
          validator: (v) => v?.isEmpty == true ? "Required" : null,
        ),
        Gap(15.h),
        _buildRoundedField(
          context,
          hintText: "Details (Short Description)",
          controller: ref.watch(shortDescCtrlProvider),
        ),
        Gap(15.h),
        _buildRoundedField(
          context,
          hintText: "Full Description",
          maxLines: 3,
          controller: ref.watch(longDescCtrlProvider),
        ),
      ],
    );
  }
}

// 3. PRICE INFO SECTION (Side by Side)
class PriceInfoSection extends ConsumerWidget {
  const PriceInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildRoundedField(
            context,
            hintText: "First Price", // Mapping Buying Price
            controller: ref.watch(buyingPriceCtrlProvider),
            keyboardType: TextInputType.number,
          ),
        ),
        Gap(15.w),
        Expanded(
          child: _buildRoundedField(
            context,
            hintText: "Final Price", // Mapping Selling Price
            controller: ref.watch(sellingPriceCtrlProvider),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

// 4. GENERAL INFO SECTION (Categories, Brands, Sizes)
class GeneralInfoSection extends ConsumerWidget {
  const GeneralInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaDataAsync = ref.watch(productCreateDataProvider);

    return metaDataAsync.when(
      data: (data) => Column(
        children: [
          // Row: Category | Size
          Row(
            children: [
              Expanded(
                child: _buildRoundedDropdown<CategoryMeta>(
                  context,
                  hintText: "Category",
                  value: ref.watch(selectedCategoryProvider),
                  items: data.categories,
                  onChanged: (val) {
                    ref.read(selectedCategoryProvider.notifier).state = val;
                    ref.read(selectedSubCategoryProvider.notifier).state = null;
                  },
                ),
              ),
              Gap(15.w),
              Expanded(
                child: _buildRoundedMultiSelect<SizeMeta>(
                  context,
                  hintText: "Size",
                  items: data.sizes,
                  selectedItems: ref.watch(selectedSizesProvider),
                  onChanged: (val) => ref.read(selectedSizesProvider.notifier).state = val,
                  itemBuilder: (item) => Text(item.name),
                ),
              ),
            ],
          ),
          Gap(15.h),

          // Row: Stock | Brand
          Row(
            children: [
              Expanded(
                child: _buildRoundedField(
                  context,
                  hintText: "Stock Quantity",
                  controller: ref.watch(stockCtrlProvider),
                  keyboardType: TextInputType.number,
                ),
              ),
              Gap(15.w),
              Expanded(
                child: _buildRoundedDropdown<BrandMeta>(
                  context,
                  hintText: "Select Brand",
                  value: ref.watch(selectedBrandProvider),
                  items: data.brands,
                  onChanged: (val) => ref.read(selectedBrandProvider.notifier).state = val,
                ),
              ),
            ],
          ),
          Gap(15.h),

          // Colour (Using MultiSelect logic from original but styled as dropdown)
          _buildRoundedMultiSelect<ColorMeta>(
            context,
            hintText: "Colour",
            items: data.colors,
            selectedItems: ref.watch(selectedColorsProvider),
            onChanged: (val) => ref.read(selectedColorsProvider.notifier).state = val,
            itemBuilder: (item) => Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(int.parse(item.colorCode.replaceAll('#', '0xff'))),
                    shape: BoxShape.circle,
                  ),
                ),
                Gap(8),
                Text(item.name),
              ],
            ),
          ),

          Gap(15.h),

          // Shipping Info Placeholder (Visual only, mapped to Unit for now or just generic dropdown)
          _buildRoundedDropdown<UnitMeta>(
            context,
            hintText: "Shipping Information (Unit)",
            value: ref.watch(selectedUnitProvider),
            items: data.units,
            onChanged: (val) => ref.read(selectedUnitProvider.notifier).state = val,
          ),

          // "+ Add Attribute" Button
          Gap(15.h),
          SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: (){}, // Logic for adding custom attributes if needed
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                icon: const Icon(Icons.add, size: 18, color: Colors.blue),
                label: const Text("Add Attribute", style: TextStyle(
                    color: Colors.blue,
                  fontSize: 10
                )),
              ),
            ),
          )
        ],
      ),
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
      error: (e, s) => const Center(child: Text("Failed to load data")),
    );
  }
}


// ==========================================
// STYLING HELPERS (PILL SHAPE)
// ==========================================

// Copy and replace the styling helper section at the bottom of your file
// with this updated code.

// ==========================================
// STYLING HELPERS (Height 40px & Compact Errors)
// ==========================================

// 1. TEXT FIELD (Height 40px)
Widget _buildRoundedField(
    BuildContext context, {
      required String hintText,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1,
      String? Function(String?)? validator,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(
          fontSize: 13.sp, // Slightly smaller font to fit 40px nicely
          color: Colors.black,
        ),
        textAlignVertical: TextAlignVertical.center, // Centers text vertically
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
          isDense: true, // Crucial for smaller height
          // Padding calculation: (40px height - 20px text/cursor) / 2 = ~10px padding
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          // Compact Error Style
          errorStyle: const TextStyle(
            fontSize: 10, // Small text
            height: 0.8,  // Tight line height to keep layout compact
            color: Colors.red,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    ],
  );
}

// 2. DROPDOWN (Height 40px)
Widget _buildRoundedDropdown<T>(
    BuildContext context, {
      required String hintText,
      required T? value,
      required List<T> items,
      required Function(T?) onChanged,
    }) {
  return DropdownButtonFormField<T>(
    value: value,
    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
    style: TextStyle(fontSize: 13.sp, color: Colors.black),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
      isDense: true,
      // Same padding logic for consistency
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      // Compact Error Style
      errorStyle: const TextStyle(
        fontSize: 10,
        height: 0.8,
        color: Colors.red,
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    items: items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(
          (item as dynamic).name,
          style: TextStyle(fontSize: 13.sp, overflow: TextOverflow.ellipsis),
        ),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

// 3. MULTI SELECT (Height 40px)
Widget _buildRoundedMultiSelect<T>(
    BuildContext context, {
      required String hintText,
      required List<T> items,
      required List<T> selectedItems,
      required Function(List<T>) onChanged,
      required Widget Function(T) itemBuilder,
    }) {
  return InkWell(
    onTap: () => _openMultiSelectSheet(context, hintText, items, selectedItems, onChanged, itemBuilder),
    child: Container(
      width: double.infinity,
      height: 40.h, // Explicit height
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: selectedItems.isEmpty
                ? Text(hintText, style: TextStyle(color: Colors.grey, fontSize: 13.sp))
                : Text(
              selectedItems.map((e) => (e as dynamic).name).join(", "),
              style: TextStyle(color: Colors.black, fontSize: 13.sp),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
        ],
      ),
    ),
  );
}

// Helper for MultiSelect Sheet (Reused logic)
void _openMultiSelectSheet<T>(
    BuildContext context,
    String label,
    List<T> items,
    List<T> selectedItems,
    Function(List<T>) onChanged,
    Widget Function(T) itemBuilder,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      final tempSelected = [...selectedItems];
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          onChanged(tempSelected);
                          Navigator.pop(context);
                        },
                        child: const Text("Done", style: TextStyle(color: Colors.orange)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isSelected = tempSelected.contains(item);
                      return CheckboxListTile(
                        value: isSelected,
                        title: itemBuilder(item),
                        activeColor: Colors.orange,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              tempSelected.add(item);
                            } else {
                              tempSelected.remove(item);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

