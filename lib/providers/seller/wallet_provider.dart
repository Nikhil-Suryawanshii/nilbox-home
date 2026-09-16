import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/seller/wallet/wallet_details.dart';
import 'package:ready_ecommerce/repositories/seller/wallet_repository.dart';
import 'package:ready_ecommerce/services/seller/wallet_service.dart';

final walletRepositoryProvider = Provider<WalletRepository>((slref) {
  return WalletRepository(slref: slref);
});

// Wallet service provider

final walletDetailsServiceProvider = StateNotifierProviderFamily<
  WalletDetailsService,
  AsyncValue<WalletDetails>,
  String
>((ref, filter) {
  final service = WalletDetailsService(slref: ref);
  service.getWalletDetails(filterType: filter);
  return service;
});

final walletHistoryServiceProvider =
    StateNotifierProvider<WalletHistoryService, bool>(
      (slref) => WalletHistoryService(slref: slref),
    );
