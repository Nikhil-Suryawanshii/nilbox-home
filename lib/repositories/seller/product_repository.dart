import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

class SellerProductRepository {
  final Ref slref;
  SellerProductRepository({required this.slref});

  Future<Response> getProductCreateData() async {
    return await slref.read(apiClientProvider).get(AppConstants.sellerProductMetaData);
  }

  Future<Response> getProductDetails(int id) async {
    return await slref.read(apiClientProvider).get(AppConstants.sellerGetProductDetails(id));
  }

  Future<Response> storeProduct(FormData formData) async {
    return await slref.read(apiClientProvider).post(
          AppConstants.sellerAddProduct,
          data: formData,
        );
  }
}

final sellerProductRepositoryProvider = Provider((slref) => SellerProductRepository(slref: slref));