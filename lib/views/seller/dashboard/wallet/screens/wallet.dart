import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/seller/wallet/wallet_details.dart';
import 'package:ready_ecommerce/models/seller/wallet/wallet_history_filter_model.dart';
import 'package:ready_ecommerce/providers/seller/wallet_provider.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/views/seller/dashboard/wallet/widgets/wallet_card.dart';
import 'package:ready_ecommerce/views/seller/dashboard/wallet/widgets/withdraw_dialog.dart';
import 'package:ready_ecommerce/views/seller/dashboard/wallet/widgets/withdraw_history_card.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({super.key});

  @override
  ConsumerState<Wallet> createState() => WalletState();

  static List<Map<String, dynamic>> filterOptions = [
    {'value': 'Today', 'key': 'today'},
    {'value': 'This Week', 'key': 'this_week'},
    {'value': 'Last Week', 'key': 'last_week'},
    {'value': 'This Month', 'key': 'this_month'},
    {'value': 'Last Month', 'key': 'last_month'},
    {'value': 'This Year', 'key': 'this_year'},
    {'value': 'Last Year', 'key': 'last_year'},
  ];
}

class WalletState extends ConsumerState<Wallet> {
  int page = 1;
  int perPage = 20;

  @override
  void initState() {
    if (mounted) ref.refresh(selectedFilterOption.notifier).state;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletHistoryServiceProvider.notifier).getWalletHistory(
            filterModel: WalletHistoryFilterModel(page: page, perPage: perPage),
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [_buildDateWiseFilterWidget()],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWalletSummaryWidget(),
          Gap(24.h),
          _buildWithdrawalHistoryWidget(),
        ],
      ),
    );
  }

  Widget _buildWalletSummaryWidget() {
    final selectedKey = ref.watch(selectedFilterOption)?['key'] ?? 'today';
    return Container(
      color: colors(context).containerColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ref.watch(walletDetailsServiceProvider(selectedKey)).when(
            data: (walletDetails) => Column(
              children: [
                _walletHeaderWidget(walletDetails: walletDetails),
                Gap(8.h),
                _buildCommissionAndProfitWidget(walletDetails: walletDetails),
                Gap(28.h),
                walletDetails.isWithdrawable == false
                    ? _buildWithdrawRequestCardWidget(walletDetails: walletDetails)
                    : _buildWithdrawCardWidget(walletDetails: walletDetails),
                    // : _buildWithdrawRequestCardWidget(walletDetails: walletDetails),
                Gap(16.h),
                _lifeTimeSales(walletDetails: walletDetails),
              ],
            ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
    );
  }

  Widget _buildWithdrawalHistoryWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ref.watch(walletHistoryServiceProvider)
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: const Center(child: CircularProgressIndicator()),
            )
          : _buildHistoryWidget(),
    );
  }

  Widget _walletHeaderWidget({required WalletDetails walletDetails}) {
    final style = AppTextStyle(context);
    final filterValue = ref.watch(selectedFilterOption)?['value'];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.99, -0.12),
          end: const Alignment(0.99, 0.12),
          colors: [EcommerceAppColor.black, colors(context).primaryColor!],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales in ${filterValue == 'Today' ? DateFormat.MMMM().format(DateTime.now()) : filterValue}',
                style: style.bodyTextSmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: EcommerceAppColor.white,
                ),
              ),
              const Icon(Icons.account_balance_wallet_outlined, color: EcommerceAppColor.white),
            ],
          ),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${walletDetails.totalSales}',
                style: style.title.copyWith(
                  fontSize: 24.sp,
                  color: EcommerceAppColor.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: ShapeDecoration(
                  color: EcommerceAppColor.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                child: Text(
                  walletDetails.growthPercentage,
                  style: style.bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w400,
                    color: EcommerceAppColor.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionAndProfitWidget({required WalletDetails walletDetails}) {
    return Row(
      children: [
        Flexible(
          child: WalletCardWidget(
            text: 'Commission',
            icon: Icons.pie_chart_outline,
            amount: '-\$${walletDetails.commission}',
          ),
        ),
        Gap(8.w),
        Flexible(
          child: WalletCardWidget(
            text: 'Profit',
            icon: Icons.monetization_on_outlined,
            amount: '\$${walletDetails.profit}',
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawCardWidget({required WalletDetails walletDetails}) {
    final style = AppTextStyle(context);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: EcommerceAppColor.black,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${walletDetails.withdrawableAmount}',
                  style: style.subTitle.copyWith(color: EcommerceAppColor.white),
                ),
                Gap(4.h),
                Text(
                  'Withdrawable Amount',
                  style: style.bodyTextSmall.copyWith(color: EcommerceAppColor.carrotOrange),
                ),
              ],
            ),
          ),
          Gap(16.w),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () => walletDetails.isWithdrawable
                  ? showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => WithdrawDialog(walletDetails: walletDetails),
                    )
                  : null,
              child: Container(
                height: 36.h,
                decoration: ShapeDecoration(
                  color: walletDetails.isWithdrawable 
                      ? colors(context).primaryColor 
                      : EcommerceAppColor.gray,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                ),
                child: Center(
                  child: Text(
                    'Withdraw',
                    style: style.bodyTextSmall.copyWith(
                      color: EcommerceAppColor.white, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawRequestCardWidget({required WalletDetails walletDetails}) {
    final style = AppTextStyle(context);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: EcommerceAppColor.black,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '\$${walletDetails.pendingWithdraw?.amount}',
                      style: style.subTitle.copyWith(color: EcommerceAppColor.white),
                    ),
                    Gap(8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: EcommerceAppColor.orange,
                      ),
                      child: Text(
                        walletDetails.pendingWithdraw!.status,
                        style: style.bodyTextSmall.copyWith(color: EcommerceAppColor.white, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
                Gap(4.h),
                Text(
                  'Withdrawal Request',
                  style: style.bodyTextSmall.copyWith(color: EcommerceAppColor.carrotOrange),
                ),
              ],
            ),
          ),
          const Icon(Icons.history_outlined, color: EcommerceAppColor.white, size: 28),
        ],
      ),
    );
  }

  Widget _lifeTimeSales({required WalletDetails walletDetails}) {
    final style = AppTextStyle(context);
    return Container(
      decoration: BoxDecoration(
        color: colors(context).accentColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        leading: Icon(Icons.trending_up, color: colors(context).primaryColor),
        title: Text(
          'Lifetime Sales',
          style: style.bodyText.copyWith(color: EcommerceAppColor.gray),
        ),
        trailing: Text(
          '\$${walletDetails.lifetimeSales}',
          style: style.text14B700,
        ),
      ),
    );
  }

  Widget _buildHistoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdrawal History',
          style: AppTextStyle(context).subTitle,
        ),
        Gap(16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ref.watch(walletHistoryServiceProvider.notifier).walletHistoryList.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: WithdrawHistoryCard(
              walletHistory: ref.watch(walletHistoryServiceProvider.notifier).walletHistoryList[index],
            ),
          ),
        ),
        Gap(18.h),
        if (ref.watch(walletHistoryServiceProvider.notifier).totalHistoryCount > perPage)
          _buildLoadMorebutton(),
        Gap(38.h),
      ],
    );
  }

  Widget _buildLoadMorebutton() {
    return InkWell(
      onTap: () => ref.read(walletHistoryServiceProvider.notifier).getWalletHistory(
            filterModel: WalletHistoryFilterModel(page: page, perPage: perPage),
          ),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          border: Border.all(color: colors(context).primaryColor!),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            'Load More',
            style: AppTextStyle(context).bodyText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }

 Widget _buildDateWiseFilterWidget() {
  final style = AppTextStyle(context);
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: InkWell(
        onTap: () => _popupMenuWidget(ref, context),
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  ref.watch(isActiveFilter)
                      ? colors(
                        GlobalFunction.navigatorKey.currentContext,
                      ).primaryColor!
                      : colors(context).accentColor!,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Text(
                ref.watch(selectedFilterOption)?['value'],
                style: style.bodyTextSmall.copyWith(color: EcommerceAppColor.gray),
              ),
              Gap(5.w),
              Icon(
                ref.watch(isActiveFilter) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18,
                color: EcommerceAppColor.gray,
              ),
            ],
          ),
        ),
      ),
    );
  }

 static List<Map<String, dynamic>> filterOptions = [
    {'value': 'Today', 'key': 'today'},
    {'value': 'This Week', 'key': 'this_week'},
    {'value': 'Last Week', 'key': 'last_week'},
    {'value': 'This Month', 'key': 'this_month'},
    {'value': 'Last Month', 'key': 'last_month'},
    {'value': 'This Year', 'key': 'this_year'},
    {'value': 'Last Year', 'key': 'last_year'},
  ];

  Future<dynamic> _popupMenuWidget(WidgetRef slref, BuildContext context) {
    slref.read(isActiveFilter.notifier).state = true;
    return showMenu(
      elevation: 1,
      color: colors(context).containerColor,
      surfaceTintColor:
          colors(GlobalFunction.navigatorKey.currentContext).light,
      context: GlobalFunction.navigatorKey.currentContext!,
      position: RelativeRect.fromLTRB(100, 80.h, 0, 0),
      items:
          filterOptions.map((option) {
            final value = option['value'];
            return PopupMenuItem<Map<String, dynamic>>(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              value: option,
              child: RadioListTile<Map<String, dynamic>>(
                visualDensity: VisualDensity.compact,
                value: option,
                groupValue: slref.watch(selectedFilterOption),
                onChanged: (selectedOption) {
                  final selectedKey = selectedOption!['key'];
                  final selectedValue = selectedOption['value'];
                  debugPrint(
                    'Selected key: $selectedKey, value: $selectedValue',
                  );
                  slref.read(selectedFilterOption.notifier).state =
                      selectedOption;
                  slref
                      .refresh(
                        walletDetailsServiceProvider(selectedKey).notifier,
                      )
                      .stream;
                  debugPrint('Value: $value');
                  Navigator.pop(context);
                },
                title: Text(
                  value,
                  style: AppTextStyle(context).bodyText.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            );
          }).toList(),
    ).then((value) {
      slref.read(isActiveFilter.notifier).state = false;
    });
  }
}

final selectedFilterOption = StateProvider<Map<String, dynamic>?>(
  (ref) => Wallet.filterOptions[0],
);

final isActiveFilter = StateProvider<bool>((ref) => false);