
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverlappingCirclesWidget extends StatelessWidget {
  final String? image1;
  final String? image2;
  final String? image3;
  final int selectedIndex;

  const OverlappingCirclesWidget({
    super.key,
    this.image1,
    this.image2,
    this.image3,
    this.selectedIndex = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center aligned stack for circles
          Center(
            child: SizedBox(
              width: 130.w,
              height: 50.h,
              child: Stack(
                children: [
                  // First circle (left)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: _buildCircle(
                      image: image1,
                      backgroundColor: Color(0xFFC8D5D5),
                      isSelected: selectedIndex == 0,
                    ),
                  ),

                  // Second circle (middle)
                  Positioned(
                    left: 35.w,
                    top: 0,
                    child: _buildCircle(
                      image: image2,
                      backgroundColor: Color(0xFFD5D5C8),
                      isSelected: selectedIndex == 1,
                    ),
                  ),

                  // Third circle (right)
                  Positioned(
                    left: 75.w,
                    top: 0,
                    child: _buildCircle(
                      image: image3,
                      backgroundColor: Color(0xFFF5D5A8),
                      isSelected: selectedIndex == 2,
                      showBorder: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle({
    String? image,
    required Color backgroundColor,
    required bool isSelected,
    bool showBorder = false,
  }) {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: showBorder
            ? Border.all(
                color: Color(0xFF4A9EFF),
                width: 1.5,
              )
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: image != null
            ? Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: backgroundColor,
                    child: Icon(
                      Icons.image,
                      size: 8.sp,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  );
                },
              )
            : Container(
                color: backgroundColor,
                child: Icon(
                  Icons.image,
                  size: 8.sp,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
      ),
    );
  }
}
