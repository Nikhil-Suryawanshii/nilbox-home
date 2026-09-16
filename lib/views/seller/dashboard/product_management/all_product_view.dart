// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
// import 'package:ready_ecommerce/config/app_constants.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/models/seller/product/product_list.dart';
// import 'package:ready_ecommerce/providers/seller/product_list_provider.dart';

// class SellerAllProductsView extends ConsumerWidget {
//   const SellerAllProductsView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final productsAsync = ref.watch(sellerProductsProvider);
//     final searchText = ref.watch(productSearchProvider);

//     // Use ref.watch for the controller text to stay in sync with the provider
//     final searchController = TextEditingController(text: searchText);
//     // Ensure the cursor stays at the end of the text
//     searchController.selection = TextSelection.fromPosition(
//       TextPosition(offset: searchController.text.length),
//     );

//     return Scaffold(
//       backgroundColor: colors(context).accentColor,
//       appBar: AppBar(
//         toolbarHeight: 80.h, // Increased height to accommodate design
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("All Products", style: AppTextStyle(context).appBarText),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         // Using bottom for the search bar to keep it in the AppBar area
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60.h),
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
//             child: CustomSearchField(
//               name: 'search_product',
//               hintText: 'Search products...',
//               textInputType: TextInputType.text,
//               controller: searchController,
//               widget: Icon(Icons.search, color: colors(context).primaryColor),
//               onChanged: (val) {
//                 ref.read(productSearchProvider.notifier).state = val ?? "";
//               },
//             ),
//           ),
//         ),
//       ),
//       body: productsAsync.when(
//         data: (products) {
//           final filteredProducts = products
//               .where((p) => p.name.toLowerCase().contains(searchText.toLowerCase()))
//               .toList();

//           if (filteredProducts.isEmpty) {
//             return const Center(child: Text("No products found"));
//           }

//           return GridView.builder(
//             padding: EdgeInsets.all(16.w),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.68, // Adjusted to fit details without overflow
//               crossAxisSpacing: 12.w,
//               mainAxisSpacing: 12.h,
//             ),
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               return _ProductGridCard(product: filteredProducts[index]);
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, s) => Center(child: Text("Error: $e")),
//       ),
//     );
//   }
// }

// class _ProductGridCard extends StatelessWidget {
//   final SellerProduct product;
//   const _ProductGridCard({required this.product});
//   final isEditing = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: colors(context).light,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Thumbnail with Network Image
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
//               child: Image.network(
//                 product.thumbnail,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image_not_supported)),
//               ),
//             ),
//           ),

//           // Action Row (Toggle + Functional Icons)
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Transform.scale(
//                   scale: 0.7,
//                   child: Switch(
//                     value: product.isActive,
//                     activeColor: colors(context).primaryColor,
//                     onChanged: (val) {
//                       // Logic for toggling status can be added here
//                     },
//                   ),
//                 ),
//                 // Icons Row
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.visibility_outlined, size: 16.sp, color: colors(context).primaryColor),
//                     Gap(4.w),
//                     Icon(Icons.qr_code_scanner, size: 16.sp, color: Colors.grey),
//                     Gap(4.w),
//                     IconButton(onPressed: (){

//                     }, icon: Icon(Icons.edit_outlined, size: 16.sp, color: Colors.blue))
//                   ],
//                 )
//               ],
//             ),
//           ),

//           // Details Section
//           Padding(
//             padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextStyle(context).bodyText.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 Gap(2.h),
//                 Text(
//                   "Qty: ${product.quantity}",
//                   style: AppTextStyle(context).bodyTextSmall.copyWith(color: Colors.grey),
//                 ),
//                 Gap(4.h),
//                 Row(
//                   children: [
//                     Text(
//                       "${AppConstants.appCurrency}${product.price}",
//                       style: AppTextStyle(context).bodyText.copyWith(
//                         color: colors(context).primaryColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(Icons.star, color: Colors.orange, size: 12.sp),
//                     Text(" (0.0)", style: AppTextStyle(context).bodyTextSmall),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
// import 'package:ready_ecommerce/config/app_constants.dart';
// import 'package:ready_ecommerce/config/app_text_style.dart';
// import 'package:ready_ecommerce/config/theme.dart';
// import 'package:ready_ecommerce/models/seller/product/product_list.dart';
// import 'package:ready_ecommerce/providers/seller/product_list_provider.dart';
// import 'package:ready_ecommerce/providers/seller/product_provider.dart'; // Import form providers
// import 'package:ready_ecommerce/views/seller/dashboard/product_management/add_product_view.dart';

