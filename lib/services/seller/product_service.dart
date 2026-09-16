// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/repositories/seller/product_repository.dart';
// import 'package:ready_ecommerce/providers/seller/product_provider.dart';

// class SellerProductService extends StateNotifier<bool> {
//   final Ref slref;
//   SellerProductService(this.slref) : super(false);

//   Future<bool> submitProduct() async {
//     state = true;
//     try { // Start loading

//       // 1. Collect Metadata from Providers
//       final category = slref.read(selectedCategoryProvider);
//       final subCategory = slref.read(selectedSubCategoryProvider);
//       final brand = slref.read(selectedBrandProvider);
//       final color = slref.read(selectedColorProvider);
//       final unit = slref.read(selectedUnitProvider);
//       final size = slref.read(selectedSizeProvider);

//       // 2. Prepare Map for API
//       Map<String, dynamic> dataMap = {
//         "name": slref.read(productNameProvider),
//         "short_description": slref.read(productShortDescProvider),
//         "description": slref.read(productLongDescProvider),
//         "category_id": category?.id,
//         "sub_category_id": subCategory?.id,
//         "brand_id": brand?.id,
//         "color_id": color?.id,
//         "unit_id": unit?.id,
//         "size_id": size?.id,
//         "buying_price": slref.read(buyingPriceProvider),
//         "selling_price": slref.read(sellingPriceProvider),
//         "discount_price": slref.read(discountPriceProvider),
//         "current_stock": slref.read(stockQuantityProvider),
//         "minimum_order_quantity": slref.read(minOrderProvider),
//         "video_type": "youtube",
//         "video_url": slref.read(videoLinkProvider),
//         "meta_title": slref.read(metaTitleProvider),
//         "meta_description": slref.read(metaDescProvider),
//         "meta_keywords": slref.read(metaKeywordsProvider),
//       };

//       debugPrint("Sending Product Data: $dataMap");

//       // 3. Convert to FormData for Multipart (Images)
//       FormData formData = FormData.fromMap(dataMap);

//       // Add thumbnail
//       final thumb = slref.read(productThumbnailProvider);
//       if (thumb != null) {
//         formData.files.add(MapEntry(
//           "thumbnail",
//           await MultipartFile.fromFile(thumb.path, filename: thumb.name),
//         ));
//       }

//       // Add gallery images
//       final gallery = slref.read(additionalImagesProvider);
//       for (var file in gallery) {
//         formData.files.add(MapEntry(
//           "images[]",
//           await MultipartFile.fromFile(file.path, filename: file.name),
//         ));
//       }

//       // 4. API Call
//       final response = await slref.read(sellerProductRepositoryProvider).storeProduct(formData);

//       state = false; // Buttons enable here
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       debugPrint("CATCH ERROR: $e");
//       state = false; // MUST set to false on error to re-enable buttons
//       return false;
//     }
//   }
// }

// final sellerProductServiceProvider = StateNotifierProvider<SellerProductService, bool>((slref) {
//   return SellerProductService(slref);
// });

// import 'dart:math';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/repositories/seller/product_repository.dart';
// import 'package:ready_ecommerce/providers/seller/product_provider.dart';

// class SellerProductService extends StateNotifier<bool> {
//   final Ref slref;
//   SellerProductService(this.slref) : super(false);

//   String _generateRandomCode() {
//     final random = Random();
//     // Generates a length between 5 and 7
//     int length = 5 + random.nextInt(3);
//     String code = '';
//     for (int i = 0; i < length; i++) {
//       code += random.nextInt(10).toString();
//     }
//     return code;
//   }

//   Future<bool> submitProduct() async {
//     try {
//       state = true;
//       final String productCode = _generateRandomCode();
//       debugPrint("Generated Product Code: $productCode");

//       // 1. Collect Metadata
//       final category = slref.read(selectedCategoryProvider);
//       final subCategory = slref.read(selectedSubCategoryProvider);
//       final brand = slref.read(selectedBrandProvider);

//       // 2. Prepare Map using exact keys from your API error log
//       Map<String, dynamic> dataMap = {
//         "name": slref.read(nameCtrlProvider).text,
//         "short_description": slref.read(shortDescCtrlProvider).text,
//         "description": slref.read(longDescCtrlProvider).text,
//         "category": category?.id, // Changed to 'category' based on your log
//         "brand_id": brand?.id,
//         "sub_category": subCategory?.id, // Changed to 'sub_category'
//         "unit": slref.read(selectedUnitProvider)?.id, // Changed to '
//         "price":
//             slref.read(sellingPriceCtrlProvider).text, // Changed to 'price'
//         "buying_price": slref.read(buyingPriceCtrlProvider).text,
//         "discount_price": slref.read(discountPriceCtrlProvider).text,
//         "quantity": slref.read(stockCtrlProvider).text, // Changed to 'quantity'
//         "code": productCode, // Required field
//         "video_type": "youtube",
//         "video_url": slref.read(videoLinkCtrlProvider).text,
//         "meta_title": slref.read(metaTitleCtrlProvider).text,
//         "meta_description": slref.read(metaDescCtrlProvider).text,
//         "meta_keywords": slref.read(metaKeywordsCtrlProvider).text,
//       };

