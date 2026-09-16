import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_text_field.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/address/address_controller.dart';
import 'package:ready_ecommerce/controllers/eCommerce/authentication/authentication_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

import '../../../../gen/assets.gen.dart';
import '../apple/apple_auth_service.dart';
import '../facebook/facebook_auth_service.dart';
import '../google/google_auth_service.dart';

// class LoginLayout extends StatefulWidget {
//   const LoginLayout({super.key});
//
//   @override
//   State<LoginLayout> createState() => _LoginLayoutState();
// }
//
// class _LoginLayoutState extends State<LoginLayout> {
//   final TextEditingController phoneController = TextEditingController();
//
//   final TextEditingController passwordController = TextEditingController();
//
//   final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
//
//   final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
//
//   @override
//   void initState() {
//     phoneController.text;
//     passwordController.text;
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     phoneController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             /// 🔶 TOP ORANGE SHAPE
//             Positioned(
//               top: -40,
//               left: -40,
//               child: Container(
//                 height: 140,
//                 width: 140,
//                 decoration: const BoxDecoration(
//                   color: EcommerceAppColor.carrotOrange,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//
//             /// 🔶 BOTTOM ORANGE SHAPE
//             Positioned(
//               bottom: -0,
//               right: -10,
//               child: SvgPicture.asset(
//                 Assets.svg.bgVectorLogin,
//                 height: 160.sp,
//                 width: 200.sp,
//                 // colorFilter: const ColorFilter.mode(
//                 //   Colors.red,
//                 //   BlendMode.srcIn,
//                 // ),
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: SingleChildScrollView(
//                 child: FormBuilder(
//                   key: formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Gap(40.h),
//                       buildHeader(context),
//                       buildBody(context),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container buildHeader(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 60,bottom: 20),
//       child:  Center(
//         child: Image.asset(
//             width: 160.w,
//             height: 67.h,
//             "assets/png/app_logo.png"),
//       ),
//     );
//   }
//
//   Widget buildBody(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w)
//           .copyWith(bottom: 20.h, top: 0.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   S.of(context).welcomeBack,
//           //   style: AppTextStyle(context)
//           //       .title
//           //       .copyWith(fontWeight: FontWeight.bold),
//           // ),
//           Gap(20.h),
//           CustomTextFormField(
//             name: S.of(context).emailOrPhone,
//             hintText: S.of(context).emailOrPhone,
//             textInputType: TextInputType.text,
//             controller: phoneController,
//             focusNode: fNodes[0],
//             textInputAction: TextInputAction.next,
//             validator: (value) => GlobalFunction.commonValidator(
//               value: value!,
//               hintText: S.of(context).emailOrPhone,
//               context: context,
//             ),
//           ),
//           Gap(20.h),
//           Consumer(builder: (context, ref, _) {
//             return CustomTextFormField(
//               name: S.of(context).password,
//               hintText: S.of(context).password,
//               textInputType: TextInputType.text,
//               focusNode: fNodes[1],
//               controller: passwordController,
//               textInputAction: TextInputAction.done,
//               obscureText: ref.watch(obscureText1),
//               widget: IconButton(
//                 splashColor: Colors.transparent,
//                 onPressed: () {
//                   ref.read(obscureText1.notifier).state =
//                       !ref.read(obscureText1);
//                 },
//                 icon: Icon(
//                   !ref.watch(obscureText1)
//                       ? Icons.visibility
//                       : Icons.visibility_off,
//                   color: colors(context).hintTextColor,
//                 ),
//               ),
//               validator: (value) => GlobalFunction.passwordValidator(
//                 value: value!,
//                 hintText: S.of(context).password,
//                 context: context,
//               ),
//             );
//           }),
//
//           Gap(35.h),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // FORGOT PASSWORD
//                 GestureDetector(
//                   onTap: () => context.nav.pushNamed(
//                     Routes.recoverPassword,
//                     arguments: true,
//                   ),
//                   child: Text(
//                     "${S.of(context).forgotPassword}?",
//                     style: AppTextStyle(context).bodyText.copyWith(
//                       fontSize: 12.sp, // Slightly smaller to fit better in a row
//                       decoration: TextDecoration.underline, // Optional: makes it look more like a link
//                     ),
//                   ),
//                 ),
//
//                 Gap(15.w), // Space between text and button
//
//                 // LOGIN BUTTON / LOADING INDICATOR
//                 Consumer(builder: (context, ref, _) {
//                   return ref.watch(authControllerProvider)
//                       ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(right: 50),
//                       child: SizedBox(
//                           height: 25,
//                           width: 25,
//                           child: CircularProgressIndicator()),
//                     ),
//                   )
//                       : SizedBox(
//                     height: 34,
//                         width: 120,
//                         child: CustomButton(
//                                               buttonText: S.of(context).login,
//                                               onPressed: () {
//                         FocusScope.of(context).unfocus();
//                         if (formKey.currentState!.validate()) {
//                           ref
//                               .read(authControllerProvider.notifier)
//                               .login(
//                             phone: phoneController.text,
//                             password: passwordController.text,
//                           )
//                               .then((response) {
//                             ref
//                                 .read(addressControllerProvider.notifier)
//                                 .getAddress();
//                             if (response.isSuccess) {
//                               context.nav.pushNamed(Routes.getCoreRouteName(
//                                   AppConstants.appServiceName));
//                             }
//                           });
//                         }
//                                               },
//                                             ),
//                       );
//                 }),
//               ],
//             ),
//           ),
//           Gap(50.h),
//
//           /// SOCIAL LOGIN
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _socialIcon(Assets.png.facebook.path,60,60,28),
//               Gap(20.w),
//               _socialIcon(Assets.png.google.path,45,45,28),
//               Gap(20.w),
//               _socialIcon(Assets.png.apple.path,48,48,28),
//             ],
//           ),
//           Gap(20.h),
//           SizedBox(
//             height: 60.h,
//             child: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     S.of(context).dontHaveAccount,
//                     style: AppTextStyle(context).bodyText.copyWith(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 11
//                     ),
//                   ),
//                   Gap(5.w),
//                   GestureDetector(
//                     onTap: () => context.nav.pushNamed(Routes.singUp),
//                     child: Text(
//                       'Create',
//                       style: AppTextStyle(context).bodyText.copyWith(
//                         fontWeight: FontWeight.w700,
//                         color: colors(context).primaryColor,
//                           fontSize: 11,
//                         decoration: TextDecoration.underline, // This adds the underline
//                         decorationColor: colors(context).primaryColor, // Optional: matches underline color to text
//                         decorationThickness: 2,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Consumer(
//             builder: (context, ref, _) {
//               return Align(
//                 alignment: Alignment.center,
//                 child: Visibility(
//                   visible: !ref.read(hiveServiceProvider).userIsLoggedIn(),
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 16.h,left: 230),
//                     child: TextButton(
//                       onPressed: () {
//                         context.nav.pushNamed(
//                           Routes.getCoreRouteName(AppConstants.appServiceName),
//                         );
//                       },
//                       child: Text(
//                         S.of(context).skip,
//                         style: AppTextStyle(context).buttonText.copyWith(
//                           fontSize: 14
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Social Icon
//   Widget _socialIcon(String assetPath,double height,double width,double radius) {
//     return CircleAvatar(
//       radius: radius,
//       backgroundColor: Colors.white,
//       child: Image.asset(
//         assetPath, // PNG path
//         height: height.h,
//         width: width.w,
//         fit: BoxFit.contain,
//       ),
//     );
//   }
// }

