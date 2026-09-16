import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/services/seller/common_service.dart';
import 'package:ready_ecommerce/views/seller/auth/forget_password.dart';
import 'package:ready_ecommerce/views/seller/widgets/image_picker_button.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class ShopOwnerWidget extends StatelessWidget {
  const ShopOwnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
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
          Gap(8.h),
          _buildInfoFormWidget(),
          Gap(8.h),
          _buildProfilePickerWidget(),
          Gap(8.h),
          _buildTermsAndConditionsWidget(),
          Gap(8.h),
        ],
      ),
    );
  }

  Widget _buildInfoFormWidget() {
    return Consumer(
      builder: (context, slref, _) {
        final masterDataModel =
            slref.watch(sellerCommonServiceProvider.notifier).masterModel;
        bool phoneRequired = masterDataModel?.data.phoneRequired ?? false;
        int phoneMin = masterDataModel?.data.minPhoneLength ?? 6;
        int phoneMax = masterDataModel?.data.maxPhoneLength ?? 20;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          color: colors(context).light,
          child: FormBuilder(
            key: slref.read(shopOwnerFormKey),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomTextFormField(
                        labelStyle: AppTextStyle(context).text18B700,
                        name: 'First Name',
                        textInputType: TextInputType.text,
                        isRequired: true,
                        controller: slref.watch(firstNameController),
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.required(
                            errorText: 'First name is required'),
                        hintText: 'Enter first name',
                      ),
                    ),
                    Gap(16.w),
                    Flexible(
                      child: CustomTextFormField(
                        labelStyle: AppTextStyle(context).text18B700,
                        name: 'Last Name',
                        textInputType: TextInputType.text,
                        isRequired: true,
                        controller: slref.watch(lastNameController),
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.required(
                            errorText: 'Last name is required'),
                        hintText: 'Enter last name',
                      ),
                    ),
                  ],
                ),
                Gap(14.h),
                CustomTextFormField(
                  name: 'Phone Number',
                  labelStyle: AppTextStyle(context).text18B700,
                  textInputType: TextInputType.phone,
                  isRequired: phoneRequired,
                  controller: slref.watch(phoneController),
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    if (phoneRequired)
                      FormBuilderValidators.required(
                          errorText: 'Phone is required'),
                    FormBuilderValidators.minLength(phoneMin,
                        errorText: 'Min $phoneMin characters'),
                    FormBuilderValidators.maxLength(phoneMax,
                        errorText: 'Max $phoneMax characters'),
                  ]),
                  hintText: 'Enter phone number',
                ),
                Gap(20.h),
                CustomTextFormField(
                  labelStyle: AppTextStyle(context).text18B700,
                  name: 'Email Address',
                  textInputType: TextInputType.emailAddress,
                  isRequired: true,
                  controller: slref.watch(emailController),
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: 'Email is required'),
                    FormBuilderValidators.email(errorText: 'Invalid email'),
                  ]),
                  hintText: 'Enter email address',
                ),
                Gap(20.h),
                Row(
                  children: [
                    Flexible(
                      child: _buildCustomDropDown(
                        context: context,
                        name: 'Gender',
                        hintText: 'Select',
                        isRequired: true,
                        initialValue: slref.watch(selectedGender),
                        onChanged: (v) =>
                            slref.read(selectedGender.notifier).state = v,
                        validator: FormBuilderValidators.required(
                            errorText: 'Required'),
                        items: ["Male", "Female", "Others"]
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                    ),
                    Gap(16.w),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => GlobalFunction.pickDate(context: context)
                            .then((date) {
                          if (date != null)
                            slref.read(dateOfBirthController).text = date;
                        }),
                        child: CustomTextFormField(
                          readOnly: true,
                          labelStyle: AppTextStyle(context).text18B700,
                          name: 'Date of Birth',
                          textInputType: TextInputType.text,
                          isRequired: true,
                          controller: slref.watch(dateOfBirthController),
                          textInputAction: TextInputAction.next,
                          widget: const Icon(Icons.calendar_today, size: 20),
                          validator: FormBuilderValidators.required(
                              errorText: 'Required'),
                          hintText: 'yyyy-mm-dd',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePickerWidget() {
    return Consumer(
      builder: (context, slref, _) {
        final image = slref.watch(selectedProfileImage);
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          color: colors(context).light,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      'Profile Photo',
                      style: AppTextStyle(context).text18B700,
                    ),
                    const Icon(Icons.star, size: 10, color: Colors.red),
                  ],
                ),
              ),
              Gap(16.h),
              CircleAvatar(
                radius: 46.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    image != null ? FileImage(File(image.path)) : null,
                child: image == null
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              Gap(20.h),
              Row(
                children: [
                  Flexible(
                    child: ImagePickerButton(
                      isActive: slref.watch(isGalleryChosen) == false,
                      title: 'Camera',
                      icon:
                          'assets/icons/camera.svg', // Assuming you'll add the path back later, using Icons is safer
                      callback: () =>
                          GlobalFunction.pickImageFromCamera().then((file) {
                        if (file != null) {
                          slref.read(selectedProfileImage.notifier).state =
                              file;
                          slref.read(isGalleryChosen.notifier).state = false;
                        }
                      }),
                    ),
                  ),
                  Gap(16.w),
                  Flexible(
                    child: ImagePickerButton(
                      isActive: slref.watch(isGalleryChosen) == true,
                      title: 'Gallery',
                      icon: 'assets/icons/gallery.svg',
                      callback: () =>
                          GlobalFunction.pickImageFromGallery().then((file) {
                        if (file != null) {
                          slref.read(selectedProfileImage.notifier).state =
                              file;
                          slref.read(isGalleryChosen.notifier).state = true;
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTermsAndConditionsWidget() {
    return Consumer(
      builder: (context, slref, _) {
        return Container(
          padding: EdgeInsets.all(16.r),
          color: colors(context).light,
          child: Row(
            children: [
              Checkbox(
                value: slref.watch(isAcceptTermsAndConditions),
                onChanged: (v) =>
                    slref.read(isAcceptTermsAndConditions.notifier).state = v!,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyle(context).text14B400,
                    children: [
                      const TextSpan(text: "I accept the "),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                            color: colors(context).primaryColor,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                            color: colors(context).primaryColor,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomDropDown({
    required String name,
    required List<DropdownMenuItem<dynamic>> items,
    required String hintText,
    required bool isRequired,
    required dynamic initialValue,
    required BuildContext context,
    required void Function(dynamic)? onChanged,
    required String? Function(dynamic)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: AppTextStyle(context).text18B700,
            ),
            if (isRequired) const Icon(Icons.star, size: 10, color: Colors.red),
          ],
        ),
        Gap(12.h),
        FormBuilderDropdown(
          name: name,
          items: items,
          initialValue: initialValue,
          onChanged: onChanged,
          decoration: GlobalFunction.inputDecoration(
              hintText: hintText, widget: null, context: context),
          validator: validator,
        ),
      ],
    );
  }
}

// Providers remain in this file or moved to a central auth_provider
final firstNameController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});
final lastNameController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});
final phoneController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});
final dateOfBirthController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});
final selectedProfileImage = StateProvider<XFile?>((slref) => null);
final selectedGender = StateProvider<String?>((slref) => null);
final isGalleryChosen = StateProvider<bool?>((slref) => null);
final isAcceptTermsAndConditions = StateProvider<bool>((slref) => false);
final shopOwnerFormKey = Provider<GlobalKey<FormBuilderState>>(
    (slref) => GlobalKey<FormBuilderState>());
