import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Traffic flow indicators showing vehicle count and wait times
class TrafficFlowWidget extends StatelessWidget {
  const TrafficFlowWidget({
    super.key,
    required this.trafficData,
  });

  final Map<String, Map<String, dynamic>> trafficData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'traffic',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Traffic Flow Status',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.5,
            children: trafficData.entries.map((entry) {
              return _buildDirectionCard(
                context,
                entry.key,
                entry.value,
                colorScheme,
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),
          _buildOverallStatus(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildDirectionCard(
    BuildContext context,
    String direction,
    Map<String, dynamic> data,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final vehicleCount = data['vehicleCount'] as int;
    final waitTime = data['waitTime'] as int;
    final congestionLevel = data['congestionLevel'] as String;
    final congestionColor = _getCongestionColor(congestionLevel);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: congestionColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: congestionColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  direction.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'directions_car',
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '$vehicleCount vehicles',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                '${waitTime}s wait',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStatus(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final totalVehicles = trafficData.values
        .map((data) => data['vehicleCount'] as int)
        .reduce((a, b) => a + b);
    final avgWaitTime = (trafficData.values
                .map((data) => data['waitTime'] as int)
                .reduce((a, b) => a + b) /
            trafficData.length)
        .round();

    final overallCongestion = _calculateOverallCongestion();
    final congestionColor = _getCongestionColor(overallCongestion);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: congestionColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: congestionColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Status',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: congestionColor,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildStatusMetric(
                  context,
                  'Total Vehicles',
                  totalVehicles.toString(),
                  'directions_car',
                  colorScheme,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatusMetric(
                  context,
                  'Avg Wait Time',
                  '${avgWaitTime}s',
                  'schedule',
                  colorScheme,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatusMetric(
                  context,
                  'Congestion',
                  overallCongestion,
                  'traffic',
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMetric(
    BuildContext context,
    String label,
    String value,
    String iconName,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getCongestionColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
      case 'light':
        return const Color(0xFF4CAF50);
      case 'moderate':
      case 'medium':
        return const Color(0xFFFFA726);
      case 'high':
      case 'heavy':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF757575);
    }
  }

  String _calculateOverallCongestion() {
    final congestionLevels = trafficData.values
        .map((data) => data['congestionLevel'] as String)
        .toList();

    final heavyCount = congestionLevels
        .where((level) => level.toLowerCase() == 'heavy')
        .length;
    final moderateCount = congestionLevels
        .where((level) => level.toLowerCase() == 'moderate')
        .length;

    if (heavyCount >= 2) return 'Heavy';
    if (heavyCount >= 1 || moderateCount >= 2) return 'Moderate';
    return 'Light';
  }
}
