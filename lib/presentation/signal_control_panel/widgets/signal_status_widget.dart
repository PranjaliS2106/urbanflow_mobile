import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Signal status display widget showing current phase and timing
class SignalStatusWidget extends StatelessWidget {
  const SignalStatusWidget({
    super.key,
    required this.currentPhase,
    required this.remainingTime,
    required this.nextPhase,
    required this.isEmergencyMode,
  });

  final String currentPhase;
  final int remainingTime;
  final String nextPhase;
  final bool isEmergencyMode;

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
        border: Border.all(
          color: isEmergencyMode
              ? colorScheme.error
              : colorScheme.outline.withValues(alpha: 0.2),
          width: isEmergencyMode ? 2 : 1,
        ),
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
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: _getPhaseColor(currentPhase, colorScheme),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Phase',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      currentPhase,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              if (isEmergencyMode)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'emergency',
                        color: colorScheme.error,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'EMERGENCY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildTimerSection(
                  context,
                  'Remaining Time',
                  '${remainingTime}s',
                  colorScheme,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTimerSection(
                  context,
                  'Next Phase',
                  nextPhase,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection(
    BuildContext context,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPhaseColor(String phase, ColorScheme colorScheme) {
    switch (phase.toLowerCase()) {
      case 'green':
      case 'go':
        return const Color(0xFF4CAF50);
      case 'yellow':
      case 'amber':
      case 'caution':
        return const Color(0xFFFFA726);
      case 'red':
      case 'stop':
        return const Color(0xFFE53935);
      default:
        return colorScheme.primary;
    }
  }
}
