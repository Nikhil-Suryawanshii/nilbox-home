// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:razin_commerce_seller_flutter/config/app_text_style.dart';
// import 'package:razin_commerce_seller_flutter/config/theme.dart';
// import 'package:razin_commerce_seller_flutter/features/common/widgets/custom_button.dart';

// class ConfirmationDialog extends StatelessWidget {
//   final String? title;
//   const ConfirmationDialog({
//     super.key,
//     this.onTapCancel,
//     this.onTapConfirm,
//     this.title,
//   });
//   final Function()? onTapCancel;
//   final Function()? onTapConfirm;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: colors(context).containerColor,
//       insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//       child: Padding(
//         padding: EdgeInsets.all(16.r),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title ?? 'Are you sure you want to delete it?',
//               textAlign: TextAlign.center,
//               style: AppTextStyle(context: context).text24B700,
//             ),
//             Gap(20.h),
//             Row(
//               children: [
//                 Flexible(
//                   flex: 1,
//                   child: CustomButton(
//                     buttonName: 'No',
//                     onTap: onTapCancel ?? () => Navigator.of(context).pop(),
//                   ),
//                 ),
//                 Gap(20.w),
//                 Flexible(
//                   flex: 1,
//                   child: CustomButton(
//                     color: colors(context).accentColor,
//                     textColor: colors(context).textColor,
//                     buttonName: 'Yes',
//                     onTap: onTapConfirm ?? () => Navigator.of(context).pop(),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart'; // Point to main app style
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? title;
  final Function()? onTapCancel;
  final Function()? onTapConfirm;

  const ConfirmationDialog({
    super.key,
    this.onTapCancel,
    this.onTapConfirm,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: colors(context).containerColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Are you sure you want to delete it?',
              textAlign: TextAlign.center,
              style: AppTextStyle(context).text24B700, // Fixed context passing
            ),
            Gap(20.h),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    buttonName: 'No',
                    onTap: onTapCancel ?? () => Navigator.of(context).pop(),
                  ),
                ),
                Gap(20.w),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    color: colors(context).accentColor,
                    textColor: colors(context).bodyTextColor, // Corrected from .textColor
                    buttonName: 'Yes',
                    onTap: onTapConfirm ?? () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}