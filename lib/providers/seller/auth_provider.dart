import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/services/seller/auth_service.dart';
import 'package:ready_ecommerce/repositories/seller/auth_repository.dart';

final sellerAuthServiceProvider = StateNotifierProvider<SellerAuthService, bool>((slref) {
  return SellerAuthService(slref: slref);
});

final sellerAuthRepositoryProvider = Provider<SellerAuthRepository>((slref) {
  return SellerAuthRepository(slref: slref);
});