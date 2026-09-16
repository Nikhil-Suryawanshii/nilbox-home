
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/order/order_filter_model.dart';
import 'package:ready_ecommerce/providers/seller/order_provider.dart';
import 'package:ready_ecommerce/views/seller/dashboard/order/screens/orders.dart';
import 'package:ready_ecommerce/views/seller/widgets/custom_button.dart'; // Verify path

class CustomDatePicker extends ConsumerStatefulWidget {
  const CustomDatePicker({super.key});

  @override
  ConsumerState<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends ConsumerState<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    final slref = ref;

    return Dialog(
      backgroundColor: colors(context).containerColor,
      surfaceTintColor: colors(context).containerColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeaderWidget(context: context, slref: slref),
            Divider(
              height: 0,
              color: colors(context).accentColor,
              thickness: 1,
            ),
            _buildBodyWidget(context: context, slref: slref),
            Gap(20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWidget({
    required BuildContext context,
    required WidgetRef slref,
  }) {
    final style = AppTextStyle(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
      ).copyWith(bottom: 20.h, top: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  slref.refresh(selectedDateFilter.notifier).state;
                  slref.refresh(startDate.notifier).state;
                  slref.refresh(endDate.notifier).state;
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: colors(context).bodyTextColor,
                  size: 24.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  slref.read(selectedDateFilter.notifier).state = null;
                  slref.read(startDate.notifier).state = null;
                  slref.read(endDate.notifier).state = null;
                  slref.refresh(selectedDatesProvider.notifier).state = [];
                },
                child: Text(
                  "Reset",
                  style: style.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                    color: EcommerceAppColor.red,
                  ),
                ),
              ),
            ],
          ),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEE, MMM d').format(DateTime.now()),
                style: style.title.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyWidget({
    required BuildContext context,
    required WidgetRef slref,
  }) {
    final style = AppTextStyle(context);
    return Column(
      children: [
        CalendarDatePicker2(
          config: CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.range,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            calendarViewMode: CalendarDatePicker2Mode.day,
            lastMonthIcon: Icon(Icons.chevron_left, color: colors(context).bodyTextColor),
            nextMonthIcon: Icon(Icons.chevron_right, color: colors(context).bodyTextColor),
            yearTextStyle: style.bodyText.copyWith(fontWeight: FontWeight.w700),
            selectedYearTextStyle: style.bodyText.copyWith(fontWeight: FontWeight.w700),
            controlsTextStyle: style.bodyText.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
            weekdayLabelTextStyle: style.bodyTextSmall.copyWith(fontWeight: FontWeight.w700),
            dayTextStyle: style.bodyText,
            disabledDayTextStyle: style.bodyText.copyWith(color: EcommerceAppColor.lightGray),
            selectedDayTextStyle: style.bodyTextSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: EcommerceAppColor.white,
            ),
            selectedDayHighlightColor: colors(context).primaryColor,
          ),
          value: slref.watch(selectedDatesProvider),
          onValueChanged: (date) {
            if (date.isNotEmpty && date.first != null) {
              slref.read(startDate.notifier).state = DateFormat('yyyy-MM-dd').format(date.first!);
              if (date.length > 1 && date.last != null) {
                slref.read(endDate.notifier).state = DateFormat('yyyy-MM-dd').format(date.last!);
              } else {
                slref.read(endDate.notifier).state = null;
              }
            }
            slref.read(selectedDatesProvider.notifier).state = date;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Divider(color: colors(context).accentColor, thickness: 1),
        ),
        Gap(10.h),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 4.0,
          children: List.generate(
            filterOption().length,
            (index) => Row(
              children: [
                Radio<String>(
                  value: filterOption()[index]['key']!,
                   groupValue: slref.watch(selectedDateFilter),
                  onChanged: (v) {
                    if (slref.read(startDate) != null) {
                      slref.refresh(startDate.notifier).state;
                      slref.refresh(endDate.notifier).state;
                    }
                    slref.read(selectedDateFilter.notifier).state = v;
                  },
                  fillColor: WidgetStateProperty.resolveWith<Color>((state) {
                    if (state.contains(WidgetState.selected)) {
                      return colors(context).primaryColor!;
                    }
                    return EcommerceAppColor.gray;
                  }),
                ),
                Text(
                  filterOption()[index]['name'] ?? '',
                  style: style.bodyTextSmall.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        Gap(20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: CustomButton(
                    color: colors(context).accentColor,
                    textColor: colors(context).bodyTextColor,
                    buttonName: "Cancel",
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: CustomButton(
                    buttonName: "Apply",
                    onTap: () {
                      slref.read(orderServiceProvider.notifier).getOrders(
                            filter: OrderFilterModel(
                              page: 1,
                              perPage: 20, // Corrected from 1 to 20 for standard fetch
                              status: slref.read(selectedOrderStatusProvider),
                              startDate: slref.read(startDate),
                              endDate: slref.read(endDate) ?? slref.read(startDate),
                              filterType: slref.read(selectedDateFilter),
                            ),
                          );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> filterOption() {
    return [
      {"key": "today", "name": "Today"},
      {"key": "this_week", "name": "This Week"},
      {"key": "last_week", "name": "Last Week"},
      {"key": "this_month", "name": "This Month"},
      {"key": "last_month", "name": "Last Month"},
      {"key": "this_year", "name": "This Year"},
      {"key": "last_year", "name": "Last Year"},
    ];
  }
}

final startDate = StateProvider<String?>((slref) => null);
final endDate = StateProvider<String?>((slref) => null);
final selectedDateFilter = StateProvider<String?>((slref) => null);
final selectedDatesProvider = StateProvider<List<DateTime?>>((slref) => []);