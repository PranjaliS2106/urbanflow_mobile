import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Real-time vehicle count display with statistics
class VehicleCountTickerWidget extends StatelessWidget {
  const VehicleCountTickerWidget({
    super.key,
    required this.vehicleCounts,
    required this.flowRate,
    required this.isVisible,
  });

  final Map<String, int> vehicleCounts;
  final int flowRate;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalVehicles =
        vehicleCounts.values.fold(0, (sum, count) => sum + count);

    return Positioned(
      top: 12.h,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'directions_car',
                  color: Colors.white,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Live Count',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Total vehicles
            _buildCountRow(
              'Total',
              totalVehicles.toString(),
              Colors.white,
              isTotal: true,
            ),

            SizedBox(height: 1.h),

            // Individual vehicle types
            ...vehicleCounts.entries.map(
              (entry) => _buildCountRow(
                _formatVehicleType(entry.key),
                entry.value.toString(),
                _getVehicleTypeColor(entry.key),
              ),
            ),

            SizedBox(height: 1.h),

            // Flow rate
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'speed',
                    color: colorScheme.primary,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '$flowRate/min',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountRow(String label, String count, Color color,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.w,
            height: 2.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          SizedBox(
            width: 15.w,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: isTotal ? 11.sp : 10.sp,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 11.sp : 10.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatVehicleType(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return 'Cars';
      case 'truck':
        return 'Trucks';
      case 'bus':
        return 'Buses';
      case 'motorcycle':
        return 'Bikes';
      case 'bicycle':
        return 'Cycles';
      default:
        return type;
    }
  }

  Color _getVehicleTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Colors.green;
      case 'truck':
        return Colors.orange;
      case 'bus':
        return Colors.blue;
      case 'motorcycle':
        return Colors.purple;
      case 'bicycle':
        return Colors.cyan;
      default:
        return Colors.yellow;
    }
  }
}