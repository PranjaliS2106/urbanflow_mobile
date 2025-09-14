import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/control_buttons_widget.dart';
import './widgets/emergency_controls_widget.dart';
import './widgets/intersection_view_widget.dart';
import './widgets/signal_status_widget.dart';
import './widgets/timing_controls_widget.dart';
import './widgets/traffic_flow_widget.dart';

/// Signal Control Panel for real-time traffic signal management
class SignalControlPanel extends StatefulWidget {
  const SignalControlPanel({super.key});

  @override
  State<SignalControlPanel> createState() => _SignalControlPanelState();
}

class _SignalControlPanelState extends State<SignalControlPanel>
    with TickerProviderStateMixin {
  // Signal state management
  String _currentPhase = 'Green';
  int _remainingTime = 45;
  String _nextPhase = 'Yellow';
  bool _isEmergencyMode = false;
  bool _isMaintenanceMode = false;

  // Signal states for each direction
  String _northSignal = 'Green';
  String _southSignal = 'Green';
  String _eastSignal = 'Red';
  String _westSignal = 'Red';

  // Timing controls
  int _greenDuration = 60;
  int _yellowDuration = 5;
  int _redDuration = 30;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _rotationController;

  // Mock junction data
  final String _junctionName = 'Main St & Broadway Ave';
  final String _junctionId = 'JCT-001';

  // Mock traffic data
  final Map<String, Map<String, dynamic>> _trafficData = {
    'North': {
      'vehicleCount': 12,
      'waitTime': 25,
      'congestionLevel': 'Moderate',
    },
    'South': {
      'vehicleCount': 8,
      'waitTime': 15,
      'congestionLevel': 'Light',
    },
    'East': {
      'vehicleCount': 18,
      'waitTime': 45,
      'congestionLevel': 'Heavy',
    },
    'West': {
      'vehicleCount': 6,
      'waitTime': 12,
      'congestionLevel': 'Light',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSignalTimer();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  void _startSignalTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_isEmergencyMode && !_isMaintenanceMode) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _cycleToNextPhase();
          }
        });
        _startSignalTimer();
      }
    });
  }

  void _cycleToNextPhase() {
    setState(() {
      switch (_currentPhase.toLowerCase()) {
        case 'green':
          _currentPhase = 'Yellow';
          _nextPhase = 'Red';
          _remainingTime = _yellowDuration;
          _updateSignalStates('Yellow');
          break;
        case 'yellow':
          _currentPhase = 'Red';
          _nextPhase = 'Green';
          _remainingTime = _redDuration;
          _updateSignalStates('Red');
          break;
        case 'red':
          _currentPhase = 'Green';
          _nextPhase = 'Yellow';
          _remainingTime = _greenDuration;
          _updateSignalStates('Green');
          break;
      }
    });
  }

  void _updateSignalStates(String phase) {
    // Simulate alternating signal pattern
    if (phase == 'Green') {
      if (_northSignal == 'Red') {
        _northSignal = 'Green';
        _southSignal = 'Green';
        _eastSignal = 'Red';
        _westSignal = 'Red';
      } else {
        _northSignal = 'Red';
        _southSignal = 'Red';
        _eastSignal = 'Green';
        _westSignal = 'Green';
      }
    } else {
      _northSignal = phase;
      _southSignal = phase;
      _eastSignal = phase;
      _westSignal = phase;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: _junctionName,
        variant: _isEmergencyMode
            ? CustomAppBarVariant.emergency
            : CustomAppBarVariant.dashboard,
        statusText: _isEmergencyMode
            ? 'Emergency Mode Active'
            : _isMaintenanceMode
                ? 'Maintenance Mode'
                : 'Normal Operation',
        statusColor: _isEmergencyMode
            ? colorScheme.error
            : _isMaintenanceMode
                ? const Color(0xFFFFA726)
                : const Color(0xFF4CAF50),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Junction info header
              _buildJunctionHeader(context, colorScheme),
              SizedBox(height: 3.h),

              // Signal status
              SignalStatusWidget(
                currentPhase: _currentPhase,
                remainingTime: _remainingTime,
                nextPhase: _nextPhase,
                isEmergencyMode: _isEmergencyMode,
              ),
              SizedBox(height: 3.h),

              // Intersection view
              IntersectionViewWidget(
                northSignal: _northSignal,
                southSignal: _southSignal,
                eastSignal: _eastSignal,
                westSignal: _westSignal,
                onDirectionTap: _handleDirectionTap,
              ),
              SizedBox(height: 3.h),

              // Control buttons
              ControlButtonsWidget(
                onPhaseChange: _handlePhaseChange,
                isEmergencyMode: _isEmergencyMode,
                currentPhase: _currentPhase,
              ),
              SizedBox(height: 3.h),

              // Emergency controls
              EmergencyControlsWidget(
                isEmergencyMode: _isEmergencyMode,
                onEmergencyToggle: _handleEmergencyToggle,
                onAllStop: _handleAllStop,
                onPriorityRoute: _handlePriorityRoute,
                onMaintenanceMode: _handleMaintenanceToggle,
                isMaintenanceMode: _isMaintenanceMode,
              ),
              SizedBox(height: 3.h),

              // Traffic flow indicators
              TrafficFlowWidget(
                trafficData: _trafficData,
              ),
              SizedBox(height: 3.h),

              // Timing controls (expandable)
              ExpansionTile(
                title: Text(
                  'Advanced Timing Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: CustomIconWidget(
                  iconName: 'tune',
                  color: colorScheme.primary,
                  size: 24,
                ),
                children: [
                  TimingControlsWidget(
                    greenDuration: _greenDuration,
                    yellowDuration: _yellowDuration,
                    redDuration: _redDuration,
                    onDurationChanged: _handleDurationChanged,
                    isEnabled: _isMaintenanceMode,
                  ),
                ],
              ),
              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/signal-control-panel',
        variant: _isEmergencyMode
            ? CustomBottomBarVariant.emergency
            : CustomBottomBarVariant.standard,
        onTap: (route) => Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (Route<dynamic> route) => false,
        ),
      ),
    );
  }

  Widget _buildJunctionHeader(BuildContext context, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'traffic',
                color: colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Junction ID: $_junctionId',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Last Updated: ${DateTime.now().toString().substring(11, 19)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(
                    alpha: 0.5 + (_pulseController.value * 0.5),
                  ),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleDirectionTap(String direction) {
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$direction approach selected'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handlePhaseChange(String phase) {
    HapticFeedback.mediumImpact();

    setState(() {
      _currentPhase = phase.substring(0, 1).toUpperCase() + phase.substring(1);

      switch (phase.toLowerCase()) {
        case 'go':
          _remainingTime = _greenDuration;
          _nextPhase = 'Yellow';
          _updateSignalStates('Green');
          break;
        case 'caution':
          _remainingTime = _yellowDuration;
          _nextPhase = 'Red';
          _updateSignalStates('Yellow');
          break;
        case 'stop':
          _remainingTime = _redDuration;
          _nextPhase = 'Green';
          _updateSignalStates('Red');
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signal changed to $_currentPhase'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleEmergencyToggle() {
    HapticFeedback.heavyImpact();

    setState(() {
      _isEmergencyMode = !_isEmergencyMode;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEmergencyMode
              ? 'Emergency mode activated'
              : 'Emergency mode deactivated',
        ),
        backgroundColor: _isEmergencyMode
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleAllStop() {
    HapticFeedback.heavyImpact();

    setState(() {
      _currentPhase = 'Red';
      _remainingTime = 999;
      _nextPhase = 'Manual';
      _northSignal = 'Red';
      _southSignal = 'Red';
      _eastSignal = 'Red';
      _westSignal = 'Red';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All-stop activated - All signals set to RED'),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handlePriorityRoute() {
    HapticFeedback.heavyImpact();

    setState(() {
      _currentPhase = 'Green';
      _remainingTime = 120;
      _nextPhase = 'Priority';
      _northSignal = 'Green';
      _southSignal = 'Green';
      _eastSignal = 'Red';
      _westSignal = 'Red';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Priority route activated for emergency vehicles'),
        backgroundColor: const Color(0xFFFF6B35),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleMaintenanceToggle() {
    HapticFeedback.lightImpact();

    setState(() {
      _isMaintenanceMode = !_isMaintenanceMode;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isMaintenanceMode
              ? 'Maintenance mode enabled - Timing controls unlocked'
              : 'Maintenance mode disabled - Automatic timing restored',
        ),
        backgroundColor: _isMaintenanceMode
            ? const Color(0xFFFFA726)
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleDurationChanged(String phase, int duration) {
    setState(() {
      switch (phase.toLowerCase()) {
        case 'green':
          _greenDuration = duration;
          break;
        case 'yellow':
          _yellowDuration = duration;
          break;
        case 'red':
          _redDuration = duration;
          break;
      }
    });
  }
}
