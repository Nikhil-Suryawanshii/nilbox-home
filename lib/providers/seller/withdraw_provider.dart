import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/repositories/seller/withdraw_repository.dart';
import 'package:ready_ecommerce/services/seller/withdraw_service.dart';

final withdrawRepositoryProvider = Provider<WithdrawRepository>(
  (slref) => WithdrawRepository(slref: slref),
);

// withdraw service provider

final withdrawServiceProvider = StateNotifierProvider<WithdrawService, bool>(
  (slref) => WithdrawService(slref: slref),
);
