// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/models/eCommerce/common/common_response.dart';
// import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
// import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
// import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart'
//     as product_details;
// import 'package:ready_ecommerce/services/eCommerce/product_service/product_service.dart';
// import 'package:ready_ecommerce/utils/request_handler.dart';
//
// import '../../../models/eCommerce/product/filter.dart';
//
// final selectedColorPriceProvider = StateProvider<double>((ref) => 0);
// final selectedSizePriceProvider = StateProvider<double>((ref) => 0);
//
// final favoriteProvider =
// StateNotifierProvider.family<FavoriteNotifier, bool, int>(
//       (ref, productId) => FavoriteNotifier(false),
// );
//
// class FavoriteNotifier extends StateNotifier<bool> {
//   FavoriteNotifier(bool state) : super(state);
//
//   void toggle() => state = !state;
// }
//
//
// final productControllerProvider =
//     StateNotifierProvider<ProductController, bool>(
//         (ref) => ProductController(ref));
//
//
// class ProductController extends StateNotifier<bool> {
//   final Ref ref;
//   ProductController(this.ref) : super(false);
//
//
//   int? _total;
//   int? get total => _total;
//
//   List<Product> _products = [];
//   List<Product> get products => _products;
//
//   List<Product> _favoriteProducts = [];
//   List<Product> get favoriteProducts => _favoriteProducts;
//
//   Filters? _filter;
//   Filters? get filter => _filter;
//   Future<void> getCategoryWiseProducts({
//     required ProductFilterModel productFilterModel,
//     required bool isPagination,
//   }) async {
//     try {
//       state = true;
//       final response = await ref
//           .read(productServiceProvider)
//           .getCategoryWiseProducts(productFilterModel: productFilterModel);
//       _total = response.data['data']['total'];
//
//       List<dynamic> productData = response.data['data']['products'];
//       _filter = Filters.fromMap(response.data['data']['filters']);
//       if (isPagination) {
//         _products.addAll(
//             productData.map((product) => Product.fromMap(product)).toList());
//       } else {
//         _products =
//             productData.map((product) => Product.fromMap(product)).toList();
//       }
//
//       state = false;
//     } catch (error) {
//       debugPrint(error.toString());
//       state = false;
//       rethrow;
//     }
//   }
//
//
//
//
//   Future<CommonResponse> favoriteProductAddRemove({
//     required int productId,
//   }) async {
//     try {
//       final response = await ref
//           .read(productServiceProvider)
//           .favoriteProductAddRemove(productId: productId);
//       return CommonResponse(isSuccess: true, message: response.data['message']);
//     } catch (error) {
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> getFavoriteProducts() async {
//     try {
//       state = true;
//       final response =
//           await ref.read(productServiceProvider).getFavoriteProducts();
//       List<dynamic> favoriteProductsData = response.data['data']['products'];
//       _favoriteProducts = favoriteProductsData
//           .map((product) => Product.fromMap(product))
//           .toList();
//       state = false;
//       return CommonResponse(isSuccess: true, message: response.data['message']);
//     } catch (error) {
//       debugPrint(error.toString());
//       state = false;
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
// }
//
// final productDetailsControllerProvider = StateNotifierProvider.family
//     .autoDispose<ProductDetailsController,
//         AsyncValue<product_details.ProductDetails>, int>((ref, productId) {
//   final controller = ProductDetailsController(ref);
//   controller.getProductDetails(productId: productId);
//   return controller;
// });
//
// class ProductDetailsController
//     extends StateNotifier<AsyncValue<product_details.ProductDetails>> {
//   final Ref ref;
//   ProductDetailsController(this.ref) : super(const AsyncLoading());
//
//   Future<void> getProductDetails({required int productId}) async {
//     try {
//       final response = await ref
//           .read(productServiceProvider)
//           .getProductDetails(productId: productId);
//       final productData = response.data['data'];
//       print('hbdfjd---${productData}');
//       state = AsyncData(product_details.ProductDetails.fromMap(productData));
//     } catch (error, stackTrace) {
//       debugPrint(error.toString());
//       state = AsyncError(
//           error is DioException ? ApiInterceptors.handleError(error) : error,
//           stackTrace);
//       rethrow;
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/eCommerce/common/common_response.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart' as product_details;
import 'package:ready_ecommerce/services/eCommerce/product_service/product_service.dart';
import 'package:ready_ecommerce/utils/request_handler.dart';
import '../../../models/eCommerce/product/filter.dart';

final selectedColorPriceProvider = StateProvider<double>((ref) => 0);
final selectedSizePriceProvider = StateProvider<double>((ref) => 0);

final favoriteProvider = StateNotifierProvider.family<FavoriteNotifier, bool, int>(
      (ref, productId) => FavoriteNotifier(false),
);

class FavoriteNotifier extends StateNotifier<bool> {
  FavoriteNotifier(bool state) : super(state);
  void toggle() => state = !state;
}

///-----------------------------------------favorite
// 1. Define the Provider
final favoriteProductsControllerProvider =
StateNotifierProvider<FavoriteProductsController, AsyncValue<List<Product>>>((ref) {
  return FavoriteProductsController(ref);
});

// 2. Define the Controller
class FavoriteProductsController extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;

  // Start with Loading state so the spinner shows immediately
  FavoriteProductsController(this.ref) : super(const AsyncLoading());

  Future<void> getFavoriteProducts() async {
    try {
      // FIX: Only show full-screen loader if we have NO data.
      // If we already have a list, keep showing it while we fetch the update.
      if (state.value == null) {
        state = const AsyncLoading();
      }

      final response = await ref.read(productServiceProvider).getFavoriteProducts();

      List<dynamic> data = response.data['data']['products'];
      final products = data.map((e) => Product.fromMap(e)).toList();

      state = AsyncData(products);
    } catch (e, st) {
      // If we have data, don't break the UI with an error screen, just log it.
      if (state.value == null) {
        state = AsyncError(e, st);
      } else {
        debugPrint("Error refreshing favorites: $e");
      }
    }
  }

  Future<void> removeFavorite(int productId) async {
    // OPTIMISTIC UPDATE: Remove from UI immediately for snappy feel
    final currentList = state.value ?? [];
    final updatedList = currentList.where((p) => p.id != productId).toList();
    state = AsyncData(updatedList);

    try {
      // Call API in background
      await ref.read(productServiceProvider).favoriteProductAddRemove(productId: productId);
    } catch (e) {
      debugPrint("Error removing favorite: $e");
      // Optional: Revert state if API fails
    }
  }
}
///-----------fav--------------------------------
// -----------------------------------------------------------------------------
// 1. FIX: Provider Definition matches the Controller type
// -----------------------------------------------------------------------------
final productControllerProvider =
StateNotifierProvider<ProductController, AsyncValue<List<Product>>>(
        (ref) => ProductController(ref));


