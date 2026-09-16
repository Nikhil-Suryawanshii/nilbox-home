import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/providers/seller/product_provider.dart';
import 'package:ready_ecommerce/services/seller/product_service.dart';
import 'package:ready_ecommerce/views/seller/dashboard/product_management/edit_product_section.dart';

class EcommerceEditProductView extends ConsumerStatefulWidget {
  const EcommerceEditProductView({super.key});

  @override
  ConsumerState<EcommerceEditProductView> createState() => _EcommerceEditProductViewState();
}

class _EcommerceEditProductViewState extends ConsumerState<EcommerceEditProductView> {
  @override
  void initState() {
    super.initState();
    // Reset any stale state + fetch fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.resetProductForm(); // light reset first
      final id = ref.read(editingProductIdProvider);
      if (id != null) {
        ref.read(sellerProductServiceProvider.notifier).fetchProductDetails(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(sellerProductServiceProvider);
    final formKey = ref.watch(editProductFormKeyProvider);

    return WillPopScope(
      onWillPop: () async {
        // Full reset when user presses back
        ref.resetProductForm(fullReset: true);
        return true;
      },
      child: Scaffold(
        backgroundColor: colors(context).accentColor,
        appBar: AppBar(
          title: Text("Edit Product", style: AppTextStyle(context).appBarText),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: const Column(
              children: [
                ProductInfoSection(),
                Gap(16),
                GeneralInfoSection(),
                Gap(16),
                PriceInfoSection(),
                Gap(16),
                ImagesSection(),
                Gap(16),
                VideoSection(),
                Gap(16),
                SEOSection(),
                Gap(30),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          color: colors(context).light,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => ref.resetProductForm(),
                  child: const Text("Reset"),
                ),
              ),
              Gap(15.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            final success = await ref
                                .read(sellerProductServiceProvider.notifier)
                                .submitProduct(context);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Product updated successfully")),
                              );
                              // Critical: full reset after success
                              ref.resetProductForm(fullReset: true);
                              Navigator.pop(context);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: colors(context).primaryColor),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}