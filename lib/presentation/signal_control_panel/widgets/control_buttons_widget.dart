import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Control buttons for manual signal phase changes
class ControlButtonsWidget extends StatelessWidget {
  const ControlButtonsWidget({
    super.key,
    required this.onPhaseChange,
    required this.isEmergencyMode,
    required this.currentPhase,
  });

  final Function(String phase) onPhaseChange;
  final bool isEmergencyMode;
  final String currentPhase;

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
          Text(
            'Manual Control',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildControlButton(
                  context,
                  'Green',
                  'go',
                  const Color(0xFF4CAF50),
                  CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 20,
                  ),
                  currentPhase.toLowerCase() == 'green',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildControlButton(
                  context,
                  'Yellow',
                  'caution',
                  const Color(0xFFFFA726),
                  CustomIconWidget(
                    iconName: 'pause',
                    color: Colors.white,
                    size: 20,
                  ),
                  currentPhase.toLowerCase() == 'yellow',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildControlButton(
                  context,
                  'Red',
                  'stop',
                  const Color(0xFFE53935),
                  CustomIconWidget(
                    iconName: 'stop',
                    color: Colors.white,
                    size: 20,
                  ),
                  currentPhase.toLowerCase() == 'red',
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (!isEmergencyMode) ...[
            Text(
              'Safety Notice',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Manual changes require confirmation and will be logged for safety compliance.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    String label,
    String phase,
    Color color,
    Widget icon,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => _handlePhaseChange(context, phase, label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 12.h,
        decoration: BoxDecoration(
          color: isActive ? color : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : color.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isActive
                    ? icon
                    : CustomIconWidget(
                        iconName: _getIconName(phase),
                        color: color,
                        size: 20,
                      ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isActive ? Colors.white : color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconName(String phase) {
    switch (phase.toLowerCase()) {
      case 'go':
        return 'play_arrow';
      case 'caution':
        return 'pause';
      case 'stop':
        return 'stop';
      default:
        return 'radio_button_unchecked';
    }
  }

  void _handlePhaseChange(BuildContext context, String phase, String label) {
    HapticFeedback.lightImpact();

    if (isEmergencyMode) {
      onPhaseChange(phase);
      return;
    }

    // Show confirmation dialog for safety
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Signal Change',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          content: Text(
            'Are you sure you want to change the signal to $label? This action will be logged for safety compliance.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPhaseChange(phase);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
