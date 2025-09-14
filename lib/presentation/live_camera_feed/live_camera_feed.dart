import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_feed_header_widget.dart';
import './widgets/emergency_alert_banner_widget.dart';
import './widgets/vehicle_count_ticker_widget.dart';
import './widgets/vehicle_detection_overlay_widget.dart';
import 'widgets/camera_controls_widget.dart';
import 'widgets/camera_feed_header_widget.dart';
import 'widgets/emergency_alert_banner_widget.dart';
import 'widgets/vehicle_count_ticker_widget.dart';
import 'widgets/vehicle_detection_overlay_widget.dart';

/// Live Camera Feed screen for real-time traffic monitoring
/// Provides AI-powered vehicle detection and traffic analysis
class LiveCameraFeed extends StatefulWidget {
  const LiveCameraFeed({super.key});

  @override
  State<LiveCameraFeed> createState() => _LiveCameraFeedState();
}

class _LiveCameraFeedState extends State<LiveCameraFeed>
    with TickerProviderStateMixin {
  // Camera feed state
  bool _isPlaying = true;
  bool _isRecording = false;
  bool _isFullscreen = false;
  String _currentQuality = 'HD';
  String _connectionStatus = 'Live';
  int _currentCameraIndex = 0;

  // AI detection state
  bool _isDetectionEnabled = true;
  List<Map<String, dynamic>> _vehicleDetections = [];
  Map<String, int> _vehicleCounts = {};
  int _flowRate = 0;

  // Emergency detection state
  bool _emergencyDetected = false;
  String _emergencyVehicleType = '';

  // UI state
  bool _showControls = true;
  bool _showVehicleCount = true;
  Timer? _hideControlsTimer;
  Timer? _detectionUpdateTimer;
  Timer? _statsUpdateTimer;

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock camera locations
  final List<Map<String, dynamic>> _cameraLocations = [
    {
      "id": 1,
      "name": "Main Street & 5th Avenue",
      "location": "Downtown Intersection",
      "status": "Live",
      "videoUrl":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
    },
    {
      "id": 2,
      "name": "Highway 101 North",
      "location": "Mile Marker 45",
      "status": "Live",
      "videoUrl":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4",
    },
    {
      "id": 3,
      "name": "Central Plaza Junction",
      "location": "City Center",
      "status": "Live",
      "videoUrl":
          "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startMockDetection();
    _startStatsUpdate();
    _resetHideControlsTimer();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _detectionUpdateTimer?.cancel();
    _statsUpdateTimer?.cancel();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _startMockDetection() {
    _detectionUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isPlaying && _isDetectionEnabled) {
        _updateVehicleDetections();
      }
    });
  }

  void _startStatsUpdate() {
    _statsUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isPlaying) {
        _updateTrafficStats();
      }
    });
  }

  void _updateVehicleDetections() {
    final random = Random();
    final vehicleTypes = ['car', 'truck', 'bus', 'motorcycle', 'bicycle'];
    final detectionCount = random.nextInt(8) + 2; // 2-9 detections

    final newDetections = <Map<String, dynamic>>[];
    final newCounts = <String, int>{};

    // Initialize counts
    for (final type in vehicleTypes) {
      newCounts[type] = 0;
    }

    for (int i = 0; i < detectionCount; i++) {
      final vehicleType = vehicleTypes[random.nextInt(vehicleTypes.length)];
      final isEmergency =
          vehicleType == 'car' && random.nextDouble() < 0.05; // 5% chance

      newDetections.add({
        'id': i,
        'type': vehicleType,
        'confidence': 0.7 + random.nextDouble() * 0.3, // 70-100% confidence
        'x': random.nextDouble() * 0.8 + 0.1, // 10-90% of screen width
        'y': random.nextDouble() * 0.8 + 0.1, // 10-90% of screen height
        'width': 0.1 + random.nextDouble() * 0.15, // 10-25% of screen width
        'height': 0.1 + random.nextDouble() * 0.15, // 10-25% of screen height
        'isEmergency': isEmergency,
      });

      newCounts[vehicleType] = (newCounts[vehicleType] ?? 0) + 1;

      // Trigger emergency detection
      if (isEmergency && !_emergencyDetected) {
        _triggerEmergencyDetection('Emergency Vehicle');
      }
    }

    if (mounted) {
      setState(() {
        _vehicleDetections = newDetections;
        _vehicleCounts = newCounts;
      });
    }
  }

  void _updateTrafficStats() {
    final random = Random();
    final newFlowRate = 15 + random.nextInt(25); // 15-40 vehicles per minute

    if (mounted) {
      setState(() {
        _flowRate = newFlowRate;
      });
    }
  }

  void _triggerEmergencyDetection(String vehicleType) {
    setState(() {
      _emergencyDetected = true;
      _emergencyVehicleType = vehicleType;
    });

    // Auto-dismiss after 10 seconds
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _emergencyDetected = false;
        });
      }
    });
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetHideControlsTimer();
    }
  }

  void _handlePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _resetHideControlsTimer();
  }

  void _handleRecord() {
    setState(() {
      _isRecording = !_isRecording;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRecording ? 'Recording started' : 'Recording stopped',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: _isRecording ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    _resetHideControlsTimer();
  }

  void _handleScreenshot() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Screenshot saved to gallery',
          style: GoogleFonts.inter(),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _resetHideControlsTimer();
  }

  void _handleQualityChange(String quality) {
    setState(() {
      _currentQuality = quality;
      _connectionStatus = quality == 'AUTO' ? 'Adjusting...' : 'Live';
    });

    // Simulate quality change delay
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _connectionStatus = 'Live';
        });
      }
    });
    _resetHideControlsTimer();
  }

  void _handleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _resetHideControlsTimer();
  }

  void _handleSettings() {
    _showSettingsBottomSheet();
    _resetHideControlsTimer();
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Camera Settings',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),

            // AI Detection Toggle
            SwitchListTile(
              title: Text(
                'AI Vehicle Detection',
                style: GoogleFonts.inter(fontSize: 14.sp),
              ),
              subtitle: Text(
                'Enable real-time vehicle classification',
                style: GoogleFonts.inter(fontSize: 12.sp),
              ),
              value: _isDetectionEnabled,
              onChanged: (value) {
                setState(() {
                  _isDetectionEnabled = value;
                });
                Navigator.pop(context);
              },
            ),

            // Vehicle Count Toggle
            SwitchListTile(
              title: Text(
                'Vehicle Count Display',
                style: GoogleFonts.inter(fontSize: 14.sp),
              ),
              subtitle: Text(
                'Show live vehicle statistics',
                style: GoogleFonts.inter(fontSize: 12.sp),
              ),
              value: _showVehicleCount,
              onChanged: (value) {
                setState(() {
                  _showVehicleCount = value;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _switchCamera(int direction) {
    final newIndex =
        (_currentCameraIndex + direction) % _cameraLocations.length;
    if (newIndex < 0) {
      _currentCameraIndex = _cameraLocations.length - 1;
    } else {
      _currentCameraIndex = newIndex;
    }

    setState(() {
      _connectionStatus = 'Connecting...';
    });

    // Simulate camera switch delay
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _connectionStatus = 'Live';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCamera = _cameraLocations[_currentCameraIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _switchCamera(-1); // Swipe right - previous camera
          } else if (details.primaryVelocity! < 0) {
            _switchCamera(1); // Swipe left - next camera
          }
        },
        child: Stack(
          children: [
            // Video feed background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _isPlaying ? 'videocam' : 'videocam_off',
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 20.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _isPlaying ? 'Live Feed Simulation' : 'Feed Paused',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      currentCamera['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Vehicle detection overlay
            if (_isPlaying && _isDetectionEnabled)
              VehicleDetectionOverlayWidget(
                detections: _vehicleDetections,
                videoSize: Size(100.w, 100.h),
                isDetectionEnabled: _isDetectionEnabled,
              ),

            // Header overlay
            if (_showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: CameraFeedHeaderWidget(
                  cameraLocation: currentCamera['name'] as String,
                  connectionStatus: _connectionStatus,
                  onBack: () => Navigator.pop(context),
                  onSettings: _handleSettings,
                  onFullscreen: _handleFullscreen,
                ),
              ),

            // Bottom controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: CameraControlsWidget(
                    isPlaying: _isPlaying,
                    isRecording: _isRecording,
                    currentQuality: _currentQuality,
                    onPlayPause: _handlePlayPause,
                    onRecord: _handleRecord,
                    onScreenshot: _handleScreenshot,
                    onQualityChange: _handleQualityChange,
                  ),
                ),
              ),

            // Vehicle count ticker
            VehicleCountTickerWidget(
              vehicleCounts: _vehicleCounts,
              flowRate: _flowRate,
              isVisible: _showVehicleCount && _isPlaying,
            ),

            // Emergency alert banner
            if (_emergencyDetected)
              Positioned(
                top: _isFullscreen ? 8.h : 15.h,
                left: 0,
                right: 0,
                child: EmergencyAlertBannerWidget(
                  isVisible: _emergencyDetected,
                  emergencyVehicleType: _emergencyVehicleType,
                  onDismiss: () {
                    setState(() {
                      _emergencyDetected = false;
                    });
                  },
                  onViewRoute: () {
                    Navigator.pushNamed(context, '/traffic-analytics');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}