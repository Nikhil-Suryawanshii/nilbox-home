import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/services/seller/hive_service.dart';
import 'package:ready_ecommerce/repositories/seller/common_repository.dart';

import '../../models/seller/auth/login_response_model.dart/user.dart';

final sellerCommonRepositoryProvider = Provider(
  (slref) => SellerCommonRepository(slref: slref),
);

final sellerHiveServiceProvider = Provider((slref) => SellerHiveService(slref: slref));

final sellerUserProvider = FutureProvider<LoginUser?>((ref) async {
  return ref.read(sellerHiveServiceProvider).getUserInfo();
});
