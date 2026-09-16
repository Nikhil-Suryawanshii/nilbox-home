import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/product/product_meta_data_model.dart';
import 'package:ready_ecommerce/models/seller/product/seller_products_details_model.dart';
import 'package:ready_ecommerce/providers/seller/product_provider.dart';


extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

Widget _sectionCard(BuildContext context, String title, List<Widget> children) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: colors(context).light,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: colors(context).primaryColor!.withOpacity(0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle(context).subTitle.copyWith(fontSize: 16.sp),
        ),
        Gap(16.h),
        ...children,
      ],
    ),
  );
}


Widget _buildField(
  BuildContext context,
  String label,
  String hint, {
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
  required TextEditingController controller,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle(context).bodyTextSmall),
        Gap(6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator ??
              (value) => label.contains('*') && (value?.trim().isEmpty ?? true)
                  ? 'This field is required'
                  : null,
          style: AppTextStyle(context).bodyText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle(context).hintText.copyWith(fontSize: 14.sp),
            filled: true,
            fillColor: colors(context).accentColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    ),
  );
}


class ProductInfoSection extends ConsumerWidget {
  const ProductInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _sectionCard(context, "Product Info", [
      _buildField(
        context,
        "Product Name *",
        "Enter Product Name",
        controller: ref.watch(nameCtrlProvider),
      ),
      _buildField(
        context,
        "Short Description *",
        "Enter short description",
        controller: ref.watch(shortDescCtrlProvider),
      ),
      _buildField(
        context,
        "Description *",
        "Enter long description",
        maxLines: 4,
        controller: ref.watch(longDescCtrlProvider),
      ),
    ]);
  }
}


class GeneralInfoSection extends ConsumerWidget {
  const GeneralInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(productCreateDataProvider);
    final productDetails = ref.watch(editingProductDataProvider);

