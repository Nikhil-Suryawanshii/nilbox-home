import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/seller/common/master_model.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';

class SellerCommonService extends StateNotifier<bool> {
  final Ref slref;
  SellerCommonService({required this.slref}) : super(false);

  MasterModel? _masterModel;
  MasterModel? get masterModel => _masterModel;

  Future<bool> checkUser({required String phone}) async {
    try {
      final response = await slref
          .read(sellerCommonRepositoryProvider)
          .checkUserStatus(phone: phone);
      
      bool userStatus = response.data['data']['user_status'];
      if (userStatus) {
        // Clear seller-specific settings if status is true
        await Hive.box(AppConstants.appSettingsBox).clear();
      }
      return userStatus;
    } catch (e) {
      debugPrint("Seller CheckUser Error: ${e.toString()}");
      return false;
    }
  }

  Future<MasterModel?> getMasterData() async {
    try {
      final response =
          await slref.read(sellerCommonRepositoryProvider).getMasterData();
      MasterModel masterModel = MasterModel.fromJson(response.data);
      _masterModel = masterModel;
      return masterModel;
    } catch (e, stk) {
      debugPrint(stk.toString());
      debugPrint(e.toString());
    }
    return null;
  }
}

final sellerCommonServiceProvider = StateNotifierProvider<SellerCommonService, bool>(
  (slref) => SellerCommonService(slref: slref),
);