//       debugPrint("Sending Form Data: $dataMap");

//       FormData formData = FormData.fromMap(dataMap);

//       // 3. Add Images
//       final thumb = slref.read(productThumbnailProvider);
//       if (thumb != null) {
//         formData.files.add(MapEntry(
//           "thumbnail",
//           await MultipartFile.fromFile(thumb.path, filename: thumb.name),
//         ));
//       }

//       final gallery = slref.read(additionalImagesProvider);
//       for (var file in gallery) {
//         formData.files
//             .add(MapEntry("images[]", await MultipartFile.fromFile(file.path)));
//       }

//       // 4. API Call
//       final response = await slref
//           .read(sellerProductRepositoryProvider)
//           .storeProduct(formData);

//       debugPrint("API Response: ${response.data}");

//       state = false;
//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       debugPrint("Submission Error: $e");
//       state = false;
//       return false;
//     }
//   }
// }

// final sellerProductServiceProvider =
//     StateNotifierProvider<SellerProductService, bool>((slref) {
//   return SellerProductService(slref);
// });

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/seller/product/seller_products_details_model.dart';
import 'package:ready_ecommerce/repositories/seller/product_repository.dart';
import 'package:ready_ecommerce/providers/seller/product_provider.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

class SellerProductService extends StateNotifier<bool> {
  final Ref slref;
  SellerProductService(this.slref) : super(false);

