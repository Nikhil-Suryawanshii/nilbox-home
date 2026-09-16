// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/animate_image.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_text_field.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/common/authentication/layouts/confirm_otp_layout.dart';

import '../../../../config/app_color.dart';
import '../../../../config/theme.dart';
import '../../../../controllers/common/country_controller.dart';
import '../../../../models/common/all_country_model/country.dart';

class RecoverPasswordLayout extends ConsumerStatefulWidget {
  final bool isPasswordRecover;
  const RecoverPasswordLayout({
    super.key,
    required this.isPasswordRecover,
  });

  @override
  ConsumerState<RecoverPasswordLayout> createState() =>
      _RecoverPasswordLayoutState();
}

class _RecoverPasswordLayoutState extends ConsumerState<RecoverPasswordLayout> {
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  Country? selectedCountry;
  String? countryCode;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materModelData =
        ref.watch(masterControllerProvider.notifier).materModel.data;

    int? phoneMinLength = materModelData.phoneMinLength;
    int? phoneMaxLength = materModelData.phoneMaxLength;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/png/login_bg.png", // <--- ADD THIS IMAGE TO ASSETS
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

            // /// 🔶 TOP ORANGE SHAPE
            // Positioned(
            //   top: -40,
            //   left: -40,
            //   child: Container(
            //     height: 140,
            //     width: 140,
            //     decoration: const BoxDecoration(
            //       color: EcommerceAppColor.carrotOrange,
            //       shape: BoxShape.circle,
            //     ),
            //   ),
            // ),
            //
            // /// 🔶 BOTTOM ORANGE SHAPE
            // Positioned(
            //   bottom: -0,
            //   right: -10,
            //   child: SvgPicture.asset(
            //     Assets.svg.bgVectorLogin,
            //     height: 160.sp,
            //     width: 200.sp,
            //     // colorFilter: const ColorFilter.mode(
            //     //   Colors.red,
            //     //   BlendMode.srcIn,
            //     // ),
            //   ),
            // ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: FormBuilder(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Gap(170.h),
                        AnimatedImage(
                          imageSize: 100.w,
                          imageWidget: Image.asset(
                            Assets.png.forgetPassword.path,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Gap(30.h),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7), // Translucent background
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white30, width: 1),
                            ),
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              if (widget.isPasswordRecover) ...[
                                Text(
                                  S.of(context).recoverPassword,
                                  style: AppTextStyle(context)
                                      .title
                                      .copyWith(fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ] else ...[
                                Text(
                                  S.of(context).verification,
                                  style: AppTextStyle(context)
                                      .title
                                      .copyWith(fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                )
                              ],
                              Gap(16.h),

                              if (widget.isPasswordRecover) ...[
                                Text(
                                  configData(ref: ref, context: context)['type'] ==
                                      'phone'
                                      ? S.of(context).recoverPassDes
                                      : S.of(context).enterThePhoneNumber,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle(context).bodyText.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  configData(ref: ref, context: context)['type'] ==
                                      'phone'
                                      ? S.of(context).enterThePhoneNumber
                                      : S.of(context).enterTheEmailAddress,
                                  // 'Enter the phone number or Email that you used when register your account.  You will receive a OTP code.',
                                  style: AppTextStyle(context).bodyText.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],

                              Gap(10.h),
                            ],
                          ),
                        ),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.white.withOpacity(0.15), // Translucent background
                        //     borderRadius: BorderRadius.circular(15),
                        //     border: Border.all(color: Colors.white30, width: 1),
                        //   ),
                        //   child: TextFormField(
                        //     controller: controller,
                        //     obscureText: isObscure,
                        //     style: const TextStyle(color: Colors.white),
                        //     cursorColor: Colors.white,
                        //     textAlign: TextAlign.center,
                        //     decoration: InputDecoration(
                        //       // prefixIcon: Icon(icon, color: Colors.white70),
                        //       suffixIcon: suffixIcon,
                        //       hintText: hintText,
                        //       hintStyle: const TextStyle(color: Colors.white60),
                        //       border: InputBorder.none,
                        //       contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                        //       errorStyle: const TextStyle(color: Colors.redAccent),
                        //     ),
                        //     validator: validator,
                        //   ),
                        // ),
                        ///
                        // Gap(30.h),
                        // Consumer(builder: (context, ref, child) {
                        //   return ref.watch(countryListControllerProvider).when(
                        //       loading: () =>
                        //           Center(child: const CircularProgressIndicator()),
                        //       error: (error, stackTrace) => Text(error.toString()),
                        //       data: (data) {
                        //         final countryList = data.data?.countries ?? [];
                        //         return FormBuilderDropdown(
                        //           name: 'country',
                        //           validator: (value) {
                        //             if (value == null) {
                        //               return S.of(context).selectCountry;
                        //             }
                        //             return null;
                        //           },
                        //           hint: Text(S.of(context).selectCountry),
                        //           onChanged: (value) {
                        //             setState(() {
                        //               selectedCountry = value as Country;
                        //               countryCode = selectedCountry?.phoneCode;
                        //             });
                        //             debugPrint("Selected country: $selectedCountry");
                        //           },
                        //           items: List.generate(countryList.length, (index) {
                        //             final country = countryList[index];
                        //             return DropdownMenuItem(
                        //               value: country,
                        //               child: Text(country.name ?? ''),
                        //             );
                        //           }),
                        //           decoration: InputDecoration(
                        //             hintStyle: AppTextStyle(context).bodyText.copyWith(
                        //               fontWeight: FontWeight.w500,
                        //               color: colors(context).hintTextColor,
                        //             ),
                        //             filled: true,
                        //             fillColor: colors(context).accentColor,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10.r),
                        //               borderSide: BorderSide(
                        //                 color: colors(context).hintTextColor ??
                        //                     EcommerceAppColor.lightGray,
                        //               ),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10.r),
                        //               borderSide: BorderSide(
                        //                 color: colors(context).accentColor ??
                        //                     EcommerceAppColor.offWhite,
                        //                 width: 2,
                        //               ),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //               borderSide: BorderSide(
                        //                 color: colors(context).primaryColor ??
                        //                     EcommerceAppColor.primary,
                        //                 width: 1.5,
                        //               ),
                        //             ),
                        //             errorBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //               borderSide: BorderSide(
                        //                 color: colors(context).errorColor ??
                        //                     EcommerceAppColor.red,
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       });
                        // }),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 30.w),
                        //   child: Container(
                        //     height: 50.h,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8.r),
                        //       border:
                        //       Border.all(color: colors(context).accentColor!),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         countryCode ?? '+00',
                        //         style: AppTextStyle(context).bodyText.copyWith(
                        //           fontWeight: FontWeight.w500,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        CustomTextFormField(
                          name: configData(ref: ref, context: context)['title'],
                          hintText:
                              configData(ref: ref, context: context)['title'],
                          textInputType:
                              configData(ref: ref, context: context)['type'] ==
                                      'phone'
                                  ? TextInputType.phone
                                  : TextInputType.text,
                          controller: phoneController,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "${configData(ref: ref, context: context)['title']} is required";
                            }

                            return configData(ref: ref, context: context)['type'] == 'phone'
                                ? GlobalFunction.phoneValidator(
                              value: value,
                              hintText: S.of(context).phoneNumber,
                              context: context,
                              minLength: phoneMinLength,
                              maxLength: phoneMaxLength,
                            )
                                : GlobalFunction.emailValidator(
                              value: value,
                              hintText: S.of(context).email,
                              context: context,
                            );
                          },
                        ),
                        Gap(30.h),
                        CustomButton(
                          buttonText: S.of(context).sendOtp,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.nav.pushNamed(
                                Routes.confirmOTP,
                                arguments: ConfirmOTPScreenArguments(
                                  phoneNumber: phoneController.text,
                                  isPasswordRecover: widget.isPasswordRecover,
                                ),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 26.h,
              left: 16.w,
              child: IconButton(
                onPressed: () {
                  context.nav.pop();
                },
                icon: Icon(
                  Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Map configData({required WidgetRef ref, required BuildContext context}) {
    if (widget.isPasswordRecover == true) {
      return {
        'title': ref
                    .read(masterControllerProvider.notifier)
                    .materModel
                    .data
                    .forgotOtpType ==
                'email'
            ? S.of(context).email
            : S.of(context).phone,
        'type': ref
                    .read(masterControllerProvider.notifier)
                    .materModel
                    .data
                    .forgotOtpType ==
                'email'
            ? 'email'
            : 'phone'
      };
    } else {
      return {
        'title': ref
                    .read(masterControllerProvider.notifier)
                    .materModel
                    .data
                    .registerOtpType ==
                'email'
            ? S.of(context).email
            : S.of(context).phone,
        'type': ref
                    .read(masterControllerProvider.notifier)
                    .materModel
                    .data
                    .registerOtpType ==
                'email'
            ? 'email'
            : 'phone'
      };
    }
  }
}
