import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class PredictiveInsightsWidget extends StatelessWidget {
  const PredictiveInsightsWidget({super.key});

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
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'psychology',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Predictive Insights',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Machine learning forecasts',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.successLight,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '94% Accuracy',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.successLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildPredictionChart(context),
            SizedBox(height: 3.h),
            _buildInsightCards(context),
            SizedBox(height: 3.h),
            _buildRecommendations(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<FlSpot> actualData = [
      const FlSpot(0, 280),
      const FlSpot(1, 320),
      const FlSpot(2, 290),
      const FlSpot(3, 350),
      const FlSpot(4, 380),
      const FlSpot(5, 360),
      const FlSpot(6, 400),
      const FlSpot(7, 420),
      const FlSpot(8, 390),
      const FlSpot(9, 450),
      const FlSpot(10, 480),
      const FlSpot(11, 460),
    ];

    final List<FlSpot> predictedData = [
      const FlSpot(12, 485),
      const FlSpot(13, 520),
      const FlSpot(14, 495),
      const FlSpot(15, 540),
      const FlSpot(16, 580),
      const FlSpot(17, 560),
      const FlSpot(18, 600),
      const FlSpot(19, 620),
      const FlSpot(20, 590),
      const FlSpot(21, 650),
      const FlSpot(22, 680),
      const FlSpot(23, 660),
    ];

    return Container(
      height: 25.h,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 100,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: colorScheme.outline.withValues(alpha: 0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 4,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final hour = value.toInt();
                  if (hour == 0) return const Text('Now');
                  if (hour == 12) return const Text('12h');
                  if (hour == 24) return const Text('24h');
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 200,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '${(value / 1000).toStringAsFixed(1)}K',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
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
          minX: 0,
          maxX: 23,
          minY: 200,
          maxY: 700,
          lineBarsData: [
            // Actual data line
            LineChartBarData(
              spots: actualData,
              isCurved: true,
              color: colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: colorScheme.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            // Predicted data line
            LineChartBarData(
              spots: predictedData,
              isCurved: true,
              color: AppTheme.warningLight,
              barWidth: 3,
              isStrokeCapRound: true,
              dashArray: [5, 5],
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: AppTheme.warningLight,
                    strokeWidth: 2,
                    strokeColor: colorScheme.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.warningLight.withValues(alpha: 0.1),
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
                  final isActual = barSpot.x <= 11;
                  return LineTooltipItem(
                    '${isActual ? 'Actual' : 'Predicted'}: ${barSpot.y.toInt()} vehicles',
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
    );
  }

  Widget _buildInsightCards(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final insights = [
      {
        'title': 'Peak Hour Prediction',
        'value': '6:30 PM',
        'description': 'Expected peak traffic time',
        'icon': 'schedule',
        'color': AppTheme.warningLight,
      },
      {
        'title': 'Congestion Level',
        'value': 'High',
        'description': 'Predicted traffic density',
        'icon': 'traffic',
        'color': AppTheme.errorLight,
      },
      {
        'title': 'Optimal Route',
        'value': 'Route A',
        'description': 'Recommended alternative',
        'icon': 'alt_route',
        'color': AppTheme.successLight,
      },
    ];

    return Row(
      children: insights.map((insight) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (insight['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (insight['color'] as Color).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: insight['icon'] as String,
                  color: insight['color'] as Color,
                  size: 20,
                ),
                SizedBox(height: 1.h),
                Text(
                  insight['value'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  insight['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  insight['description'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final recommendations = [
      {
        'title': 'Extend Green Light Duration',
        'description':
            'Increase Main St signal by 15 seconds during peak hours',
        'priority': 'High',
        'impact': '+12% flow improvement',
        'icon': 'lightbulb',
      },
      {
        'title': 'Deploy Traffic Officers',
        'description': 'Station officers at Junction 5 between 5-7 PM',
        'priority': 'Medium',
        'impact': '+8% congestion reduction',
        'icon': 'person',
      },
      {
        'title': 'Alternative Route Promotion',
        'description': 'Suggest Oak Avenue via mobile notifications',
        'priority': 'Low',
        'impact': '+5% traffic distribution',
        'icon': 'navigation',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Recommendations',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...recommendations.map((rec) {
          Color priorityColor = rec['priority'] == 'High'
              ? AppTheme.errorLight
              : rec['priority'] == 'Medium'
                  ? AppTheme.warningLight
                  : AppTheme.successLight;

          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: rec['icon'] as String,
                    color: priorityColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rec['title'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.w),
                            decoration: BoxDecoration(
                              color: priorityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              rec['priority'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                color: priorityColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        rec['description'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Expected Impact: ${rec['impact']}',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.successLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}