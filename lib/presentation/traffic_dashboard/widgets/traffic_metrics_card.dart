import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Traffic metrics card widget for displaying key performance indicators
class TrafficMetricsCard extends StatelessWidget {
  const TrafficMetricsCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.iconName,
    required this.trend,
    required this.trendValue,
    this.onTap,
    this.isAlert = false,
  });

  final String title;
  final String value;
  final String unit;
  final String iconName;
  final String trend; // 'up', 'down', 'stable'
  final String trendValue;
  final VoidCallback? onTap;
  final bool isAlert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 16.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isAlert
              ? colorScheme.errorContainer.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAlert
                ? colorScheme.error.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isAlert
                        ? colorScheme.error.withValues(alpha: 0.1)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: isAlert ? colorScheme.error : colorScheme.primary,
                    size: 5.w,
                  ),
                ),
                _buildTrendIndicator(colorScheme),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: isAlert
                                ? colorScheme.error
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unit.isNotEmpty) ...[
                        SizedBox(width: 1.w),
                        Text(
                          unit,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(ColorScheme colorScheme) {
    Color trendColor;
    IconData trendIcon;

    switch (trend.toLowerCase()) {
      case 'up':
        trendColor = colorScheme.error;
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendColor = AppTheme.successLight;
        trendIcon = Icons.trending_down;
        break;
      case 'stable':
      default:
        trendColor = colorScheme.onSurface.withValues(alpha: 0.6);
        trendIcon = Icons.trending_flat;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trendIcon,
            color: trendColor,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            trendValue,
            style: TextStyle(
              color: trendColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
