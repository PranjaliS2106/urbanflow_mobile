import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar variants for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and actions
  standard,

  /// Dashboard app bar with status indicators
  dashboard,

  /// Emergency app bar with priority styling
  emergency,

  /// Minimal app bar for focused tasks
  minimal,
}

/// Production-ready custom app bar for smart city traffic management
/// Implements professional credibility with immediate visual clarity
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a custom app bar with specified variant and configuration
  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
    this.statusText,
    this.statusColor,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The title text displayed in the app bar
  final String title;

  /// The visual variant of the app bar
  final CustomAppBarVariant variant;

  /// Whether to show the back button (when applicable)
  final bool showBackButton;

  /// Action widgets displayed on the right side
  final List<Widget>? actions;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// Status text for dashboard variant
  final String? statusText;

  /// Status color for dashboard variant
  final Color? statusColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom elevation override
  final double? elevation;

  /// Custom background color override
  final Color? backgroundColor;

  /// Custom foreground color override
  final Color? foregroundColor;

  @override
  Size get preferredSize => Size.fromHeight(_getAppBarHeight());

  double _getAppBarHeight() {
    switch (variant) {
      case CustomAppBarVariant.dashboard:
        return 72.0; // Extra height for status indicators
      case CustomAppBarVariant.emergency:
        return 64.0; // Standard height with emergency styling
      case CustomAppBarVariant.minimal:
        return 56.0; // Compact height
      case CustomAppBarVariant.standard:
      default:
        return 64.0; // Standard height
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: _buildTitle(context, theme, isDark),
      centerTitle: centerTitle,
      elevation: elevation ?? _getElevation(),
      backgroundColor:
          backgroundColor ?? _getBackgroundColor(colorScheme, isDark),
      foregroundColor:
          foregroundColor ?? _getForegroundColor(colorScheme, isDark),
      systemOverlayStyle: _getSystemOverlayStyle(isDark),
      leading: _buildLeading(context, theme),
      actions: _buildActions(context, theme),
      flexibleSpace: variant == CustomAppBarVariant.dashboard
          ? _buildDashboardFlexibleSpace(context, theme, isDark)
          : null,
      toolbarHeight: variant == CustomAppBarVariant.dashboard ? 72.0 : null,
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme, bool isDark) {
    switch (variant) {
      case CustomAppBarVariant.emergency:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _getForegroundColor(theme.colorScheme, isDark),
              ),
            ),
          ],
        );

      case CustomAppBarVariant.minimal:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _getForegroundColor(theme.colorScheme, isDark),
          ),
        );

      case CustomAppBarVariant.dashboard:
        return Column(
          crossAxisAlignment: centerTitle
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _getForegroundColor(theme.colorScheme, isDark),
              ),
            ),
            if (statusText != null) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor ?? theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: _getForegroundColor(theme.colorScheme, isDark)
                          .withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );

      case CustomAppBarVariant.standard:
      default:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _getForegroundColor(theme.colorScheme, isDark),
          ),
        );
    }
  }

  Widget? _buildLeading(BuildContext context, ThemeData theme) {
    if (!showBackButton) return null;

    final canPop = ModalRoute.of(context)?.canPop ?? false;
    if (!canPop) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  List<Widget>? _buildActions(BuildContext context, ThemeData theme) {
    final defaultActions = <Widget>[];

    // Add emergency button for emergency variant
    if (variant == CustomAppBarVariant.emergency) {
      defaultActions.add(
        IconButton(
          icon: const Icon(Icons.emergency),
          onPressed: () => _handleEmergencyAction(context),
          tooltip: 'Emergency Override',
        ),
      );
    }

    // Add notification button for dashboard variant
    if (variant == CustomAppBarVariant.dashboard) {
      defaultActions.add(
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _handleNotificationAction(context),
          tooltip: 'Notifications',
        ),
      );
    }

    // Combine with custom actions
    final List<Widget> allActions = [...defaultActions, ...(actions ?? [])];
    return allActions.isNotEmpty ? allActions : null;
  }

  Widget? _buildDashboardFlexibleSpace(
      BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getBackgroundColor(theme.colorScheme, isDark),
            _getBackgroundColor(theme.colorScheme, isDark)
                .withValues(alpha: 0.95),
          ],
        ),
      ),
    );
  }

  double _getElevation() {
    switch (variant) {
      case CustomAppBarVariant.emergency:
        return 8.0; // Higher elevation for emergency
      case CustomAppBarVariant.minimal:
        return 2.0; // Minimal elevation
      case CustomAppBarVariant.dashboard:
        return 4.0; // Standard elevation with gradient
      case CustomAppBarVariant.standard:
      default:
        return 4.0; // Standard elevation
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isDark) {
    switch (variant) {
      case CustomAppBarVariant.emergency:
        return colorScheme.error;
      case CustomAppBarVariant.minimal:
        return colorScheme.surface;
      case CustomAppBarVariant.dashboard:
      case CustomAppBarVariant.standard:
      default:
        return colorScheme.primary;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme, bool isDark) {
    switch (variant) {
      case CustomAppBarVariant.emergency:
        return colorScheme.onError;
      case CustomAppBarVariant.minimal:
        return colorScheme.onSurface;
      case CustomAppBarVariant.dashboard:
      case CustomAppBarVariant.standard:
      default:
        return colorScheme.onPrimary;
    }
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(bool isDark) {
    switch (variant) {
      case CustomAppBarVariant.emergency:
        return SystemUiOverlayStyle.light; // Always light for emergency
      case CustomAppBarVariant.minimal:
        return isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
      case CustomAppBarVariant.dashboard:
      case CustomAppBarVariant.standard:
      default:
        return SystemUiOverlayStyle.light; // Light for primary background
    }
  }

  void _handleEmergencyAction(BuildContext context) {
    // Navigate to emergency override or show emergency modal
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Emergency Override',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Activate emergency traffic control protocols?',
              style: GoogleFonts.inter(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/signal-control-panel');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Activate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleNotificationAction(BuildContext context) {
    // Show notifications or navigate to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No new notifications',
          style: GoogleFonts.inter(),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}