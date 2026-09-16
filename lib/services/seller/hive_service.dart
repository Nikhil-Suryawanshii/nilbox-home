import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/seller/auth/login_response_model.dart/user.dart';

class SellerHiveService {
  final Ref slref;
  SellerHiveService({required this.slref});

  // Save auth token in the seller-specific box
  Future<void> saveToken({required String token}) async {
    final box = Hive.box(AppConstants.sellerAuthBox);
    await box.put(AppConstants.sellerAuthToken, token);
  }

  // Get seller auth token
  // Future<String?> getToken() async {
  //   final box = Hive.box(AppConstants.sellerAuthBox);
  //   return box.get(AppConstants.sellerAuthToken);
  // }

  Future<String?> getToken() async {
    final authToken = await Hive.openBox(AppConstants.sellerAuthBox)
        .then((box) => box.get(AppConstants.sellerAuthToken));

    if (authToken != null) {
      return authToken;
    }
    return null;
  }

  bool sellerIsLoggedIn() {
    final userAuthToken =
        Hive.box(AppConstants.sellerAuthBox).get(AppConstants.sellerAuthToken);
    return userAuthToken == null ? false : true;
  }

  Future<void> clearToken() async {
    final box = Hive.box(AppConstants.sellerAuthBox);
    await box.delete(AppConstants.sellerAuthToken);
  }

  // Save Seller-specific info
  Future saveUserInfo({required LoginUser userInfo}) async {
    final userBox = Hive.box(AppConstants.sellerUserBox);
    await userBox.put(AppConstants.sellerData, userInfo.toMap());
  }

  Future<LoginUser?> getUserInfo() async {
    final userBox = Hive.box(AppConstants.sellerUserBox);
    Map<dynamic, dynamic>? userInfo = userBox.get(AppConstants.sellerData);
    if (userInfo != null) {
      return LoginUser.fromMap(userInfo.cast<String, dynamic>());
    }
    return null;
  }

  // Shared settings (Themes and Locales)
  Future setAppTheme({required bool isDarkTheme}) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(AppConstants.isDarkTheme, isDarkTheme);
  }

  Future setAppLocale({required String appLocale}) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(AppConstants.appLocal, appLocale);
  }

   String getAppLocale() {
    final appSettingsBox = Hive.box(AppConstants.appSettingsBox);
    return appSettingsBox.get(AppConstants.appLocal, defaultValue: 'en');
  }

  ///------logout---------
  Future<void> sellerLogout() async {
    /// 🔹 Clear seller auth token
    final authBox = Hive.box(AppConstants.sellerAuthBox);
    await authBox.delete(AppConstants.sellerAuthToken);

    /// 🔹 Clear seller user data
    final userBox = Hive.box(AppConstants.sellerUserBox);
    await userBox.delete(AppConstants.sellerData);

    /// 🔹 OPTIONAL: Clear entire boxes if you want full reset
    // await authBox.clear();
    // await userBox.clear();
  }
}