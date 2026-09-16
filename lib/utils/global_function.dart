// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:ready_ecommerce/config/app_color.dart';
// import 'package:ready_ecommerce/config/app_constants.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
// import 'package:ready_ecommerce/generated/l10n.dart';
// import 'package:ready_ecommerce/models/eCommerce/order/order_model.dart';

// import '../controllers/common/master_controller.dart';

// class GlobalFunction {
//   static void changeStatusBarTheme({required isDark}) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
//       ),
//     );
//   }

//   static final GlobalKey<NavigatorState> navigatorKey =
//       GlobalKey<NavigatorState>();

//   static void showCustomSnackbar({
//     required String message,
//     required bool isSuccess,
//   }) {
//     final snackBar = SnackBar(
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       dismissDirection: DismissDirection.startToEnd,
//       backgroundColor: isSuccess
//           ? colors(navigatorKey.currentState!.context).primaryColor
//           : colors(navigatorKey.currentState!.context).errorColor,
//       content: Text(message),
//     );
//     ScaffoldMessenger.of(navigatorKey.currentState!.context)
//         .showSnackBar(snackBar);
//   }

//   static Future<void> pickImageFromGallery({required WidgetRef ref}) async {
//     final picker = ImagePicker();
//     await picker.pickImage(source: ImageSource.gallery).then((imageFile) {
//       if (imageFile != null) {
//         ref.read(selectedUserProfileImage.notifier).state = imageFile;
//       }
//     });
//   }

//   static String errorText(
//       {required String fieldName, required BuildContext context}) {
//     return '$fieldName ${S.of(context).isRequired}';
//   }

//   static String? commonValidator({
//     required String value,
//     required String hintText,
//     required BuildContext context,
//   }) {
//     if (value.isEmpty) {
//       return errorText(fieldName: hintText, context: context);
//     }
//     return null;
//   }

//   static String? phoneValidator({
//     required String value,
//     required String hintText,
//     required BuildContext context,
//     int? minLength,
//     int? maxLength,
//     bool? isPhoneRequired,
//   }) {
//     // Step 1: Check if input is required and empty
//     if (isPhoneRequired == true && value.isEmpty) {
//       return errorText(fieldName: hintText, context: context);
//     }

//     // Step 2: Only validate length if a value is provided
//     if (value.isNotEmpty) {
//       if (minLength != null && value.length < minLength) {
//         return 'Please enter a valid $hintText with at least $minLength characters';
//       }
//       if (maxLength != null && value.length > maxLength) {
//         return 'Please enter a valid $hintText with at most $maxLength characters';
//       }
//     }

//     return null;
//   }

//   static String? emailValidator({
//     required String value,
//     required String hintText,
//     required BuildContext context,
//   }) {
//     final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

//     if (value.isEmpty) {
//       return errorText(fieldName: hintText, context: context);
//     } else if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid $hintText';
//     }
//     return null;
//   }

//   static String? passwordValidator({
//     required String value,
//     required String hintText,
//     required BuildContext context,
//   }) {
//     if (value.isEmpty) {
//       return errorText(fieldName: hintText, context: context);
//     } else if (value.length < 6) {
//       return 'Please enter a valid $hintText with at least 6 characters';
//     }

//     return null;
//   }

//   static Color getBackgroundColor({required BuildContext context}) {
//     return Theme.of(context).scaffoldBackgroundColor == EcommerceAppColor.black
//         ? EcommerceAppColor.black
//         : EcommerceAppColor.white;
//   }

//   static Color getContainerColor() {
//     bool isDark = Hive.box(AppConstants.appSettingsBox)
//         .get(AppConstants.isDarkTheme, defaultValue: false);

//     return isDark ? EcommerceAppColor.black : EcommerceAppColor.white;
//   }

//   static Widget getStatusWidget(
//       {required BuildContext context, required String status}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
//       decoration: BoxDecoration(
//         color: getStatusWidgetColor(context: context, status: status),
//         borderRadius: BorderRadius.circular(30.r),
//       ),
//       child: Center(
//         child: Text(
//           status.toUpperCase()[0] + status.substring(1),
//           style: AppTextStyle(context)
//               .bodyText
//               .copyWith(fontSize: 12.sp, color: EcommerceAppColor.white),
//         ),
//       ),
//     );
//   }

//   static String formatDeliveryAddress({
//     required BuildContext context,
//     required Address address,
//   }) {
//     // Create a list of the address components
//     List<String?> addressComponents = [
//       address.addressLine,
//       address.flatNo,
//       address.addressLine2,
//       address.area,
//       address.postCode,
//     ];

//     // Filter out null or empty values and join them with a comma
//     return addressComponents
//         .where((element) =>
//             element != null &&
//             element.isNotEmpty) // Filter out null and empty values
//         .map((element) => element!) // Safely unwrapping non-null values
//         .join(", "); // Join with a comma and a space
//   }