class LoginLayout extends ConsumerStatefulWidget {
  const LoginLayout({super.key});

  @override
  ConsumerState<LoginLayout> createState() => _LoginLayoutState();
}


class _LoginLayoutState extends ConsumerState<LoginLayout> {
// class _LoginLayoutState extends State<LoginLayout> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // 1. STACK FOR BACKGROUND IMAGE
        body: Stack(
          children: [
            /// 🖼️ BACKGROUND IMAGE
            Positioned.fill(
              child: Image.asset(
                "assets/png/login_bg.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback gradient if image is missing
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// 🌑 GRADIENT OVERLAY (To make text readable)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.4, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            /// 📝 CONTENT
            SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: FormBuilder(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(MediaQuery.of(context).size.height * 0.3),

                          /// EMAIL FIELD
                          CustomTextFormField(
                            name: S.of(context).emailOrPhone,
                            hintText: S.of(context).emailOrPhone,
                            textInputType: TextInputType.text,
                            controller: phoneController,
                            focusNode: fNodes[0],
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                GlobalFunction.commonValidator(
                              value: value!,
                              hintText: S.of(context).emailOrPhone,
                              context: context,
                            ),
                          ),
                          Gap(20.h),
                          Consumer(builder: (context, ref, _) {
                            return CustomTextFormField(
                              name: S.of(context).password,
                              hintText: S.of(context).password,
                              textInputType: TextInputType.text,
                              focusNode: fNodes[1],
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              obscureText: ref.watch(obscureText1),
                              widget: IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  ref.read(obscureText1.notifier).state =
                                      !ref.read(obscureText1);
                                },
                                icon: Icon(
                                  !ref.watch(obscureText1)
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colors(context).hintTextColor,
                                ),
                              ),
                              validator: (value) =>
                                  GlobalFunction.passwordValidator(
                                value: value!,
                                hintText: S.of(context).password,
                                context: context,
                              ),
                            );
                          }),
                          Gap(20.h),

                          /// 🟢 CONTINUE (LOGIN) BUTTON
                          Consumer(builder: (context, ref, _) {
                            return SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFF27A1A), // Green Color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: ref.watch(authControllerProvider)
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState!.validate()) {
                                          ref
                                              .read(authControllerProvider
                                                  .notifier)
                                              .login(
                                                phone: phoneController.text,
                                                password:
                                                    passwordController.text,
                                              )
                                              .then((response) {
                                            ref
                                                .read(addressControllerProvider
                                                    .notifier)
                                                .getAddress();
                                            if (response.isSuccess) {
                                              context.nav.pushNamed(
                                                  Routes.getCoreRouteName(
                                                      AppConstants
                                                          .appServiceName));
                                            }
                                          });
                                        }
                                      },
                                child: ref.watch(authControllerProvider)
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Continue",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            );
                          }),

