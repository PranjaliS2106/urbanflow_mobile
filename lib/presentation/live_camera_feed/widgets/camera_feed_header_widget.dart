import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Header overlay for camera feed with location and controls
class CameraFeedHeaderWidget extends StatelessWidget {
  const CameraFeedHeaderWidget({
    super.key,
    required this.cameraLocation,
    required this.connectionStatus,
    required this.onBack,
    required this.onSettings,
    required this.onFullscreen,
  });

  final String cameraLocation;
  final String connectionStatus;
  final VoidCallback onBack;
  final VoidCallback onSettings;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: Colors.white,
                  size: 5.w,
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Camera location and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cameraLocation,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: _getStatusColor(connectionStatus),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        connectionStatus,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fullscreen toggle
                GestureDetector(
                  onTap: onFullscreen,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'fullscreen',
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Settings button
                GestureDetector(
                  onTap: onSettings,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'settings',
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'live':
      case 'connected':
        return Colors.green;
      case 'reconnecting':
      case 'buffering':
        return Colors.orange;
      case 'offline':
      case 'disconnected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}