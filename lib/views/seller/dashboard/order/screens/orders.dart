import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/models/seller/order/order_filter_model.dart';
import 'package:ready_ecommerce/providers/seller/order_provider.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/order_card.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/order_details_bottom_sheet.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/order_filter_card.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/widgets/pending_order_card.dart';
import 'package:ready_ecommerce/views/seller/widgets/date_picker_screen.dart';

class Orders extends ConsumerStatefulWidget {
  const Orders({super.key});

  @override
  ConsumerState<Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<Orders> {
  final ScrollController pendingListController = ScrollController();
  final ScrollController listController = ScrollController();

  int page = 1;
  int perPage = 20;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(orderServiceProvider.notifier).getOrders(
            filter: OrderFilterModel(
              page: page,
              perPage: perPage,
              status: 'all',
            ),
          ),
    );
    pendingListController.addListener(pendingOrderScrollListener);
    listController.addListener(orderScrollListener);
    super.initState();
  }

  void pendingOrderScrollListener() {
    final notifier = ref.read(orderServiceProvider.notifier);
    if (pendingListController.offset >= pendingListController.position.maxScrollExtent &&
        notifier.orders.length < notifier.totalOrders) {
      page++;
      notifier.getOrders(
        filter: OrderFilterModel(
          page: page,
          perPage: perPage,
          status: ref.read(selectedOrderStatusProvider),
        ),
      );
    }
  }

  void orderScrollListener() {
    final notifier = ref.read(orderServiceProvider.notifier);
    if (listController.offset >= listController.position.maxScrollExtent &&
        notifier.orders.length < notifier.totalOrders) {
      page++;
      notifier.getOrders(
        filter: OrderFilterModel(
          page: page,
          perPage: perPage,
          status: ref.read(selectedOrderStatusProvider),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

 Widget buildBody() {
    return Consumer(
      builder: (context, slref, _) {
        return Column(
          children: [
            buildOrderStatusListWidget(),
            buildListWidget(),
            Visibility(
              visible: slref.watch(orderServiceProvider) && page > 1,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  PreferredSize buildAppBar() {
    final style = AppTextStyle(context);
    return PreferredSize(
      preferredSize: Size(double.infinity, 70.h),
      child: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 10.h),
        color: colors(context).containerColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Orders", style: style.subTitle),
                Gap(4.h),
                Text(
                  'Today - ${DateFormat('EEE, MMM dd, yyyy').format(DateTime.now())}',
                  style: style.bodyTextSmall.copyWith(color: EcommerceAppColor.gray),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => const CustomDatePicker(),
              ),
              child: CircleAvatar(
                radius: 22.r,
                backgroundColor: colors(context).accentColor,
                child: Icon(Icons.calendar_today, color: colors(context).primaryColor, size: 20.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderStatusListWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: EcommerceAppColor.gray.withOpacity(0.2), width: 1)),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      height: 62.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: ref.watch(orderServiceProvider.notifier).orderStatusList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          final statusModel = ref.watch(orderServiceProvider.notifier).orderStatusList[index];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: OrderFilterCard(
              isActive: ref.watch(selectedOrderStatusProvider) == statusModel.status,
              statusModel: statusModel,
              callback: () {
                if (ref.read(selectedOrderStatusProvider) != statusModel.status) {
                  ref.read(selectedOrderStatusProvider.notifier).state = statusModel.status;
                  page = 1;
                  ref.read(orderServiceProvider.notifier).getOrders(
                        filter: OrderFilterModel(page: page, perPage: perPage, status: statusModel.status),
                      );
                }
              },
            ),
          );
        }),
      ),
    );
  }

  Widget buildListWidget() {
    final isLoading = ref.watch(orderServiceProvider);
    final status = ref.watch(selectedOrderStatusProvider);
    if (isLoading && page == 1) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    // return status == 'pending' ? buildPendingOrderList() : buildOrderList();
    return status == 'pending' || status == 'confirm' || status == 'to_pickup' || status == 'to_delivery'
    // return status ==  'All'
        ? buildPendingOrderList() : buildOrderList();
  }

  Widget buildPendingOrderList() {
    final orders = ref.watch(orderServiceProvider.notifier).orders;
    return Expanded(
      child: ListView.builder(
        controller: pendingListController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: orders.length,
        itemBuilder: ((context, index) {
          final order = orders[index];
          // print('ordersss---${order.orderStatus}');
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: PendingOrderCard(
              order: order,
              callback: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => OrderDetailsBottomSheet(order: order),
                );
              },
            ),
          );
        }),
      ),
    );
  }

 Widget buildOrderList() {
  final orders = ref.watch(orderServiceProvider.notifier).orders;
  return Expanded(
    child: ListView.builder(
      controller: listController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: orders.length,
      itemBuilder: ((context, index) {
        final order = orders[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: OrderCard(
            order: order,
            callback: () {
              // Standard Navigator call matching Routes.sellerOrderDetails
              Navigator.pushNamed(
                context, 
                Routes.sellerOrderDetails, 
                arguments: order.id,
              );
            },
          ),
        );
      }),
    ),
  );
}
}

final selectedOrderStatusProvider = StateProvider<String>((ref) => 'all');