    // Auto-apply selections when both product data and metadata are available
    if (metaAsync.hasValue && productDetails != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyDropdownSelections(ref, metaAsync.value!, productDetails);
      });
    }

    return metaAsync.when(
      data: (metaData) => _sectionCard(context, "General Information", [
        _buildDropdown<CategoryMeta>(
          context: context,
          label: "Select Category *",
          value: ref.watch(selectedCategoryProvider),
          items: metaData.categories,
          onChanged: (val) {
            ref.read(selectedCategoryProvider.notifier).state = val;
            ref.read(selectedSubCategoryProvider.notifier).state = null;
          },
          isRequired: true,
        ),
        if (ref.watch(selectedCategoryProvider)?.subCategories.isNotEmpty ?? false)
          _buildDropdown<SubCategoryMeta>(
            context: context,
            label: "Select Sub Category",
            value: ref.watch(selectedSubCategoryProvider),
            items: ref.watch(selectedCategoryProvider)!.subCategories,
            onChanged: (val) => ref.read(selectedSubCategoryProvider.notifier).state = val,
          ),
        _buildDropdown<BrandMeta>(
          context: context,
          label: "Select Brand",
          value: ref.watch(selectedBrandProvider),
          items: metaData.brands,
          onChanged: (val) => ref.read(selectedBrandProvider.notifier).state = val,
        ),
        _buildDropdown<ColorMeta>(
          context: context,
          label: "Select Color",
          value: ref.watch(selectedColorProvider),
          items: metaData.colors,
          onChanged: (val) => ref.read(selectedColorProvider.notifier).state = val,
        ),
        _buildDropdown<UnitMeta>(
          context: context,
          label: "Select Unit",
          value: ref.watch(selectedUnitProvider),
          items: metaData.units,
          onChanged: (val) => ref.read(selectedUnitProvider.notifier).state = val,
        ),
        _buildDropdown<SizeMeta>(
          context: context,
          label: "Select Size",
          value: ref.watch(selectedSizeProvider),
          items: metaData.sizes,
          onChanged: (val) => ref.read(selectedSizeProvider.notifier).state = val,
        ),
      ]),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Failed to load metadata: $err")),
    );
  }

  void _applyDropdownSelections(
    WidgetRef ref,
    ProductCreateDataModel metaData,
    SellerProductDetailsModel product,
  ) {
   
    if (product.category != null) {
      final matchedCat = metaData.categories.firstWhereOrNull(
        (c) => c.id == product.category!.id,
      );
      if (matchedCat != null) {
        ref.read(selectedCategoryProvider.notifier).state = matchedCat;

        
        if (product.subCategories.isNotEmpty && matchedCat.subCategories.isNotEmpty) {
          final subCatId = product.subCategories.first.id;
          final matchedSub = matchedCat.subCategories.firstWhereOrNull(
            (s) => s.id == subCatId,
          );
          if (matchedSub != null) {
            ref.read(selectedSubCategoryProvider.notifier).state = matchedSub;
          }
        }
      }
    }

    
    if (product.brand != null) {
      final brandId = _getIdFromDynamic(product.brand);
      if (brandId != null) {
        final matchedBrand = metaData.brands.firstWhereOrNull((b) => b.id == brandId);
        ref.read(selectedBrandProvider.notifier).state = matchedBrand;
      }
    }

    if (product.unit != null) {
      final unitId = _getIdFromDynamic(product.unit);
      if (unitId != null) {
        final matchedUnit = metaData.units.firstWhereOrNull((u) => u.id == unitId);
        ref.read(selectedUnitProvider.notifier).state = matchedUnit;
      }
    }

    if (product.colors.isNotEmpty) {
      final colorId = _getIdFromDynamic(product.colors.first);
      if (colorId != null) {
        final matchedColor = metaData.colors.firstWhereOrNull((c) => c.id == colorId);
        ref.read(selectedColorProvider.notifier).state = matchedColor;
      }
    }

    if (product.sizes.isNotEmpty) {
      final sizeId = _getIdFromDynamic(product.sizes.first);
      if (sizeId != null) {
        final matchedSize = metaData.sizes.firstWhereOrNull((s) => s.id == sizeId);
        ref.read(selectedSizeProvider.notifier).state = matchedSize;
      }
    }
  }

  int? _getIdFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value['id'] as int?;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}