// class SellerAllProductsView extends ConsumerWidget {
//   const SellerAllProductsView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final productsAsync = ref.watch(sellerProductsProvider);
//     final searchText = ref.watch(productSearchProvider);

//     final searchController = TextEditingController(text: searchText);
//     searchController.selection = TextSelection.fromPosition(
//       TextPosition(offset: searchController.text.length),
//     );

//     return Scaffold(
//       backgroundColor: colors(context).accentColor,
//       appBar: AppBar(
//         toolbarHeight: 80.h,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("All Products", style: AppTextStyle(context).appBarText),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(60.h),
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
//             child: CustomSearchField(
//               name: 'search_product',
//               hintText: 'Search products...',
//               textInputType: TextInputType.text,
//               controller: searchController,
//               widget: Icon(Icons.search, color: colors(context).primaryColor),
//               onChanged: (val) {
//                 ref.read(productSearchProvider.notifier).state = val ?? "";
//               },
//             ),
//           ),
//         ),
//       ),
//       body: productsAsync.when(
//         data: (products) {
//           final filteredProducts = products
//               .where((p) =>
//                   p.name.toLowerCase().contains(searchText.toLowerCase()))
//               .toList();

//           if (filteredProducts.isEmpty) {
//             return const Center(child: Text("No products found"));
//           }

//           return GridView.builder(
//             padding: EdgeInsets.all(16.w),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.68,
//               crossAxisSpacing: 12.w,
//               mainAxisSpacing: 12.h,
//             ),
//             itemCount: filteredProducts.length,
//             itemBuilder: (context, index) {
//               return _ProductGridCard(product: filteredProducts[index]);
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, s) => Center(child: Text("Error: $e")),
//       ),
//     );
//   }
// }

// class _ProductGridCard extends ConsumerWidget {
//   // Changed to ConsumerWidget
//   final SellerProduct product;
//   const _ProductGridCard({required this.product});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       decoration: BoxDecoration(
//         color: colors(context).light,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
//               child: Image.network(
//                 product.thumbnail,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) =>
//                     const Center(child: Icon(Icons.image_not_supported)),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.w),
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 // Row(
//                 //   mainAxisSize: MainAxisSize.min,
//                 //   children: [

//                 //   ],
//                 // )
//                 Gap(15.w),
//                 Icon(Icons.visibility_outlined,
//                     size: 16.sp, color: colors(context).primaryColor),
//                 Gap(15.w),
//                 Icon(Icons.qr_code_scanner, size: 16.sp, color: Colors.grey),
//                 // Gap(4.w),
//                 // --- UPDATED EDIT BUTTON ---
//                 // IconButton(
//                 //   onPressed: () {
//                 //     //
//                 //     // ref.read(isEditingProductProvider.notifier).state = true;
//                 //     // ref.read(editingProductIdProvider.notifier).state = product.id;

//                 //     // ref.read(nameCtrlProvider).text = product.name;
//                 //     // ref.read(sellingPriceCtrlProvider).text = product.price.toString();
//                 //     // ref.read(discountPriceCtrlProvider).text = product.discountPrice.toString();
//                 //     // ref.read(stockCtrlProvider).text = product.quantity.toString();

//                 //     // // 3. Navigate to the form
//                 //     // Navigator.push(
//                 //     //   context,
//                 //     //   MaterialPageRoute(builder: (context) => const EcommerceAddProductView()),
//                 //     // );
//                 //   },
//                 //   icon: Icon(Icons.edit_outlined,
//                 //       size: 16.sp, color: Colors.blue),
//                 //   // padding: EdgeInsets.zero,
//                 //   // constraints: const BoxConstraints(),
//                 // )

//                 IconButton(
//                   onPressed: () {
//                     // 1. Set editing mode
//                     ref.read(isEditingProductProvider.notifier).state = true;
//                     ref.read(editingProductIdProvider.notifier).state =
//                         product.id;

