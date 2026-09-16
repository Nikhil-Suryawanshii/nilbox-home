import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/repositories/seller/withdraw_repository.dart';

class WithdrawService extends StateNotifier<bool> {
  final Ref slref;
  WithdrawService({required this.slref}) : super(false);

  Future<bool> withdrawWallet({required String amount}) async {
    try {
      state = true;
      final response = await slref
          .read(withdrawRepositoryProvider)
          .withdrawWallet(amount: amount);
      final status = response.statusCode == 200;
      state = false;
      return status;
    } catch (error) {
      debugPrint('Error in withdrawWallet: $error');
      state = false;
      return false;
    }
  }
}