                          Gap(20.h),
                          Text(
                            "or",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14.sp),
                          ),
                          Gap(20.h),



                          /// 🔵 FACEBOOK BUTTON
                          _socialButton(
                            text: "Continue with Facebook",
                            iconPath: Assets.png.facebook.path,
                            textColor: Colors.black,
                            // onTap: () async {
                            //   // 1. Show loading
                            //   showDialog(
                            //     context: context,
                            //     barrierDismissible: false,
                            //     builder: (_) => const Center(child: CircularProgressIndicator()),
                            //   );
                            //
                            //   try {
                            //     // 2. Facebook Sign-In (Client)
                            //     final userCredential = await ref
                            //         .read(facebookAuthServiceProvider)
                            //         .signInWithFacebook();
                            //
                            //     if (userCredential != null && userCredential.user != null) {
                            //       final user = userCredential.user!;
                            //
                            //       // 3. Backend Social Login
                            //       final response = await ref
                            //           .read(authControllerProvider.notifier)
                            //           .socialLogin(
                            //         provider: "facebook",
                            //         firebaseUid: user.uid,
                            //         email: user.email ?? "",
                            //         name: user.displayName ?? "Facebook User",
                            //         phone: user.phoneNumber,
                            //       );
                            //
                            //       if (context.mounted) Navigator.pop(context);
                            //
                            //       if (response.isSuccess) {
                            //         ref.read(addressControllerProvider.notifier).getAddress();
                            //
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(
                            //             content: Text(response.message),
                            //             backgroundColor: Colors.green,
                            //           ),
                            //         );
                            //
                            //         context.nav.pushNamed(
                            //           Routes.getCoreRouteName(AppConstants.appServiceName),
                            //         );
                            //       } else {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(
                            //             content: Text(response.message),
                            //             backgroundColor: Colors.red,
                            //           ),
                            //         );
                            //       }
                            //     } else {
                            //       if (context.mounted) Navigator.pop(context);
                            //     }
                            //   } catch (e) {
                            //     if (context.mounted) Navigator.pop(context);
                            //     // debugPrint('mm-${e.toString()}');
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         content: Text(e.toString()),
                            //         backgroundColor: Colors.red,
                            //       ),
                            //     );
                            //   }
                            // },
                            onTap: ()async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Center(child: Text("Under Development")),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          ),

                          Gap(12.h),

                          /// 🔴 GOOGLE BUTTON (Requested)
                          _socialButton(
                            text: "Continue with Google",
                            iconPath: Assets.png.google.path,
                            textColor: Colors.black,
                            onTap: () async {
                              // 1. Show Loading
                              // showDialog(
                              //   context: context,
                              //   barrierDismissible: false,
                              //   builder: (context) => const Center(
                              //       child: CircularProgressIndicator()),
                              // );

                              try {
                                // 2. PART A: Google Sign-In (Client Side)
                                final userCredential = await ref
                                    .read(googleAuthServiceProvider)
                                    .signInWithGoogle();

                                if (userCredential != null &&
                                    userCredential.user != null) {
                                  final user = userCredential.user!;


                                  // 3. PART B: Backend API Call (Server Side)
                                  final response = await ref
                                      .read(authControllerProvider.notifier)
                                      .socialLogin(
                                        provider: "google",
                                        firebaseUid: user.uid,
                                        email: user.email ?? "",
                                        name: user.displayName,
                                        phone: user.phoneNumber,
                                      );

                                  // 4. Close Dialog
                                  if (context.mounted) Navigator.pop(context);

                                  // 5. Handle Final Success
                                  if (response.isSuccess) {
                                    // Fetch Address or other startup data if needed
                                    ref
                                        .read(
                                            addressControllerProvider.notifier)
                                        .getAddress();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.green),
                                      );
                                      // REDIRECT TO HOME
                                      context.nav.pushNamed(
                                          Routes.getCoreRouteName(
                                              AppConstants.appServiceName));
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.red),
                                      );
                                    }
                                  }
                                } else {
                                  // User cancelled Google Login
                                  if (context.mounted) Navigator.pop(context);
                                }
                              } catch (e) {
                                if (context.mounted) Navigator.pop(context);
                                debugPrint("Login Error: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("An error occurred: $e"),
                                      backgroundColor: Colors.red),
                                );
                              }
                            },
                          ),
                          Gap(12.h),

                          /// ⚫ APPLE BUTTON
                          _socialButton(
                            text: "Continue with Apple",
                            iconPath: Assets.png.apple.path,
                            textColor: Colors.black,
                            onTap: () async {
                              // 1. Show Loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              );

                              try {
                                // 2. PART A: Apple Sign-In (Client Side)
                                // Call the new service here
                                final userCredential = await ref
                                    .read(appleAuthServiceProvider)
                                    .signInWithApple();

                                if (userCredential != null &&
                                    userCredential.user != null) {
                                  final user = userCredential.user!;

                                  // 3. PART B: Backend API Call (Server Side)
                                  // Apple usually only shares the email/name on the very first login.
                                  // On subsequent logins, these might be null, so we provide fallbacks.
                                  final response = await ref
                                      .read(authControllerProvider.notifier)
                                      .socialLogin(
                                        provider: "apple",
                                        firebaseUid: user.uid,
                                        email: user.email ?? "",
                                        name: user.displayName ?? "Apple User",
                                        phone: user.phoneNumber,
                                      );

                                  // 4. Close Dialog
                                  if (context.mounted) Navigator.pop(context);

                                  // 5. Handle Final Success
                                  if (response.isSuccess) {
                                    ref
                                        .read(
                                            addressControllerProvider.notifier)
                                        .getAddress();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.green),
                                      );
                                      // REDIRECT TO HOME
                                      context.nav.pushNamed(
                                          Routes.getCoreRouteName(
                                              AppConstants.appServiceName));
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response.message),
                                            backgroundColor: Colors.red),
                                      );
                                    }
                                  }
                                } else {
                                  // User cancelled Apple Login
                                  if (context.mounted) Navigator.pop(context);
                                }
                              } catch (e) {
                                if (context.mounted) Navigator.pop(context);
                                debugPrint("Login Error: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("An error occurred: $e"),
                                      backgroundColor: Colors.red),
                                );
                              }
                            },
                          ),

                          Gap(30.h),

                          /// FOOTER LINKS
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    context.nav.pushNamed(Routes.singUp),
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14.sp),
                                    children: [
                                      TextSpan(
                                        text: "Sign up",
                                        style: TextStyle(
                                          color: const Color(
                                              0xFFF27A1A), // Green to match button
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Gap(10.h),
                              GestureDetector(
                                onTap: () => context.nav.pushNamed(
                                  Routes.recoverPassword,
                                  arguments: true,
                                ),
                                child: Text(
                                  "Forget your password?",
                                  style: TextStyle(
                                    color: const Color(0xFFF27A1A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Gap(20.h),
                          Consumer(
                            builder: (context, ref, _) {
                              return Visibility(
                                visible: !ref
                                    .read(hiveServiceProvider)
                                    .userIsLoggedIn(),
                                child: TextButton(
                                  onPressed: () {
                                    context.nav.pushNamed(
                                      Routes.getCoreRouteName(
                                          AppConstants.appServiceName),
                                    );
                                  },
                                  child: Text(
                                    S.of(context).skip,
                                    style: AppTextStyle(context)
                                        .buttonText
                                        .copyWith(fontSize: 14,color: Colors.red),
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      ),
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

  /// 🔹 Helper for Full-Width Social Buttons
  Widget _socialButton({
    required String text,
    required String iconPath,
    required VoidCallback onTap,
    Color textColor = Colors.black,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[200], // Splash color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Image.asset(
                iconPath,
                height: 26.h,
                width: 26.w,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Spacer to balance the icon width for perfect centering
            SizedBox(width: 34.w),
          ],
        ),
      ),
    );
  }
}

///
// class LoginLayout extends StatefulWidget {
//   const LoginLayout({super.key});
//
//   @override
//   State<LoginLayout> createState() => _LoginLayoutState();
// }
//
// class _LoginLayoutState extends State<LoginLayout> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         body: Stack(
//           children: [
//             /// 🔶 TOP ORANGE SHAPE
//             Positioned(
//               top: -40,
//               left: -40,
//               child: Container(
//                 height: 140,
//                 width: 140,
//                 decoration: const BoxDecoration(
//                   color: EcommerceAppColor.carrotOrange,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//
//             /// 🔶 BOTTOM ORANGE SHAPE
//             Positioned(
//               bottom: -0,
//               right: -40,
//               child: SvgPicture.asset(
//                 Assets.svg.bgVectorLogin,
//                 height: 200.sp,
//                 width: 300.sp,
//                 // colorFilter: const ColorFilter.mode(
//                 //   Colors.red,
//                 //   BlendMode.srcIn,
//                 // ),
//               ),
//             ),
//
//             /// 🔹 MAIN CONTENT
//             SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 child: FormBuilder(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       Gap(90.h),
//
//                       /// LOGO
//                       const AppLogo(isAnimation: true),
//                       Gap(50.h),
//
//                       /// EMAIL / PHONE
//                       _pillInput(
//                         controller: phoneController,
//                         hint: 'Email or Phone',
//                         icon: Icons.person_outline,
//                       ),
//
//                       Gap(20.h),
//
//                       /// PASSWORD
//                       Consumer(builder: (context, ref, _) {
//                         return _pillInput(
//                           controller: passwordController,
//                           hint: 'Password',
//                           obscure: ref.watch(obscureText1),
//                           icon: ref.watch(obscureText1)
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           onIconTap: () {
//                             ref.read(obscureText1.notifier).state =
//                                 !ref.read(obscureText1);
//                           },
//                         );
//                       }),
//
//                       Gap(12.h),
//
// //
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           /// FORGET PASSWORD
//
//                           GestureDetector(
//                             onTap: () => context.nav.pushNamed(
//                               Routes.recoverPassword,
//                               arguments: true,
//                             ),
//                             child: const Text(
//                               'Forget Password?',
//                               style: TextStyle(
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//
//                           /// LOGIN BUTTON
//                           Consumer(builder: (context, ref, _) {
//                             return ref.watch(authControllerProvider)
//                                 ? const CircularProgressIndicator()
//                                 : SizedBox(
//                                     width: 160.w,
//                                     child: CustomButton(
//                                       // radius: 30,
//                                       buttonText: 'Log in',
//                                       onPressed: () {
//                                         if (formKey.currentState!.validate()) {
//                                           ref
//                                               .read(authControllerProvider
//                                                   .notifier)
//                                               .login(
//                                                 phone: phoneController.text,
//                                                 password:
//                                                     passwordController.text,
//                                               )
//                                               .then((response) {
//                                             if (response.isSuccess) {
//                                               context.nav.pushNamed(
//                                                 Routes.getCoreRouteName(
//                                                     AppConstants
//                                                         .appServiceName),
//                                               );
//                                             }
//                                           });
//                                         }
//                                       },
//                                     ),
//                                   );
//                           }),
//                         ],
//                       ),
//
//                       Gap(28.h),
//
//                       Gap(40.h),
//
//                       /// SOCIAL LOGIN
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _socialIcon(Assets.svg.facebook, Colors.blue),
//                           Gap(20.w),
//                           _socialIcon(Assets.svg.google, Colors.red),
//                           Gap(20.w),
//                           _socialIcon(Assets.svg.apple, Colors.black),
//                         ],
//                       ),
//
//                       Gap(40.h),
//
//                       /// CREATE ACCOUNT
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Don't have an account? "),
//                           GestureDetector(
//                             onTap: () => context.nav.pushNamed(Routes.singUp),
//                             child: const Text(
//                               'Create',
//                               style: TextStyle(
//                                 color: EcommerceAppColor.carrotOrange,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Gap(20.h),
//
//                       /// SKIP
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           onPressed: () {
//                             context.nav.pushNamed(
//                               Routes.getCoreRouteName(
//                                   AppConstants.appServiceName),
//                             );
//                           },
//                           child: const Text(
//                             'Skip',
//                             style: TextStyle(
//                               color: EcommerceAppColor.carrotOrange,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       Gap(40.h),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Rounded Input Field
//   Widget _pillInput({
//     required TextEditingController controller,
//     required String hint,
//     IconData? icon,
//     bool obscure = false,
//     VoidCallback? onIconTap,
//   }) {
//     return Container(
//       height: 52.h,
//       padding: EdgeInsets.symmetric(horizontal: 18.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               obscureText: obscure,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           if (icon != null)
//             GestureDetector(
//               onTap: onIconTap,
//               child: Icon(icon, color: Colors.grey),
//             ),
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Social Icon
//   Widget _socialIcon(String assetPath, Color color) {
//     return CircleAvatar(
//       radius: 20,
//       backgroundColor: Colors.white,
//       child: SvgPicture.asset(
//         assetPath, // Changed from icon to assetPath
//         height: 20.sp,
//         width: 20.sp,
//         colorFilter: ColorFilter.mode(
//           color,
//           BlendMode.srcIn,
//         ),
//       ),
//     );
//   }
// }
