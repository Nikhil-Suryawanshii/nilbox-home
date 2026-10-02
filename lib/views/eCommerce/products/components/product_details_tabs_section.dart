import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/controllers/eCommerce/shop/shop_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/review_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/similar_products_widget.dart';

const Color _kAccent = Color(0xFFFF5722);

class ProductDetailsTabsSection extends ConsumerStatefulWidget {
  final ProductDetails productDetails;

  const ProductDetailsTabsSection({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ProductDetailsTabsSection> createState() =>
      _ProductDetailsTabsSectionState();
}

class _ProductDetailsTabsSectionState
    extends ConsumerState<ProductDetailsTabsSection> {
  static const _tabs = ['Overview', 'Details', 'Reviews', 'Q&A'];
  bool _descriptionExpanded = false;
  bool _boxExpanded = false;
  bool _specsExpanded = false;
  int _reviewPage = 1;
  final int _perPage = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews(isPagination: false);
    });
  }

  Future<void> _loadReviews({required bool isPagination}) async {
    await ref.read(shopControllerProvider.notifier).getReviews(
          productFilterModel: ProductFilterModel(
            productId: widget.productDetails.product.id,
            page: _reviewPage,
            perPage: _perPage,
          ),
          isPagination: isPagination,
        );
  }

  List<String> _featureLabels() {
    final product = widget.productDetails.product;
    if (product.features != null && product.features!.isNotEmpty) {
      return product.features!.map((f) => f.title).toList();
    }
    return [];
  }

  static const _featureIcons = [
    Icons.check_circle_outline,
    Icons.star_outline,
    Icons.local_offer_outlined,
    Icons.verified_outlined,
    Icons.thumb_up_alt_outlined,
    Icons.workspace_premium_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(productDetailsTabIndexProvider);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(tabIndex),
          Gap(16.h),
          if (tabIndex == 0) _buildOverviewTab(),
          if (tabIndex == 1) _buildDetailsTab(),
          if (tabIndex == 2) _buildReviewsTab(),
          if (tabIndex == 3) _buildQaTab(),
          Gap(24.h),
          if (widget.productDetails.relatedProducts.isNotEmpty) ...[
            SimilarProductsWidget(productDetails: widget.productDetails),
            Gap(16.h),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar(int tabIndex) {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final selected = tabIndex == index;
        return Expanded(
          child: InkWell(
            onTap: () =>
                ref.read(productDetailsTabIndexProvider.notifier).state = index,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    _tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? _kAccent : Colors.grey.shade600,
                    ),
                  ),
                ),
                Container(
                  height: 2.5.h,
                  color: selected ? _kAccent : Colors.transparent,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOverviewTab() {
    final labels = _featureLabels();
    final product = widget.productDetails.product;
    final imageUrl = product.thumbnails.isNotEmpty
        ? (product.thumbnails.first.thumbnail ?? '')
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labels.isNotEmpty) ...[
          Text(
            'Key Features',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Gap(12.h),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: labels.length.clamp(1, 6),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _featureIcons[index % _featureIcons.length],
                      size: 26.sp,
                      color: Colors.black87,
                    ),
                    Gap(8.h),
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Gap(16.h),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 7,
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Container(color: Colors.grey.shade200),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.w,
                top: 16.h,
                right: 16.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.shortDescription.isNotEmpty
                          ? (product.shortDescription.length > 40
                              ? '${product.shortDescription.substring(0, 40)}...'
                              : product.shortDescription)
                          : 'A smarter way to live',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gap(10.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: _kAccent,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow,
                              color: Colors.white, size: 16.sp),
                          Gap(4.w),
                          Text(
                            'Watch Video',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(16.h),
        _buildExpandableTile(
          title: 'Product Description',
          expanded: _descriptionExpanded,
          onTap: () =>
              setState(() => _descriptionExpanded = !_descriptionExpanded),
          child: _buildDescriptionBody(),
        ),
        _buildChevronRow(
          title: "What's in the Box",
          expanded: _boxExpanded,
          onTap: () => setState(() => _boxExpanded = !_boxExpanded),
          child: _buildBoxItemsBody(),
        ),
        _buildChevronRow(
          title: 'Specifications',
          expanded: _specsExpanded,
          onTap: () => setState(() => _specsExpanded = !_specsExpanded),
          child: _buildSpecsBody(),
        ),
        Gap(8.h),
        _buildReviewsSummaryRow(),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return Column(
      children: [
        _buildExpandableTile(
          title: 'Product Description',
          expanded: _descriptionExpanded,
          onTap: () => setState(() => _descriptionExpanded = !_descriptionExpanded),
          child: _buildDescriptionBody(),
        ),
        _buildChevronRow(
          title: "What's in the Box",
          expanded: _boxExpanded,
          onTap: () => setState(() => _boxExpanded = !_boxExpanded),
          child: _buildBoxItemsBody(),
        ),
        _buildChevronRow(
          title: 'Specifications',
          expanded: _specsExpanded,
          onTap: () => setState(() => _specsExpanded = !_specsExpanded),
          child: _buildSpecsBody(),
        ),
      ],
    );
  }

  Widget _buildDescriptionBody() {
    final raw = widget.productDetails.product.description;
    if (raw.trim().isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          'No description available',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
        ),
      );
    }
    return Html(
      data: raw,
      shrinkWrap: true,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(13.sp),
          color: Colors.grey.shade800,
        ),
      },
    );
  }

  Widget _buildBoxItemsBody() {
    final product = widget.productDetails.product;
    if (product.boxItems == null || product.boxItems!.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          'Details not available',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: product.boxItems!
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, size: 16.sp, color: Colors.grey.shade700),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSpecsBody() {
    final product = widget.productDetails.product;
    if (product.specifications == null || product.specifications!.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Text(
          'Details not available',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: product.specifications!
            .map(
              (spec) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        spec.label,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        spec.value,
                        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildReviewsSummaryRow() {
    final product = widget.productDetails.product;
    final reviews = ref.watch(shopControllerProvider.notifier).review;
    
    int count5 = 0, count4 = 0, count3 = 0, count2 = 0, count1 = 0;
    for (var r in reviews) {
      if (r.rating >= 4.5) count5++;
      else if (r.rating >= 3.5) count4++;
      else if (r.rating >= 2.5) count3++;
      else if (r.rating >= 1.5) count2++;
      else count1++;
    }
    final total = reviews.isNotEmpty ? reviews.length : 1;

    Widget _buildProgressBar(int stars, int count) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Text('$stars', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.black87)),
            Gap(4.w),
            Icon(Icons.star, color: _kAccent, size: 14.sp),
            Gap(8.w),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: count / total,
                  minHeight: 6.h,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(_kAccent),
                ),
              ),
            ),
            Gap(12.w),
            SizedBox(
              width: 14.w,
              child: Text('$count', style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600), textAlign: TextAlign.right),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                product.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < product.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: _kAccent,
                          size: 20.sp,
                        );
                      }),
                    ),
                    Gap(4.h),
                    Text(
                      '${product.totalReviews} reviews',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
          Gap(16.h),
          _buildProgressBar(5, count5),
          _buildProgressBar(4, count4),
          _buildProgressBar(3, count3),
          _buildProgressBar(2, count2),
          _buildProgressBar(1, count1),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final product = widget.productDetails.product;
    final reviews = ref.watch(shopControllerProvider.notifier).review;
    final loading = ref.watch(shopControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReviewsSummaryRow(),
        Gap(12.h),
        if (loading && reviews.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (reviews.isEmpty ||
            product.totalReviews == '0' ||
            product.totalReviews.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: Center(
              child: Text(
                'No reviews yet',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
            ),
          )
        else
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
          ),
      ],
    );
  }

  Widget _buildQaTab() {
    final product = widget.productDetails.product;
    if (product.faqs == null || product.faqs!.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            'No questions yet',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: product.faqs!
            .map(
              (faq) => Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q: ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                        Expanded(child: Text(faq.question, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black))),
                      ],
                    ),
                    Gap(8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('A: ', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                        Expanded(child: Text(faq.answer, style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700))),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (expanded) child,
        Divider(color: Colors.grey.shade200),
      ],
    );
  }

  Widget _buildChevronRow({
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.chevron_right,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (expanded) child,
        Divider(color: Colors.grey.shade200),
      ],
    );
  }
}
