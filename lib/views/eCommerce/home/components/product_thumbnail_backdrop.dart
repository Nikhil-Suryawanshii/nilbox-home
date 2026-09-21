import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductThumbnailBackdrop extends StatelessWidget {
  final String imageUrl;
  final double height;
  final BorderRadius borderRadius;
  final Color glowColor;

  const ProductThumbnailBackdrop({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.borderRadius,
    this.glowColor = const Color(0xFFFFF0E6),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final glowSize = cardWidth * 0.74;

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
              Container(
                width: glowSize,
                height: glowSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      glowColor.withOpacity(0.45),
                      glowColor,
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: height * 0.11,
                child: Container(
                  width: glowSize * 0.44,
                  height: 7.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.black.withOpacity(0.06),
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: cardWidth * 0.78,
                height: glowSize * 0.88,
                fit: BoxFit.contain,
              ),
            ],
          ),
        );
      },
    );
  }
}
