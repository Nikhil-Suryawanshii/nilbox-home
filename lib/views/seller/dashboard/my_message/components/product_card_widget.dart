// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/models/eCommerce/shop_message_model/product.dart';
// import 'package:ready_ecommerce/utils/global_function.dart';

// class ProductMessageCard extends StatefulWidget {
//   final ProductMessage product;

//   const ProductMessageCard({super.key, required this.product});

//   @override
//   State<ProductMessageCard> createState() => _ProductMessageCardState();
// }

// class _ProductMessageCardState extends State<ProductMessageCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: GlobalFunction.getContainerColor(),
//       child: Container(
//         width: 260.w,
//         height: 100.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.r),
//           border: Border.all(color: colors(context).accentColor!),
//         ),
//         padding: EdgeInsets.all(12.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             _buildProductImage(productImage: widget.product.thumbnail ?? ''),
//             Gap(16.w),
//             _buildProductInfo(context: context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductImage({required String productImage}) {
//     return Flexible(
//       flex: 1,
//       child: Container(
//         width: 80.w,
//         height: 60.h,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: CachedNetworkImageProvider(
//               productImage,
//               errorListener: (error) => debugPrint(error.toString()),
//             ),
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductInfo({required BuildContext context}) {
//     return Flexible(
//       flex: 5,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   widget.product.name ?? '',
//                   maxLines: 2,
//                   style: AppTextStyle(context: context).text14B400.copyWith(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14.sp,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           Gap(10.h),
//           Row(
//             children: [
//               Text(
//                 "${widget.product.price ?? ''}",
//                 style: AppTextStyle(context: context).text14B400.copyWith(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14.sp,
//                 ),
//               ),
//               const Spacer(),
//               Icon(
//                 Icons.star,
//                 color: colors(context).primaryColor,
//                 size: 15.sp,
//               ),
//               Gap(5.w),
//               Text(
//                 "${widget.product.rating ?? ''}",
//                 style: AppTextStyle(
//                   context: context,
//                 ).text14B400.copyWith(fontWeight: FontWeight.w600),
//               ),
//               Gap(5.w),
//               Text(
//                 "(${widget.product.totalReviews ?? ''})",
//                 style: AppTextStyle(
//                   context: context,
//                 ).text14B400.copyWith(fontSize: 12.sp),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/eCommerce/shop_message_model/product.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class ProductMessageCard extends StatefulWidget {
  final ProductMessage product;

  const ProductMessageCard({super.key, required this.product});

  @override
  State<ProductMessageCard> createState() => _ProductMessageCardState();
}

class _ProductMessageCardState extends State<ProductMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: GlobalFunction.getContainerColor(),
      child: Container(
        width: 260.w,
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors(context).accentColor!),
        ),
        padding: EdgeInsets.all(12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProductImage(productImage: widget.product.thumbnail ?? ''),
            Gap(16.w),
            _buildProductInfo(context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage({required String productImage}) {
    return Flexible(
      flex: 1,
      child: Container(
        width: 80.w,
        height: 60.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              productImage,
              errorListener: (error) => debugPrint(error.toString()),
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo({required BuildContext context}) {
    final style = AppTextStyle(context); // Updated to use positional constructor

    return Flexible(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.product.name ?? '',
                  maxLines: 2,
                  // Using text14B700 for a semi-bold look as requested (600/700)
                  style: style.text14B700,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Text(
                "${widget.product.price ?? ''}",
                style: style.text14B700,
              ),
              const Spacer(),
              Icon(
                Icons.star,
                color: colors(context).primaryColor,
                size: 15.sp,
              ),
              Gap(5.w),
              Text(
                "${widget.product.rating ?? ''}",
                // Using text14B700 to match the price weight
                style: style.text14B700,
              ),
              Gap(5.w),
              Text(
                "(${widget.product.totalReviews ?? ''})",
                // Using bodyTextSmall which is 12.sp
                style: style.bodyTextSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
