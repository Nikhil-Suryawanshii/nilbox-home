// // import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ready_ecommerce/models/seller/auth/login_response_model.dart/user.dart';
// import 'package:ready_ecommerce/models/seller/auth/sign_up_model.dart';
// import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
// import 'package:ready_ecommerce/models/seller/common/common_model.dart';
// import 'package:ready_ecommerce/providers/seller/common_provider.dart';
// import 'package:ready_ecommerce/utils/api_client.dart';

// class SellerAuthService extends StateNotifier<bool> {
//   final Ref slref;
//   SellerAuthService({required this.slref}) : super(false);

//   Future<CommonResponseModel> login({
//     required String contact,
//     required String password,
//   }) async {
//     try {
//       state = true;
//       final response = await slref
//           .read(sellerAuthRepositoryProvider)
//           .login(contact: contact, password: password);
//       final status = response.statusCode == 200;
//       if (status) {
//         final userInfo = LoginUser.fromMap(response.data['data']['user']);
//         // Save to SELLER specific Hive box
//         await slref.read(sellerHiveServiceProvider).saveToken(token: response.data['data']['access']['token']);
//         slref.read(apiClientProvider).updateToken(token: response.data['data']['access']['token']);
//         await slref.read(sellerHiveServiceProvider).saveUserInfo(userInfo: userInfo);
//       }
//       state = false;
//       return CommonResponseModel(
//         status: status,
//         message: status ? '' : response.data['message'],
//       );
//     } catch (e) {
//       state = false;
//       return CommonResponseModel(status: false, message: 'Login Error: $e');
//     }
//   }

//   Future<CommonResponseModel> signUp({
//     required SignUpModel signUpModel,
//     required XFile profile,
//     required XFile shopLogo,
//     required XFile shopBanner,
//   }) async {
//     try {
//       state = true;
//       final response = await slref.read(sellerAuthRepositoryProvider).signUp(
//             signUpModel: signUpModel,
//             profile: profile,
//             shopBanner: shopLogo,
//             shopLogo: shopBanner,
//           );
//       final status = response.statusCode == 200 || response.statusCode == 201;
//       state = false;
//       return CommonResponseModel(status: status, message: status ? '' : 'Failed to sign up');
//     } catch (e) {
//       state = false;
//       return CommonResponseModel(status: false, message: 'SignUp Error: $e');
//     }
//   }

//   Future<CommonResponseModel> sendOTP({required String email, required bool isForgotPassword}) async {
//     try {
//       state = true;
//       final response = await slref.read(sellerAuthRepositoryProvider).sendOTP(email: email, isForgotPassword: isForgotPassword);
//       state = false;
//       return CommonResponseModel(status: response.statusCode == 200, message: '', data: response.data);
//     } catch (e) {
//       state = false;
//       return CommonResponseModel(status: false, message: e.toString());
//     }
//   }

//   Future<CommonResponseModel> verifyOTP({required String email, required String otp}) async {
//     try {
//       state = true;
//       final response = await slref.read(sellerAuthRepositoryProvider).verifyOTP(email: email, otp: otp);
//       final status = response.statusCode == 200;
//       state = false;
//       return CommonResponseModel(
//         status: status,
//         message: status ? '' : 'Failed to verify OTP',
//         data: status ? response.data['data']['token'] : null,
//       );
//     } catch (e) {
//       state = false;
//       return CommonResponseModel(status: false, message: 'Verify Error: $e');
//     }
//   }
// }

// // final sellerAuthServiceProvider = StateNotifierProvider<SellerAuthService, bool>((slref) => SellerAuthService(slref: slref));
// // final sellerAuthRepositoryProvider = Provider<SellerAuthRepository>((slref) => SellerAuthRepository(slref: slref));


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/models/seller/auth/login_response_model.dart/user.dart';
import 'package:ready_ecommerce/models/seller/auth/sign_up_model.dart';
import 'package:ready_ecommerce/providers/seller/auth_provider.dart';
import 'package:ready_ecommerce/models/seller/common/common_model.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

class SellerAuthService extends StateNotifier<bool> {
  final Ref slref;
  SellerAuthService({required this.slref}) : super(false);

