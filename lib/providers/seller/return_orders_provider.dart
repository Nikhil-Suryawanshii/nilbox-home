import 'package:flutter_riverpod/flutter_riverpod.dart';// Create this model
import 'package:ready_ecommerce/models/seller/return_order/return_order_model.dart';
import 'package:ready_ecommerce/repositories/seller/return_order_repository.dart'; // Create this

final sellerReturnOrdersProvider = FutureProvider<ReturnOrdersResponse>((ref) async {
  final repo = ref.read(sellerReturnOrderRepositoryProvider);
  final response = await repo.getReturnOrders();
  return ReturnOrdersResponse.fromJson(response.data);
});


final updateReturnOrderStatusProvider = StateNotifierProvider<UpdateReturnOrderStatusNotifier, AsyncValue<void>>(
  (ref) => UpdateReturnOrderStatusNotifier(ref),
);

class UpdateReturnOrderStatusNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UpdateReturnOrderStatusNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateStatus(int id, String status) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(sellerReturnOrderRepositoryProvider);
      await repo.updateReturnOrderStatus(id, status);
      state = const AsyncValue.data(null);

      ref.invalidate(sellerReturnOrdersProvider);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}