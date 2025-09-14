import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Interactive traffic heatmap widget with junction markers
class TrafficHeatmap extends StatefulWidget {
  const TrafficHeatmap({
    super.key,
    required this.onJunctionTap,
    required this.onJunctionLongPress,
  });

  final Function(Map<String, dynamic> junction) onJunctionTap;
  final Function(Map<String, dynamic> junction) onJunctionLongPress;

  @override
  State<TrafficHeatmap> createState() => _TrafficHeatmapState();
}

class _TrafficHeatmapState extends State<TrafficHeatmap> {
  final TransformationController _transformationController =
      TransformationController();

  // Mock junction data
  final List<Map<String, dynamic>> junctions = [
    {
      "id": "J001",
      "name": "Main St & 5th Ave",
      "status": "optimal",
      "congestionLevel": 0.2,
      "vehicleCount": 45,
      "position": {"x": 0.3, "y": 0.4},
      "signalStatus": "green",
      "emergencyVehicles": 0,
    },
    {
      "id": "J002",
      "name": "Broadway & Central",
      "status": "warning",
      "congestionLevel": 0.7,
      "vehicleCount": 128,
      "position": {"x": 0.6, "y": 0.3},
      "signalStatus": "yellow",
      "emergencyVehicles": 1,
    },
    {
      "id": "J003",
      "name": "Park Ave & 12th St",
      "status": "critical",
      "congestionLevel": 0.9,
      "vehicleCount": 203,
      "position": {"x": 0.4, "y": 0.7},
      "signalStatus": "red",
      "emergencyVehicles": 0,
    },
    {
      "id": "J004",
      "name": "Oak St & Elm Ave",
      "status": "optimal",
      "congestionLevel": 0.3,
      "vehicleCount": 67,
      "position": {"x": 0.8, "y": 0.6},
      "signalStatus": "green",
      "emergencyVehicles": 0,
    },
    {
      "id": "J005",
      "name": "First St & Market",
      "status": "warning",
      "congestionLevel": 0.6,
      "vehicleCount": 156,
      "position": {"x": 0.2, "y": 0.8},
      "signalStatus": "yellow",
      "emergencyVehicles": 2,
    },
  ];

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 35.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Heatmap background
            _buildHeatmapBackground(colorScheme),

            // Interactive map with junction markers
            InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: EdgeInsets.all(4.w),
              minScale: 0.8,
              maxScale: 3.0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: junctions
                      .map((junction) => _buildJunctionMarker(
                            context,
                            junction,
                            colorScheme,
                          ))
                      .toList(),
                ),
              ),
            ),

            // Map controls
            _buildMapControls(colorScheme),

            // Legend
            _buildLegend(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapBackground(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.2, -0.3),
          radius: 0.8,
          colors: [
            AppTheme.errorLight.withValues(alpha: 0.3),
            AppTheme.warningLight.withValues(alpha: 0.2),
            AppTheme.successLight.withValues(alpha: 0.1),
            colorScheme.surface,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: HeatmapPainter(junctions: junctions),
      ),
    );
  }

  Widget _buildJunctionMarker(
    BuildContext context,
    Map<String, dynamic> junction,
    ColorScheme colorScheme,
  ) {
    final position = junction["position"] as Map<String, dynamic>;
    final status = junction["status"] as String;
    final emergencyVehicles = junction["emergencyVehicles"] as int;

    Color markerColor = AppTheme.getStatusColor(status);

    return Positioned(
      left: (position["x"] as double) * 85.w,
      top: (position["y"] as double) * 30.h,
      child: GestureDetector(
        onTap: () => widget.onJunctionTap(junction),
        onLongPress: () => widget.onJunctionLongPress(junction),
        child: Container(
          width: 12.w,
          height: 6.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main marker
              Container(
                width: 10.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: markerColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'traffic',
                    color: colorScheme.surface,
                    size: 4.w,
                  ),
                ),
              ),

              // Emergency vehicle indicator
              if (emergencyVehicles > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 4.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emergencyVehicles.toString(),
                        style: TextStyle(
                          color: colorScheme.surface,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls(ColorScheme colorScheme) {
    return Positioned(
      top: 2.h,
      right: 3.w,
      child: Column(
        children: [
          _buildControlButton(
            colorScheme,
            'zoom_in',
            () => _transformationController.value = Matrix4.identity()
              ..scale(2.0),
          ),
          SizedBox(height: 1.h),
          _buildControlButton(
            colorScheme,
            'zoom_out',
            () => _transformationController.value = Matrix4.identity()
              ..scale(0.8),
          ),
          SizedBox(height: 1.h),
          _buildControlButton(
            colorScheme,
            'center_focus_strong',
            () => _transformationController.value = Matrix4.identity(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    ColorScheme colorScheme,
    String iconName,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 10.w,
      height: 5.h,
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: CustomIconWidget(
          iconName: iconName,
          color: colorScheme.onSurface,
          size: 4.w,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLegend(ThemeData theme, ColorScheme colorScheme) {
    return Positioned(
      bottom: 2.h,
      left: 3.w,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLegendItem(theme, AppTheme.successLight, 'Low'),
            SizedBox(width: 2.w),
            _buildLegendItem(theme, AppTheme.warningLight, 'Medium'),
            SizedBox(width: 2.w),
            _buildLegendItem(theme, AppTheme.errorLight, 'High'),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for heatmap visualization
class HeatmapPainter extends CustomPainter {
  final List<Map<String, dynamic>> junctions;

  HeatmapPainter({required this.junctions});

  @override
  void paint(Canvas canvas, Size size) {
    for (final junction in junctions) {
      final position = junction["position"] as Map<String, dynamic>;
      final congestionLevel = junction["congestionLevel"] as double;

      final center = Offset(
        (position["x"] as double) * size.width,
        (position["y"] as double) * size.height,
      );

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            _getCongestionColor(congestionLevel).withValues(alpha: 0.4),
            _getCongestionColor(congestionLevel).withValues(alpha: 0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: 80));

      canvas.drawCircle(center, 80, paint);
    }
  }

  Color _getCongestionColor(double level) {
    if (level < 0.4) return AppTheme.successLight;
    if (level < 0.7) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
