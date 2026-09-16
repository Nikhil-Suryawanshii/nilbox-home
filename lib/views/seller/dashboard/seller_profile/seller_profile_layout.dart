import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart'; // Assuming you have assets for icons
import 'package:ready_ecommerce/routes.dart';

import '../../../../config/app_constants.dart';
import '../../../../controllers/misc/misc_controller.dart';
import '../../../../models/seller/auth/login_response_model.dart/user.dart';
import '../../../../providers/seller/common_provider.dart';
import '../../../../services/common/hive_service_provider.dart';

class SellerProfileView extends ConsumerWidget {
  const SellerProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light background
      body: FutureBuilder<LoginUser?>(
        future: ref.read(sellerHiveServiceProvider).getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. Header Section (Gradient Background + Profile Card)
                _buildHeaderSection(context, ref, user),

                Gap(20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      // 2. Theme & Language Toggle
                      // _buildThemeLanguageRow(context),
                      // ProfileThemeLanguageRow(),


                      // Gap(20.h),

                      // 3. User Info Card
                      _buildInfoCard(
                        context,
                        title: "User Info",
                        icon: Icons.person,
                        onEdit: () {
                          // TODO: Navigate to Edit User Profile
                        },
                        children: [
                          _buildGridItem(
                            context,
                            label: "Full Name",
                            value: "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                          ),
                          _buildGridItem(
                            context,
                            label: "Phone Number",
                            value: user?.phone ?? "-",
                          ),
                          _buildGridItem(
                            context,
                            label: "Gender",
                            value: user?.gender ?? "Male",
                          ),
                          _buildGridItem(
                            context,
                            label: "Email",
                            value: user?.email ?? "-",
                            isFullWidth: true, // Email usually needs more space
                          ),
                        ],
                      ),

                      Gap(20.h),

                      // 4. Shop Info Card
                      _buildInfoCard(
                        context,
                        title: "Shop Info",
                        icon: Icons.store,
                        onEdit: () {
                          // TODO: Navigate to Edit Shop Profile
                        },
                        children: [
                          _buildGridItem(
                            context,
                            label: "Shop Name",
                            value: user?.shop?.name ?? "Easy Life",
                          ),
                          _buildGridItem(
                            context,
                            label: "Shop Phone Number",
                            value: user?.phone ?? "-", // Using user phone as fallback
                          ),
                          _buildGridItem(
                            context,
                            label: "Address",
                            value: user?.shop?.address ?? "Dhaka, Bangladesh",
                            isFullWidth: true,
                          ),
                          _buildGridItem(
                            context,
                            label: "Description",
                            value: user?.shop?.description ??
                                "Welcome to Easy Life, your go-to e-commerce shop! We offer the latest products...",
                            isFullWidth: true,
                            isDescription: true,
                          ),
                        ],
                      ),

                      Gap(30.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER METHODS ---

  Widget _buildHeaderSection(BuildContext context, WidgetRef ref, LoginUser? user) {
    return Stack(
      children: [
        // Dark Background (Top Sliver)
        Container(
          height: 140.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E2530), Color(0xFF2C3545)],
            ),
          ),
        ),

        // Floating Card
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 0),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & Avatar Stack
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                  image: (user?.shop?.logo != null)
                      ? DecorationImage(image: NetworkImage(user!.shop!.logo!))
                      : null,
                ),
                child: (user?.shop?.logo == null)
                    ? Icon(Icons.store, color: Colors.grey, size: 30.sp)
                    : null,
              ),

              Gap(12.w),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gap(4.h),
                    Text(
                      user?.shop?.name ?? "Easy Life",
                      style: AppTextStyle(context).text16B700.copyWith(fontSize: 18.sp),
                    ),
                    Gap(6.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Gap(4.w),
                        Text(
                          "5.0 (0)  |  17+ Products",
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Logout Button
              InkWell(
                onTap: () async {
                  // Logout Logic from your snippet
                  // await ref.read(sellerHiveServiceProvider).clearAll();
                  ref.read(selectedTabIndexProvider.notifier).state = 0;
                  if (context.mounted) {
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   'ecommerce${Routes.core}',
                    //       (route) => false,
                    // );
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.logout, // Or Assets.svg.logout if you have it
                    color: Colors.pink,
                    size: 20.sp,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeLanguageRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Theme Mode",
              style: AppTextStyle(context).bodyText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            Gap(10.w),
            // Simple Switch
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: false,
                onChanged: (val) {},
                activeColor: colors(context).primaryColor,
              ),
            ),
          ],
        ),

        // Language Dropdown Mock
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              // You can use a flag image here
              const Icon(Icons.flag, size: 16, color: Colors.red),
              Gap(6.w),
              Text(
                "English",
                style: AppTextStyle(context).bodyTextSmall.copyWith(fontWeight: FontWeight.w600),
              ),
              Gap(4.w),
              const Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onEdit,
        required List<Widget> children,
      }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Row(
            children: [
              Icon(icon, color: Colors.pink, size: 20.sp),
              Gap(10.w),
              Text(
                title,
                style: AppTextStyle(context).text16B700,
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.pink.withOpacity(0.5)),
                  ),
                  child: Icon(Icons.edit, size: 14.sp, color: Colors.pink),
                ),
              ),
            ],
          ),
          Gap(20.h),

          // Content Grid
          Wrap(
            spacing: 20.w, // Horizontal gap
            runSpacing: 20.h, // Vertical gap
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, {
        required String label,
        required String value,
        bool isFullWidth = false,
        bool isDescription = false,
      }) {
    // Calculate width: subtract padding (40 + 32) / 2 approx for half width
    double width = isFullWidth
        ? double.infinity
        : (MediaQuery.of(context).size.width - 80.w) / 2;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle(context).bodyTextSmall.copyWith(
              color: Colors.grey.shade500,
              fontSize: 12.sp,
            ),
          ),
          Gap(6.h),
          isDescription
              ? Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6F8),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              value,
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          )
              : Text(
            value,
            style: AppTextStyle(context).bodyText.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileThemeLanguageRow extends ConsumerWidget {
  const ProfileThemeLanguageRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Hive.box(AppConstants.appSettingsBox)
        .get(AppConstants.isDarkTheme, defaultValue: false) as bool;
    // 👈 same logic

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// 🌙 THEME TOGGLE
        Row(
          children: [
            Text(
              "Theme Mode",
              style: AppTextStyle(context).bodyText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            Gap(10.w),
            Switch(
              value: isDark,
              activeColor: colors(context).primaryColor,
              onChanged: (value) {
                ref
                    .read(hiveServiceProvider)
                    .setAppTheme(isDarkTheme: value);
              },
            ),
          ],
        ),

        /// 🌍 LANGUAGE
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.languageView);
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, size: 16),
                Gap(6.w),
                Text(
                  "Language",
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Gap(4.w),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
