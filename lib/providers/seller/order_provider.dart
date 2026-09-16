import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/seller/order/order_model.dart';
import 'package:ready_ecommerce/repositories/seller/order_repository.dart';
import 'package:ready_ecommerce/services/seller/order_service.dart';


final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(slref: ref);
});

final orderServiceProvider = StateNotifierProvider<OrderService, bool>((ref) {
  return OrderService(slref: ref);
});

final orderStatusProvider = StateNotifierProvider<OrderStatusService, bool>((ref) {
  return OrderStatusService(slref: ref);
});


final orderDetailsServiceProvider = StateNotifierProvider.family
    .autoDispose<OrderDetailsService, AsyncValue<SellerOrder>, int>((ref, orderId) {
      final service = OrderDetailsService(slref: ref);
      service.getOrderDetails(orderId: orderId);
      return service;
    });