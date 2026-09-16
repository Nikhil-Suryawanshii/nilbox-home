import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

final sellerReturnOrderRepositoryProvider = Provider<SellerReturnOrderRepository>(
  (ref) => SellerReturnOrderRepository(ref),
);

class SellerReturnOrderRepository {
  final Ref ref;

  SellerReturnOrderRepository(this.ref);

  Future<Response> updateReturnOrderStatus(int id, String status) async {
    final formData = FormData.fromMap({'status': status});
    return await ref.read(apiClientProvider).post(
          AppConstants.sellerUpdateReturnOrderStatus(id),
          data: formData,
        );
  }

  Future<Response> getReturnOrders() async {
    return await ref.read(apiClientProvider).get(AppConstants.sellerReturnOrders);
  }
}