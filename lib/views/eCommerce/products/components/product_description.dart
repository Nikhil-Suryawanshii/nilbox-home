import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_color_picker.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_size_picker.dart';

const Color _kAccent = Color(0xFFFF5722);

class ProductDescription extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;
  final VoidCallback? onViewReviews;

  const ProductDescription({
    super.key,
    required this.productDetails,
    this.onAddToCart,
    this.onBuyNow,
    this.onViewReviews,
  });

  @override
  ConsumerState<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends ConsumerState<ProductDescription> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDetailsQuantityProvider.notifier).state = 1;
    });
  }

  void _incrementQuantity() {
    final maxQty = widget.productDetails.product.quantity;
    final current = ref.read(productDetailsQuantityProvider);
    if (current < maxQty) {
      ref.read(productDetailsQuantityProvider.notifier).state = current + 1;
    }
  }

  void _decrementQuantity() {
    final current = ref.read(productDetailsQuantityProvider);
    if (current > 1) {
      ref.read(productDetailsQuantityProvider.notifier).state = current - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.productDetails.product;
    final quantity = ref.watch(productDetailsQuantityProvider);
    final colorPrice = ref.watch(selectedColorPriceProvider);
    final sizePrice = ref.watch(selectedSizePriceProvider);
    final bool inStock = product.quantity > 0;
    final bool isDisabled = !inStock;
    final bool showUrgency = product.quantity > 0 && product.quantity <= 25;

    final basePrice =
        product.discountPrice > 0 ? product.discountPrice : product.price;
    final displayPrice = basePrice + colorPrice + sizePrice;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Gap(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: inStock
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  inStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    color: inStock
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFC62828),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            product.shortDescription.isNotEmpty
                ? product.shortDescription
                : 'Stay connected. Stay active. Stay ahead.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
          Gap(12.h),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < product.rating.floor()
                      ? Icons.star_rounded
                      : (index < product.rating
                          ? Icons.star_half_rounded
                          : Icons.star_border_rounded),
                  color: _kAccent,
                  size: 18.sp,
                );
              }),
              Gap(6.w),
              Text(
                '${product.rating}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
              Gap(4.w),
              Text(
                '(${product.totalReviews} reviews)',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13.sp,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  ref.read(productDetailsTabIndexProvider.notifier).state = 2;
                  widget.onViewReviews?.call();
                },
                child: Text(
                  'View Reviews >',
                  style: TextStyle(
                    color: _kAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          Gap(16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                GlobalFunction.price(
                  ref: ref,
                  price: displayPrice.toString(),
                ),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: _kAccent,
                ),
              ),
              Gap(8.w),
              if (product.discountPrice > 0)
                Padding(
                  padding: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    GlobalFunction.price(
                      ref: ref,
                      price: product.price.toString(),
                    ),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade500,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              Gap(10.w),
              if (product.discountPercentage > 0)
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text(
                    '${product.discountPercentage.toInt()}% OFF',
                    style: TextStyle(
                      color: const Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
            ],
          ),
          if (showUrgency) ...[
            Gap(14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department,
                      color: _kAccent, size: 20.sp),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'Almost sold out! (${product.quantity} left in stock, buy now!)',
                      style: TextStyle(
                        color: _kAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Gap(20.h),
          if (product.colors.isNotEmpty) ...[
            ProductColorPicker(productDetails: widget.productDetails),
            Gap(18.h),
          ],
          if (product.productSizeList.isNotEmpty) ...[
            ProductSizePicker(productDetails: widget.productDetails),
            Gap(18.h),
          ],
          Row(
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Gap(16.w),
              Container(
                height: 40.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                      onTap: isDisabled ? null : _decrementQuantity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Icon(Icons.remove,
                            size: 20.sp, color: Colors.black87),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minWidth: 30.w),
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                      onTap: isDisabled ? null : _incrementQuantity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Icon(Icons.add,
                            size: 20.sp, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(20.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: OutlinedButton.icon(
                    onPressed: isDisabled ? null : widget.onAddToCart,
                    icon: Icon(Icons.shopping_cart_outlined,
                        color: isDisabled ? Colors.grey : _kAccent, size: 20.sp),
                    label: Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: isDisabled ? Colors.grey : _kAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDisabled ? Colors.grey.shade300 : _kAccent,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: isDisabled ? null : widget.onBuyNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kAccent,
                      disabledBackgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(24.h),
          Divider(color: Colors.grey.shade200, thickness: 1),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFeatureIcon(
                Icons.local_shipping_outlined,
                'Free Delivery',
                product.shop.estimatedDeliveryTime.isNotEmpty
                    ? product.shop.estimatedDeliveryTime
                    : '3-5 days',
              ),
              Container(height: 40.h, width: 1, color: Colors.grey.shade200),
              _buildFeatureIcon(
                  Icons.verified_outlined, '1 Year Warranty', 'Official Brand'),
              Container(height: 40.h, width: 1, color: Colors.grey.shade200),
              _buildFeatureIcon(Icons.assignment_return_outlined,
                  '7 Days Return', 'Easy Returns'),
              Container(height: 40.h, width: 1, color: Colors.grey.shade200),
              _buildFeatureIcon(
                  Icons.support_agent_outlined, '24/7 Support', "We're here"),
            ],
          ),
          Gap(12.h),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 26.sp, color: Colors.black87),
          Gap(6.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Gap(2.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
