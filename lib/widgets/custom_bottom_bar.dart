import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom navigation bar variants for different operational contexts
enum CustomBottomBarVariant {
  /// Standard navigation with all main sections
  standard,

  /// Field operations with essential controls only
  field,

  /// Emergency response with priority actions
  emergency,

  /// Compact view for smaller screens
  compact,
}

/// Navigation item data structure
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.badge,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final String? badge;
}

/// Production-ready custom bottom navigation bar for traffic management
/// Optimized for one-handed mobile access during field operations
class CustomBottomBar extends StatelessWidget {
  /// Creates a custom bottom navigation bar with specified variant
  const CustomBottomBar({
    super.key,
    required this.currentRoute,
    this.variant = CustomBottomBarVariant.standard,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  /// Current active route path
  final String currentRoute;

  /// Visual variant of the bottom bar
  final CustomBottomBarVariant variant;

  /// Callback when navigation item is tapped
  final Function(String route)? onTap;

  /// Custom background color override
  final Color? backgroundColor;

  /// Custom selected item color override
  final Color? selectedItemColor;

  /// Custom unselected item color override
  final Color? unselectedItemColor;

  /// Custom elevation override
  final double? elevation;

  /// Get navigation items based on variant
  List<BottomNavItem> _getNavigationItems() {
    switch (variant) {
      case CustomBottomBarVariant.field:
        return [
          const BottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/traffic-dashboard',
          ),
          const BottomNavItem(
            icon: Icons.videocam_outlined,
            activeIcon: Icons.videocam,
            label: 'Cameras',
            route: '/live-camera-feed',
          ),
          const BottomNavItem(
            icon: Icons.traffic_outlined,
            activeIcon: Icons.traffic,
            label: 'Signals',
            route: '/signal-control-panel',
          ),
        ];

      case CustomBottomBarVariant.emergency:
        return [
          const BottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/traffic-dashboard',
          ),
          const BottomNavItem(
            icon: Icons.emergency_outlined,
            activeIcon: Icons.emergency,
            label: 'Emergency',
            route: '/signal-control-panel',
          ),
          const BottomNavItem(
            icon: Icons.videocam_outlined,
            activeIcon: Icons.videocam,
            label: 'Live Feed',
            route: '/live-camera-feed',
          ),
        ];

      case CustomBottomBarVariant.compact:
        return [
          const BottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Home',
            route: '/traffic-dashboard',
          ),
          const BottomNavItem(
            icon: Icons.traffic_outlined,
            activeIcon: Icons.traffic,
            label: 'Control',
            route: '/signal-control-panel',
          ),
          const BottomNavItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
            label: 'Data',
            route: '/traffic-analytics',
          ),
        ];

      case CustomBottomBarVariant.standard:
      default:
        return [
          const BottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/traffic-dashboard',
          ),
          const BottomNavItem(
            icon: Icons.videocam_outlined,
            activeIcon: Icons.videocam,
            label: 'Cameras',
            route: '/live-camera-feed',
          ),
          const BottomNavItem(
            icon: Icons.traffic_outlined,
            activeIcon: Icons.traffic,
            label: 'Signals',
            route: '/signal-control-panel',
          ),
          const BottomNavItem(
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
            label: 'Analytics',
            route: '/traffic-analytics',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final items = _getNavigationItems();
    final currentIndex = _getCurrentIndex(items);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? _getBackgroundColor(colorScheme, isDark),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: _getBarHeight(),
          padding: EdgeInsets.symmetric(
            horizontal: _getHorizontalPadding(),
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavigationItem(
                context,
                theme,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    ThemeData theme,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final itemColor = isSelected
        ? (selectedItemColor ?? _getSelectedColor(colorScheme, isDark))
        : (unselectedItemColor ?? _getUnselectedColor(colorScheme, isDark));

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, item.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with badge support
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      key: ValueKey(isSelected),
                      color: itemColor,
                      size: _getIconSize(),
                    ),
                  ),
                  if (item.badge != null)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          item.badge!,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onError,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),

              // Label
              const SizedBox(height: 4),
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: _getLabelFontSize(),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: itemColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Selection indicator
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 20 : 0,
                height: 2,
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex(List<BottomNavItem> items) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].route == currentRoute) {
        return i;
      }
    }
    return 0; // Default to first item if route not found
  }

  double _getBarHeight() {
    switch (variant) {
      case CustomBottomBarVariant.compact:
        return 60;
      case CustomBottomBarVariant.field:
      case CustomBottomBarVariant.emergency:
      case CustomBottomBarVariant.standard:
      default:
        return 70;
    }
  }

  double _getHorizontalPadding() {
    switch (variant) {
      case CustomBottomBarVariant.compact:
        return 8;
      case CustomBottomBarVariant.field:
      case CustomBottomBarVariant.emergency:
      case CustomBottomBarVariant.standard:
      default:
        return 16;
    }
  }

  double _getIconSize() {
    switch (variant) {
      case CustomBottomBarVariant.compact:
        return 20;
      case CustomBottomBarVariant.field:
      case CustomBottomBarVariant.emergency:
      case CustomBottomBarVariant.standard:
      default:
        return 24;
    }
  }

  double _getLabelFontSize() {
    switch (variant) {
      case CustomBottomBarVariant.compact:
        return 10;
      case CustomBottomBarVariant.field:
      case CustomBottomBarVariant.emergency:
      case CustomBottomBarVariant.standard:
      default:
        return 12;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isDark) {
    switch (variant) {
      case CustomBottomBarVariant.emergency:
        return colorScheme.errorContainer;
      case CustomBottomBarVariant.field:
      case CustomBottomBarVariant.compact:
      case CustomBottomBarVariant.standard:
      default:
        return colorScheme.surface;
    }
  }

  Color _getSelectedColor(ColorScheme colorScheme, bool isDark) {
    switch (variant) {
      case CustomBottomBarVariant.emergency:
        return colorScheme.error;
      case CustomBottomBarVariant.field:
      case CustomBottomBarVariant.compact:
      case CustomBottomBarVariant.standard:
      default:
        return colorScheme.primary;
    }
  }

  Color _getUnselectedColor(ColorScheme colorScheme, bool isDark) {
    return colorScheme.onSurface.withValues(alpha: 0.6);
  }

  void _handleTap(BuildContext context, String route) {
    // Provide haptic feedback for better mobile experience
    HapticFeedback.lightImpact();

    // Call custom callback if provided
    if (onTap != null) {
      onTap!(route);
      return;
    }

    // Default navigation behavior
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (Route<dynamic> route) => false,
      );
    }
  }
}
