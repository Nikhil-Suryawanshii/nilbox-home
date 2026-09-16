// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/routes.dart';
// import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
// import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';

// class SellerCreatePassword extends StatefulWidget {
//   final String? token;
//   const SellerCreatePassword({super.key, required this.token});

//   @override
//   State<SellerCreatePassword> createState() => _SellerCreatePasswordState();
// }

// class _SellerCreatePasswordState extends State<SellerCreatePassword> {
//   final formKey = GlobalKey<FormBuilderState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Create a Password')),
//       body: Consumer(builder: (context, slref, _) {
//         return SingleChildScrollView(
//           padding: EdgeInsets.all(16.r),
//           child: FormBuilder(
//             key: formKey,
//             child: Column(
//               children: [
//                 CustomTextFormField(
//                   name: 'password',
//                   hintText: 'New Password',
//                   textInputType: TextInputType.text,
//                   controller: TextEditingController(), // Replace with provider controller if needed
//                   textInputAction: TextInputAction.next,
//                   obscureText: true,
//                   validator: FormBuilderValidators.required(),
//                 ),
//                 Gap(20.h),
//                 CustomTextFormField(
//                   name: 'confirm_password',
//                   hintText: 'Confirm Password',
//                   textInputType: TextInputType.text,
//                   controller: TextEditingController(),
//                   textInputAction: TextInputAction.done,
//                   obscureText: true,
//                   validator: FormBuilderValidators.required(),
//                 ),
//                 Gap(30.h),
//                 CustomButton(
//                   buttonName: 'Set Password',
//                   onTap: () {
//                     if (formKey.currentState!.validate()) {
//                       Navigator.pushNamedAndRemoveUntil(context, Routes.sellerLogin, (r) => false);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart'; // Added Import
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/models/seller/auth/sign_up_model.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/views/seller/auth/forget_password.dart';
import 'package:ready_ecommerce/views/seller/auth/registration.dart';
import 'package:ready_ecommerce/views/seller/auth/shop_owner_widget.dart';
import 'package:ready_ecommerce/views/seller/auth/shop_details_widget.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class CreatePassword extends StatefulWidget {
  final String? token;
  const CreatePassword({super.key, required this.token});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final List<FocusNode> fNodes = [FocusNode(), FocusNode()];
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create a Password')),
        body: FormBuilder(
          key: formKey,
          child: Consumer(
            builder: (context, slref, _) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.only(top: 8.h),
                color: colors(context).light,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(
                      name: 'Create Password',
                      hintText: 'Create password',
                      focusNode: fNodes[0],
                      textInputType: TextInputType.text,
                      controller: slref.read(passwordController),
                      textInputAction: TextInputAction.next,
                      obscureText: slref.watch(isObsecureNewPass),
                      widget: IconButton(
                        onPressed: () {
                          slref.read(isObsecureNewPass.notifier).state =
                              !slref.watch(isObsecureNewPass);
                        },
                        icon: Icon(
                          slref.watch(isObsecureNewPass)
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Please enter password!'),
                        FormBuilderValidators.minLength(6,
                            errorText: 'Password must be at least 6 characters'),
                      ]),
                    ),
                    Gap(20.h),
                    CustomTextFormField(
                      name: 'Confirm Password',
                      hintText: 'Confirm Password',
                      focusNode: fNodes[1],
                      textInputType: TextInputType.text,
                      controller: slref.watch(conPasswordController),
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Please enter confirm password!'),
                        (value) {
                          if (value != slref.read(passwordController).text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ]),
                      obscureText: slref.watch(isObsecureConfirmPass),
                      widget: IconButton(
                        onPressed: () {
                          slref.read(isObsecureConfirmPass.notifier).state =
                              !slref.read(isObsecureConfirmPass);
                        },
                        icon: Icon(
                          slref.watch(isObsecureConfirmPass)
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    Gap(30.h),
                    slref.watch(sellerAuthServiceProvider)
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            buttonName: 'Set Password',
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                widget.token == null
                                    ? performSignUp(slref, context)
                                    : performForgotPassword(slref, context);
                              }
                            },
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void performSignUp(WidgetRef slref, BuildContext context) async {
    final signUpModel = SignUpModel(
      firstName: slref.read(firstNameController).text,
      lastName: slref.read(lastNameController).text,
      phone: slref.read(phoneController).text,
      email: slref.read(emailController).text,
      gender: slref.read(selectedGender)!,
      dateOfBirth: slref.read(dateOfBirthController).text,
      shopName: slref.read(shopNameController).text,
      password: slref.read(passwordController).text,
      confirmPassword: slref.read(conPasswordController).text,
    );

    final File profile = File(slref.read(selectedProfileImage)!.path);
    final File shopLogo = File(slref.read(selectedShopLogo)!.path);
    final File shopBanner = File(slref.read(selectedShopBanner)!.path);

    slref.read(sellerAuthServiceProvider.notifier).signUp(
          signUpModel: signUpModel,
          profile: XFile(profile.path),
          shopLogo: XFile(shopLogo.path),
          shopBanner: XFile(shopBanner.path),
        ).then((response) {
      if (response.status) {
        Navigator.pushNamed(context, Routes.sellerUnderReview);
      } else {
        GlobalFunction.showCustomSnackbar(message: response.message, isSuccess: false);
      }
    });
  }

  void performForgotPassword(WidgetRef slref, BuildContext context) {
    // Calling the corrected 'forgotPassword' (correct spelling)
    slref.read(sellerAuthServiceProvider.notifier).forgotPassword( 
          password: slref.read(passwordController).text,
          confirmPassword: slref.read(conPasswordController).text,
          token: widget.token!,
        ).then((response) {
      if (response.status) {
        GlobalFunction.showCustomSnackbar(message: "Password changed successfully", isSuccess: true);
        Navigator.pushNamedAndRemoveUntil(context, Routes.sellerLogin, (r) => false);
      } else {
        GlobalFunction.showCustomSnackbar(message: response.message, isSuccess: false);
      }
    });
  }
}

// State Providers for local UI control
final isObsecureNewPass = StateProvider<bool>((slref) => true);
final isObsecureConfirmPass = StateProvider<bool>((slref) => true);

final passwordController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});

final conPasswordController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});