import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Emergency control panel with override capabilities
class EmergencyControlsWidget extends StatelessWidget {
  const EmergencyControlsWidget({
    super.key,
    required this.isEmergencyMode,
    required this.onEmergencyToggle,
    required this.onAllStop,
    required this.onPriorityRoute,
    required this.onMaintenanceMode,
    required this.isMaintenanceMode,
  });

  final bool isEmergencyMode;
  final VoidCallback onEmergencyToggle;
  final VoidCallback onAllStop;
  final VoidCallback onPriorityRoute;
  final VoidCallback onMaintenanceMode;
  final bool isMaintenanceMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color:
            isEmergencyMode ? colorScheme.errorContainer : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmergencyMode
              ? colorScheme.error
              : colorScheme.outline.withValues(alpha: 0.2),
          width: isEmergencyMode ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isEmergencyMode
                ? colorScheme.error.withValues(alpha: 0.2)
                : colorScheme.shadow.withValues(alpha: 0.1),
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
                iconName: 'emergency',
                color:
                    isEmergencyMode ? colorScheme.error : colorScheme.onSurface,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Emergency Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEmergencyMode
                        ? colorScheme.error
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              Switch(
                value: isEmergencyMode,
                onChanged: (_) => _handleEmergencyToggle(context),
                activeColor: colorScheme.error,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  'All Stop',
                  'stop_circle',
                  colorScheme.error,
                  onAllStop,
                  'Immediately stop all traffic',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildEmergencyButton(
                  context,
                  'Priority Route',
                  'local_fire_department',
                  const Color(0xFFFF6B35),
                  onPriorityRoute,
                  'Activate emergency vehicle priority',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildMaintenanceToggle(context, colorScheme),
          if (isEmergencyMode) ...[
            SizedBox(height: 3.h),
            _buildEmergencyNotice(context, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context,
    String label,
    String iconName,
    Color color,
    VoidCallback onPressed,
    String description,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () =>
          _handleEmergencyAction(context, label, onPressed, description),
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceToggle(
      BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isMaintenanceMode
            ? const Color(0xFFFFA726).withValues(alpha: 0.1)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMaintenanceMode
              ? const Color(0xFFFFA726).withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'build',
            color: isMaintenanceMode
                ? const Color(0xFFFFA726)
                : colorScheme.onSurface,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maintenance Mode',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isMaintenanceMode
                        ? const Color(0xFFFFA726)
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Disable automatic signal timing',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isMaintenanceMode,
            onChanged: (_) => _handleMaintenanceToggle(context),
            activeColor: const Color(0xFFFFA726),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNotice(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Mode Active',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'All manual overrides are logged. Normal operation will resume automatically after 30 minutes.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleEmergencyToggle(BuildContext context) {
    HapticFeedback.mediumImpact();

    if (isEmergencyMode) {
      // Confirm deactivation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Deactivate Emergency Mode'),
            content: const Text(
                'Are you sure you want to deactivate emergency mode? Normal signal operation will resume.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onEmergencyToggle();
                },
                child: const Text('Deactivate'),
              ),
            ],
          );
        },
      );
    } else {
      // Confirm activation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Activate Emergency Mode'),
            content: const Text(
                'This will enable manual signal override capabilities. All actions will be logged for compliance.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onEmergencyToggle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Activate'),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleEmergencyAction(
    BuildContext context,
    String action,
    VoidCallback onPressed,
    String description,
  ) {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text(
              '$description\n\nThis action will be immediately executed and logged for safety compliance.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Execute'),
            ),
          ],
        );
      },
    );
  }

  void _handleMaintenanceToggle(BuildContext context) {
    HapticFeedback.lightImpact();

    if (isMaintenanceMode) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exit Maintenance Mode'),
            content: const Text(
                'Automatic signal timing will be restored. Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onMaintenanceMode();
                },
                child: const Text('Exit'),
              ),
            ],
          );
        },
      );
    } else {
      onMaintenanceMode();
    }
  }
}
