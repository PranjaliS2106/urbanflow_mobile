import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/heatmap_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/predictive_insights_widget.dart';
import './widgets/time_series_chart_widget.dart';
import './widgets/vehicle_classification_chart_widget.dart';
import 'widgets/filter_bottom_sheet_widget.dart';
import 'widgets/heatmap_widget.dart';
import 'widgets/metrics_card_widget.dart';
import 'widgets/predictive_insights_widget.dart';
import 'widgets/time_series_chart_widget.dart';
import 'widgets/vehicle_classification_chart_widget.dart';

class TrafficAnalytics extends StatefulWidget {
  const TrafficAnalytics({super.key});

  @override
  State<TrafficAnalytics> createState() => _TrafficAnalyticsState();
}

class _TrafficAnalyticsState extends State<TrafficAnalytics>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'Daily';
  Map<String, dynamic> appliedFilters = {};

  final List<TabItem> tabs = [
    const TabItem(
      label: 'Overview',
      route: '/traffic-analytics/overview',
      icon: Icons.dashboard,
    ),
    const TabItem(
      label: 'Analytics',
      route: '/traffic-analytics',
      icon: Icons.analytics,
    ),
    const TabItem(
      label: 'Reports',
      route: '/traffic-analytics/reports',
      icon: Icons.assessment,
    ),
  ];

  // Mock metrics data
  final List<Map<String, dynamic>> metricsData = [
    {
      'title': 'Daily Vehicle Count',
      'value': '24,580',
      'unit': 'vehicles',
      'trend': '+12.5%',
      'isPositive': true,
      'icon': Icons.directions_car,
    },
    {
      'title': 'Average Speed',
      'value': '42.3',
      'unit': 'km/h',
      'trend': '+3.2%',
      'isPositive': true,
      'icon': Icons.speed,
    },
    {
      'title': 'Peak Hour Congestion',
      'value': '78%',
      'unit': 'density',
      'trend': '-5.8%',
      'isPositive': false,
      'icon': Icons.traffic,
    },
    {
      'title': 'Efficiency Rating',
      'value': '8.7',
      'unit': '/10',
      'trend': '+0.9',
      'isPositive': true,
      'icon': Icons.trending_up,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const CustomAppBar(
        title: 'Traffic Analytics',
        variant: CustomAppBarVariant.dashboard,
        statusText: 'Real-time Data',
        statusColor: AppTheme.successLight,
      ),
      body: Column(
        children: [
          // Sticky header with tabs and date selector
          Container(
            color: colorScheme.surface,
            child: Column(
              children: [
                CustomTabBar(
                  tabs: tabs,
                  currentRoute: '/traffic-analytics',
                  variant: CustomTabBarVariant.standard,
                  onTap: _handleTabNavigation,
                ),
                _buildDateRangeHeader(context),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  _buildMetricsSection(context),
                  TimeSeriesChartWidget(
                    selectedPeriod: selectedPeriod,
                    onPeriodChanged: (period) {
                      setState(() {
                        selectedPeriod = period;
                      });
                    },
                  ),
                  const HeatmapWidget(),
                  const VehicleClassificationChartWidget(),
                  const PredictiveInsightsWidget(),
                  SizedBox(height: 10.h), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentRoute: '/traffic-analytics',
        variant: CustomBottomBarVariant.standard,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFilterBottomSheet,
        icon: CustomIconWidget(
          iconName: 'filter_list',
          color: colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'Filters',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDateRangeHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Range',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Sep 07 - Sep 14, 2025',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _exportData,
                icon: CustomIconWidget(
                  iconName: 'file_download',
                  color: colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Export Data',
              ),
              IconButton(
                onPressed: _refreshData,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Refresh Data',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(BuildContext context) {
    return Container(
      height: 20.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: metricsData.length,
        itemBuilder: (context, index) {
          final metric = metricsData[index];
          return MetricsCardWidget(
            title: metric['title'] as String,
            value: metric['value'] as String,
            unit: metric['unit'] as String,
            trend: metric['trend'] as String,
            isPositive: metric['isPositive'] as bool,
            icon: metric['icon'] as IconData,
          );
        },
      ),
    );
  }

  void _handleTabNavigation(String route) {
    if (route != '/traffic-analytics') {
      Navigator.pushNamed(context, route);
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => FilterBottomSheetWidget(
          onFiltersApplied: (filters) {
            setState(() {
              appliedFilters = filters;
            });
            _showFilterAppliedSnackBar();
          },
        ),
      ),
    );
  }

  void _exportData() {
    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Analytics data exported successfully',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to exported files or show download location
          },
        ),
      ),
    );
  }

  void _refreshData() {
    // Mock refresh functionality with loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'Refreshing analytics data...',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // Simulate data refresh
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Data refreshed successfully',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });
  }

  void _showFilterAppliedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.successLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Filters applied successfully',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Clear',
          onPressed: () {
            setState(() {
              appliedFilters.clear();
            });
          },
        ),
      ),
    );
  }
}