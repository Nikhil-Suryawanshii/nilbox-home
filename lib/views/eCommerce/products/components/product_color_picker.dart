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
    final colors = productDetails.product.colors;
    if (colors.isEmpty) return const SizedBox.shrink();

    final rawIndex = ref.watch(selectedProductColorIndex) ?? 0;
    final selectedIndex = rawIndex.clamp(0, colors.length - 1);
    if (rawIndex != selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedProductColorIndex.notifier).state = selectedIndex;
        ref.read(selectedColorPriceProvider.notifier).state =
            colors[selectedIndex].price;
      });
    }
    final selectedColorName = colors[selectedIndex].name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Color: ',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: selectedColorName,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        Gap(10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              colors.length,
              (index) {
                final isSelected = selectedIndex == index;
                final colorHex = colors[index].colorCode;
                
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedProductColorIndex.notifier).state = index;
                    ref.read(selectedColorPriceProvider.notifier).state =
                        colors[index].price;
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(3.w), // Inner gap for selected state
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF5722) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      height: 36.w,
                      width: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black12,
                          width: 1,
                        ),
                        color: Color(int.parse(colorHex.replaceFirst('#', '0xff'))),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
