import 'dart:io';
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
import 'package:ready_ecommerce/views/seller/widgets/image_picker_button.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_text_field.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class ShopDetailsWidget extends ConsumerWidget {
  const ShopDetailsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef slref) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
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
              _buildInfoFormWidget(context, slref),
              Gap(8.h),
              _buildShopImagesWidget(context, slref),
              Gap(8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoFormWidget(BuildContext context, WidgetRef slref) {
    return Container(
      padding: EdgeInsets.all(16.r),
      color: colors(context).light,
      child: FormBuilder(
        key: slref.read(shopDetailsFormKey),
        child: CustomTextFormField(
          labelStyle: AppTextStyle(context).text18B700,
          name: 'Shop Name',
          hintText: 'Enter shop name',
          textInputType: TextInputType.text,
          isRequired: true,
          controller: slref.read(shopNameController),
          textInputAction: TextInputAction.done,
          validator: FormBuilderValidators.required(
              errorText: 'Shop name is required'),
        ),
      ),
    );
  }

  Widget _buildShopImagesWidget(BuildContext context, WidgetRef slref) {
    final logo = slref.watch(selectedShopLogo);
    final banner = slref.watch(selectedShopBanner);

    return Container(
      padding: EdgeInsets.all(16.r),
      color: colors(context).light,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Shop Logo', style: AppTextStyle(context).text16B700),
              const Icon(Icons.star, size: 10, color: Colors.red),
            ],
          ),
          Gap(12.h),
          Row(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    logo != null ? FileImage(File(logo.path)) : null,
                child: logo == null
                    ? const Icon(Icons.store, color: Colors.grey)
                    : null,
              ),
              Gap(16.w),
              Expanded(
                child: ImagePickerButton(
                  icon: 'assets/icons/gallery.svg',
                  title: 'Upload Logo',
                  isActive: false,
                  callback: () =>
                      GlobalFunction.pickImageFromGallery().then((file) {
                    if (file != null)
                      slref.read(selectedShopLogo.notifier).state = file;
                  }),
                ),
              ),
            ],
          ),
          const Divider(height: 40),
          Row(
            children: [
              Text('Shop Banner', style: AppTextStyle(context).text16B700),
              const Icon(Icons.star, size: 10, color: Colors.red),
            ],
          ),
          Gap(12.h),
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
              image: banner != null
                  ? DecorationImage(
                      image: FileImage(File(banner.path)), fit: BoxFit.cover)
                  : null,
            ),
            child: banner == null
                ? const Icon(Icons.image, size: 40, color: Colors.grey)
                : null,
          ),
          Gap(12.h),
          ImagePickerButton(
            icon: 'assets/icons/gallery.svg',
            title: 'Upload Banner',
            isActive: false,
            callback: () => GlobalFunction.pickImageFromGallery().then((file) {
              if (file != null)
                slref.read(selectedShopBanner.notifier).state = file;
            }),
          ),
        ],
      ),
    );
  }
}

final shopNameController = Provider<TextEditingController>((slref) {
  final controller = TextEditingController();
  slref.onDispose(() => controller.dispose());
  return controller;
});
final selectedShopLogo = StateProvider<XFile?>((slref) => null);
final selectedShopBanner = StateProvider<XFile?>((slref) => null);
final shopDetailsFormKey = Provider<GlobalKey<FormBuilderState>>(
    (slref) => GlobalKey<FormBuilderState>());
