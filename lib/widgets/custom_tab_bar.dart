import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab bar variants for different dashboard contexts
enum CustomTabBarVariant {
  /// Standard tabs for main dashboard sections
  standard,

  /// Compact tabs for limited space
  compact,

  /// Scrollable tabs for many options
  scrollable,

  /// Segmented control style for binary choices
  segmented,
}

/// Tab item data structure
class TabItem {
  const TabItem({
    required this.label,
    required this.route,
    this.icon,
    this.badge,
    this.enabled = true,
  });

  final String label;
  final String route;
  final IconData? icon;
  final String? badge;
  final bool enabled;
}

/// Production-ready custom tab bar for traffic management dashboards
/// Implements adaptive information density for optimal data presentation
class CustomTabBar extends StatelessWidget {
  /// Creates a custom tab bar with specified variant and configuration
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentRoute,
    this.variant = CustomTabBarVariant.standard,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable,
  });

  /// List of tab items to display
  final List<TabItem> tabs;

  /// Current active route path
  final String currentRoute;

  /// Visual variant of the tab bar
  final CustomTabBarVariant variant;

  /// Callback when tab is tapped
  final Function(String route)? onTap;

  /// Custom background color override
  final Color? backgroundColor;

  /// Custom selected tab color override
  final Color? selectedColor;

  /// Custom unselected tab color override
  final Color? unselectedColor;

  /// Custom indicator color override
  final Color? indicatorColor;

  /// Whether tabs should be scrollable
  final bool? isScrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = _getCurrentIndex();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? _getBackgroundColor(colorScheme, isDark),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: _buildTabBar(context, theme, currentIndex),
    );
  }

  Widget _buildTabBar(BuildContext context, ThemeData theme, int currentIndex) {
    switch (variant) {
      case CustomTabBarVariant.segmented:
        return _buildSegmentedControl(context, theme, currentIndex);
      case CustomTabBarVariant.compact:
      case CustomTabBarVariant.scrollable:
      case CustomTabBarVariant.standard:
      default:
        return _buildStandardTabBar(context, theme, currentIndex);
    }
  }

  Widget _buildStandardTabBar(
      BuildContext context, ThemeData theme, int currentIndex) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: tabs.length,
      initialIndex: currentIndex,
      child: TabBar(
        tabs: tabs.map((tab) => _buildTab(context, theme, tab)).toList(),
        isScrollable: isScrollable ?? _getIsScrollable(),
        labelColor: selectedColor ?? _getSelectedColor(colorScheme, isDark),
        unselectedLabelColor:
            unselectedColor ?? _getUnselectedColor(colorScheme, isDark),
        indicatorColor:
            indicatorColor ?? _getIndicatorColor(colorScheme, isDark),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: _getLabelFontSize(),
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: _getLabelFontSize(),
          fontWeight: FontWeight.w400,
        ),
        onTap: (index) => _handleTap(context, tabs[index].route),
        padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding()),
        tabAlignment: _getTabAlignment(),
      ),
    );
  }

  Widget _buildSegmentedControl(
      BuildContext context, ThemeData theme, int currentIndex) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: _buildSegmentedTab(
              context,
              theme,
              tab,
              isSelected,
              isFirst,
              isLast,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTab(BuildContext context, ThemeData theme, TabItem tab) {
    final hasIcon = tab.icon != null;
    final hasBadge = tab.badge != null;

    return Tab(
      height: _getTabHeight(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getTabPadding(),
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon) ...[
              Icon(
                tab.icon,
                size: _getIconSize(),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                tab.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (hasBadge) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tab.badge!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onError,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTab(
    BuildContext context,
    ThemeData theme,
    TabItem tab,
    bool isSelected,
    bool isFirst,
    bool isLast,
  ) {
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: tab.enabled ? () => _handleTap(context, tab.route) : null,
      borderRadius: BorderRadius.horizontal(
        left: isFirst ? const Radius.circular(7) : Radius.zero,
        right: isLast ? const Radius.circular(7) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(7) : Radius.zero,
            right: isLast ? const Radius.circular(7) : Radius.zero,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: 16,
                color:
                    isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                tab.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (tab.badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tab.badge!,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onError,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getCurrentIndex() {
    for (int i = 0; i < tabs.length; i++) {
      if (tabs[i].route == currentRoute) {
        return i;
      }
    }
    return 0; // Default to first tab if route not found
  }

  bool _getIsScrollable() {
    switch (variant) {
      case CustomTabBarVariant.scrollable:
        return true;
      case CustomTabBarVariant.compact:
        return tabs.length > 4;
      case CustomTabBarVariant.segmented:
      case CustomTabBarVariant.standard:
      default:
        return tabs.length > 3;
    }
  }

  double _getTabHeight() {
    switch (variant) {
      case CustomTabBarVariant.compact:
        return 40;
      case CustomTabBarVariant.scrollable:
      case CustomTabBarVariant.standard:
      default:
        return 48;
    }
  }

  double _getTabPadding() {
    switch (variant) {
      case CustomTabBarVariant.compact:
        return 8;
      case CustomTabBarVariant.scrollable:
      case CustomTabBarVariant.standard:
      default:
        return 16;
    }
  }

  double _getHorizontalPadding() {
    switch (variant) {
      case CustomTabBarVariant.compact:
        return 8;
      case CustomTabBarVariant.scrollable:
      case CustomTabBarVariant.standard:
      default:
        return 16;
    }
  }

  double _getLabelFontSize() {
    switch (variant) {
      case CustomTabBarVariant.compact:
        return 12;
      case CustomTabBarVariant.scrollable:
      case CustomTabBarVariant.standard:
      default:
        return 14;
    }
  }

  double _getIconSize() {
    switch (variant) {
      case CustomTabBarVariant.compact:
        return 16;
      case CustomTabBarVariant.scrollable:
      case CustomTabBarVariant.standard:
      default:
        return 20;
    }
  }

  TabAlignment _getTabAlignment() {
    switch (variant) {
      case CustomTabBarVariant.scrollable:
        return TabAlignment.start;
      case CustomTabBarVariant.compact:
      case CustomTabBarVariant.standard:
      default:
        return TabAlignment.fill;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isDark) {
    return colorScheme.surface;
  }

  Color _getSelectedColor(ColorScheme colorScheme, bool isDark) {
    return colorScheme.primary;
  }

  Color _getUnselectedColor(ColorScheme colorScheme, bool isDark) {
    return colorScheme.onSurface.withValues(alpha: 0.6);
  }

  Color _getIndicatorColor(ColorScheme colorScheme, bool isDark) {
    return colorScheme.primary;
  }

  void _handleTap(BuildContext context, String route) {
    // Call custom callback if provided
    if (onTap != null) {
      onTap!(route);
      return;
    }

    // Default navigation behavior
    if (currentRoute != route) {
      Navigator.pushNamed(context, route);
    }
  }
}
