import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/wallet/wallet_history.dart';

class WithdrawHistoryCard extends StatelessWidget {
  final WalletHistory walletHistory;
  const WithdrawHistoryCard({super.key, required this.walletHistory});

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: colors(context).containerColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                walletHistory.createdAt,
                style: style.bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors(context).bodyTextColor,
                ),
              ),
              Text(
                '\$${walletHistory.amount}',
                style: style.text14B700.copyWith(
                  color: colors(context).bodyTextColor,
                ),
              ),
            ],
          ),
          Gap(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bill ID ${walletHistory.billNo}',
                style: style.bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: EcommerceAppColor.gray,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Implement your logic here
                },
                child: Text(
                  'Download Invoice',
                  style: style.bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w400,
                    color: EcommerceAppColor.blue,
                    decorationColor: EcommerceAppColor.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}