  String _generateRandomCode() {
    final random = Random();
    int length = 5 + random.nextInt(3);
    String code = '';
    for (int i = 0; i < length; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }

  /// Fetches details and populates all providers for editing using the Model class
//  Future<void> fetchProductDetails(int id) async {
//   try {
//     state = true; // Start loading
//     final response = await slref.read(sellerProductRepositoryProvider).getProductDetails(id);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final productData = response.data['data']['product'];
//       final productDetails = SellerProductDetailsModel.fromJson(productData);

//       // --- TEXT CONTROLLERS ---
//       slref.read(nameCtrlProvider).text = productDetails.name;
//       slref.read(sellingPriceCtrlProvider).text = productDetails.price.toString();
//       slref.read(discountPriceCtrlProvider).text = productDetails.discountPrice.toString();
//       slref.read(stockCtrlProvider).text = productDetails.quantity.toString();
//       slref.read(minOrderCtrlProvider).text = productDetails.minOrderQuantity.toString();
//       slref.read(shortDescCtrlProvider).text = productDetails.shortDescription;
//       slref.read(longDescCtrlProvider).text = productDetails.description;

//       // SEO & Video
//       slref.read(videoLinkCtrlProvider).text = productData['video_url'] ?? "";
//       slref.read(metaTitleCtrlProvider).text = productData['meta_title'] ?? "";
//       slref.read(metaDescCtrlProvider).text = productData['meta_description'] ?? "";
//       slref.read(metaKeywordsCtrlProvider).text = productData['meta_keywords'] ?? "";

//       // --- DROPDOWN POPULATION ---
//       // We use .read here because we are inside an async method
//       final metaData = slref.read(productCreateDataProvider).value;

//       if (metaData != null) {
//         // MATCH CATEGORY
//         if (productDetails.category != null) {
//           final categoryMatch = metaData.categories
//               .where((c) => c.id == productDetails.category!.id)
//               .firstOrNull;
//           slref.read(selectedCategoryProvider.notifier).state = categoryMatch;

//           // MATCH SUB-CATEGORY (Check categoryMatch first)
//           if (productDetails.subCategories.isNotEmpty && categoryMatch != null) {
//             final subCatId = productDetails.subCategories.first.id;
//             slref.read(selectedSubCategoryProvider.notifier).state = categoryMatch.subCategories
//                 .where((sc) => sc.id == subCatId)
//                 .firstOrNull;
//           }
//         }

//         // MATCH BRAND
//         if (productDetails.brand != null) {
//           int brandId = (productDetails.brand is Map) ? productDetails.brand['id'] : (int.tryParse(productDetails.brand.toString()) ?? 0);
//           slref.read(selectedBrandProvider.notifier).state = metaData.brands.where((b) => b.id == brandId).firstOrNull;
//         }

//         // MATCH UNIT
//         if (productDetails.unit != null) {
//           int unitId = (productDetails.unit is Map) ? productDetails.unit['id'] : (int.tryParse(productDetails.unit.toString()) ?? 0);
//           slref.read(selectedUnitProvider.notifier).state = metaData.units.where((u) => u.id == unitId).firstOrNull;
//         }

//         // MATCH COLOR
//         if (productDetails.colors.isNotEmpty) {
//           int colorId = (productDetails.colors.first is Map) ? productDetails.colors.first['id'] : (int.tryParse(productDetails.colors.first.toString()) ?? 0);
//           slref.read(selectedColorProvider.notifier).state = metaData.colors.where((col) => col.id == colorId).firstOrNull;
//         }

//         // MATCH SIZE
//         if (productDetails.sizes.isNotEmpty) {
//           int sizeId = (productDetails.sizes.first is Map) ? productDetails.sizes.first['id'] : (int.tryParse(productDetails.sizes.first.toString()) ?? 0);
//           slref.read(selectedSizeProvider.notifier).state = metaData.sizes.where((s) => s.id == sizeId).firstOrNull;
//         }
//       }

//       // Update the network thumbnail
//       slref.read(networkThumbnailProvider.notifier).state = productDetails.thumbnail;
//     }
//   } catch (e) {
//     debugPrint("Fetch Details Error: $e");
//   } finally {
//     // ASYNC CHECK: Ensure the provider is still being listened to before updating state
//     // This prevents the 'defunct' error
//     if (slref.exists(sellerProductServiceProvider)) {
//         state = false;
//     }
//   }
// }

  Future<void> fetchProductDetails(int id) async {
    try {
      state = true;
      final response = await slref
          .read(sellerProductRepositoryProvider)
          .getProductDetails(id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final productData = response.data['data']['product'];
        final productDetails = SellerProductDetailsModel.fromJson(productData);

        // Only fill text fields and network images
        slref.read(nameCtrlProvider).text = productDetails.name;
        slref.read(shortDescCtrlProvider).text =
            productDetails.shortDescription;
        slref.read(longDescCtrlProvider).text = productDetails.description;
        slref.read(sellingPriceCtrlProvider).text =
            productDetails.price.toString();
        slref.read(discountPriceCtrlProvider).text =
            productDetails.discountPrice.toString();
        slref.read(stockCtrlProvider).text = productDetails.quantity.toString();
        slref.read(minOrderCtrlProvider).text =
            productDetails.minOrderQuantity.toString();

        // Optional fields
        slref.read(videoLinkCtrlProvider).text = productData['video_url'] ?? "";
        slref.read(metaTitleCtrlProvider).text =
            productData['meta_title'] ?? "";
        slref.read(metaDescCtrlProvider).text =
            productData['meta_description'] ?? "";
        slref.read(metaKeywordsCtrlProvider).text =
            productData['meta_keywords'] ?? "";

        // Network images
        slref.read(networkThumbnailProvider.notifier).state =
            productDetails.thumbnail;
        slref.read(networkAdditionalImagesProvider.notifier).state =
            List<String>.from(
                productDetails.additionalThumbnail.map((e) => e.toString()));

        // Set the full product data (used by UI for pre-selection)
        slref.read(editingProductDataProvider.notifier).state = productDetails;
      }
    } catch (e) {
      debugPrint("Fetch Details Error: $e");
    } finally {
      if (slref.exists(sellerProductServiceProvider)) {
        state = false;
      }
    }
  }

  Future<bool> submitProduct(BuildContext context) async {
    try {
      state = true;
      final bool isEditing = slref.read(isEditingProductProvider);
      final int? productId = slref.read(editingProductIdProvider);
      // final String productCode = _generateRandomCode();

      // 1. Collect Metadata
      final category = slref.read(selectedCategoryProvider);
      final subCategory = slref.read(selectedSubCategoryProvider);
      final brand = slref.read(selectedBrandProvider);
      final unit = slref.read(selectedUnitProvider);
      // final color = slref.read(selectedColorProvider);
      // final size = slref.read(selectedSizeProvider);
      final colors = slref.read(selectedColorsProvider);
      final sizes  = slref.read(selectedSizesProvider);

      // 2. Prepare Map
      // Map<String, dynamic> dataMap = {
      //   "name": slref.read(nameCtrlProvider).text,
      //   "short_description": slref.read(shortDescCtrlProvider).text,
      //   "description": slref.read(longDescCtrlProvider).text,
      //   "category": category?.id,
      //   "sub_category": subCategory?.id,
      //   "brand_id": brand?.id,
      //   "unit": unit?.id,
      //   "color": color != null ? [color.id] : [], // ← fix here
      //   "size": size != null ? [size.id] : [],
      //   "price": slref.read(sellingPriceCtrlProvider).text,
      //   "buying_price": slref.read(buyingPriceCtrlProvider).text,
      //   "discount_price": slref.read(discountPriceCtrlProvider).text,
      //   "quantity": slref.read(stockCtrlProvider).text,
      //   "video_type": "youtube",
      //   "video_url": slref.read(videoLinkCtrlProvider).text,
      //   "meta_title": slref.read(metaTitleCtrlProvider).text,
      //   "meta_description": slref.read(metaDescCtrlProvider).text,
      //   "meta_keywords": slref.read(metaKeywordsCtrlProvider).text,
      //   "code": _generateRandomCode()
      // };


   FormData formData = FormData();

    // Add normal fields
    formData.fields.add(MapEntry("name", slref.read(nameCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("short_description", slref.read(shortDescCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("description", slref.read(longDescCtrlProvider).text.trim()));
    if (category != null) formData.fields.add(MapEntry("category", category.id.toString()));


      if (subCategory != null) {
        formData.fields.add(
          MapEntry('sub_category[]', subCategory.id.toString()),
        );
      }


      // if (subCategory != null) formData.fields.add(MapEntry("sub_category", subCategory.id.toString()));
    if (brand != null) formData.fields.add(MapEntry("brand_id", brand.id.toString()));
    if (unit != null) formData.fields.add(MapEntry("unit", unit.id.toString()));


      // COLORS
      for (final color in colors) {
        formData.fields.add(
          MapEntry("colors[]", color.id.toString()),
        );
      }

// SIZES
      for (final size in sizes) {
        formData.fields.add(
          MapEntry("size[]", size.id.toString()),
        );
      }

    // CRITICAL FIX: Add color & size as ARRAY fields
    // if (color != null) {
    //   formData.fields.add(MapEntry("color[]", color.id.toString()));  // ← Laravel sees this as array
    // } else {
    //   // Optional: send empty array if backend allows
    //   // formData.fields.add(MapEntry("color[]", ""));
    // }
    //
    // if (size != null) {
    //   formData.fields.add(MapEntry("size[]", size.id.toString()));  // ← same for size
    // }

    formData.fields.add(MapEntry("price", slref.read(sellingPriceCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("buying_price", slref.read(buyingPriceCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("discount_price", slref.read(discountPriceCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("quantity", slref.read(stockCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("min_order_quantity", slref.read(minOrderCtrlProvider).text.trim() ?? "1"));
    formData.fields.add(MapEntry("video_type", "youtube"));
    formData.fields.add(MapEntry("video_url", slref.read(videoLinkCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("meta_title", slref.read(metaTitleCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("meta_description", slref.read(metaDescCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("meta_keywords", slref.read(metaKeywordsCtrlProvider).text.trim()));
    formData.fields.add(MapEntry("code", _generateRandomCode()));

      // Only generate new code if creating a new product
      // if (!isEditing) {
      //   dataMap["code"] = _generateRandomCode();
      // }

      debugPrint("Sending Form Data: $formData");
      // FormData formData = FormData.fromMap(dataMap);

      // 3. Add Images
      final thumb = slref.read(productThumbnailProvider);
      if (thumb != null) {
        final fileSize = await thumb.length(); 
      if (fileSize > 2048 * 1024) { 
        debugPrint("Thumbnail too large: ${fileSize / 1024} KB");
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Thumbnail must be under 2MB"),
              backgroundColor: Colors.red,
            ),
          );
        }
        state = false;
        return false;
      }
        formData.files.add(MapEntry(
          "thumbnail",
          await MultipartFile.fromFile(thumb.path, filename: thumb.name),
        ));
      }

      final gallery = slref.read(additionalImagesProvider);
      for (var file in gallery) {
        formData.files
            .add(MapEntry("images[]", await MultipartFile.fromFile(file.path)));
      }

      // 4. API Call (Switch between Store and Update)
      final Response response;
      if (isEditing && productId != null) {
        response = await slref.read(apiClientProvider).post(
              AppConstants.sellerUpdateProduct(productId),
              data: formData,
            );
      } else {
        response = await slref
            .read(sellerProductRepositoryProvider)
            .storeProduct(formData);
      }

      debugPrint("API Response: ${response.data}");
      state = false;
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Submission Error: $e");
      state = false;
      return false;
    }
  }
}

final sellerProductServiceProvider =
    StateNotifierProvider<SellerProductService, bool>((slref) {
  return SellerProductService(slref);
});
