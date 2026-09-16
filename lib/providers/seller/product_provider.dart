import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/models/seller/product/product_meta_data_model.dart';
import 'package:ready_ecommerce/models/seller/product/seller_products_details_model.dart';
import 'package:ready_ecommerce/repositories/seller/product_repository.dart'; // your model

// ── Metadata (safe to autoDispose) ───────────────────────────────────────
final productCreateDataProvider = FutureProvider.autoDispose<ProductCreateDataModel>((ref) async {
  final response = await ref.read(sellerProductRepositoryProvider).getProductCreateData();
  return ProductCreateDataModel.fromJson(response.data['data']);
});

// ── Edit mode flags (non-autoDispose - survive navigation) ────────────────
final isEditingProductProvider = StateProvider<bool>((ref) => false);
final editingProductIdProvider = StateProvider<int?>((ref) => null);
final editingProductDataProvider = StateProvider<SellerProductDetailsModel?>((ref) => null);

// ── Network images for display in edit mode ───────────────────────────────
final networkThumbnailProvider = StateProvider<String?>((ref) => null);
final networkAdditionalImagesProvider = StateProvider<List<String>>((ref) => []);

// ── Text Controllers (non-autoDispose) ─────────────────────────────────────
final nameCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final shortDescCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final longDescCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final buyingPriceCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final sellingPriceCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final discountPriceCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final stockCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final minOrderCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final videoLinkCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final metaTitleCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final metaDescCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
final metaKeywordsCtrlProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

// ── Dropdown Selections (non-autoDispose) ──────────────────────────────────
final selectedCategoryProvider = StateProvider<CategoryMeta?>((ref) => null);
final selectedSubCategoryProvider = StateProvider<SubCategoryMeta?>((ref) => null);
// final selectedSubCategoriesProvider =
// StateProvider<List<SubCategoryMeta>>((ref) => []);
final selectedColorsProvider =
StateProvider<List<ColorMeta>>((ref) => []);

final selectedSizesProvider =
StateProvider<List<SizeMeta>>((ref) => []);

final selectedBrandProvider = StateProvider<BrandMeta?>((ref) => null);
final selectedColorProvider = StateProvider<ColorMeta?>((ref) => null);
final selectedUnitProvider = StateProvider<UnitMeta?>((ref) => null);
final selectedSizeProvider = StateProvider<SizeMeta?>((ref) => null);

// ── Images (non-autoDispose) ───────────────────────────────────────────────
final productThumbnailProvider = StateProvider<XFile?>((ref) => null);
final additionalImagesProvider = StateProvider<List<XFile>>((ref) => []);

// ── Form Keys ──────────────────────────────────────────────────────────────
final addProductFormKeyProvider = Provider.autoDispose<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());
final editProductFormKeyProvider = Provider.autoDispose<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

// ── Reset function (call after success/cancel) ─────────────────────────────
extension ProductProviderReset on WidgetRef {
  void resetProductForm({bool fullReset = false}) {
    read(nameCtrlProvider.notifier).state = TextEditingController();
    read(shortDescCtrlProvider.notifier).state = TextEditingController();
    read(longDescCtrlProvider.notifier).state = TextEditingController();
    read(buyingPriceCtrlProvider.notifier).state = TextEditingController();
    read(sellingPriceCtrlProvider.notifier).state = TextEditingController();
    read(discountPriceCtrlProvider.notifier).state = TextEditingController();
    read(stockCtrlProvider.notifier).state = TextEditingController();
    read(minOrderCtrlProvider.notifier).state = TextEditingController();
    read(videoLinkCtrlProvider.notifier).state = TextEditingController();
    read(metaTitleCtrlProvider.notifier).state = TextEditingController();
    read(metaDescCtrlProvider.notifier).state = TextEditingController();
    read(metaKeywordsCtrlProvider.notifier).state = TextEditingController();

    read(selectedCategoryProvider.notifier).state = null;
    read(selectedSubCategoryProvider.notifier).state = null;
    read(selectedBrandProvider.notifier).state = null;
    read(selectedColorProvider.notifier).state = null;
    read(selectedUnitProvider.notifier).state = null;
    read(selectedSizeProvider.notifier).state = null;

    read(productThumbnailProvider.notifier).state = null;
    read(additionalImagesProvider.notifier).state = [];
    read(networkThumbnailProvider.notifier).state = null;
    read(networkAdditionalImagesProvider.notifier).state = [];

    if (fullReset) {
      read(isEditingProductProvider.notifier).state = false;
      read(editingProductIdProvider.notifier).state = null;
      read(editingProductDataProvider.notifier).state = null;
    }
  }
}