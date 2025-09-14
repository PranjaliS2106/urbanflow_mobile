import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Splash screen for UrbanFlow Mobile traffic management application
/// Provides branded launch experience while initializing critical services
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _textSlideAnimation;

  String _statusText = 'Initializing UrbanFlow...';
  bool _showRetryButton = false;
  bool _isInitializing = true;

  // Mock initialization states
  final List<Map<String, dynamic>> _initializationSteps = [
    {
      'text': 'Connecting to Traffic Network...',
      'duration': 800,
      'progress': 0.2,
    },
    {
      'text': 'Loading Junction Configurations...',
      'duration': 600,
      'progress': 0.4,
    },
    {
      'text': 'Fetching Emergency Protocols...',
      'duration': 700,
      'progress': 0.6,
    },
    {
      'text': 'Preparing Traffic Data Cache...',
      'duration': 500,
      'progress': 0.8,
    },
    {
      'text': 'Finalizing System Setup...',
      'duration': 400,
      'progress': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation controller
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Logo scale animation with pulse effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo opacity animation
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Start progress animation
      _progressAnimationController.forward();

      // Simulate initialization steps
      for (int i = 0; i < _initializationSteps.length; i++) {
        final step = _initializationSteps[i];

        if (mounted) {
          setState(() {
            _statusText = step['text'] as String;
          });
        }

        // Simulate network delay and processing time
        await Future.delayed(Duration(milliseconds: step['duration'] as int));

        // Check for timeout simulation (5% chance)
        if (i == 0 && DateTime.now().millisecond % 20 == 0) {
          await _handleTimeout();
          return;
        }
      }

      // Initialization complete
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _statusText = 'System Ready';
          _isInitializing = false;
        });
      }

      // Navigate to appropriate screen based on authentication status
      await Future.delayed(const Duration(milliseconds: 800));
      _navigateToNextScreen();
    } catch (e) {
      await _handleTimeout();
    }
  }

  Future<void> _handleTimeout() async {
    if (mounted) {
      setState(() {
        _statusText = 'Connection timeout. Please check your network.';
        _showRetryButton = true;
        _isInitializing = false;
      });
    }

    // Auto-retry after 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    if (mounted && _showRetryButton) {
      _retryConnection();
    }
  }

  void _retryConnection() {
    setState(() {
      _statusText = 'Retrying connection...';
      _showRetryButton = false;
      _isInitializing = true;
    });

    // Reset progress animation
    _progressAnimationController.reset();
    _startInitialization();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // Mock authentication check
    final isAuthenticated = _checkAuthenticationStatus();
    final isNewUser = _checkNewUserStatus();

    String nextRoute;
    if (isAuthenticated) {
      nextRoute = '/traffic-dashboard';
    } else if (isNewUser) {
      // For new users, we'll go to login for now since onboarding isn't specified
      nextRoute = '/login-screen';
    } else {
      nextRoute = '/login-screen';
    }

    // Smooth fade transition
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check - in real app, check stored tokens
    // For demo purposes, randomly return true/false
    return DateTime.now().millisecond % 3 == 0;
  }

  bool _checkNewUserStatus() {
    // Mock new user check - in real app, check if user has completed onboarding
    return DateTime.now().millisecond % 4 == 0;
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacer
              SizedBox(height: 15.h),

              // Logo section
              Expanded(
                flex: 3,
                child: _buildLogoSection(),
              ),

              // Status and progress section
              Expanded(
                flex: 2,
                child: _buildStatusSection(),
              ),

              // Bottom spacer
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoOpacityAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo container with pulse effect
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'traffic',
                      color: Colors.white,
                      size: 12.w,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // App name with slide animation
                SlideTransition(
                  position: _textSlideAnimation,
                  child: Column(
                    children: [
                      Text(
                        'UrbanFlow',
                        style: AppTheme.lightTheme.textTheme.headlineLarge
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Smart Traffic Management',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14.sp,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress indicator
          if (_isInitializing) ...[
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Container(
                  width: 60.w,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
          ],

          // Status text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _statusText,
              key: ValueKey(_statusText),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 3.h),

          // Retry button
          if (_showRetryButton)
            AnimatedOpacity(
              opacity: _showRetryButton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: _retryConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.lightTheme.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 1.5.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Retry Connection',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Loading indicator for active initialization
          if (_isInitializing && !_showRetryButton) ...[
            SizedBox(height: 2.h),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
