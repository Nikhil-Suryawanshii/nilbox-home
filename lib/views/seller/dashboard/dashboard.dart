// import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/seller/auth/login_response_model.dart/user.dart';
import 'package:ready_ecommerce/models/seller/dashboard/dashboard_data_model.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/providers/seller/dashboard_provider.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/seller/dashboard/product_management/add_product_view.dart';
import 'package:ready_ecommerce/views/seller/dashboard/product_management/all_product_view.dart';
import 'package:ready_ecommerce/views/seller/dashboard/return_order/seller_return_order_view.dart';
import 'package:ready_ecommerce/views/seller/dashboard/seller_profile/seller_profile_layout.dart';
import 'package:ready_ecommerce/views/seller/dashboard/widgets/line_chart.dart';
import 'package:ready_ecommerce/views/seller/dashboard/widgets/order_over_view_card.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/services/common/hive_service_provider.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart';

class SellerDashboard extends ConsumerWidget {
  const SellerDashboard({super.key});

  Widget _buildSellerProfileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const SellerProfileView(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SvgPicture.asset(
          Assets.svg.profileIcon, //
          height: 22.h,
          colorFilter: ColorFilter.mode(
            // colors(context).hintTextColor!,
            Colors.white,
            BlendMode.srcIn,

          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef slref) {
    return Scaffold(
      backgroundColor: colors(context).accentColor,
      resizeToAvoidBottomInset: false,
      // Allows content to go behind the nav bar for a cleaner look
      // extendBody: true,
      // drawer: SizedBox(
      //   width: MediaQuery.of(context).size.width * 0.75, // Covers 75% of screen
      //   child: _buildMenuWidget(context, slref),
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.orange,
      //   onPressed: () => _showProductManagementOptions(context),
      //   icon: const Icon(Icons.add),
      //   label: const Text("Sell"),
      // ),
      ///-----------new---------
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: _sellFloatingButton(context),
      // bottomNavigationBar: _buildBottomNavBar(context),
      ///--------------------------

      // appBar: AppBar(
      //   leading: IconButton(
      //       icon: const Icon(Icons.arrow_back),
      //       onPressed: () {
      //         slref.read(selectedTabIndexProvider.notifier).state = 0;
      //
      //         Navigator.pushNamedAndRemoveUntil(
      //           context,
      //           'ecommerce${Routes.core}',
      //           (route) => false,
      //         );
      //       }),
      //   title:
      //       Text("Seller Dashboard", style: AppTextStyle(context).appBarText),
      //   actions: [
      //     Builder(
      //       builder: (scaffoldContext) => IconButton(
      //         icon: const Icon(Icons.menu),
      //         onPressed: () {
      //           Scaffold.of(scaffoldContext).openEndDrawer();
      //         },
      //       ),
      //     ),
      //     Gap(10.w),
      //   ],
      // ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2C),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // ✅ BACK BUTTON COLOR
        ),
        // leading: Builder(
        //   builder: (context) {
        //     return IconButton(
        //       icon: const Icon(Icons.menu, color: Colors.white),
        //       onPressed: () => Scaffold.of(context).openDrawer(),
        //     );
        //   },
        // ),
        title: const Text(
          "Seller Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              // IconButton(
              //   icon: const Icon(Icons.notifications_none, color: Colors.white),
              //   onPressed: () {},
              // ),
              _buildSellerProfileIcon(context),
              // Positioned(
              //   right: 8,
              //   top: 8,
              //   child: Container(
              //     padding: const EdgeInsets.all(4),
              //     decoration: const BoxDecoration(
              //       color: Colors.orange,
              //       shape: BoxShape.circle,
              //     ),
              //     child: const Text(
              //       "2",
              //       style: TextStyle(color: Colors.white, fontSize: 10),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),

      body: slref.watch(dashboardServiceProvider('this_year')).when(
            data: (dashboardData) => _buildBody(context, slref, dashboardData),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }

  // Widget _buildBody(
  //     BuildContext context, WidgetRef slref, DashboardDataModel dashboardData) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         _buildOrderOverViewWidget(context, dashboardData),
  //         Gap(12.h),
  //         _buildProfitWidget(context, dashboardData),
  //         Gap(28.h),
  //         _buildSalesStatistic(context, slref, dashboardData),
  //         Gap(20.h),
  //         _buildManagementGrid(context, slref),
  //         Gap(30.h),
  //       ],
  //     ),
  //   );
  // }

  Widget _sellFloatingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EcommerceAddProductView()),
              );
            },
            child: Container(
              height: 55,
              width: 55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0xFF2BB3A2), // green
                    Color(0xFF3F7DE8), // blue
                    Color(0xFFF6C000), // yellow
                    Color(0xFF2BB3A2),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.5),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Sell",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomNavBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            /// 🔹 LEFT + RIGHT NAV ITEMS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bottomItem(
                  icon: Icons.home,
                  label: "Home",
                  isActive: true,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'ecommerce${Routes.sellerDashboard}',
                    );
                  },
                ),
                _bottomItem(
                  icon: Icons.chat_bubble_outline,
                  label: "Chats",
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'ecommerce${Routes.sellerMyMessageView}',
                    );
                  },
                ),

                const SizedBox(width: 60), // space for center button

                _bottomItem(
                  icon: Icons.list_alt,
                  label: "Products",
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   'ecommerce${Routes.productsView}',
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const SellerAllProductsView()),
                    );
                  },
                ),
                _bottomItem(
                  icon: Icons.featured_play_list,
                  label: "Orders",
                  onTap: () {
                    _showOrderManagementOptions(context);
                  },
                ),
              ],
            ),

            /// 🔥 CENTER SELL BUTTON
            // Positioned(
            //   top: -12,
            //   child: GestureDetector(
            //     onTap: () => _showProductManagementOptions(context),
            //     child: Container(
            //       height: 64,
            //       width: 64,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         gradient: const SweepGradient(
            //           colors: [
            //             Color(0xFF2BB3A2),
            //             Color(0xFF3F7DE8),
            //             Color(0xFFF6C000),
            //             Color(0xFF2BB3A2),
            //           ],
            //         ),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(5),
            //         child: Container(
            //           decoration: const BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //           child: const Icon(
            //             Icons.add,
            //             size: 28,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget _bottomItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? Colors.blue : Colors.black54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.blue : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBody(
      BuildContext context,
      WidgetRef slref,
      DashboardDataModel dashboardData,
      ) {
    return Stack(
      children: [
        // 🔹 Dark background continuation (behind body)
        Container(
          height: 120.h,
          color: const Color(0xFF1E1E2C),
        ),

        // 🔹 White rounded body (like image)
        Container(
          margin: EdgeInsets.only(top: 20.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28.r),
              topRight: Radius.circular(28.r),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16.h),
            child: Column(
              children: [
                _buildOrderOverViewWidget(context, dashboardData),
                Gap(12.h),
                _buildProfitWidget(context, dashboardData),
                Gap(25.h),
                _buildSalesStatistic(context, slref, dashboardData),
                Gap(20.h),
                _buildManagementGrid(context, slref),
                Gap(30.h),
              ],
            ),
          ),
        ),
      ],
    );
  }



  // Widget _buildOrderOverViewWidget(
  //     BuildContext context, DashboardDataModel dashboardDataModel) {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: const Alignment(-0.99, -0.12),
  //         end: const Alignment(0.99, 0.12),
  //         colors: [
  //           EcommerceAppColor.black,
  //           colors(context).primaryColor!,
  //         ],
  //       ),
  //     ),
  //     child: Container(
  //       padding: EdgeInsets.all(16.r),
  //       decoration: BoxDecoration(
  //         color: colors(context).containerColor,
  //         borderRadius: BorderRadius.circular(12.r),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "Order Overview",
  //                 style: AppTextStyle(context).text12B700,
  //               ),
  //               const Icon(Icons.arrow_forward_ios, size: 12),
  //             ],
  //           ),
  //           Gap(8.h),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: OrderOverViewCard(
  //                   count: dashboardDataModel.pendingOrder.toString(),
  //                   status: "Pending Orders",
  //                   icon: Assets.svg.inactiveBag, // Standardized icon usage
  //                 ),
  //               ),
  //               Gap(8.w),
  //               Expanded(
  //                 child: OrderOverViewCard(
  //                   count: dashboardDataModel.todayOrder.toString(),
  //                   status: "Today's Orders",
  //                   icon: Assets.svg.activeBag,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Gap(8.h),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: OrderOverViewCard(
  //                   count: dashboardDataModel.toPickupOrder.toString(),
  //                   status: "To Pickup",
  //                   icon: Assets.svg.inactiveHome,
  //                 ),
  //               ),
  //               Gap(8.w),
  //               Expanded(
  //                 child: OrderOverViewCard(
  //                   count: dashboardDataModel.toDeliveryOrder.toString(),
  //                   status: "To Delivery",
  //                   icon: Assets.svg.activeHome,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildOrderOverViewWidget(
      BuildContext context, DashboardDataModel data) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        children: [
          _statCard("Pending Orders", data.pendingOrder, Icons.shopping_bag, Colors.orange),
          _statCard("Today's Orders", data.todayOrder, Icons.shopping_cart, Colors.blue),
          _statCard("To Pickup", data.toPickupOrder, Icons.location_on, Colors.purple),
          _statCard("To Delivery", data.toDeliveryOrder, Icons.home, Colors.green),
        ],
      ),
    );
  }

  Widget _statCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.black,fontSize: 15)),
        ],
      ),
    );
  }


  // Widget _buildProfitWidget(
  //     BuildContext context, DashboardDataModel dashboardDataModel) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 16.w),
  //     padding: EdgeInsets.all(12.r),
  //     decoration: BoxDecoration(
  //       color: EcommerceAppColor.black,
  //       borderRadius: BorderRadius.circular(12.r),
  //     ),
  //     child: IntrinsicHeight(
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   '\$${dashboardDataModel.walletBalance}',
  //                   style: AppTextStyle(context)
  //                       .text16B700
  //                       .copyWith(color: Colors.white),
  //                 ),
  //                 Gap(4.h),
  //                 Text(
  //                   "Withdrawable Amount",
  //                   style: AppTextStyle(context).text12B700.copyWith(
  //                         fontWeight: FontWeight.w400,
  //                         color: colors(context).secondaryColor,
  //                       ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const VerticalDivider(
  //               color: Colors.white24, indent: 5, endIndent: 5),
  //           Gap(10.w),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   '\$${dashboardDataModel.thisManthSales}',
  //                   style: AppTextStyle(context)
  //                       .text16B700
  //                       .copyWith(color: Colors.white),
  //                 ),
  //                 Gap(4.h),
  //                 Text(
  //                   "Sales This Month",
  //                   style: AppTextStyle(context).text12B700.copyWith(
  //                         fontWeight: FontWeight.w400,
  //                         color: colors(context).secondaryColor,
  //                       ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildProfitWidget(
      BuildContext context, DashboardDataModel data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: _infoCard(
              title: "Withdrawable Balance",
              value: "\$${data.walletBalance}",
              button: "Withdraw",
              context: context

            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _infoCard(
              title: "Sales (This Month)",
              value: "\$${data.thisManthSales}",
              sub: "Compared to last month",
                context: context
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    String? button,
    String? sub,
    context
  }) {
    return Container(
      height: 165,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: EcommerceAppColor.black,fontSize: 12)),
          // const SizedBox(height: 6),
          Spacer(),
          Text(value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (sub != null)Spacer(),
          if (sub != null)
            Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          if (button != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.sellerWallet,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(button,style: TextStyle(
                color: EcommerceAppColor.white
              ),),
            ),
          ]
        ],
      ),
    );
  }


  Widget _buildSalesStatistic(BuildContext context, WidgetRef slref,
      DashboardDataModel dashboardDataModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors(context).containerColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text("Sales Statistics",
                Text("Quick Actions",
                    style: AppTextStyle(context).text14B700),
                _buildDateWiseFilterWidget(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
            child: LineChartSample2(dashboardDataModel),
          ),
        ],
      ),
    );
  }


  Widget _buildDateWiseFilterWidget() {
    return Consumer(
      builder: (context, slref, _) {
        final style = AppTextStyle(context);
        return Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: InkWell(
            onTap: () {
              _popupMenuWidget(slref, context);
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      slref.watch(isActiveFilter)
                          ? colors(
                            GlobalFunction.navigatorKey.currentContext,
                          ).primaryColor!
                          : Theme.of(context).scaffoldBackgroundColor,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Text(
                    slref.watch(selectedFilterOption)!['value'],
                    style: style.bodyTextSmall.copyWith(
                      color: EcommerceAppColor.gray,
                    ),
                  ),
                  Gap(5.w),
                  Icon(
                    slref.watch(isActiveFilter) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18.sp,
                    color: EcommerceAppColor.gray,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _popupMenuWidget(WidgetRef slref, BuildContext context) {
    Completer<void> completer = Completer<void>();
    RenderBox buttonRenderBox = context.findRenderObject() as RenderBox;
    final buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);
    final buttonSize = buttonRenderBox.size;
    slref.read(isActiveFilter.notifier).state = true;
    return showMenu(
      elevation: 1,
      color: colors(context).containerColor,
      surfaceTintColor:
          colors(GlobalFunction.navigatorKey.currentContext).light,
      context: GlobalFunction.navigatorKey.currentContext!,
      position: RelativeRect.fromLTRB(
        buttonPosition.dx,
        buttonPosition.dy + buttonSize.height,
        buttonPosition.dx + buttonSize.width,
        buttonPosition.dy + buttonSize.height * 2,
      ),
      items:
          filterOptions.map((option) {
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
                  final value = slref.refresh(
                    dashboardServiceProvider(selectedKey).notifier,
                  );
                  debugPrint('Value: $value');
                  Navigator.of(context).pop();
                },
                title: Text(
                  option['value'],
                  style: AppTextStyle(context).bodyText.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            );
          }).toList(),
    ).then((value) {
      slref.read(isActiveFilter.notifier).state = false;
      completer.complete();
    });
  }

  static final List<Map<String, dynamic>> filterOptions = [
    {'key': 'this_year', 'value': 'This Year'},
    {'key': 'last_year', 'value': 'Last Year'},
  ];

  // PreferredSizeWidget? _buildAppBar() {
  //   return AppBar(
  //     centerTitle: false,
  //     title: Assets.png.splashLogo.image(height: 50.h, width: 140.w),
  //     actions: [
  //       Consumer(
  //         builder: (context, slref, _) {
  //           return IconButton(
  //             onPressed:
  //                 () => slref.refresh(dashboardServiceProvider('this_year')),
  //             icon: const Icon(Icons.refresh),
  //           );
  //         },
  //       ),
  //       // Consumer(builder: (context, slref, _) {
  //       //   return GestureDetector(
  //       //     onTap: () {
  //       //       // Hive.box(AppConstants.authToken).clear();
  //       //       // slref.read(apiClientProvider).updateToken(token: '');
  //       //     },
  //       //     child: SvgPicture.asset(Assets.svg.notification),
  //       //   );
  //       // }),
  //       Gap(16.w),
  //     ],
  //   );
  }

  Widget _buildManagementGrid(BuildContext context, WidgetRef slref) {
    slref.read(hiveServiceProvider).userIsLoggedIn();

    final List<Map<String, dynamic>> sellOptions = [
      {
        'title': 'Product Management',
        'icon': Icons.inventory_2_outlined,
        'onTap': () => _showProductManagementOptions(context),
      },
      {
        'title': 'Order Management',
        'icon': Icons.shopping_basket_outlined,
        // 'onTap': () => _showOrderManagementOptions(context),
        'onTap': () {
          Navigator.pushNamed(
            context,
            Routes.sellerOrders,
          );
        },
      },
      {
        'title': 'Conversation',
        'icon': Icons.chat_bubble_outline,
        'onTap': () {
          Navigator.pushNamed(
            context,
            'ecommerce${Routes.sellerMyMessageView}',
          );
        },
      },
      {
        'title': 'Wallet',
        'icon': Icons.account_balance_wallet_outlined,
        'onTap': () {
          Navigator.pushNamed(
            context,
            Routes.sellerWallet,
          );
        },
      },

      {
      'title': 'Return Orders',
      'icon': Icons.keyboard_return, // nice return arrow icon
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SellerReturnOrdersView(),
          ),
        );
      },
    },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.4,
        ),
        itemCount: sellOptions.length,
        itemBuilder: (context, index) {
          final item = sellOptions[index];
          final bool isBlank = item['title'].isEmpty;

          if (isBlank) return const SizedBox();

          return GestureDetector(
            onTap: item['onTap'],
            child: Container(
              decoration: BoxDecoration(
                color: colors(context).light,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors(context).primaryColor!.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'],
                    color: colors(context).primaryColor,
                    size: 28.sp,
                  ),
                  Gap(8.h),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors(context).bodyTextColor,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProductManagementOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Product Management", style: AppTextStyle(context).subTitle),
              Gap(20.h),
              ListTile(
                  leading:
                      Icon(Icons.list_alt, color: colors(context).primaryColor),
                  title: Text("All Products",
                      style: AppTextStyle(context).bodyText),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SellerAllProductsView()),
                        ),
                      }),
              Divider(color: colors(context).accentColor),
              ListTile(
                leading: Icon(Icons.add_box_outlined,
                    color: colors(context).primaryColor),
                title:
                    // Text("Add Product", style: AppTextStyle(context).bodyText),
                    Text("Sell Product", style: AppTextStyle(context).bodyText),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EcommerceAddProductView()),
                  );
                },
              ),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }
  void _showOrderManagementOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Order Management", style: AppTextStyle(context).subTitle),
              Gap(20.h),
              ListTile(
                  leading:
                      Icon(Icons.list_alt, color: colors(context).primaryColor),
                  title: Text("My Orders",
                      style: AppTextStyle(context).bodyText),
                  onTap: () => {
                        Navigator.pop(context),
                    Navigator.pushNamed(
                      context,
                      Routes.sellerOrders,
                    ),
                      }),
              Divider(color: colors(context).accentColor),
              ListTile(
                leading: Icon(Icons.keyboard_return,
                    color: colors(context).primaryColor),
                title:
                    Text("Return Orders", style: AppTextStyle(context).bodyText),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SellerReturnOrdersView()),
                  );
                },
              ),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuWidget(BuildContext context, WidgetRef slref) {
    return Drawer(
      backgroundColor: colors(context).light,
      child: FutureBuilder<LoginUser?>(
        future: slref.read(sellerHiveServiceProvider).getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          return Column(
            children: [
              // Header Profile Part
              Container(
                padding: EdgeInsets.only(top: 60.h, bottom: 20.h),
                width: double.infinity,
                color: colors(context).primaryColor!.withOpacity(0.1),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45.r,
                      backgroundColor: colors(context).primaryColor,
                      backgroundImage: (user?.profilePhoto != null)
                          ? NetworkImage(user!.profilePhoto!)
                          : null,
                      child: (user?.profilePhoto == null)
                          ? Icon(Icons.person, size: 45.sp, color: Colors.white)
                          : null,
                    ),
                    Gap(12.h),
                    Text(
                      user?.shop?.name ?? "Seller Shop",
                      style: AppTextStyle(context).text16B700,
                    ),
                  ],
                ),
              ),

              // Details Section
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Details",
                        style: AppTextStyle(context).text14B700.copyWith(
                              color: colors(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                      Gap(20.h),
                      _detailRow(context, "Full Name",
                          "${user?.firstName ?? '-'} ${user?.lastName ?? ''}"),
                      _detailRow(context, "Phone", user?.phone ?? '-'),
                      _detailRow(context, "Email", user?.email ?? '-'),
                      _detailRow(context, "Gender", user?.gender ?? '-'),
                      _detailRow(
                          context, "DOB", user?.dateOfBirth?.toString() ?? '-'),
                      _detailRow(
                          context, "Shop Status", user?.shopStatus ?? '-'),
                      _detailRow(context, "Active",
                          (user?.isActive ?? false) ? "Yes" : "No"),
                    ],
                  ),
                ),
              ),

              // Logout Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: CustomButton(
                  buttonName: "Logout",
                  onTap: () async {
                    // 1. Clear Hive Seller Data
                    // await slref.read(sellerHiveServiceProvider).clearAll();

                    // 2. Reset Tab to Home
                    slref.read(selectedTabIndexProvider.notifier).state = 0;

                    // 3. Navigate to Main Dashboard
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'ecommerce${Routes.core}',
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
              Gap(20.h),
            ],
          );
        },
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                AppTextStyle(context).text12B700.copyWith(color: Colors.grey),
          ),
          Gap(4.h),
          Text(
            value.trim().isEmpty ? "-" : value,
            style: AppTextStyle(context).text14B400,
          ),
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }

final selectedFilterOption = StateProvider<Map<String, dynamic>?>(
  (slref) => SellerDashboard.filterOptions[0],
);

final isActiveFilter = StateProvider<bool>((slref) => false);

