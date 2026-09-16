import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/providers/seller/common_provider.dart';
import 'package:ready_ecommerce/views/seller/auth/seller_auth_gate_view.dart';
import 'package:ready_ecommerce/views/seller/dashboard/dashboard.dart';

class SellerDashboardWrapper extends ConsumerWidget {
  const SellerDashboardWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef slref) {
    return FutureBuilder<String?>(
      future: slref.watch(sellerHiveServiceProvider).getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool hasToken = snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty;

        if (hasToken) {
          return const SellerDashboard();
        } else {
          return const SellerAuthGateView();
        }
      },
    );
  }
}