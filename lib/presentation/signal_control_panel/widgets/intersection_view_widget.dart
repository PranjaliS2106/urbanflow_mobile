import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Visual representation of intersection with signal states
class IntersectionViewWidget extends StatelessWidget {
  const IntersectionViewWidget({
    super.key,
    required this.northSignal,
    required this.southSignal,
    required this.eastSignal,
    required this.westSignal,
    required this.onDirectionTap,
  });

  final String northSignal;
  final String southSignal;
  final String eastSignal;
  final String westSignal;
  final Function(String direction) onDirectionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 50.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Intersection background
          Center(
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'add',
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  size: 8.w,
                ),
              ),
            ),
          ),

          // North signal
          Positioned(
            top: 2.h,
            left: 0,
            right: 0,
            child: Center(
              child: _buildSignalLight(
                context,
                'North',
                northSignal,
                colorScheme,
                () => onDirectionTap('north'),
              ),
            ),
          ),

          // South signal
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Center(
              child: _buildSignalLight(
                context,
                'South',
                southSignal,
                colorScheme,
                () => onDirectionTap('south'),
              ),
            ),
          ),

          // East signal
          Positioned(
            right: 2.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildSignalLight(
                context,
                'East',
                eastSignal,
                colorScheme,
                () => onDirectionTap('east'),
              ),
            ),
          ),

          // West signal
          Positioned(
            left: 2.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildSignalLight(
                context,
                'West',
                westSignal,
                colorScheme,
                () => onDirectionTap('west'),
              ),
            ),
          ),

          // Traffic flow indicators
          _buildTrafficFlowIndicators(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSignalLight(
    BuildContext context,
    String direction,
    String signal,
    ColorScheme colorScheme,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final signalColor = _getSignalColor(signal);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: signalColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: signalColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: signalColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: signalColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              direction,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              signal.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: signalColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficFlowIndicators(
      BuildContext context, ColorScheme colorScheme) {
    return Positioned.fill(
      child: CustomPaint(
        painter: TrafficFlowPainter(colorScheme),
      ),
    );
  }

  Color _getSignalColor(String signal) {
    switch (signal.toLowerCase()) {
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
        return const Color(0xFF757575);
    }
  }
}

/// Custom painter for traffic flow visualization
class TrafficFlowPainter extends CustomPainter {
  final ColorScheme colorScheme;

  TrafficFlowPainter(this.colorScheme);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw road lines
    // Horizontal road
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );

    // Vertical road
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );

    // Draw lane dividers
    paint.strokeWidth = 1;
    paint.color = colorScheme.outline.withValues(alpha: 0.2);

    // Horizontal lane dividers
    canvas.drawLine(
      Offset(0, center.dy - 20),
      Offset(size.width, center.dy - 20),
      paint,
    );
    canvas.drawLine(
      Offset(0, center.dy + 20),
      Offset(size.width, center.dy + 20),
      paint,
    );

    // Vertical lane dividers
    canvas.drawLine(
      Offset(center.dx - 20, 0),
      Offset(center.dx - 20, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + 20, 0),
      Offset(center.dx + 20, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