Widget _buildDropdown<T>({
  required BuildContext context,
  required String label,
  required T? value,
  required List<T> items,
  required void Function(T?) onChanged,
  bool isRequired = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle(context).bodyTextSmall),
        Gap(6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: colors(context).accentColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<T>(
              value: value,
              isExpanded: true,
              validator: isRequired ? (v) => v == null ? 'Required' : null : null,
              hint: Text(
                label.replaceAll('*', '').trim(),
                style: AppTextStyle(context).hintText.copyWith(fontSize: 14.sp),
              ),
              items: items.map((T item) {
                final dynamicItem = item as dynamic;
                final name = dynamicItem.name as String;

                Widget prefix = const SizedBox.shrink();

                if (item is CategoryMeta || item is SubCategoryMeta) {
                  prefix = Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: CircleAvatar(
                      radius: 12.r,
                      backgroundImage: NetworkImage(dynamicItem.thumbnail),
                    ),
                  );
                } else if (item is ColorMeta) {
                  final colorCode = dynamicItem.colorCode as String;
                  prefix = Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Color(int.parse(colorCode.replaceAll('#', '0xff'))),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }

                return DropdownMenuItem<T>(
                  value: item,
                  child: Row(
                    children: [
                      prefix,
                      Expanded(child: Text(name)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    ),
  );
}

class PriceInfoSection extends ConsumerWidget {
  const PriceInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _sectionCard(context, "Price Information", [
      _buildField(
        context,
        "Buying Price *",
        "Buying Price",
        keyboardType: TextInputType.number,
        controller: ref.watch(buyingPriceCtrlProvider),
      ),
      _buildField(
        context,
        "Selling Price *",
        "Selling Price",
        keyboardType: TextInputType.number,
        controller: ref.watch(sellingPriceCtrlProvider),
      ),
      _buildField(
        context,
        "Discount Price",
        "Discount Price (optional)",
        keyboardType: TextInputType.number,
        controller: ref.watch(discountPriceCtrlProvider),
      ),
      _buildField(
        context,
        "Current Stock Quantity *",
        "Quantity",
        keyboardType: TextInputType.number,
        controller: ref.watch(stockCtrlProvider),
      ),
      _buildField(
        context,
        "Minimum Order Quantity *",
        "Minimum Order Quantity",
        keyboardType: TextInputType.number,
        controller: ref.watch(minOrderCtrlProvider),
      ),
    ]);
  }
}


class ImagesSection extends ConsumerWidget {
  const ImagesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbFile = ref.watch(productThumbnailProvider);
    final galleryFiles = ref.watch(additionalImagesProvider);
    final networkThumb = ref.watch(networkThumbnailProvider);
    final networkGallery = ref.watch(networkAdditionalImagesProvider);

    return _sectionCard(context, "Images", [
      // Thumbnail
      _buildImagePicker(
        context: context,
        label: "Thumbnail (Ratio 1:1) *",
        currentFile: thumbFile,
        networkUrl: networkThumb,
        onPick: () => _pickImage(ref, isThumbnail: true),
        isRequired: true,
      ),
      Gap(16.h),
      Text("Additional Images", style: AppTextStyle(context).bodyTextSmall),
      Gap(8.h),
      SizedBox(
        height: 100.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // New picked gallery images
            ...galleryFiles.map((file) => Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      File(file.path),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            // Existing network gallery images (only if no new ones picked)
            if (galleryFiles.isEmpty)
              ...networkGallery.map((url) => Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        url,
                        width: 100.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            // Add new image button
            _buildImagePicker(
              context: context,
              label: "",
              currentFile: null,
              networkUrl: null,
              onPick: () => _pickImage(ref, isThumbnail: false),
              showLabel: false,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildImagePicker({
    required BuildContext context,
    required String label,
    required XFile? currentFile,
    required String? networkUrl,
    required VoidCallback onPick,
    bool isRequired = false,
    bool showLabel = true,
  }) {
    final hasImage = currentFile != null || networkUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: AppTextStyle(context).bodyTextSmall,
          ),
          Gap(8.h),
        ],
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: colors(context).accentColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isRequired && !hasImage ? Colors.red : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: currentFile != null
                        ? Image.file(File(currentFile.path), fit: BoxFit.cover)
                        : Image.network(networkUrl!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(WidgetRef ref, {required bool isThumbnail}) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: ref.context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(_, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(_, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        if (isThumbnail) {
          ref.read(productThumbnailProvider.notifier).state = image;
          ref.read(networkThumbnailProvider.notifier).state = null; // clear old network one
        } else {
          ref.read(additionalImagesProvider.notifier).update((state) => [...state, image]);
        }
      }
    }
  }
}


class VideoSection extends ConsumerWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _sectionCard(context, "Video Info", [
      _buildField(
        context,
        "Video Link",
        "YouTube or Vimeo link (optional)",
        controller: ref.watch(videoLinkCtrlProvider),
      ),
    ]);
  }
}


class SEOSection extends ConsumerWidget {
  const SEOSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _sectionCard(context, "SEO Information", [
      _buildField(
        context,
        "Meta Title",
        "Meta title (optional)",
        controller: ref.watch(metaTitleCtrlProvider),
      ),
      _buildField(
        context,
        "Meta Description",
        "Meta description (optional)",
        maxLines: 3,
        controller: ref.watch(metaDescCtrlProvider),
      ),
      _buildField(
        context,
        "Meta Keywords",
        "Comma separated keywords (optional)",
        controller: ref.watch(metaKeywordsCtrlProvider),
      ),
    ]);
  }
}