//   static Color getStatusWidgetColor(
//       {required BuildContext context, required String status}) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return EcommerceAppColor.gray;
//       case 'confirm':
//         return EcommerceAppColor.carrotOrange;
//       case 'processing':
//         return EcommerceAppColor.blue;
//       case 'on the way':
//         return EcommerceAppColor.primary;
//       case 'delivered':
//         return EcommerceAppColor.green;
//       case 'refunded':
//         return EcommerceAppColor.green;
//       case 'approved':
//         return EcommerceAppColor.blue;
//       case 'cancelled':
//         return EcommerceAppColor.red;
//       case 'mismatch':
//         return EcommerceAppColor.orange;
//       case 'damaged':
//         return EcommerceAppColor.yellow;
//       default:
//         return EcommerceAppColor.red;
//     }
//   }

//   static double getPrice(
//       {required double currentPrice, required double discountPrice}) {
//     return discountPrice > 0 ? discountPrice : currentPrice;
//   }

//   static String price({
//     required String price,
//     required WidgetRef ref,
//   }) {
//     var currecy = ref.watch(currencyProvider);

//     final String actualPrice =
//         (double.parse(price) * currecy.rate).toStringAsFixed(2);
//     if (currecy.position.trim() == 'prefix') {
//       return '${currecy.symbol}$actualPrice';
//     } else {
//       return '$actualPrice${currecy.symbol}';
//     }
//   }

//   static String formatMessageDateTime(DateTime dateTime) {
//     try {
//       DateTime parsedDate = dateTime.toLocal(); // Convert to local time
//       return DateFormat('h:mm a, MMMM dd, yyyy').format(parsedDate);
//     } catch (e) {
//       return "Invalid date";
//     }
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart'; // New Import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/order/order_model.dart';
import 'package:ready_ecommerce/models/seller/order/order_model.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import '../controllers/common/master_controller.dart';

class GlobalFunction {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentState!.context;