// -----------------------------------------------------------------------------
// 2. FIX: Class extends AsyncValue<List<Product>>, NOT bool
// -----------------------------------------------------------------------------
class ProductController extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;

  // 3. FIX: Initialize with AsyncData([]) instead of 'false'
  ProductController(this.ref) : super(const AsyncData([]));

  int? _total;
  int? get total => _total;

  // Helper to access the current list easily
  List<Product> get products => state.value ?? [];

  List<Product> _favoriteProducts = [];
  List<Product> get favoriteProducts => _favoriteProducts;

  Filters? _filter;
  Filters? get filter => _filter;

  /// 🔥 NEW METHOD FOR REFRESH
  Future<void> refreshProducts({
    required ProductFilterModel filter,
  }) async {
    try {
      state = const AsyncValue.loading();

      final response = await ref
          .read(productServiceProvider)
          .getCategoryWiseProducts(productFilterModel: filter);

      _total = response.data['data']['total'];
      List<dynamic> productData = response.data['data']['products'];
      _filter = Filters.fromMap(response.data['data']['filters']);

      final newProducts = productData.map((product) => Product.fromMap(product)).toList();

      state = AsyncValue.data(newProducts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getCategoryWiseProducts({
    required ProductFilterModel productFilterModel,
    required bool isPagination,
  }) async {
    try {
      // 4. FIX: Use AsyncLoading state instead of 'state = true'
      if (!isPagination) {
        state = const AsyncLoading();
      }

      final response = await ref
          .read(productServiceProvider)
          .getCategoryWiseProducts(productFilterModel: productFilterModel);

      _total = response.data['data']['total'];
      List<dynamic> productData = response.data['data']['products'];
      _filter = Filters.fromMap(response.data['data']['filters']);

      final newProducts = productData.map((product) => Product.fromMap(product)).toList();

      // 5. FIX: Update state with AsyncData
      if (isPagination) {
        final currentList = state.valueOrNull ?? [];
        state = AsyncData([...currentList, ...newProducts]);
      } else {
        state = AsyncData(newProducts);
      }

    } catch (error, stackTrace) {
      debugPrint(error.toString());
      // 6. FIX: Handle errors properly
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<CommonResponse> favoriteProductAddRemove({
    required int productId,
  }) async {
    try {
      final response = await ref
          .read(productServiceProvider)
          .favoriteProductAddRemove(productId: productId);
      return CommonResponse(isSuccess: true, message: response.data['message']);
    } catch (error) {
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> getFavoriteProducts() async {
    try {
      // Note: We don't set 'state' here because 'state' drives the main grid.
      // If you want a loader for favorites, use a separate provider.
      final response =
      await ref.read(productServiceProvider).getFavoriteProducts();
      List<dynamic> favoriteProductsData = response.data['data']['products'];
      _favoriteProducts = favoriteProductsData
          .map((product) => Product.fromMap(product))
          .toList();
      return CommonResponse(isSuccess: true, message: response.data['message']);
    } catch (error) {
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }
}

// -----------------------------------------------------------------------------
// Product Details Controller (Unchanged)
// -----------------------------------------------------------------------------
final productDetailsControllerProvider = StateNotifierProvider.family
    .autoDispose<ProductDetailsController,
    AsyncValue<product_details.ProductDetails>, int>((ref, productId) {
  final controller = ProductDetailsController(ref);
  controller.getProductDetails(productId: productId);
  return controller;
});

class ProductDetailsController
    extends StateNotifier<AsyncValue<product_details.ProductDetails>> {
  final Ref ref;
  ProductDetailsController(this.ref) : super(const AsyncLoading());

  Future<void> getProductDetails({required int productId}) async {
    try {
      final response = await ref
          .read(productServiceProvider)
          .getProductDetails(productId: productId);
      final productData = response.data['data'];
      state = AsyncData(product_details.ProductDetails.fromMap(productData));
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      state = AsyncError(
          error is DioException ? ApiInterceptors.handleError(error) : error,
          stackTrace);
      rethrow;
    }
  }
}