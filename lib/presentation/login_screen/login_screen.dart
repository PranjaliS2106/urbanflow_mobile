import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/traffic_logo_widget.dart';
import './widgets/two_factor_auth_widget.dart';
import 'widgets/biometric_auth_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/traffic_logo_widget.dart';
import 'widgets/two_factor_auth_widget.dart';

/// Login screen for traffic management personnel authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables
  bool _isLoading = false;
  bool _showBiometric = false;
  bool _showTwoFactor = false;
  String? _employeeIdError;
  String? _passwordError;
  String? _generalError;
  int _loginAttempts = 0;

  // Mock credentials for different user types
  final Map<String, Map<String, dynamic>> _mockCredentials = {
    '12345678': {
      'password': 'Admin@2024',
      'role': 'Traffic Control Operator',
      'name': 'Sarah Johnson',
      'requiresTwoFactor': true,
    },
    '87654321': {
      'password': 'Field@2024',
      'role': 'Field Operations Manager',
      'name': 'Michael Rodriguez',
      'requiresTwoFactor': false,
    },
    '11223344': {
      'password': 'Emergency@2024',
      'role': 'Emergency Response Coordinator',
      'name': 'Emily Chen',
      'requiresTwoFactor': true,
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideAnimationController.forward();
      }
    });
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showBiometric = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            _buildMainContent(theme, colorScheme),

            // Two-factor authentication modal
            if (_showTwoFactor) _buildTwoFactorModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 4.h),

            // Logo section
            FadeTransition(
              opacity: _fadeAnimation,
              child: const TrafficLogoWidget(),
            ),

            SizedBox(height: 6.h),

            // Login form
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildLoginForm(theme, colorScheme),
              ),
            ),

            SizedBox(height: 4.h),

            // Biometric authentication
            if (_showBiometric)
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: BiometricAuthWidget(
                    onBiometricAuth: _handleBiometricAuth,
                    isLoading: _isLoading,
                  ),
                ),
              ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome text
          Text(
            'Welcome Back',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Sign in to access traffic management system',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          SizedBox(height: 4.h),

          // General error message
          if (_generalError != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'error',
                    color: colorScheme.error,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      _generalError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // Login form fields
          LoginFormWidget(
            employeeIdController: _employeeIdController,
            passwordController: _passwordController,
            onEmployeeIdChanged: _onEmployeeIdChanged,
            onPasswordChanged: _onPasswordChanged,
            employeeIdError: _employeeIdError,
            passwordError: _passwordError,
            isLoading: _isLoading,
          ),

          SizedBox(height: 3.h),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading ? null : _handleForgotPassword,
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Sign in button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canSignIn() ? _handleSignIn : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                elevation: _isLoading ? 0 : 2,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Sign In',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 3.h),

          // Security notice
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: colorScheme.primary,
                  size: 4.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Secure government network connection with certificate pinning',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorModal() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TwoFactorAuthWidget(
            onCodeSubmit: _handleTwoFactorCode,
            onResendCode: _handleResendTwoFactorCode,
            isLoading: _isLoading,
          ),
        ),
      ),
    );
  }

  void _onEmployeeIdChanged(String value) {
    setState(() {
      _employeeIdError = _validateEmployeeId(value);
      _generalError = null;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordError = _validatePassword(value);
      _generalError = null;
    });
  }

  String? _validateEmployeeId(String value) {
    if (value.isEmpty) {
      return 'Employee ID is required';
    }
    if (value.length < 8) {
      return 'Employee ID must be 8 digits';
    }
    if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return 'Employee ID must contain only numbers';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
        .hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }

  bool _canSignIn() {
    return !_isLoading &&
        _employeeIdController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _employeeIdError == null &&
        _passwordError == null;
  }

  void _handleSignIn() async {
    if (!_canSignIn()) return;

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final employeeId = _employeeIdController.text;
    final password = _passwordController.text;

    // Check credentials
    final credentials = _mockCredentials[employeeId];

    if (credentials == null || credentials['password'] != password) {
      setState(() {
        _isLoading = false;
        _loginAttempts++;

        if (_loginAttempts >= 3) {
          _generalError =
              'Account temporarily locked due to multiple failed attempts. Please try again in 30 minutes.';
        } else {
          _generalError =
              'Invalid employee ID or password. Please check your credentials and try again.';
        }
      });

      // Haptic feedback for error
      HapticFeedback.mediumImpact();
      return;
    }

    // Check if two-factor authentication is required
    if (credentials['requiresTwoFactor'] == true) {
      setState(() {
        _isLoading = false;
        _showTwoFactor = true;
      });
      return;
    }

    // Success - navigate to dashboard
    _handleSuccessfulLogin(credentials);
  }

  void _handleBiometricAuth() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful biometric authentication
    final mockCredentials = _mockCredentials['12345678']!;
    _handleSuccessfulLogin(mockCredentials);
  }

  void _handleTwoFactorCode(String code) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate two-factor verification
    await Future.delayed(const Duration(seconds: 2));

    if (code == '123456') {
      // Success
      final employeeId = _employeeIdController.text;
      final credentials = _mockCredentials[employeeId]!;
      _handleSuccessfulLogin(credentials);
    } else {
      setState(() {
        _isLoading = false;
        _generalError = 'Invalid verification code. Please try again.';
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _handleResendTwoFactorCode() {
    // Simulate resending code
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Verification code sent to your registered device',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleSuccessfulLogin(Map<String, dynamic> credentials) {
    // Success haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = false;
      _showTwoFactor = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome back, ${credentials['name']}!',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to traffic dashboard
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/traffic-dashboard',
          (route) => false,
        );
      }
    });
  }

  void _handleForgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildForgotPasswordModal(),
    );
  }

  Widget _buildForgotPasswordModal() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),

          SizedBox(height: 3.h),

          // Icon
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'help_outline',
                color: colorScheme.primary,
                size: 8.w,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            'Password Recovery',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'For security reasons, password reset must be requested through your system administrator or IT support team.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Contact IT Support'),
            ),
          ),

          SizedBox(height: 2.h),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}