//                     // 2. Navigate (The View will handle fetching details in initState)
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               const EcommerceAddProductView()),
//                     );
//                   },
//                   icon: Icon(Icons.edit_outlined,
//                       size: 16.sp, color: Colors.blue),
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextStyle(context)
//                       .bodyText
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 Gap(2.h),
//                 Text(
//                   "Qty: ${product.quantity}",
//                   style: AppTextStyle(context)
//                       .bodyTextSmall
//                       .copyWith(color: Colors.grey),
//                 ),
//                 Gap(4.h),
//                 Row(
//                   children: [
//                     Text(
//                       "${AppConstants.appCurrency}${product.price}",
//                       style: AppTextStyle(context).bodyText.copyWith(
//                             color: colors(context).primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                     const Spacer(),
//                     Icon(Icons.star, color: Colors.orange, size: 12.sp),
//                     Text(" (0.0)", style: AppTextStyle(context).bodyTextSmall),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/product/product_list.dart';
import 'package:ready_ecommerce/providers/seller/product_list_provider.dart';
import 'package:ready_ecommerce/providers/seller/product_provider.dart'; 
import 'package:ready_ecommerce/views/seller/dashboard/product_management/add_product_view.dart';
import 'package:ready_ecommerce/views/seller/dashboard/product_management/edit_product_view.dart';

class SellerAllProductsView extends ConsumerWidget {
  const SellerAllProductsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the products list and the current search text
    final productsAsync = ref.watch(sellerProductsProvider);
    final searchText = ref.watch(productSearchProvider);

    // Syncing the controller with the provider state
    // TextSelection ensures the cursor doesn't jump to the start on rebuild
    final searchController = TextEditingController(text: searchText);
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchController.text.length),
    );

    return Scaffold(
      backgroundColor: colors(context).accentColor,
      appBar: AppBar(
        toolbarHeight: 80.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("All Products", style: AppTextStyle(context).appBarText),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          // Refresh Icon Button
          IconButton(
            icon: Icon(Icons.refresh, size: 28.sp),
            tooltip: 'Refresh Products',
            onPressed: () {
              // Refresh the products list by invalidating/re-fetching the provider
              ref.invalidate(sellerProductsProvider);
              // Optional: Clear search if you want a full refresh
              // ref.read(productSearchProvider.notifier).state = '';
            },
          ),
          Gap(10.w), // Spacing from right edge
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
            child: CustomSearchField(
              name: 'search_product',
              hintText: 'Search products...',
              textInputType: TextInputType.text,
              controller: searchController,
              widget: Icon(Icons.search, color: colors(context).primaryColor),
              onChanged: (val) {
                // Instantly updating the provider to filter the list
                ref.read(productSearchProvider.notifier).state = val ?? "";
              },
            ),
          ),
        ),
      ),
      body: productsAsync.when(
        data: (products) {
          // Filtering the list locally based on the search provider state
          final filteredProducts = products
              .where((p) =>
                  p.name.toLowerCase().contains(searchText.toLowerCase()))
              .toList();

          // Handling the "Product not found" state
          if (filteredProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60.sp, color: Colors.grey),
                  Gap(10.h),
                  Text(
                    "Product not found",
                    style: AppTextStyle(context).bodyText.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return _ProductGridCard(product: filteredProducts[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
      ),
    );
  }
}

class _ProductGridCard extends ConsumerWidget {
  final SellerProduct product;
  const _ProductGridCard({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: colors(context).light,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Thumbnail
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.network(
                product.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),
          
          // Action Buttons Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_outlined,
                    size: 18.sp, color: colors(context).primaryColor),
                Gap(15.w),
                Icon(Icons.qr_code_scanner, size: 18.sp, color: Colors.grey),
                Gap(15.w),
                // --- Edit Button Logic ---
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // 1. Setting the mode to editing
                    ref.read(isEditingProductProvider.notifier).state = true;
                    // 2. Storing the product ID to fetch details in the next view
                    ref.read(editingProductIdProvider.notifier).state = product.id;
                    debugPrint("Navigating to Edit for ID: ${product.id}");

                    // 3. Navigating to the add/edit form
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EcommerceEditProductView(),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit_outlined, size: 18.sp, color: Colors.blue),
                )
              ],
            ),
          ),

          // Product Details Section
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Gap(2.h),
                Text(
                  "Qty: ${product.quantity}",
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(color: Colors.grey),
                ),
                Gap(4.h),
                Row(
                  children: [
                    Text(
                      "${AppConstants.appCurrency}${product.price}",
                      style: AppTextStyle(context).bodyText.copyWith(
                            color: colors(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.orange, size: 12.sp),
                    Text(" (0.0)", style: AppTextStyle(context).bodyTextSmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}