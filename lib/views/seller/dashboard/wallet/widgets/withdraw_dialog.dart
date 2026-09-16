import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/wallet/wallet_details.dart';
import 'package:ready_ecommerce/providers/seller/wallet_provider.dart';
import 'package:ready_ecommerce/providers/seller/withdraw_provider.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/views/seller/dashboard/dashboard.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';

class WithdrawDialog extends StatefulWidget {
  final WalletDetails walletDetails;
  const WithdrawDialog({super.key, required this.walletDetails});

  @override
  State<WithdrawDialog> createState() => _WithdrawDialogState();
}

class _WithdrawDialogState extends State<WithdrawDialog> {
  late TextEditingController amountController;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyle(context);
    final themeColors = colors(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: themeColors.light,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: themeColors.light,
            ),
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            child: FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(16.h),
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: themeColors.primaryColor?.withOpacity(0.1),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 32.sp,
                        color: themeColors.primaryColor,
                      ),
                    ),
                    Gap(16.h),
                    Text(
                      'Send a Withdrawal Request',
                      style: style.title.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    Gap(8.h),
                    Text(
                      'Please enter withdrawal amount and tap send request button',
                      textAlign: TextAlign.center,
                      style: style.bodyText.copyWith(color: EcommerceAppColor.gray),
                    ),
                    Gap(16.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeColors.accentColor ?? EcommerceAppColor.offWhite,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildCustomColumn(
                              context: context,
                              label: 'Current Balance',
                              value: '\$${widget.walletDetails.withdrawableAmount}',
                            ),
                          ),
                          Expanded(
                            child: _buildCustomColumn(
                              context: context,
                              label: 'Payment Method',
                              value: 'Bank Transfer',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: themeColors.accentColor?.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Enter Amount (USD)',
                            style: style.bodyText.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Gap(8.h),
                          _buildAmountField(context),
                          Gap(8.h),
                          Text(
                            'Minimum withdrawal amount is \$${widget.walletDetails.minWithdrawableAmount}',
                            style: style.bodyTextSmall.copyWith(
                              color: EcommerceAppColor.lightGray,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),
                    Consumer(
                      builder: (context, ref, _) {
                        return ref.watch(withdrawServiceProvider)
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                buttonName: 'Send Request',
                                onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(withdrawServiceProvider.notifier)
                                      .withdrawWallet(
                                        amount: amountController.text.trim(),
                                      )
                                      .then((value) {
                                        ref.watch(
                                          walletDetailsServiceProvider(
                                            ref.read(
                                              selectedFilterOption,
                                            )!['key'],
                                          ),
                                        );
                                        navigatePop();
                                      });
                                }
                              },
                              );
                      },
                    ),
                    Gap(12.h),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 5.w,
            top: 5.h,
            child: IconButton(
              icon: Icon(Icons.close, color: themeColors.bodyTextColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  navigatePop() => context.nav.pop();

  Widget _buildCustomColumn({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    final style = AppTextStyle(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: style.bodyTextSmall.copyWith(color: EcommerceAppColor.gray, fontSize: 10.sp),
        ),
        Gap(4.h),
        Text(
          value,
          style: style.bodyText.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildAmountField(BuildContext context) {
    final themeColors = colors(context);
    final style = AppTextStyle(context);

    return FormBuilderTextField(
      autofocus: true,
      name: 'withdrawal',
      controller: amountController,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: style.title.copyWith(fontSize: 24.sp),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Amount is required'),
        FormBuilderValidators.numeric(errorText: 'Invalid amount'),
        FormBuilderValidators.min(
          double.tryParse(widget.walletDetails.minWithdrawableAmount.toString()) ?? 0,
          errorText: 'Amount is too low',
        ),
      ]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        fillColor: EcommerceAppColor.white,
        filled: true,
        hintText: '0.00',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: EcommerceAppColor.gray.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: EcommerceAppColor.gray.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: themeColors.primaryColor!, width: 1.5),
        ),
      ),
    );
  }
}