  static void changeStatusBarTheme({required isDark}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static void showCustomSnackbar({
    required String message,
    required bool isSuccess,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      dismissDirection: DismissDirection.startToEnd,
      backgroundColor: isSuccess
          ? colors(navigatorKey.currentState!.context).primaryColor
          : colors(navigatorKey.currentState!.context).errorColor,
      content: Text(message),
    );
    ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(snackBar);
  }

  // --- START SELLER AUTH PART: Image Utilities ---

  static Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  static Future<XFile?> pickImageFromCamera() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera);
  }

  static Future<File?> compressedImage(File? image) async {
    try {
      if (image == null) return null;
      final int sizeInBytes = image.lengthSync();
      final double sizeInMb = sizeInBytes / (1024 * 1024);

      if (sizeInMb > 2.0) {
        final String targetPath = '${image.path}_compressed.jpg';
        final result = await FlutterImageCompress.compressAndGetFile(
          image.path,
          targetPath,
          quality: 70,
        );
        return result != null ? File(result.path) : image;
      }
      return image;
    } catch (e) {
      debugPrint('Error during image compression: $e');
      return image;
    }
  }

  // --- SELLER AUTH PART: UI Decoration ---

  static InputDecoration inputDecoration({
    required String hintText,
    required Widget? widget,
    Widget? prefixwidget,
    required BuildContext context,
    Color? fillColor,
    double? borderRadius,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      alignLabelWithHint: true,
      hintText: hintText,
      hintStyle: AppTextStyle(context)
          .hintText16B400
          .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
      suffixIcon: widget,
      prefixIcon: prefixwidget,
      filled: true,
      fillColor: fillColor ?? colors(context).containerColor,
      errorStyle: AppTextStyle(context).text14B400.copyWith(color: colors(context).errorColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: BorderSide(color: colors(context).hintTextColor!.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: BorderSide(color: colors(context).hintTextColor!.withOpacity(0.2), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: BorderSide(color: colors(context).primaryColor!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        borderSide: BorderSide(color: colors(context).errorColor!, width: 1.5),
      ),
    );
  }
  // --- END SELLER AUTH PART ---

  // Main App Original Pick Image
  static Future<void> pickImageFromGalleryMain({required WidgetRef ref}) async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((imageFile) {
      if (imageFile != null) {
        ref.read(selectedUserProfileImage.notifier).state = imageFile;
      }
    });
  }

  // Pick date by Flutter DatePicker
  static Future<String?> pickDate({required BuildContext context}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime(2101),
    );
    if (picked != null) return DateFormat('yyyy-MM-dd').format(picked);
    return null;
  }

  static String errorText({required String fieldName, required BuildContext context}) {
    return '$fieldName ${S.of(context).isRequired}';
  }

  static String? commonValidator({
    required String value,
    required String hintText,
    required BuildContext context,
  }) {
    if (value.isEmpty) return errorText(fieldName: hintText, context: context);
    return null;
  }

  static String? phoneValidator({
    required String value,
    required String hintText,
    required BuildContext context,
    int? minLength,
    int? maxLength,
    bool? isPhoneRequired,
  }) {
    if (isPhoneRequired == true && value.isEmpty) return errorText(fieldName: hintText, context: context);
    if (value.isNotEmpty) {
      if (minLength != null && value.length < minLength) return 'At least $minLength characters required';
      if (maxLength != null && value.length > maxLength) return 'At most $maxLength characters required';
    }
    return null;
  }

  static String? emailValidator({required String value, required String hintText, required BuildContext context}) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (value.isEmpty) return errorText(fieldName: hintText, context: context);
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid $hintText';
    return null;
  }

  static String? passwordValidator({required String value, required String hintText, required BuildContext context}) {
    if (value.isEmpty) return errorText(fieldName: hintText, context: context);
    if (value.length < 6) return 'At least 6 characters required';
    return null;
  }

  static Color getBackgroundColor({required BuildContext context}) {
    return Theme.of(context).scaffoldBackgroundColor == EcommerceAppColor.black
        ? EcommerceAppColor.black
        : EcommerceAppColor.white;
  }

  static Color getContainerColor() {
    bool isDark = Hive.box(AppConstants.appSettingsBox).get(AppConstants.isDarkTheme, defaultValue: false);
    return isDark ? EcommerceAppColor.black : EcommerceAppColor.white;
  }

  static Widget getStatusWidget({required BuildContext context, required String status}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: getStatusWidgetColor(context: context, status: status),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Center(
        child: Text(
          status.toUpperCase()[0] + status.substring(1),
          style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp, color: EcommerceAppColor.white),
        ),
      ),
    );
  }

  static Widget getReturnStatusWidget({required BuildContext context, required String status}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: getReturnOrderStatsusColor(context: context, status: status),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Center(
        child: Text(
          status.toUpperCase()[0] + status.substring(1),
          style: AppTextStyle(context).bodyText.copyWith(fontSize: 12.sp, color: EcommerceAppColor.white),
        ),
      ),
    );
  }

  static String formatDeliveryAddress({required BuildContext context, required Address address}) {
    List<String?> components = [address.addressLine, address.flatNo, address.addressLine2, address.area, address.postCode];
    return components.where((e) => e != null && e!.isNotEmpty).join(", ");
  }

  static String getFormattedAddress(SellerAddress address) {
    return '${address.flatNo}, ${address.addressLine}, ${address.addressLine2}, ${address.area}, ${address.postCode}';
  }

  static String appLocale({required WidgetRef slref}) {
    return slref.read(sellerHiveServiceProvider).getAppLocale();
  }

  static Color getStatusWidgetColor({required BuildContext context, required String status}) {
    switch (status.toLowerCase()) {
      case 'pending': return EcommerceAppColor.gray;
      case 'confirm': return EcommerceAppColor.carrotOrange;
      case 'processing': return EcommerceAppColor.blue;
      case 'on the way': return EcommerceAppColor.primary;
      case 'delivered': return EcommerceAppColor.green;
      default: return EcommerceAppColor.red;
    }
  }

  static Color getOrderStatsusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return EcommerceAppColor.orange;
      case 'confirm':
        return EcommerceAppColor.carrotOrange;
      case 'processing':
        return EcommerceAppColor.primary;
      case 'pickup':
        return EcommerceAppColor.blue;
      case 'on the way':
        return EcommerceAppColor.blue;
      case 'delivered':
        return EcommerceAppColor.green;
      default:
        return EcommerceAppColor.red;
    }
  }

  static Color getReturnOrderStatsusColor({required BuildContext context, required String status}) {
    switch (status.toLowerCase()) {
      case 'pending':
        return EcommerceAppColor.orange;
      case 'rejected':
        return EcommerceAppColor.red;
      case 'Damaged':
        return EcommerceAppColor.carrotOrange;
      case 'mismatch':
        return EcommerceAppColor.blue;
      case 'approved':
        return EcommerceAppColor.green;
      default:
        return EcommerceAppColor.red;
    }
  }


  static double getPrice({required double currentPrice, required double discountPrice}) {
    return discountPrice > 0 ? discountPrice : currentPrice;
  }

  static String price({required String price, required WidgetRef ref}) {
    var currecy = ref.watch(currencyProvider);
    final double actualPrice = double.parse(price) * currecy.rate;
    if (currecy.position.trim() == 'prefix') {
      return '${currecy.symbol}${actualPrice.toStringAsFixed(2)}';
    } else {
      return '${actualPrice.toStringAsFixed(2)}${currecy.symbol}';
    }
  }

  static String formatMessageDateTime(DateTime dateTime) {
    try {
      return DateFormat('h:mm a, MMMM dd, yyyy').format(dateTime.toLocal());
    } catch (e) {
      return "Invalid date";
    }
  }
}