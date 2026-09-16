import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/seller/common/common_model.dart';
import 'package:ready_ecommerce/models/seller/order/order_filter_model.dart';
import 'package:ready_ecommerce/models/seller/order/order_model.dart';
import 'package:ready_ecommerce/models/seller/order/order_status_model.dart';
import 'package:ready_ecommerce/providers/seller/order_provider.dart';

class OrderService extends StateNotifier<bool> {
  final Ref slref;
  OrderService({required this.slref}) : super(false);

  late int _totalOrders;

  int get totalOrders => _totalOrders;

  List<SellerOrder> _orders = [];

  List<SellerOrder> get orders => _orders;

  List<OrderStatusModel> _orderStatusList = [];

  List<OrderStatusModel> get orderStatusList => _orderStatusList;

  Future<void> getOrders({required OrderFilterModel filter}) async {
    state = true;
    try {
      final response = await slref
          .read(orderRepositoryProvider)
          .getOrders(filter: filter);

      _totalOrders = response.data['data']['total_items'];
      List<dynamic> ordersData = response.data['data']['orders'];
      if (filter.page > 1) {
        _orders = [
          ..._orders,
          ...ordersData.map((order) => SellerOrder.fromJson(order)),
        ];
      } else {
        _orders = ordersData.map((order) => SellerOrder.fromJson(order)).toList();
        List<dynamic> ordersStatusData = response.data['data']['status_orders'];

        _orderStatusList =
            ordersStatusData
                .map((orderStatus) => OrderStatusModel.fromMap(orderStatus))
                .toList();
      }
      state = false;
    } catch (e) {
      state = false;
      debugPrint('Error in getOrders: $e');
      rethrow;
    }
  }
}

class OrderStatusService extends StateNotifier<bool> {
  final Ref slref;
  OrderStatusService({required this.slref}) : super(false);

  Future<CommonResponseModel> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(orderRepositoryProvider)
          .updateOrderStatus(orderId: orderId, status: status);
      final isSucceess = response.statusCode == 200;
      state = false;
      return CommonResponseModel(
        status: isSucceess,
        message: response.data['message'],
      );
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponseModel(status: false, message: e.toString());
    }
  }
}

class OrderDetailsService extends StateNotifier<AsyncValue<SellerOrder>> {
  final Ref slref;
  OrderDetailsService({required this.slref})
    : super(const AsyncValue.loading());

  Future<void> getOrderDetails({required int orderId}) async {
    try {
      final response = await slref
          .read(orderRepositoryProvider)
          .getOrderDetails(orderId: orderId);
      state = AsyncValue.data(SellerOrder.fromJson(response.data['data']['order']));
    } catch (e) {
      debugPrint(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
