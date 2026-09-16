import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/seller/order/order_filter_model.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

abstract class OrderRepositoryInterface {
  Future<Response> getOrders({required OrderFilterModel filter});
  Future<Response> updateOrderStatus({
    required int orderId,
    required String status,
  });
  Future<Response> getOrderDetails({required int orderId});
}

class OrderRepository implements OrderRepositoryInterface {
  final Ref slref;
  OrderRepository({required this.slref});
  @override
  Future<Response> getOrders({required OrderFilterModel filter}) async {
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerOrders, query: filter.toMap());
    return response;
  }

  @override
  Future<Response> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    final response = await slref
        .read(apiClientProvider)
        .post(
          AppConstants.sellerUpdateOrderStatus,
          data: {'order_id': orderId, 'order_status': status},
        );
    return response;
  }

  @override
  Future<Response> getOrderDetails({required int orderId}) async {
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerGetOrderDetails, query: {'order_id': orderId});
    return response;
  }
}
