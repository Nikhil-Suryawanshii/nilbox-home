import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/utils/api_client.dart';


abstract class DashboardRepositoryInterface {
  Future<Response> getDashboardData({required String filter});
}

class DashboardRepository implements DashboardRepositoryInterface {
  DashboardRepository({required this.slref});
  final Ref slref;
  @override
  Future<Response> getDashboardData({required String filter}) async {
    final response = await slref
        .read(apiClientProvider)
        .get(AppConstants.sellerDashboard, query: {'filter_type': filter});
    return response;
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((slref) {
  return DashboardRepository(slref: slref);
});
