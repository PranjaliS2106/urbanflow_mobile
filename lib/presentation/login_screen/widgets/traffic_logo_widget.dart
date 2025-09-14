import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Traffic authority logo widget with institutional branding
class TrafficLogoWidget extends StatelessWidget {
  const TrafficLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Logo Container
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background pattern
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),

              // Traffic light icon
              CustomIconWidget(
                iconName: 'traffic',
                color: colorScheme.onPrimary,
                size: 12.w,
              ),

              // Corner accent
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // App Title
        Text(
          'UrbanFlow Mobile',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // Subtitle
        Text(
          'Traffic Management Authority',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),

        SizedBox(height: 0.5.h),

        // Version badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 0.5.h,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            'v2.1.4 • Secure Access',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
