import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

abstract class SellerCommonRepositoryInterface {
  Future<Response> checkUserStatus({required String phone});
  Future<Response> getMasterData();
}

class SellerCommonRepository implements SellerCommonRepositoryInterface {
  final Ref slref;
  SellerCommonRepository({required this.slref});

  @override
  Future<Response> checkUserStatus({required String phone}) async {
    // Uses AppConstants.sellerCheckUserStatus as per the merged constants
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerCheckUserStatus, query: {'phone': phone});
    return response;
  }

  @override
  Future<Response> getMasterData() async {
    // Shared master data endpoint
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.settings);
    return response;
  }
}