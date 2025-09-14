import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import '../../../core/app_export.dart';

/// AI detection overlay showing vehicle bounding boxes and classifications
class VehicleDetectionOverlayWidget extends StatelessWidget {
  const VehicleDetectionOverlayWidget({
    super.key,
    required this.detections,
    required this.videoSize,
    required this.isDetectionEnabled,
  });

  final List<Map<String, dynamic>> detections;
  final Size videoSize;
  final bool isDetectionEnabled;

  @override
  Widget build(BuildContext context) {
    if (!isDetectionEnabled || detections.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: DetectionPainter(
        detections: detections,
        videoSize: videoSize,
      ),
      child: Container(),
    );
  }
}

/// Custom painter for drawing detection bounding boxes
class DetectionPainter extends CustomPainter {
  const DetectionPainter({
    required this.detections,
    required this.videoSize,
  });

  final List<Map<String, dynamic>> detections;
  final Size videoSize;

  @override
  void paint(Canvas canvas, Size size) {
    for (final detection in detections) {
      _drawDetection(canvas, size, detection);
    }
  }

  void _drawDetection(
      Canvas canvas, Size size, Map<String, dynamic> detection) {
    final double x = (detection['x'] as double) * size.width;
    final double y = (detection['y'] as double) * size.height;
    final double width = (detection['width'] as double) * size.width;
    final double height = (detection['height'] as double) * size.height;
    final String vehicleType = detection['type'] as String;
    final double confidence = detection['confidence'] as double;
    final bool isEmergency = detection['isEmergency'] as bool? ?? false;

    // Determine box color based on vehicle type
    Color boxColor = _getVehicleColor(vehicleType, isEmergency);

    // Draw bounding box
    final paint = Paint()
      ..color = boxColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromLTWH(x, y, width, height);
    canvas.drawRect(rect, paint);

    // Draw filled background for label
    final labelPaint = Paint()
      ..color = boxColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final labelText = '$vehicleType ${(confidence * 100).toInt()}%';
    final textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final labelRect = Rect.fromLTWH(
      x,
      y - textPainter.height - 4,
      textPainter.width + 8,
      textPainter.height + 4,
    );

    canvas.drawRect(labelRect, labelPaint);

    // Draw label text
    textPainter.paint(canvas, Offset(x + 4, y - textPainter.height - 2));

    // Draw emergency indicator if applicable
    if (isEmergency) {
      _drawEmergencyIndicator(canvas, x + width - 20, y, 16);
    }
  }

  void _drawEmergencyIndicator(Canvas canvas, double x, double y, double size) {
    final emergencyPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Draw emergency triangle
    final path = Path();
    path.moveTo(x + size / 2, y);
    path.lineTo(x, y + size);
    path.lineTo(x + size, y + size);
    path.close();

    canvas.drawPath(path, emergencyPaint);

    // Draw exclamation mark
    final exclamationPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Exclamation line
    canvas.drawRect(
      Rect.fromLTWH(x + size / 2 - 1, y + 4, 2, size - 10),
      exclamationPaint,
    );

    // Exclamation dot
    canvas.drawCircle(
      Offset(x + size / 2, y + size - 3),
      1.5,
      exclamationPaint,
    );
  }

  Color _getVehicleColor(String vehicleType, bool isEmergency) {
    if (isEmergency) return Colors.red;

    switch (vehicleType.toLowerCase()) {
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for real-time updates
  }
}