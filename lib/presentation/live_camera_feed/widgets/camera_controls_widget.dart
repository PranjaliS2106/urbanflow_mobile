import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Camera control buttons for live feed operations
class CameraControlsWidget extends StatelessWidget {
  const CameraControlsWidget({
    super.key,
    required this.isPlaying,
    required this.isRecording,
    required this.currentQuality,
    required this.onPlayPause,
    required this.onRecord,
    required this.onScreenshot,
    required this.onQualityChange,
  });

  final bool isPlaying;
  final bool isRecording;
  final String currentQuality;
  final VoidCallback onPlayPause;
  final VoidCallback onRecord;
  final VoidCallback onScreenshot;
  final Function(String) onQualityChange;

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
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Play/Pause Button
          _buildControlButton(
            icon: isPlaying ? 'pause' : 'play_arrow',
            onTap: onPlayPause,
            backgroundColor: colorScheme.primary,
            iconColor: Colors.white,
          ),

          // Record Button
          _buildControlButton(
            icon: isRecording ? 'stop' : 'fiber_manual_record',
            onTap: onRecord,
            backgroundColor: isRecording
                ? colorScheme.error
                : Colors.white.withValues(alpha: 0.2),
            iconColor: isRecording ? Colors.white : colorScheme.error,
          ),

          // Screenshot Button
          _buildControlButton(
            icon: 'camera_alt',
            onTap: onScreenshot,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            iconColor: Colors.white,
          ),

          // Quality Selector
          _buildQualitySelector(colorScheme),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: iconColor,
            size: 6.w,
          ),
        ),
      ),
    );
  }

  Widget _buildQualitySelector(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => _showQualityMenu(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentQuality,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: Colors.white,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityMenu() {
    // Quality selection would be handled by parent widget
    final qualities = ['HD', 'SD', 'AUTO'];
    final currentIndex = qualities.indexOf(currentQuality);
    final nextIndex = (currentIndex + 1) % qualities.length;
    onQualityChange(qualities[nextIndex]);
  }
}