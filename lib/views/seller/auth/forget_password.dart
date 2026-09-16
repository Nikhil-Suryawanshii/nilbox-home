import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';

class ForgotPassowrd extends StatelessWidget {
  const ForgotPassowrd({super.key});

  static final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors(context).light,
      appBar: AppBar(title: const Text("Forgot Password")),
      body: SafeArea(
        child: Consumer(
          builder: (context, slref, _) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(24.h),
                    const Center(child: Icon(Icons.lock_reset, size: 80, color: Colors.grey)),
                    Gap(62.h),
                    Text(
                      "Forgot Password",
                      style: AppTextStyle(context).text24B700,
                    ),
                    Gap(12.h),
                    Text(
                      "Enter your registered email address below",
                      style: AppTextStyle(context).text14B400.copyWith(
                            fontWeight: FontWeight.w500,
                            color: EcommerceAppColor.gray,
                          ),
                    ),
                    Gap(24.h),
                    CustomTextFormField(
                      name: "Email",
                      textInputType: TextInputType.text,
                      controller: slref.read(emailController),
                      textInputAction: TextInputAction.done,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Email is required'),
                        FormBuilderValidators.email(errorText: 'Invalid email'),
                      ]),
                      hintText: "Enter Email",
                    ),
                    Gap(24.h),
                    slref.watch(sellerAuthServiceProvider)
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            buttonName: "Send OTP",
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                slref
                                    .read(sellerAuthServiceProvider.notifier)
                                    .sendOTP(
                                      email: slref.read(emailController).text,
                                      isForgotPassword: true,
                                    )
                                    .then((response) {
                                  if (response.status) {
                                    Navigator.pushNamed(context, Routes.sellerConfirmOTP,
                                        arguments: slref.read(emailController).text);
                                  }
                                });
                              }
                            },
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final emailController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});