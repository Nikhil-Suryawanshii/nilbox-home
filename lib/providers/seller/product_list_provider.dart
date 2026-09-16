import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/seller/product/product_list.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

final sellerProductsProvider = FutureProvider.autoDispose<List<SellerProduct>>((ref) async {
  final response = await ref.read(apiClientProvider).get(AppConstants.sellerGetProducts);
  final List data = response.data['data']['products'];
  return data.map((e) => SellerProduct.fromJson(e)).toList();
});

// State for search
final productSearchProvider = StateProvider.autoDispose<String>((ref) => "");