 Future<CommonResponseModel> login({
    required String contact,
    required String password,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(sellerAuthRepositoryProvider)
          .login(contact: contact, password: password);

      if (response.statusCode == 200) {
        final rawData = response.data['data'];
        
        // 1. Map the User and nested Shop data
        final userInfo = LoginUser.fromMap(rawData['user']);
        
        // 2. Extract Token
        final String token = rawData['access']['token'];

        // 3. Save to Hive using our new service
        final hive = slref.read(sellerHiveServiceProvider);
        await hive.saveToken(token: token);
        await hive.saveUserInfo(userInfo: userInfo);

        // 4. Update the API Client with the new token for future requests
        slref.read(apiClientProvider).updateToken(token: token);

        state = false;
        return CommonResponseModel(status: true, message: "Log In Successful");
      }
      
      state = false;
      return CommonResponseModel(status: false, message: response.data['message']);
    } catch (e) {
      state = false;
      return CommonResponseModel(status: false, message: 'Login Error: $e');
    }
  }

  Future<CommonResponseModel> forgotPassword({
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    state = true;
    try {
      final response = await slref
          .read(sellerAuthRepositoryProvider)
          .forgotPassword(
            password: password,
            confirmPassword: confirmPassword,
            token: token,
          );
      final status = response.statusCode == 200;
      state = false;
      return CommonResponseModel(
        status: status,
        message: response.data['message'] ?? (status ? 'Password reset successfully' : 'Failed to reset password'),
      );
    } catch (e) {
      debugPrint('Error in forgotPassword: $e');
      state = false;
      return CommonResponseModel(
        status: false,
        message: 'Error in forgotPassword: $e',
      );
    }
  }

  Future<CommonResponseModel> signUp({
    required SignUpModel signUpModel,
    required XFile profile,
    required XFile shopLogo,
    required XFile shopBanner,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(sellerAuthRepositoryProvider)
          .signUp(
            signUpModel: signUpModel,
            profile: profile,
            shopBanner: shopBanner,
            shopLogo: shopLogo,
          );

      final status = response.statusCode == 200 || response.statusCode == 201;
      state = false;

      return CommonResponseModel(
        status: status,
        message: status ? 'Registration Successful' : (response.data['message'] ?? 'Failed to sign up'),
      );
    } catch (e) {
      state = false;
      debugPrint('Error in signUp: $e');
      return CommonResponseModel(status: false, message: 'Error in signUp: $e');
    }
  }

  Future<CommonResponseModel> sendOTP({
    required String email,
    required bool isForgotPassword,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(sellerAuthRepositoryProvider)
          .sendOTP(email: email, isForgotPassword: isForgotPassword);
      state = false;
      final status = response.statusCode == 200;
      return CommonResponseModel(
        status: status,
        message: response.data['message'] ?? '',
        data: response.data,
      );
    } catch (e) {
      state = false;
      return CommonResponseModel(status: false, message: e.toString());
    }
  }

  Future<CommonResponseModel> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(sellerAuthRepositoryProvider)
          .verifyOTP(email: email, otp: otp);

      final status = response.statusCode == 200;
      state = false;

      return CommonResponseModel(
        status: status,
        message: status ? 'OTP Verified' : (response.data['message'] ?? 'Failed to verify OTP'),
        data: status ? response.data['data']['token'] : null,
      );
    } catch (e) {
      state = false;
      debugPrint('Error in verifyOTP: $e');
      return CommonResponseModel(
        status: false,
        message: 'Error in verifyOTP: $e',
      );
    }
  }

  Future<CommonResponseModel> checkPhoneAndEmail({
    required String email,
    required String phone,
  }) async {
    try {
      state = true;
      final response = await slref
          .read(sellerAuthRepositoryProvider)
          .checkPhoneAndEmail(email: email, phone: phone);
      state = false;
      final status = response.statusCode == 200;
      return CommonResponseModel(
        status: status,
        message: response.data['message'] ?? '',
        data: response.data,
      );
    } catch (e) {
      state = false;
      return CommonResponseModel(status: false, message: e.toString());
    }
  }
}