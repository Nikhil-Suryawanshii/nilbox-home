import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/seller/dashboard/dashboard_data_model.dart';
import 'package:ready_ecommerce/repositories/seller/dashboard_repository.dart';
import 'package:ready_ecommerce/services/seller/dashboard_service.dart';


final dashboardRepositoryProvider = Provider<DashboardRepository>((slref) {
  return DashboardRepository(slref: slref);
});

// dashboard service provider

final dashboardServiceProvider = StateNotifierProviderFamily<
  DashboardService,
  AsyncValue<DashboardDataModel>,
  String
>((slref, arg) {
  final filter = arg;
  final service = DashboardService(slref: slref);
  service.getDashboardData(filter: filter);
  return service;
});
