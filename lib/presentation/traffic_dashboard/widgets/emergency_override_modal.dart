import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Emergency override modal for immediate traffic signal control
class EmergencyOverrideModal extends StatefulWidget {
  const EmergencyOverrideModal({
    super.key,
    required this.onActivate,
    required this.onCancel,
  });

  final Function(String junctionId, String action) onActivate;
  final VoidCallback onCancel;

  @override
  State<EmergencyOverrideModal> createState() => _EmergencyOverrideModalState();
}

class _EmergencyOverrideModalState extends State<EmergencyOverrideModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  String? selectedJunction;
  String? selectedAction;

  final List<Map<String, dynamic>> junctions = [
    {"id": "J001", "name": "Main St & 5th Ave", "status": "optimal"},
    {"id": "J002", "name": "Broadway & Central", "status": "warning"},
    {"id": "J003", "name": "Park Ave & 12th St", "status": "critical"},
    {"id": "J004", "name": "Oak St & Elm Ave", "status": "optimal"},
    {"id": "J005", "name": "First St & Market", "status": "warning"},
  ];

  final List<Map<String, dynamic>> actions = [
    {
      "id": "priority_route",
      "name": "Priority Route",
      "description": "Clear path for emergency vehicles",
      "icon": "local_hospital",
      "color": Colors.red,
    },
    {
      "id": "all_red",
      "name": "All Red Override",
      "description": "Stop all traffic immediately",
      "icon": "stop",
      "color": Colors.red,
    },
    {
      "id": "extend_green",
      "name": "Extend Green",
      "description": "Extend current green phase",
      "icon": "play_arrow",
      "color": Colors.green,
    },
    {
      "id": "manual_control",
      "name": "Manual Control",
      "description": "Take full manual control",
      "icon": "settings",
      "color": Colors.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(4.w),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 80.h,
                  maxWidth: 90.w,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(theme, colorScheme),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildJunctionSelection(theme, colorScheme),
                            SizedBox(height: 4.h),
                            _buildActionSelection(theme, colorScheme),
                            SizedBox(height: 4.h),
                            _buildWarningMessage(theme, colorScheme),
                            SizedBox(height: 4.h),
                            _buildActionButtons(theme, colorScheme),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.errorLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'emergency',
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Override',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Immediate traffic control activation',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onCancel,
            icon: CustomIconWidget(
              iconName: 'close',
              color: Colors.white,
              size: 5.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJunctionSelection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Junction',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 2.h),
        ...junctions
            .map((junction) => _buildJunctionOption(
                  theme,
                  colorScheme,
                  junction,
                ))
            .toList(),
      ],
    );
  }

  Widget _buildJunctionOption(
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> junction,
  ) {
    final isSelected = selectedJunction == junction["id"];
    final status = junction["status"] as String;

    return GestureDetector(
      onTap: () => setState(() => selectedJunction = junction["id"]),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppTheme.getStatusColor(status).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'traffic',
                  color: AppTheme.getStatusColor(status),
                  size: 4.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    junction["name"],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Status: ${status.toUpperCase()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getStatusColor(status),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: colorScheme.primary,
                size: 5.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSelection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Action',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            final isSelected = selectedAction == action["id"];

            return GestureDetector(
              onTap: () => setState(() => selectedAction = action["id"]),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (action["color"] as Color).withValues(alpha: 0.1)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? action["color"] as Color
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: action["icon"],
                      color: isSelected
                          ? action["color"] as Color
                          : colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 6.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      action["name"],
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? action["color"] as Color
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      action["description"],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 9.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWarningMessage(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.warningLight,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Emergency override will immediately affect traffic flow. Use only in critical situations.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.warningLight,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    final canActivate = selectedJunction != null && selectedAction != null;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(
                color: colorScheme.outline,
                width: 1,
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton(
            onPressed: canActivate
                ? () => widget.onActivate(selectedJunction!, selectedAction!)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              disabledBackgroundColor:
                  colorScheme.outline.withValues(alpha: 0.3),
            ),
            child: Text(
              'ACTIVATE',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
