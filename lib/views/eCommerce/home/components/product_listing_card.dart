import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/add_to_cart_bottom_sheet.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

import '../../../../components/ecommerce/confirmation_dialog.dart';
import '../../../../routes.dart';
import '../../../../services/common/hive_service_provider.dart';
import '../../../../utils/context_less_navigation.dart';
import 'product_card_background.dart';

class ProductListingCard extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final int? backgroundIndex;

  const ProductListingCard({
    super.key,
    required this.product,
    this.onTap,
    this.backgroundIndex,
  });

  @override
  ConsumerState<ProductListingCard> createState() =>
      _ProductListingCardState();
}

class _ProductListingCardState extends ConsumerState<ProductListingCard> {
  static const _cardBg = Colors.white;
  static const _titleColor = Color(0xFF1A1A2E);
  static const _priceRed = Color(0xFFE53935);
  static const _newBadgeBg = Color(0xFFE3F2FD);
  static const _newBadgeText = Color(0xFF1565C0);
  static const _saveBadgeBg = Color(0xFFFFEBEE);
  static const _starGold = Color(0xFFFFB800);
  bool _cartPressed = false;

  Color get _imageBackground => ProductCardBackground.forProduct(
        widget.product,
        index: widget.backgroundIndex,
      );

  Color get _innerGlow => ProductCardBackground.innerGlow(_imageBackground);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
        ref.read(favoriteProvider(widget.product.id).notifier).state =
            widget.product.isFavorite;
      }
    });
  }

  bool get _hasDiscount =>
      widget.product.discountPercentage > 0 ||
      (widget.product.discountPrice > 0 &&
          widget.product.discountPrice < widget.product.price);

  double get _discountPrice => widget.product.discountPrice > 0
      ? widget.product.discountPrice
      : widget.product.price;

  double get _sellingPrice => widget.product.price;

  double get _savingsAmount => _sellingPrice - _discountPrice;

  String get _brandLabel {
    final brand = widget.product.brand?.trim();
    if (brand != null && brand.isNotEmpty) return brand.toLowerCase();
    return widget.product.shop.name.toLowerCase();
  }

  bool get _isNewProduct {
    final sold = int.tryParse(widget.product.totalSold) ?? 0;
    return sold <= 5;
  }

  void _onFavoriteTap() {
    HapticFeedback.lightImpact();
    if (ref.read(hiveServiceProvider).userIsLoggedIn()) {
      ref.read(favoriteProvider(widget.product.id).notifier).toggle();
      ref
          .read(productControllerProvider.notifier)
          .favoriteProductAddRemove(productId: widget.product.id);
    } else {
      showDialog(
        context: context,
        builder: (_) => ConfirmationDialog(
          title: 'You are unable to favorite products without login!',
          confirmButtonText: 'Login',
          onPressed: () {
            context.nav.pushNamedAndRemoveUntil(Routes.login, (route) => false);
          },
        ),
      );
    }
  }

  void _onAddToCartTap() {
    HapticFeedback.lightImpact();
    ref.refresh(selectedProductSizeIndex.notifier).state;
    ref.refresh(selectedProductColorIndex.notifier).state;
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      context: context,
      builder: (_) => AddToCartBottomSheet(product: widget.product),
    );
  }

  Widget _buildDiscountBadge() {
    if (!_hasDiscount) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: _priceRed,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '${widget.product.discountPercentage.toInt()}% OFF',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(bool isFavorite) {
    return GestureDetector(
      onTap: _onFavoriteTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
          size: 17.sp,
          color: _priceRed,
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isFavorite) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final areaWidth = constraints.maxWidth;
          final glowSize = areaWidth * 0.78;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 148.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _imageBackground,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: glowSize,
                      height: glowSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _innerGlow.withOpacity(0.75),
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: widget.product.thumbnail,
                      width: areaWidth * 0.68,
                      height: 108.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Positioned(top: 10.h, left: 10.w, child: _buildDiscountBadge()),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: _buildFavoriteButton(isFavorite),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStarRating() {
    final rating = widget.product.rating.clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = rating >= index + 1;
        final half = !filled && rating > index;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          size: 12.sp,
          color: filled || half ? _starGold : const Color(0xFFD9D9D9),
        );
      }),
    );
  }

  Widget _buildRatingRow() {
    final reviews = widget.product.totalReviews;
    return Row(
      children: [
        _buildStarRating(),
        Gap(4.w),
        Flexible(
          child: Text(
            '${widget.product.rating.toStringAsFixed(1)} ($reviews)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF757575),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_isNewProduct) ...[
          Container(
            width: 1,
            height: 12.h,
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            color: const Color(0xFFE0E0E0),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: _newBadgeBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'New',
              style: TextStyle(
                color: _newBadgeText,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection() {
    if (!_hasDiscount) {
      return Text(
        GlobalFunction.price(ref: ref, price: _sellingPrice.toString()),
        style: TextStyle(
          color: _priceRed,
          fontWeight: FontWeight.w700,
          fontSize: 17.sp,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              GlobalFunction.price(ref: ref, price: _discountPrice.toString()),
              style: TextStyle(
                color: _priceRed,
                fontWeight: FontWeight.w700,
                fontSize: 17.sp,
              ),
            ),
            Gap(8.w),
            Text(
              GlobalFunction.price(ref: ref, price: _sellingPrice.toString()),
              style: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                decorationColor: const Color(0xFF9E9E9E),
                decorationThickness: 1.5,
              ),
            ),
          ],
        ),
        if (_savingsAmount > 0) ...[
          Gap(8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: _saveBadgeBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'Save ${GlobalFunction.price(ref: ref, price: _savingsAmount.toString())}',
              style: TextStyle(
                color: _priceRed,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _cartPressed = true),
      onTapUp: (_) => setState(() => _cartPressed = false),
      onTapCancel: () => setState(() => _cartPressed = false),
      onTap: _onAddToCartTap,
      child: AnimatedScale(
        scale: _cartPressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 42.h,
          decoration: BoxDecoration(
            color: _priceRed,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: _priceRed.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svg.shoppingBag,
                height: 17.h,
                width: 17.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              Gap(8.w),
              Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoriteProvider(widget.product.id));

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(isFavorite),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyText.copyWith(
                          color: _titleColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          height: 1.2,
                        ),
                  ),
                  Gap(4.h),
                  Text(
                    _brandLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Gap(8.h),
                  _buildRatingRow(),
                  Gap(10.h),
                  _buildPriceSection(),
                  Gap(12.h),
                  _buildAddToCartButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
