// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ready_ecommerce/config/app_constants.dart';
// import 'package:ready_ecommerce/models/seller/auth/sign_up_model.dart';
// import 'package:ready_ecommerce/utils/api_client.dart';

// class SellerAuthRepository {
//   final Ref slref;
//   SellerAuthRepository({required this.slref});

//   Future<Response> login({required String contact, required String password}) async {
//     return await slref.read(apiClientProvider).post(
//       AppConstants.sellerLogin,
//       data: {'contact': contact, 'password': password},
//     );
//   }

//   Future<Response> signUp({
//     required SignUpModel signUpModel,
//     required XFile profile,
//     required XFile shopLogo,
//     required XFile shopBanner,
//   }) async {
//     FormData formData = FormData.fromMap({
//       'profile_photo': await MultipartFile.fromFile(profile.path),
//       'shop_logo': await MultipartFile.fromFile(shopLogo.path),
//       'shop_banner': await MultipartFile.fromFile(shopBanner.path),
//       ...signUpModel.toMap(),
//     });
//     return await slref.read(apiClientProvider).post(AppConstants.sellerSignUp, data: formData);
//   }

//   Future<Response> sendOTP({required String email, required bool isForgotPassword}) async {
//     return await slref.read(apiClientProvider).post(
//       AppConstants.sellerSendOTP,
//       data: {'email': email, 'forgot_password': isForgotPassword},
//     );
//   }

//   Future<Response> verifyOTP({required String email, required String otp}) async {
//     return await slref.read(apiClientProvider).post(AppConstants.sellerVerifyOTP, data: {'email': email, 'otp': otp});
//   }

//   Future<Response> forgotPassword({required String password, required String confirmPassword, required String token}) async {
//     return await slref.read(apiClientProvider).post(
//       AppConstants.sellerForgotPassword,
//       data: {'password': password, 'password_confirmation': confirmPassword, 'token': token},
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/seller/auth/sign_up_model.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

abstract class SellerAuthRepositoryInterface {
  Future<Response> login({required String contact, required String password});
  Future<Response> signUp({
    required SignUpModel signUpModel,
    required XFile profile,
    required XFile shopLogo,
    required XFile shopBanner,
  });
  Future<Response> sendOTP({
    required String email,
    required bool isForgotPassword,
  });
  Future<Response> verifyOTP({required String email, required String otp});
  Future<Response> forgotPassword({
    required String password,
    required String confirmPassword,
    required String token,
  });
  Future<Response> checkPhoneAndEmail({
    required String email,
    required String phone,
  });
}

class SellerAuthRepository implements SellerAuthRepositoryInterface {
  final Ref slref;
  SellerAuthRepository({required this.slref});

  @override
  Future<Response> login({
    required String contact,
    required String password,
  }) async {
    final response = await slref.read(apiClientProvider).post(
      AppConstants.sellerLogin,
      data: {'contact': contact, 'password': password},
    );
    return response;
  }

  @override
  Future<Response> signUp({
    required SignUpModel signUpModel,
    required XFile profile,
    required XFile shopLogo,
    required XFile shopBanner,
  }) async {
    FormData formData = FormData.fromMap({
      'profile_photo': await MultipartFile.fromFile(profile.path),
      'shop_logo': await MultipartFile.fromFile(shopLogo.path),
      'shop_banner': await MultipartFile.fromFile(shopBanner.path),
      ...signUpModel.toMap(),
    });
    
    final response = await slref
        .read(apiClientProvider)
        .post(AppConstants.sellerSignUp, data: formData);

    return response;
  }

  @override
  Future<Response> sendOTP({
    required String email,
    required bool isForgotPassword,
  }) async {
    final response = await slref.read(apiClientProvider).post(
      AppConstants.sellerSendOTP,
      data: {'email': email, 'forgot_password': isForgotPassword},
    );
    return response;
  }

  @override
  Future<Response> verifyOTP({
    required String email,
    required String otp,
  }) async {
    final response = await slref
        .read(apiClientProvider)
        .post(AppConstants.sellerVerifyOTP, data: {'email': email, 'otp': otp});
    return response;
  }

  @override
  Future<Response> forgotPassword({
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    final response = await slref.read(apiClientProvider).post(
      AppConstants.sellerForgotPassword,
      data: {
        'password': password,
        'password_confirmation': confirmPassword,
        'token': token,
      },
    );
    return response;
  }

  @override
  Future<Response> checkPhoneAndEmail({
    required String email,
    required String phone,
  }) async {
    final response = await slref.read(apiClientProvider).post(
      AppConstants.sellerCheckPhoneAndEmail,
      data: {'email': email, 'phone': phone},
    );
    return response;
  }
}