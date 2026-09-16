import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/seller/wallet/wallet_history_filter_model.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

abstract class WalletRepositoryInterface {
  Future<Response> getWalletDetails({required String? filterType});
  Future<Response> getWalletHistory({
    required WalletHistoryFilterModel filterModel,
  });
}

class WalletRepository implements WalletRepositoryInterface {
  final Ref slref;
  WalletRepository({required this.slref});
  @override
  Future<Response> getWalletDetails({required String? filterType}) async {
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerWalletDetails , query: {'filter_type': filterType});
    return response;
  }

  @override
  Future<Response> getWalletHistory({
    required WalletHistoryFilterModel filterModel,
  }) async {
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerWalletHistory, query: filterModel.toMap());
    return response;
  }
}