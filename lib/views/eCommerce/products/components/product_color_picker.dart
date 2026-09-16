import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
///--------just previous-------
// class ProductColorPicker extends ConsumerStatefulWidget {
//   final ProductDetails productDetails;
//   const ProductColorPicker({
//     super.key,
//     required this.productDetails,
//   });
//
//   @override
//   ConsumerState<ProductColorPicker> createState() => _ProductColorPickerState();
// }
//
// class _ProductColorPickerState extends ConsumerState<ProductColorPicker> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.refresh(selectedProductColorIndex.notifier).state;
//       ref.read(selectedColorPriceProvider.notifier).state =
//           widget.productDetails.product.colors[0].price;
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: double.infinity,
//       // margin: EdgeInsets.symmetric(horizontal: 20.w),
//       padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.r),
//         color: Colors.transparent,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   S.of(context).color,
//           //   style: AppTextStyle(context).bodyText.copyWith(
//           //         fontWeight: FontWeight.w500,
//           //       ),
//           // ),
//           // Gap(5.h),
//           // SingleChildScrollView(
//           //   scrollDirection: Axis.horizontal,
//           //   child: Row(
//           //     children: [
//           //       Wrap(
//           //         alignment: WrapAlignment.start,
//           //         direction: Axis.horizontal,
//           //         children: List.generate(
//           //           widget.productDetails.product.colors.length,
//           //           (index) => Padding(
//           //             padding: EdgeInsets.symmetric(horizontal: 5.w),
//           //             child: Material(
//           //               color: Theme.of(context).scaffoldBackgroundColor,
//           //               shape: RoundedRectangleBorder(
//           //                 borderRadius: BorderRadius.circular(5.r),
//           //               ),
//           //               child: InkWell(
//           //                 borderRadius: BorderRadius.circular(5.r),
//           //                 onTap: () {
//           //                   ref.read(selectedProductColorIndex.notifier).state =
//           //                       index;
//           //                   ref
//           //                           .read(selectedColorPriceProvider.notifier)
//           //                           .state =
//           //                       widget
//           //                           .productDetails.product.colors[index].price;
//           //                 },
//           //                 child: Container(
//           //                   padding: EdgeInsets.symmetric(
//           //                       horizontal: 5.w, vertical: 3.h),
//           //                   decoration: BoxDecoration(
//           //                     // color: ,
//           //                     borderRadius: BorderRadius.circular(5.r),
//           //                     border: Border.all(
//           //                       color: ref.watch(selectedProductColorIndex) ==
//           //                               index
//           //                           ? EcommerceAppColor.primary
//           //                           : colors(context).accentColor!,
//           //                     ),
//           //                   ),
//           //                   child: Center(
//           //                     child: Text(
//           //                       widget.productDetails.product.colors[index]
//           //                               .name[0]
//           //                               .toUpperCase() +
//           //                           widget.productDetails.product.colors[index]
//           //                               .name
//           //                               .substring(1),
//           //                       style: AppTextStyle(context)
//           //                           .bodyTextSmall
//           //                           .copyWith(
//           //                             fontWeight: FontWeight.w500,
//           //                             color: ref.watch(
//           //                                         selectedProductColorIndex) ==
//           //                                     index
//           //                                 ? EcommerceAppColor.primary
//           //                                 : EcommerceAppColor.gray,
//           //                           ),
//           //                     ),
//           //                   ),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(
//                 widget.productDetails.product.colors.length,
//                 (index) {
//                   final isSelected =
//                       ref.watch(selectedProductColorIndex) == index;
//
//                   final colorHex =
//                       widget.productDetails.product.colors[index].colorCode;
//                   // example: "#FF0000"
//
//                   return GestureDetector(
//                     onTap: () {
//                       ref.read(selectedProductColorIndex.notifier).state =
//                           index;
//                       ref.read(selectedColorPriceProvider.notifier).state =
//                           widget.productDetails.product.colors[index].price;
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(right: 10.w),
//                       padding: EdgeInsets.all(1.w),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: isSelected
//                               ? EcommerceAppColor.black
//                               : Colors.transparent,
//                           width: 1,
//                         ),
//                       ),
//                       child: Container(
//                         height: 24.w,
//                         width: 24.w,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: EcommerceAppColor.black,
//                             width: 0.5,
//                           ),
//                           color: Color(
//                               int.parse(colorHex.replaceFirst('#', '0xff'))),
//                           // color: Color(0xffb74093),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           ///---------old design------------
//           // Padding(
//           //   padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
//           //   child: Divider(
//           //     thickness: 0.1,
//           //   ),
//           // )
//           ///------------------------------------
//         ],
//       ),
//     );
//   }
// }
///--------just previous-------
class ProductColorPicker extends ConsumerWidget {
  final ProductDetails productDetails;
  const ProductColorPicker({super.key, required this.productDetails});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedProductColorIndex);

    final selectedColorText = selectedIndex == null
        ? "Colour"
        : productDetails.product.colors[selectedIndex].name;

    return InkWell(
      borderRadius: BorderRadius.circular(22.r),
      onTap: () => _openColorDialog(context, ref),
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: Colors.black),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedColorText,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                // overflow: TextOverflow.ellipsis
              ),
            ),
            Gap(3.w),
            const Icon(Icons.keyboard_arrow_down, size: 18),
          ],
        ),
      ),
    );
  }

  /// 🔥 COLOR DIALOG
  void _openColorDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TITLE
                Text(
                  "Select Colour",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Gap(12.h),
                const Divider(height: 1),

                /// COLOR LIST
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: productDetails.product.colors.length,
                    separatorBuilder: (_, __) => Gap(10.h),
                    itemBuilder: (context, index) {
                      final color = productDetails.product.colors[index];
                      final isSelected =
                          ref.watch(selectedProductColorIndex) == index;

                      return InkWell(
                        borderRadius: BorderRadius.circular(14.r),
                        onTap: () {
                          ref
                              .read(selectedProductColorIndex.notifier)
                              .state = index;
                          ref
                              .read(selectedColorPriceProvider.notifier)
                              .state = color.price;

                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF9B2CFF)
                                  : Colors.black12,
                            ),
                            color: isSelected
                                ? const Color(0xFFF4ECFF)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              /// COLOR DOT
                              Container(
                                height: 18.w,
                                width: 18.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(
                                    int.parse(
                                      color.colorCode
                                          .replaceFirst('#', '0xff'),
                                    ),
                                  ),
                                  border: Border.all(color: Colors.black),
                                ),
                              ),

                              Gap(12.w),

                              /// NAME
                              Expanded(
                                child: Text(
                                  color.name,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              /// CHECK
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF9B2CFF),
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

