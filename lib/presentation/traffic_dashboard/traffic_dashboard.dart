import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/emergency_override_modal.dart';
import './widgets/incident_card.dart';
import './widgets/traffic_heatmap.dart';
import './widgets/traffic_metrics_card.dart';

/// Traffic Dashboard screen for comprehensive real-time traffic monitoring
class TrafficDashboard extends StatefulWidget {
  const TrafficDashboard({super.key});

  @override
  State<TrafficDashboard> createState() => _TrafficDashboardState();
}

class _TrafficDashboardState extends State<TrafficDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isOffline = false;
  DateTime _lastUpdated = DateTime.now();

  // Mock data for dashboard metrics
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "Active Junctions",
      "value": "24",
      "unit": "",
      "iconName": "traffic",
      "trend": "stable",
      "trendValue": "0%",
      "isAlert": false,
    },
    {
      "title": "Current Incidents",
      "value": "3",
      "unit": "",
      "iconName": "warning",
      "trend": "up",
      "trendValue": "+2",
      "isAlert": true,
    },
    {
      "title": "Emergency Vehicles",
      "value": "5",
      "unit": "",
      "iconName": "local_hospital",
      "trend": "up",
      "trendValue": "+3",
      "isAlert": true,
    },
    {
      "title": "Average Flow Rate",
      "value": "1,247",
      "unit": "vph",
      "iconName": "speed",
      "trend": "down",
      "trendValue": "-5%",
      "isAlert": false,
    },
  ];

  // Mock incidents data
  final List<Map<String, dynamic>> _incidentsData = [
    {
      "id": "INC001",
      "priority": "critical",
      "type": "accident",
      "location": "Main St & 5th Ave",
      "description":
          "Multi-vehicle collision blocking two lanes. Emergency services on scene.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "status": "active",
      "emergencyVehicles": 3,
    },
    {
      "id": "INC002",
      "priority": "high",
      "type": "construction",
      "location": "Broadway & Central",
      "description":
          "Emergency road repair causing significant delays during peak hours.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "investigating",
      "emergencyVehicles": 0,
    },
    {
      "id": "INC003",
      "priority": "medium",
      "type": "congestion",
      "location": "Park Ave & 12th St",
      "description": "Heavy traffic congestion due to signal timing issues.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 45)),
      "status": "active",
      "emergencyVehicles": 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeDashboard() async {
    setState(() => _isLoading = true);

    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();

    setState(() => _isLoading = true);

    // Simulate refresh
    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  void _showEmergencyOverride() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmergencyOverrideModal(
        onActivate: (junctionId, action) {
          Navigator.pop(context);
          _handleEmergencyActivation(junctionId, action);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _handleEmergencyActivation(String junctionId, String action) {
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Emergency override activated for $junctionId',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Control',
          textColor: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, '/signal-control-panel'),
        ),
      ),
    );
  }

  void _handleJunctionTap(Map<String, dynamic> junction) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildJunctionBottomSheet(junction),
    );
  }

  void _handleJunctionLongPress(Map<String, dynamic> junction) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildJunctionContextMenu(junction),
    );
  }

  void _handleIncidentDismiss(String incidentId) {
    setState(() {
      _incidentsData.removeWhere((incident) => incident["id"] == incidentId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Incident marked as resolved'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Restore incident logic would go here
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Traffic Control',
        variant: CustomAppBarVariant.dashboard,
        statusText: _isOffline ? 'Offline Mode' : 'Live Data',
        statusColor: _isOffline ? AppTheme.warningLight : AppTheme.successLight,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/traffic-analytics'),
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: colorScheme.onPrimary,
              size: 6.w,
            ),
            tooltip: 'Analytics',
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // City status header
            SliverToBoxAdapter(
              child: _buildCityStatusHeader(theme, colorScheme),
            ),

            // Metrics cards
            SliverToBoxAdapter(
              child: _buildMetricsSection(theme, colorScheme),
            ),

            // Traffic heatmap
            SliverToBoxAdapter(
              child: _buildHeatmapSection(theme, colorScheme),
            ),

            // Incidents section
            SliverToBoxAdapter(
              child: _buildIncidentsSection(theme, colorScheme),
            ),

            // Bottom padding for FAB
            SliverToBoxAdapter(
              child: SizedBox(height: 20.h),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildEmergencyFAB(colorScheme),
      bottomNavigationBar: const CustomBottomBar(
        currentRoute: '/traffic-dashboard',
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildCityStatusHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metro City Traffic',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last updated: ${_formatLastUpdated()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.errorLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'notifications_active',
                  color: AppTheme.errorLight,
                  size: 6.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  '${_incidentsData.length}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.errorLight,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'Alerts',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 2.h,
            children: _metricsData
                .map((metric) => TrafficMetricsCard(
                      title: metric["title"],
                      value: metric["value"],
                      unit: metric["unit"],
                      iconName: metric["iconName"],
                      trend: metric["trend"],
                      trendValue: metric["trendValue"],
                      isAlert: metric["isAlert"],
                      onTap: () => _handleMetricTap(metric["title"]),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Traffic Heatmap',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/traffic-analytics'),
                icon: CustomIconWidget(
                  iconName: 'fullscreen',
                  color: colorScheme.primary,
                  size: 4.w,
                ),
                label: Text(
                  'Full View',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          TrafficHeatmap(
            onJunctionTap: _handleJunctionTap,
            onJunctionLongPress: _handleJunctionLongPress,
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentsSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Incidents',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/traffic-analytics'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _incidentsData.isEmpty
              ? _buildEmptyIncidents(theme, colorScheme)
              : SizedBox(
                  height: 25.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(bottom: 2.h),
                    itemCount: _incidentsData.length,
                    itemBuilder: (context, index) {
                      final incident = _incidentsData[index];
                      return IncidentCard(
                        incident: incident,
                        onTap: () => _handleIncidentTap(incident),
                        onDismiss: () => _handleIncidentDismiss(incident["id"]),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyIncidents(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppTheme.successLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.successLight,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'All Clear!',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.successLight,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'No active incidents reported',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyFAB(ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: _showEmergencyOverride,
      backgroundColor: AppTheme.errorLight,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: CustomIconWidget(
        iconName: 'emergency',
        color: Colors.white,
        size: 5.w,
      ),
      label: Text(
        'Emergency',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildJunctionBottomSheet(Map<String, dynamic> junction) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  junction["name"],
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        colorScheme,
                        'videocam',
                        'View Cameras',
                        () => Navigator.pushNamed(context, '/live-camera-feed'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildQuickAction(
                        colorScheme,
                        'traffic',
                        'Control Signals',
                        () => Navigator.pushNamed(
                            context, '/signal-control-panel'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        colorScheme,
                        'analytics',
                        'View Analytics',
                        () =>
                            Navigator.pushNamed(context, '/traffic-analytics'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildQuickAction(
                        colorScheme,
                        'emergency',
                        'Emergency',
                        () {
                          Navigator.pop(context);
                          _showEmergencyOverride();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJunctionContextMenu(Map<String, dynamic> junction) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: [
                Text(
                  'Junction Controls',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                _buildContextMenuItem(
                  colorScheme,
                  'route',
                  'Set Priority Route',
                  () => Navigator.pop(context),
                ),
                _buildContextMenuItem(
                  colorScheme,
                  'history',
                  'View History',
                  () => Navigator.pop(context),
                ),
                _buildContextMenuItem(
                  colorScheme,
                  'settings',
                  'Manual Override',
                  () {
                    Navigator.pop(context);
                    _showEmergencyOverride();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    ColorScheme colorScheme,
    String iconName,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
        foregroundColor: colorScheme.primary,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: colorScheme.primary,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContextMenuItem(
    ColorScheme colorScheme,
    String iconName,
    String label,
    VoidCallback onPressed,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        size: 5.w,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _handleMetricTap(String metricTitle) {
    switch (metricTitle.toLowerCase()) {
      case 'active junctions':
        Navigator.pushNamed(context, '/traffic-analytics');
        break;
      case 'current incidents':
        Navigator.pushNamed(context, '/traffic-analytics');
        break;
      case 'emergency vehicles':
        Navigator.pushNamed(context, '/live-camera-feed');
        break;
      case 'average flow rate':
        Navigator.pushNamed(context, '/traffic-analytics');
        break;
    }
  }

  void _handleIncidentTap(Map<String, dynamic> incident) {
    Navigator.pushNamed(context, '/live-camera-feed');
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}
