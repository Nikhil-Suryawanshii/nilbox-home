// // class VideoSection extends StatelessWidget {
// //   const VideoSection({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return _sectionCard(context, "Upload or Add Product Video", [
// //       _buildField(context, "Select Video Type", "YouTube Link"),
// //       _buildField(context, "YouTube Video Link", "Paste embed code"),
// //     ]);
// //   }
// // }

// // class SEOSection extends StatelessWidget {
// //   const SEOSection({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return _sectionCard(context, "SEO Information", [
// //       _buildField(context, "Meta Title", "Meta Title"),
// //       _buildField(context, "Meta Description", "Meta Description", maxLines: 3),
// //       _buildField(context, "Meta Keywords", "Write keywords and Press enter"),
// //     ]);
// //   }
// // }



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/product/product_meta_data_model.dart';
import 'package:ready_ecommerce/providers/seller/product_provider.dart';

// --- Common UI Helpers ---

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
        Text(title, style: AppTextStyle(context).subTitle.copyWith(fontSize: 16.sp)),
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
          validator: validator ?? (value) {
            if (label.contains('*')) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
            }
            return null;
          },
          style: AppTextStyle(context).bodyText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle(context).hintText.copyWith(fontSize: 14.sp),
            fillColor: colors(context).accentColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            errorStyle: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    ),
  );
}

