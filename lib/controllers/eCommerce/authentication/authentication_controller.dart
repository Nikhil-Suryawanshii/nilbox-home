// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ready_ecommerce/models/eCommerce/authentication/sign_up.dart';
// import 'package:ready_ecommerce/models/eCommerce/authentication/user.dart';
// import 'package:ready_ecommerce/models/eCommerce/common/common_response.dart';
// import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
// import 'package:ready_ecommerce/services/eCommerce/auth_service/auth_service.dart';
// import 'package:ready_ecommerce/utils/api_client.dart';
//
// import '../../../config/app_constants.dart';
//
// final authControllerProvider =
//     StateNotifierProvider<AuthController, bool>((ref) => AuthController(ref));
//
// class AuthController extends StateNotifier<bool> {
//   final Ref ref;
//   AuthController(this.ref) : super(false);
//
//   Future<CommonResponse> singUp({required SingUp singUpInfo}) async {
//     state = true;
//     final response =
//         await ref.read(authServiceProvider).signUp(singUpInfo: singUpInfo);
//     final String message = response.data['message'];
//     if (response.statusCode == 200) {
//       final userInfo = User.fromMap(response.data['data']['user']);
//       final accessToken = response.data['data']['access']['token'];
//       ref.read(hiveServiceProvider).saveUserInfo(userInfo: userInfo);
//       ref.read(hiveServiceProvider).saveUserAuthToken(authToken: accessToken);
//       ref.read(apiClientProvider).updateToken(token: accessToken);
//       state = false;
//       return CommonResponse(isSuccess: true, message: message);
//     }
//     state = false;
//     return CommonResponse(isSuccess: false, message: message);
//   }
//
//   Future<CommonResponse> sendOTP(
//       {required String phone, required bool isForgot})
//   async {
//     try {
//       state = true;
//       final response = await ref
//           .read(authServiceProvider)
//           .sendOTP(phone: phone, isForgot: isForgot);
//       final String message = response.data['message'];
//       final String otp = response.data['data']['otp'].toString();
//       state = false;
//       return CommonResponse(isSuccess: true, message: message, data: otp);
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> verifyOTP(
//       {required String phone, required String otp})
//   async {
//     try {
//       state = true;
//       final response =
//           await ref.read(authServiceProvider).verifyOTP(phone: phone, otp: otp);
//       final String message = response.data['message'];
//       final String token = response.data['data']['token'];
//       state = false;
//       return CommonResponse(isSuccess: true, message: message, data: token);
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> resetPassword({
//     required String password,
//     required String confrimPassword,
//     required String forgotPasswordToken,
//   }) async {
//     try {
//       state = true;
//       final response = await ref.read(authServiceProvider).resetPassword(
//             password: password,
//             confirmPassword: confrimPassword,
//             forgotPasswordToken: forgotPasswordToken,
//           );
//       final String message = response.data['message'];
//
//       if (response.statusCode == 200) {
//         state = false;
//         return CommonResponse(isSuccess: true, message: message);
//       }
//       state = false;
//       return CommonResponse(
//         isSuccess: false,
//         message: message,
//       );
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> login(
//       {required String phone, required String password}) async {
//     try {
//       state = true;
//       final response = await ref
//           .read(authServiceProvider)
//           .login(phone: phone, password: password);
//       final String message = response.data['message'];
//       final userInfo = User.fromMap(response.data['data']['user']);
//       final accessToken = response.data['data']['access']['token'];
//       ref.read(hiveServiceProvider).saveUserInfo(userInfo: userInfo);
//       ref.read(hiveServiceProvider).saveUserAuthToken(authToken: accessToken);
//       ref.read(apiClientProvider).updateToken(token: accessToken);
//       state = false;
//       return CommonResponse(isSuccess: true, message: message);
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> changePassword({
//     required String oldPassword,
//     required String newPassword,
//     required String confirmNewPassword,
//   }) async {
//     try {
//       state = true;
//       final response = await ref.read(authServiceProvider).changePassword(
//             oldPassword: oldPassword,
//             newPassword: newPassword,
//             confirmNewPassword: confirmNewPassword,
//           );
//       final String message = response.data['message'];
//       if (response.statusCode == 200) {
//         state = false;
//         return CommonResponse(isSuccess: true, message: message);
//       } else {
//         state = false;
//         return CommonResponse(isSuccess: false, message: message);
//       }
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> updateProfile(
//       {required User userInfo, required File? file}) async {
//     try {
//       state = true;
//       final response = await ref.read(authServiceProvider).updateProfile(
//             userInfo: userInfo,
//             file: file,
//           );
//       final String message = response.data['message'];
//       final User userData = User.fromMap(response.data['data']['user']);
//       ref.read(hiveServiceProvider).saveUserInfo(userInfo: userData);
//       state = false;
//       return CommonResponse(isSuccess: true, message: message);
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   Future<CommonResponse> logout() async {
//     try {
//       state = true;
//       final response = await ref.read(authServiceProvider).logout();
//       final String message = response.data['message'];
//       state = false;
//       return CommonResponse(isSuccess: true, message: message);
//     } catch (error) {
//       state = false;
//       debugPrint(error.toString());
//       return CommonResponse(isSuccess: false, message: error.toString());
//     }
//   }
//
//   // Inside AuthController class
//   Future<CommonResponse> socialLogin({
//     required String firebaseUid,
//     required String email,
//     String? name,
//     String? phone,
//   }) async {
//     try {
//       state = true; // Set loading state
//
//       final response = await ref.read(apiClientProvider).post(
//         AppConstants.socialLogin,
//         data: {
//           "provider": "google",
//           "firebase_uid": firebaseUid,
//           "email": email,
//           "name": name ?? "New User",
//           // "phone": phone,
//           "phone": '8299807631',
//           "country": "India", // Hardcoded based on your request
//           "phone_code": "91"   // Hardcoded based on your request
//         },
//       );
//
//       // 1. Save the Token and User Data locally (Hive/SharedPreferences)
//       final responseData = response.data['data'];
//
//       final String token = responseData['access']['token'];
//
//
//       await ref.read(hiveServiceProvider).saveUserAuthToken(authToken: token);
//
//       final Map<String, dynamic> user = responseData['user'];
//       final User userObject = User.fromMap(user);
//
//       // await ref.read(hiveServiceProvider).saveUserAuthToken(authToken: token);
//       await ref.read(hiveServiceProvider).saveUserInfo(userInfo: userObject);
//
//       ref.read(apiClientProvider).updateHeader(token);
//
//       state = false; // Stop loading
//       return CommonResponse(isSuccess: true, message: response.data['message']);
//     } catch (e) {
//       state = false;
//       debugPrint("Social Login Error: $e");
//       return CommonResponse(isSuccess: false, message: e.toString());
//     }
//   }
// }

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/eCommerce/authentication/sign_up.dart';
import 'package:ready_ecommerce/models/eCommerce/authentication/user.dart';
import 'package:ready_ecommerce/models/eCommerce/common/common_response.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/services/eCommerce/auth_service/auth_service.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

import '../../../config/app_constants.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(ref));

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  AuthController(this.ref) : super(false);

  Future<CommonResponse> singUp({required SingUp singUpInfo}) async {
    state = true;
    final response =
        await ref.read(authServiceProvider).signUp(singUpInfo: singUpInfo);
    final String message = response.data['message'];
    if (response.statusCode == 200) {
      final userInfo = User.fromMap(response.data['data']['user']);
      final accessToken = response.data['data']['access']['token'];
      ref.read(hiveServiceProvider).saveUserInfo(userInfo: userInfo);
      ref.read(hiveServiceProvider).saveUserAuthToken(authToken: accessToken);
      ref.read(apiClientProvider).updateToken(token: accessToken);
      state = false;
      return CommonResponse(isSuccess: true, message: message);
    }
    state = false;
    return CommonResponse(isSuccess: false, message: message);
  }

  Future<CommonResponse> sendOTP(
      {required String phone, required bool isForgot}) async {
    try {
      state = true;
      final response = await ref
          .read(authServiceProvider)
          .sendOTP(phone: phone, isForgot: isForgot);
      final String message = response.data['message'];
      final String otp = response.data['data']['otp'].toString();
      state = false;
      return CommonResponse(isSuccess: true, message: message, data: otp);
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> verifyOTP(
      {required String phone, required String otp}) async {
    try {
      state = true;
      final response =
          await ref.read(authServiceProvider).verifyOTP(phone: phone, otp: otp);
      final String message = response.data['message'];
      final String token = response.data['data']['token'];
      state = false;
      return CommonResponse(isSuccess: true, message: message, data: token);
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> resetPassword({
    required String password,
    required String confrimPassword,
    required String forgotPasswordToken,
  }) async {
    try {
      state = true;
      final response = await ref.read(authServiceProvider).resetPassword(
            password: password,
            confirmPassword: confrimPassword,
            forgotPasswordToken: forgotPasswordToken,
          );
      final String message = response.data['message'];

      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(isSuccess: true, message: message);
      }
      state = false;
      return CommonResponse(
        isSuccess: false,
        message: message,
      );
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> login(
      {required String phone, required String password}) async {
    try {
      state = true;
      final response = await ref
          .read(authServiceProvider)
          .login(phone: phone, password: password);
      final String message = response.data['message'];
      final userInfo = User.fromMap(response.data['data']['user']);
      final accessToken = response.data['data']['access']['token'];
      ref.read(hiveServiceProvider).saveUserInfo(userInfo: userInfo);
      ref.read(hiveServiceProvider).saveUserAuthToken(authToken: accessToken);
      ref.read(apiClientProvider).updateToken(token: accessToken);
      state = false;
      return CommonResponse(isSuccess: true, message: message);
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      state = true;
      final response = await ref.read(authServiceProvider).changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmNewPassword: confirmNewPassword,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(isSuccess: true, message: message);
      } else {
        state = false;
        return CommonResponse(isSuccess: false, message: message);
      }
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> updateProfile(
      {required User userInfo, required File? file}) async {
    try {
      state = true;
      final response = await ref.read(authServiceProvider).updateProfile(
            userInfo: userInfo,
            file: file,
          );
      final String message = response.data['message'];
      final User userData = User.fromMap(response.data['data']['user']);
      ref.read(hiveServiceProvider).saveUserInfo(userInfo: userData);
      state = false;
      return CommonResponse(isSuccess: true, message: message);
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> logout() async {
    try {
      state = true;
      final response = await ref.read(authServiceProvider).logout();
      final String message = response.data['message'];
      state = false;
      return CommonResponse(isSuccess: true, message: message);
    } catch (error) {
      state = false;
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  // Social Login Method - Corrected based on your response structure
//   Future<CommonResponse> socialLogin({
//     required String firebaseUid,
//     required String email,
//     String? name,
//     String? phone,
//   }) async {
//     try {
//       state = true; // Set loading state

//       final response = await ref.read(apiClientProvider).post(
//         AppConstants.socialLogin,
//         data: {
//           "provider": "google",
//           "firebase_uid": firebaseUid,
//           "email": email,
//           "name": name ?? "New User",
//           "phone": phone ?? "8299807631", // Use provided phone or default
//           "country": "India", // Hardcoded based on your request
//           "phone_code": "91"   // Hardcoded based on your request
//         },
//       );

//       // Check if response is successful
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> responseData = response.data;

//         // Extract message
//         final String message = responseData['message'];

//         // Extract data from response - CORRECTED: The access token is directly under 'data'
//         final Map<String, dynamic> data = responseData['data'];

//         // Extract token - CORRECTED: Based on your response structure
//         final String accessToken = data['access']['token'];

//         // Extract user data - CORRECTED: Based on your response structure
//         final Map<String, dynamic> user = data['user'];
//         final User userObject = User.fromMap(user);

//         // Save token and user data to Hive
//         await ref.read(hiveServiceProvider).saveUserAuthToken(authToken: accessToken);
//         await ref.read(hiveServiceProvider).saveUserInfo(userInfo: userObject);

//         // Update API client token
//         ref.read(apiClientProvider).updateToken(token: accessToken);

//         state = false; // Stop loading

//         return CommonResponse(
//           isSuccess: true,
//           message: message,
//         );
//       } else {
//         // Handle non-200 responses
//         final String errorMessage = response.data['message'] ?? 'Login failed';
//         state = false;
//         return CommonResponse(isSuccess: false, message: errorMessage);
//       }
//     } catch (e) {
//       state = false;
//       debugPrint("Social Login Error: $e");

//       // More detailed error message
//       String errorMessage = "Login failed";
//       if (e is Map<String, dynamic>) {
//         errorMessage = e['message']?.toString() ?? errorMessage;
//       } else if (e.toString().contains("Exception")) {
//         errorMessage = e.toString().replaceAll("Exception: ", "");
//       } else {
//         errorMessage = e.toString();
//       }

//       return CommonResponse(isSuccess: false, message: errorMessage);
//     }
//   }
// }

// Corrected Social Login Method
  Future<CommonResponse> socialLogin({
    required String provider,
    required String firebaseUid,
    required String email,
    String? name,
    String? phone,
  }) async {
    try {
      state = true;

      final response = await ref.read(apiClientProvider).post(
        AppConstants.socialLogin,
        data: {
          "provider": provider,
          "firebase_uid": firebaseUid,
          "email": email,
          "name": name ?? "New User",
          "phone": phone ?? "",
          "country": "India",
          "phone_code": "91"
        },
      );

      // Handle successful login (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        final String message = responseData['message'] ?? "Login Successful";

        // Access the nested data object
        final Map<String, dynamic> data = responseData['data'];

        // Extract token and user info
        final String accessToken = data['access']['token'];
        final User userObject = User.fromMap(data['user']);

        // Persist data locally
        await ref
            .read(hiveServiceProvider)
            .saveUserAuthToken(authToken: accessToken);
        await ref.read(hiveServiceProvider).saveUserInfo(userInfo: userObject);

        // Update the Dio/API Client with the new Bearer token
        ref.read(apiClientProvider).updateToken(token: accessToken);

        state = false;
        return CommonResponse(isSuccess: true, message: message);
      } else {
        state = false;
        return CommonResponse(
            isSuccess: false, message: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      state = false;
      debugPrint("Social Login Error: $e");

      String errorMessage = "Login failed";

      // Handle the 405 Method Not Allowed specifically for debugging
      if (e.toString().contains("405")) {
        errorMessage =
            "Backend Error: The API expects GET but Flutter sent POST. Please update backend routes.";
      } else if (e.toString().contains("401")) {
        errorMessage = "Unauthorized: Firebase token invalid or expired.";
      } else {
        errorMessage = e.toString();
      }

      return CommonResponse(isSuccess: false, message: errorMessage);
    }
  }
}
