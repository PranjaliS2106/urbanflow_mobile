import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HeatmapWidget extends StatelessWidget {
  const HeatmapWidget({super.key});

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
                  'Congestion Heatmap',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Traffic density across different time periods',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                _buildHeatmapGrid(context),
                SizedBox(height: 3.h),
                _buildLegend(context),
              ],
            ),
          ),
          SizedBox(height: 4.w),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<String> timeLabels = ['6AM', '9AM', '12PM', '3PM', '6PM', '9PM'];
    final List<String> dayLabels = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];

    // Mock congestion data (0-1 scale)
    final List<List<double>> congestionData = [
      [0.3, 0.8, 0.5, 0.6, 0.9, 0.4], // Monday
      [0.4, 0.9, 0.6, 0.7, 0.95, 0.5], // Tuesday
      [0.35, 0.85, 0.55, 0.65, 0.9, 0.45], // Wednesday
      [0.4, 0.9, 0.6, 0.7, 0.95, 0.5], // Thursday
      [0.45, 0.95, 0.65, 0.75, 1.0, 0.6], // Friday
      [0.2, 0.4, 0.7, 0.8, 0.6, 0.7], // Saturday
      [0.15, 0.3, 0.6, 0.7, 0.5, 0.6], // Sunday
    ];

    return Column(
      children: [
        // Time labels header
        Row(
          children: [
            SizedBox(width: 12.w), // Space for day labels
            ...timeLabels.map((time) => Expanded(
                  child: Text(
                    time,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                )),
          ],
        ),
        SizedBox(height: 2.h),
        // Heatmap grid
        ...dayLabels.asMap().entries.map((entry) {
          final dayIndex = entry.key;
          final dayLabel = entry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Row(
              children: [
                SizedBox(
                  width: 12.w,
                  child: Text(
                    dayLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ...congestionData[dayIndex].asMap().entries.map((timeEntry) {
                  final timeIndex = timeEntry.key;
                  final intensity = timeEntry.value;

                  return Expanded(
                    child: Container(
                      height: 4.h,
                      margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                      decoration: BoxDecoration(
                        color: _getHeatmapColor(intensity, colorScheme),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '${(intensity * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                            color: intensity > 0.6
                                ? Colors.white
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Low',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(width: 2.w),
        ...List.generate(5, (index) {
          final intensity = (index + 1) / 5;
          return Container(
            width: 6.w,
            height: 2.h,
            margin: EdgeInsets.symmetric(horizontal: 0.5.w),
            decoration: BoxDecoration(
              color: _getHeatmapColor(intensity, colorScheme),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        SizedBox(width: 2.w),
        Text(
          'High',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Color _getHeatmapColor(double intensity, ColorScheme colorScheme) {
    if (intensity <= 0.2) {
      return AppTheme.successLight.withValues(alpha: 0.3);
    } else if (intensity <= 0.4) {
      return AppTheme.successLight.withValues(alpha: 0.6);
    } else if (intensity <= 0.6) {
      return AppTheme.warningLight.withValues(alpha: 0.6);
    } else if (intensity <= 0.8) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.errorLight;
    }
  }
}