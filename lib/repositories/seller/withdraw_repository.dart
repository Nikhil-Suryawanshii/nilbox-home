import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

abstract class WithdrawRepositoryInterface {
  Future<Response> withdrawWallet({required String amount});
}

class WithdrawRepository implements WithdrawRepositoryInterface {
  final Ref slref;
  WithdrawRepository({required this.slref});
  @override
  Future<Response> withdrawWallet({required String amount}) async {
    final response = await slref
        .read(apiClientProvider)
        .post(AppConstants.sellerWithdrawWallet, data: {'amount': amount});
    return response;
  }
}

final withdrawRepositoryProvider = Provider<WithdrawRepository>(
  (slref) => WithdrawRepository(slref: slref),
);
