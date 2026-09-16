import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/seller/dashboard/dashboard_data_model.dart';
import 'package:ready_ecommerce/repositories/seller/dashboard_repository.dart';

class DashboardService extends StateNotifier<AsyncValue<DashboardDataModel>> {
  DashboardService({required this.slref}) : super(const AsyncValue.loading());
  final Ref slref;

  Future<void> getDashboardData({required String filter}) async {
    try {
      final response = await slref
          .read(dashboardRepositoryProvider)
          .getDashboardData(filter: filter);
      state = AsyncValue.data(
        DashboardDataModel.fromJson(response.data['data']),
      );
    } catch (e) {
      debugPrint(e.toString());
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}
