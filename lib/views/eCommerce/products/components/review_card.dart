// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/models/eCommerce/shop/shop_review.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  const ReviewCard({
    super.key,
    required this.review,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomerInfo(),
          Gap(12.h),
          Text(
            widget.review.description,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          if (widget.review.description.length > 100) ...[
            Gap(8.h),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Read less' : 'Read more',
                    style: TextStyle(
                      color: const Color(0xFFFF5722),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(4.w),
                  Icon(
                    _isExpanded ? Icons.arrow_upward : Icons.arrow_forward,
                    color: const Color(0xFFFF5722),
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: widget.review.customerProfile.isNotEmpty
              ? CachedNetworkImageProvider(widget.review.customerProfile)
              : null,
          child: widget.review.customerProfile.isEmpty
              ? Icon(Icons.person, color: Colors.grey, size: 24.sp)
              : null,
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.review.customerName,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(2.h),
              Text(
                widget.review.createdAt,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < widget.review.rating.floor()
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: const Color(0xFFFF5722),
                  size: 14.sp,
                );
              }),
            ),
            Gap(4.w),
            Text(
              widget.review.rating.toDouble().toStringAsFixed(1),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
