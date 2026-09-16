// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';

// class SellerLogin extends ConsumerStatefulWidget {
//   const SellerLogin({super.key});
//   @override
//   ConsumerState<SellerLogin> createState() => _SellerLoginState();
// }

// class _SellerLoginState extends ConsumerState<SellerLogin> {
//   final contactController = TextEditingController();
//   final passController = TextEditingController();
//   final formKey = GlobalKey<FormBuilderState>();

//   @override
//   Widget build(BuildContext context) {
//     final slref = ref;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.r),
//           child: FormBuilder(
//             key: formKey,
//             child: Column(
//               children: [
//                 Gap(50.h),
//                 const Icon(Icons.storefront, size: 100, color: Colors.blue),
//                 Gap(30.h),
//                 Text("Seller Login", style: AppTextStyle(context).text24B700),
//                 Gap(24.h),
//                 CustomTextFormField(
//                   name: 'contact',
//                   controller: contactController,
//                   textInputType: TextInputType.text,
//                   textInputAction: TextInputAction.next,
//                   validator: FormBuilderValidators.required(),
//                   hintText: "Phone or Email",
//                 ),
//                 Gap(20.h),
//                 CustomTextFormField(
//                   name: 'password',
//                   controller: passController,
//                   obscureText: !slref.watch(sellerPasswordVisible),
//                   textInputType: TextInputType.text,
//                   textInputAction: TextInputAction.done,
//                   validator: FormBuilderValidators.required(),
//                   hintText: "Password",
//                   widget: IconButton(
//                     onPressed: () => slref
//                         .read(sellerPasswordVisible.notifier)
//                         .state = !slref.watch(sellerPasswordVisible),
//                     icon: Icon(slref.watch(sellerPasswordVisible)
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                   ),
//                 ),
//                 Gap(30.h),
//                 CustomButton(
//                   buttonName: "Login",
//                   onTap: () async {
//                     if (formKey.currentState!.validate()) {
//                       final res = await slref
//                           .read(sellerAuthServiceProvider.notifier)
//                           .login(
//                             contact: contactController.text.trim(),
//                             password: passController.text,
//                           );
//                       if (res.status) {
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, Routes.sellerDashboard, (r) => false);
//                       }
//                     }
//                   },
//                 ),
//                 Gap(20.h),
//                 TextButton(
//                   onPressed: () =>
//                       Navigator.pushNamed(context, Routes.sellerRegistration),
//                   child: const Text("Don't have an account? Register Now"),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// final sellerPasswordVisible = StateProvider<bool>((slref) => false);
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final contactController = TextEditingController();
  final passController = TextEditingController();
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    contactController.text;
    passController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcommerceAppColor.white,
      bottomNavigationBar: _buildBottomNavigationBar(context: context),
      body: Consumer(
        builder: (context, slref, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 110.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors(context).accentColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(44),
                      bottomRight: Radius.circular(44),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: const AppLogo(
                      height: 90,
                      width: 150,
                      isAnimation: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: FormBuilder(
                    key: formKey,
                    child: Column(
                      children: [
                        Gap(70.h),
                        Text(
                          "Welcome Back",
                          style: AppTextStyle(context).text24B700,
                        ),
                        Gap(54.h),
                        CustomTextFormField(
                          labelStyle: AppTextStyle(context).text18B700,
                          name: "Phone or Email",
                          textInputType: TextInputType.text,
                          controller: contactController,
                          textInputAction: TextInputAction.next,
                          validator: FormBuilderValidators.required(
                            errorText: "Enter phone or email address",
                          ),
                          hintText: "Enter phone or email address",
                        ),
                        Gap(20.h),
                        CustomTextFormField(
                          labelStyle: AppTextStyle(context).text18B700,
                          obscureText: !slref.watch(passwordVisible),
                          name: "Password",
                          textInputType: TextInputType.text,
                          controller: passController,
                          textInputAction: TextInputAction.done,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Enter your password here",
                            ),
                            FormBuilderValidators.minLength(
                              6,
                              errorText:
                                  "Password must be at least 6 characters",
                            ),
                          ]),
                          hintText: "Enter Password",
                          widget: IconButton(
                            onPressed: () {
                              slref.read(passwordVisible.notifier).state =
                                  !slref.watch(passwordVisible);
                            },
                            icon: Icon(
                              slref.watch(passwordVisible)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        Gap(16.h),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.sellerForgotPassword);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: AppTextStyle(context).text14B400,
                            ),
                          ),
                        ),
                        Gap(24.h),
                        slref.watch(sellerAuthServiceProvider)
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
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
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        slref
                                            .read(sellerAuthServiceProvider
                                                .notifier)
                                            .login(
                                              contact:
                                                  contactController.text.trim(),
                                              password: passController.text,
                                            )
                                            .then((response) {
                                          if (response.status) {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Routes.sellerDashboard,
                                                (r) => false);
                                          }
                                        });
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        // : CustomButton(
                        //     buttonName: "Login",
                        //     onTap: () {
                        //       if (formKey.currentState!.validate()) {
                        //         slref
                        //             .read(
                        //                 sellerAuthServiceProvider.notifier)
                        //             .login(
                        //               contact:
                        //                   contactController.text.trim(),
                        //               password: passController.text,
                        //             )
                        //             .then((response) {
                        //           if (response.status) {
                        //             Navigator.pushNamedAndRemoveUntil(
                        //                 context,
                        //                 Routes.sellerDashboard,
                        //                 (r) => false);
                        //           }
                        //         });
                        //       }
                        //     },
                        //   ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar({required BuildContext context}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: colors(context).secondaryColor!),
            ),
          ),
          height: 62.h,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyle(context).text16B400,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.sellerRegistration);
                  },
                  child: Text(
                    "Register Now",
                    style: AppTextStyle(context).text16B400.copyWith(
                          color: colors(context).primaryColor,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: -51.h,
          child: Image.asset(
            'assets/png/sale_loginBrick-.png',
            height: 82.h,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

final passwordVisible = StateProvider<bool>((slref) => false);
