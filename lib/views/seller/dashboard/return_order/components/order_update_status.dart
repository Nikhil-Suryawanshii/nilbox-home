import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/return_order/return_order_model.dart';
import 'package:ready_ecommerce/providers/seller/return_orders_provider.dart';

class SellerReturnOrderDetailView extends ConsumerStatefulWidget {
  final int returnOrderId;

  const SellerReturnOrderDetailView({super.key, required this.returnOrderId});

  @override
  ConsumerState<SellerReturnOrderDetailView> createState() => _SellerReturnOrderDetailViewState();
}

class _SellerReturnOrderDetailViewState extends ConsumerState<SellerReturnOrderDetailView> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Initialize with current status
    final returnOrders = ref.read(sellerReturnOrdersProvider).valueOrNull;
    final order = returnOrders?.returnOrders.firstWhere(
      (o) => o.id == widget.returnOrderId,
      orElse: () => ReturnOrder(
        id: 0,
        orderId: "N/A",
        reason: "",
        amount: 0.0,
        status: "Pending",
        quantity: 0,
        paymentStatus: "Unpaid",
        rejectNote: null,
        returnDate: "N/A",
        returnAddress: "N/A",
      ),
    );
    _selectedStatus = order?.status ?? "Pending";
  }

  @override
  Widget build(BuildContext context) {
    final returnOrdersAsync = ref.watch(sellerReturnOrdersProvider);
    final updateStatusAsync = ref.watch(updateReturnOrderStatusProvider);

    return Scaffold(
      backgroundColor: colors(context).accentColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Order Status", style: AppTextStyle(context).appBarText),
      ),
      body: returnOrdersAsync.when(
        data: (data) {
          final order = data.returnOrders.firstWhere(
            (o) => o.id == widget.returnOrderId,
            orElse: () => ReturnOrder(
              id: 0,
              orderId: "N/A",
              reason: "Not found",
              amount: 0.0,
              status: "Pending",
              quantity: 0,
              paymentStatus: "Unpaid",
              rejectNote: null,
              returnDate: "N/A",
              returnAddress: "N/A",
            ),
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReturnOrderDetailsCard(context, order),
                Gap(20.h),
                _buildSectionCard(context, "Return Reason", order.reason),
                Gap(16.h),
                _buildSectionCard(context, "Return Address", order.returnAddress),
                Gap(20.h),
                _buildStatusSection(context, order),
                Gap(20.h),
                _buildCustomerInfo(context),
                Gap(30.h),
                // Update Status Button with loading & real API
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateStatusAsync.isLoading
                        ? null
                        : () async {
                            await ref.read(updateReturnOrderStatusProvider.notifier).updateStatus(
                                  widget.returnOrderId,
                                  _selectedStatus,
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Status updated successfully"),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: updateStatusAsync.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            "Update Status",
                            style: AppTextStyle(context).buttonText.copyWith(color: Colors.white),
                          ),
                  ),
                ),
                Gap(20.h),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error loading order: $e")),
      ),
    );
  }

  // White background card for Return Order Details
  Widget _buildReturnOrderDetailsCard(BuildContext context, ReturnOrder order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors(context).light,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Return Order Details", style: AppTextStyle(context).subTitle),
          Gap(12.h),
          _DetailRow(label: "Order ID", value: order.orderId),
          _DetailRow(label: "Amount", value: "\$${order.amount.toStringAsFixed(2)}"),
          _DetailRow(label: "Quantity", value: order.quantity.toString()),
          _DetailRow(label: "Return Date", value: order.returnDate),
          _DetailRow(label: "Payment Status", value: order.paymentStatus),
        ],
      ),
    );
  }

  // Simple section card
  Widget _buildSectionCard(BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors(context).light,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle(context).text16B700),
          Gap(8.h),
          Text(content, style: AppTextStyle(context).bodyText),
        ],
      ),
    );
  }

  // Status section with dropdown
  Widget _buildStatusSection(BuildContext context, ReturnOrder order) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors(context).light,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Return Order Status", style: AppTextStyle(context).text16B700),
          Gap(12.h),
          Text("Change Order Status", style: AppTextStyle(context).bodyTextSmall),
          Gap(8.h),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: ['Pending', 'Approved', 'Damaged', 'Mismatch', 'Rejected']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            ),
          ),
          Gap(16.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Cancel return logic (API call)
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors(context).errorColor!),
                foregroundColor: colors(context).errorColor,
              ),
              child: const Text("Cancel Return"),
            ),
          ),
        ],
      ),
    );
  }

  // Customer Info (hardcoded for now)
  Widget _buildCustomerInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors(context).light,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer Info", style: AppTextStyle(context).text16B700),
          Gap(12.h),
          _DetailRow(label: "Name", value: "Vishnu Mahto"),
          _DetailRow(label: "Phone", value: "7369058124"),
        ],
      ),
    );
  }
}

// Reusable Detail Row Widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle(context).bodyTextSmall.copyWith(color: Colors.grey),
          ),
          Text(
            value,
            style: AppTextStyle(context).bodyText,
          ),
        ],
      ),
    );
  }
}
