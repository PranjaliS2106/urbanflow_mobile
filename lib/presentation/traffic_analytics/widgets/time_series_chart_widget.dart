import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import '../../../core/app_export.dart';

class TimeSeriesChartWidget extends StatefulWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const TimeSeriesChartWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  State<TimeSeriesChartWidget> createState() => _TimeSeriesChartWidgetState();
}

class _TimeSeriesChartWidgetState extends State<TimeSeriesChartWidget> {
  final List<String> periods = ['Hourly', 'Daily', 'Weekly', 'Monthly'];

  List<FlSpot> _getChartData() {
    switch (widget.selectedPeriod) {
      case 'Hourly':
        return [
          const FlSpot(0, 120),
          const FlSpot(1, 95),
          const FlSpot(2, 80),
          const FlSpot(3, 75),
          const FlSpot(4, 85),
          const FlSpot(5, 110),
          const FlSpot(6, 180),
          const FlSpot(7, 250),
          const FlSpot(8, 320),
          const FlSpot(9, 280),
          const FlSpot(10, 240),
          const FlSpot(11, 260),
          const FlSpot(12, 290),
          const FlSpot(13, 270),
          const FlSpot(14, 250),
          const FlSpot(15, 280),
          const FlSpot(16, 310),
          const FlSpot(17, 380),
          const FlSpot(18, 420),
          const FlSpot(19, 350),
          const FlSpot(20, 280),
          const FlSpot(21, 220),
          const FlSpot(22, 180),
          const FlSpot(23, 140),
        ];
      case 'Daily':
        return [
          const FlSpot(1, 4200),
          const FlSpot(2, 3800),
          const FlSpot(3, 4100),
          const FlSpot(4, 4500),
          const FlSpot(5, 4800),
          const FlSpot(6, 3200),
          const FlSpot(7, 2800),
          const FlSpot(8, 4300),
          const FlSpot(9, 4600),
          const FlSpot(10, 4400),
          const FlSpot(11, 4700),
          const FlSpot(12, 4900),
          const FlSpot(13, 3100),
          const FlSpot(14, 2900),
          const FlSpot(15, 4200),
        ];
      case 'Weekly':
        return [
          const FlSpot(1, 28000),
          const FlSpot(2, 32000),
          const FlSpot(3, 29000),
          const FlSpot(4, 35000),
          const FlSpot(5, 31000),
          const FlSpot(6, 33000),
          const FlSpot(7, 30000),
          const FlSpot(8, 34000),
          const FlSpot(9, 36000),
          const FlSpot(10, 32000),
          const FlSpot(11, 38000),
          const FlSpot(12, 35000),
        ];
      case 'Monthly':
        return [
          const FlSpot(1, 120000),
          const FlSpot(2, 135000),
          const FlSpot(3, 128000),
          const FlSpot(4, 142000),
          const FlSpot(5, 138000),
          const FlSpot(6, 145000),
          const FlSpot(7, 152000),
          const FlSpot(8, 148000),
          const FlSpot(9, 155000),
          const FlSpot(10, 160000),
          const FlSpot(11, 158000),
          const FlSpot(12, 165000),
        ];
      default:
        return [];
    }
  }

  String _getYAxisLabel(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Traffic Flow Patterns',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: periods.map((period) {
                      final isSelected = period == widget.selectedPeriod;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => widget.onPeriodChanged(period),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              period,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30.h,
            padding: EdgeInsets.all(4.w),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: widget.selectedPeriod == 'Monthly'
                      ? 50000
                      : widget.selectedPeriod == 'Weekly'
                          ? 10000
                          : widget.selectedPeriod == 'Daily'
                              ? 1000
                              : 100,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: widget.selectedPeriod == 'Hourly'
                          ? 4
                          : widget.selectedPeriod == 'Daily'
                              ? 3
                              : widget.selectedPeriod == 'Weekly'
                                  ? 2
                                  : 2,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        String text = '';
                        switch (widget.selectedPeriod) {
                          case 'Hourly':
                            text = '${value.toInt()}:00';
                            break;
                          case 'Daily':
                            text = 'Day ${value.toInt()}';
                            break;
                          case 'Weekly':
                            text = 'W${value.toInt()}';
                            break;
                          case 'Monthly':
                            text = 'M${value.toInt()}';
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            text,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: widget.selectedPeriod == 'Monthly'
                          ? 50000
                          : widget.selectedPeriod == 'Weekly'
                              ? 10000
                              : widget.selectedPeriod == 'Daily'
                                  ? 1000
                                  : 100,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _getYAxisLabel(value),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                minX: widget.selectedPeriod == 'Hourly' ? 0 : 1,
                maxX: widget.selectedPeriod == 'Hourly'
                    ? 23
                    : widget.selectedPeriod == 'Daily'
                        ? 15
                        : widget.selectedPeriod == 'Weekly'
                            ? 12
                            : 12,
                minY: 0,
                maxY: widget.selectedPeriod == 'Monthly'
                    ? 180000
                    : widget.selectedPeriod == 'Weekly'
                        ? 40000
                        : widget.selectedPeriod == 'Daily'
                            ? 5500
                            : 450,
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.3),
                          colorScheme.primary.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: colorScheme.inverseSurface,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${_getYAxisLabel(barSpot.y)} vehicles',
                          GoogleFonts.inter(
                            color: colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}