// --- Sections ---

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
    final metaDataAsync = ref.watch(productCreateDataProvider);

    return metaDataAsync.when(
      data: (data) => _sectionCard(context, "General Information", [
        _buildDynamicDropdown<CategoryMeta>(
          context,
          ref,
          label: "Select Category *",
          value: ref.watch(selectedCategoryProvider),
          items: data.categories,
          onChanged: (val) {
            ref.read(selectedCategoryProvider.notifier).state = val;
            ref.read(selectedSubCategoryProvider.notifier).state = null;
          },
        ),
        if (ref.watch(selectedCategoryProvider)?.subCategories.isNotEmpty ?? false)
          _buildDynamicDropdown<SubCategoryMeta>(
            context,
            ref,
            label: "Select Sub Categories",
            value: ref.watch(selectedSubCategoryProvider),
            items: ref.watch(selectedCategoryProvider)!.subCategories,
            onChanged: (val) => ref.read(selectedSubCategoryProvider.notifier).state = val,
          ),
        _buildDynamicDropdown<BrandMeta>(
          context,
          ref,
          label: "Select Brand",
          value: ref.watch(selectedBrandProvider),
          items: data.brands,
          onChanged: (val) => ref.read(selectedBrandProvider.notifier).state = val,
        ),
        // _buildDynamicDropdown<ColorMeta>(
        //   context,
        //   ref,
        //   label: "Select Color",
        //   value: ref.watch(selectedColorProvider),
        //   items: data.colors,
        //   onChanged: (val) => ref.read(selectedColorProvider.notifier).state = val,
        // ),
        _buildMultiSelectField<ColorMeta>(
          context,
          ref,
          label: "Select Colors",
          items: data.colors,
          selectedItems: ref.watch(selectedColorsProvider),
          onChanged: (values) =>
          ref.read(selectedColorsProvider.notifier).state = values,
          itemBuilder: (item) => Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Color(int.parse(item.colorCode.replaceAll('#', '0xff'))),
                  shape: BoxShape.circle,
                ),
              ),
              Gap(10),
              Text(item.name),
            ],
          ),
        ),

        _buildDynamicDropdown<UnitMeta>(
          context,
          ref,
          label: "Select Unit",
          value: ref.watch(selectedUnitProvider),
          items: data.units,
          onChanged: (val) => ref.read(selectedUnitProvider.notifier).state = val,
        ),
        // _buildDynamicDropdown<SizeMeta>(
        //   context,
        //   ref,
        //   label: "Select Size",
        //   value: ref.watch(selectedSizeProvider),
        //   items: data.sizes,
        //   onChanged: (val) => ref.read(selectedSizeProvider.notifier).state = val,
        // ),
        _buildMultiSelectField<SizeMeta>(
          context,
          ref,
          label: "Select Sizes",
          items: data.sizes,
          selectedItems: ref.watch(selectedSizesProvider),
          onChanged: (values) =>
          ref.read(selectedSizesProvider.notifier).state = values,
          itemBuilder: (item) => Text(item.name),
        ),

      ]),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => const Center(child: Text("Error loading metadata")),
    );
  }

  Widget _buildDynamicDropdown<T>(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
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
                isExpanded: true,
                value: value,
                validator: (v) => (label.contains('*') && v == null) ? 'Required' : null,
                hint: Text(label, style: AppTextStyle(context).hintText.copyWith(fontSize: 14.sp)),
                items: items.map((item) {
                  Widget content;
                  if (item is CategoryMeta || item is SubCategoryMeta) {
                    content = Row(
                      children: [
                        CircleAvatar(
                          radius: 10.r,
                          backgroundImage: NetworkImage((item as dynamic).thumbnail),
                        ),
                        Gap(10.w),
                        Text((item as dynamic).name),
                      ],
                    );
                  } else if (item is ColorMeta) {
                    content = Row(
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Color(int.parse((item as dynamic).colorCode.replaceAll('#', '0xff'))),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gap(10.w),
                        Text((item as dynamic).name),
                      ],
                    );
                  } else {
                    content = Text((item as dynamic).name);
                  }
                  return DropdownMenuItem<T>(
                    value: item,
                    child: content,
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

  Widget _buildMultiSelectField<T>(
      BuildContext context,
      WidgetRef ref, {
        required String label,
        required List<T> items,
        required List<T> selectedItems,
        required Function(List<T>) onChanged,
        required Widget Function(T) itemBuilder,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle(context).bodyTextSmall),
          Gap(6.h),

          InkWell(
            onTap: () => _openMultiSelectBottomSheet<T>(
              context,
              labels: label,
              items: items,
              selectedItems: selectedItems,
              onChanged: onChanged,
              itemBuilder: itemBuilder,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors(context).accentColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedItems.isEmpty
                  ? Text(label,
                  style: AppTextStyle(context).hintText.copyWith(
                    fontSize: 14
                  ))
                  : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: selectedItems
                    .map(
                      (e) => Chip(
                    label: Text((e as dynamic).name),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      final updated = [...selectedItems]..remove(e);
                      onChanged(updated);
                    },
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void _openMultiSelectBottomSheet<T>(
      BuildContext context, {
        required String labels,
        required List<T> items,
        required List<T> selectedItems,
        required Function(List<T>) onChanged,
        required Widget Function(T) itemBuilder,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Transparent to show rounded corners
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (_) {
        final tempSelected = [...selectedItems];

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75, // 75% height
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // 🔹 Grab Handle & Header
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          labels,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "${tempSelected.length} selected",
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // 🔹 Animated List Items
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final item = items[index];
                        final isSelected = tempSelected.contains(item);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? tempSelected.remove(item)
                                  : tempSelected.add(item);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.orange.shade50
                                  : Colors.grey.shade50,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                // Custom Content Builder
                                Expanded(child: itemBuilder(item)),

                                // Animated Checkbox
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔹 Bottom Action Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          onChanged(tempSelected);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.orange.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Apply Selection",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
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
        "10",
        keyboardType: TextInputType.number,
        controller: ref.watch(sellingPriceCtrlProvider),
      ),
      _buildField(
        context,
        "Discount Price",
        "0",
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
        "1",
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
    final thumb = ref.watch(productThumbnailProvider);
    final gallery = ref.watch(additionalImagesProvider);

    return _sectionCard(context, "Images", [
      _imageBox(context, "Thumbnail (Ratio 1:1) *", thumb, () => _pickImage(context, ref, isThumb: true)),
      Gap(16.h),
      Text("Additional Thumbnails", style: AppTextStyle(context).bodyTextSmall),
      Gap(8.h),
      SizedBox(
        height: 100.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...gallery.map((file) => Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(File(file.path), width: 100.w, height: 100.h, fit: BoxFit.cover),
                  ),
                )),
            _imageBox(context, "", null, () => _pickImage(context, ref, isThumb: false), showLabel: false),
          ],
        ),
      ),
    ]);
  }

  Widget _imageBox(BuildContext context, String label, XFile? file, VoidCallback onTap, {bool showLabel = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) Text(label, style: AppTextStyle(context).bodyTextSmall),
        if (showLabel) Gap(8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: colors(context).accentColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: file == null
                ? const Icon(Icons.add_a_photo_outlined, color: Colors.grey)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(File(file.path), fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref, {required bool isThumb}) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
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

class VideoSection extends ConsumerWidget {
  const VideoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _sectionCard(context, "Video Info", [
      _buildField(
        context,
        "Video Link",
        "YouTube Video Link",
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
        "Meta Title",
        controller: ref.watch(metaTitleCtrlProvider),
      ),
      _buildField(
        context,
        "Meta Description",
        "Meta Description",
        maxLines: 3,
        controller: ref.watch(metaDescCtrlProvider),
      ),
      _buildField(
        context,
        "Meta Keywords",
        "Keywords separated by comma",
        controller: ref.watch(metaKeywordsCtrlProvider),
      ),
    ]);
  }
}
