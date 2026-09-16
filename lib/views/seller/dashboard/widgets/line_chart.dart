import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/models/seller/dashboard/dashboard_data_model.dart';

class LineChartSample2 extends ConsumerStatefulWidget {
  final DashboardDataModel dashboardDataModel;
  const LineChartSample2(this.dashboardDataModel, {super.key});

  @override
  ConsumerState<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends ConsumerState<LineChartSample2> {
  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      colors(context).containerColor!,
      colors(context).primaryColor!,
    ];

    return Stack(
      children: [
        AspectRatio(aspectRatio: 1.32, child: LineChart(mainData(gradientColors))),
        Positioned(
          bottom: 5,
          right: 6.w,
          child: GestureDetector(
            onTap: () {
              ref.read(isLastSixMonth.notifier).state = !ref.read(isLastSixMonth);
            },
            child: CircleAvatar(
              backgroundColor: colors(context).accentColor,
              radius: 12.r,
              child: Icon(
                Icons.chevron_right,
                size: 16.sp,
                color: EcommerceAppColor.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = AppTextStyle(context).text12B700.copyWith(
          fontWeight: FontWeight.w400,
          color: EcommerceAppColor.gray,
        );

    String text = '';
    switch (value.toInt()) {
      case 2: text = 'Jan'; break;
      case 4: text = 'Feb'; break;
      case 6: text = 'Mar'; break;
      case 8: text = 'Apr'; break;
      case 10: text = 'May'; break;
      case 11: text = 'Jun'; break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitleWidgets2(double value, TitleMeta meta) {
    final style = AppTextStyle(context).text12B700.copyWith(
          fontWeight: FontWeight.w400,
          color: EcommerceAppColor.gray,
        );

    String text = '';
    switch (value.toInt()) {
      case 2: text = 'Jul'; break;
      case 4: text = 'Aug'; break;
      case 6: text = 'Sep'; break;
      case 8: text = 'Oct'; break;
      case 10: text = 'Nov'; break;
      case 11: text = 'Dec'; break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = '';
    switch (value.toInt()) {
      case 0: text = '0'; break;
      case 1: text = '1k'; break;
      case 2: text = '2k'; break;
      case 3: text = '3k'; break;
      case 4: text = '4k'; break;
      default: return const SizedBox.shrink();
    }

    return Text(
      text,
      style: AppTextStyle(context).text12B700.copyWith(
            fontWeight: FontWeight.w400,
            color: EcommerceAppColor.gray,
          ),
      textAlign: TextAlign.left,
    );
  }

  LineChartData mainData(List<Color> gradientColors) {
    // Logic to split the 12 month values into two halves
    int midPoint = widget.dashboardDataModel.salesChartValues.length ~/ 2;
    List<double> firstHalf = widget.dashboardDataModel.salesChartValues.sublist(0, midPoint);
    List<double> secondHalf = widget.dashboardDataModel.salesChartValues.sublist(midPoint);

    bool showLastSix = ref.watch(isLastSixMonth);
    List<double> currentValues = showLastSix ? secondHalf : firstHalf;

    // Normalizing values for a 0-4 Y-axis scale
    double maxVal = currentValues.isEmpty ? 1 : currentValues.reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    final List<FlSpot> spots = List.generate(
      currentValues.length,
      (index) => FlSpot((index * 2) + 1.5, (currentValues[index] / maxVal) * 4),
    );

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: EcommerceAppColor.lightGray.withOpacity(0.2),
          strokeWidth: 1,
          dashArray: [5, 5],
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: showLastSix ? bottomTitleWidgets2 : bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 13,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(colors: [gradientColors[1], gradientColors[1]]),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [gradientColors[1].withOpacity(0.3), gradientColors[1].withOpacity(0.0)],
            ),
          ),
        ),
      ],
    );
  }
}

final isLastSixMonth = StateProvider<bool>((ref) => false);