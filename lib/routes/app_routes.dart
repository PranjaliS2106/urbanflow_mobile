import 'package:flutter/material.dart';
import '../presentation/traffic_dashboard/traffic_dashboard.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/signal_control_panel/signal_control_panel.dart';
import '../presentation/traffic_analytics/traffic_analytics.dart';
import '../presentation/live_camera_feed/live_camera_feed.dart';
import '../presentation/login_screen/login_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String trafficDashboard = '/traffic-dashboard';
  static const String splash = '/splash-screen';
  static const String signalControlPanel = '/signal-control-panel';
  static const String trafficAnalytics = '/traffic-analytics';
  static const String liveCameraFeed = '/live-camera-feed';
  static const String login = '/login-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    trafficDashboard: (context) => const TrafficDashboard(),
    splash: (context) => const SplashScreen(),
    signalControlPanel: (context) => const SignalControlPanel(),
    trafficAnalytics: (context) => const TrafficAnalytics(),
    liveCameraFeed: (context) => const LiveCameraFeed(),
    login: (context) => const LoginScreen(),
    // TODO: Add your other routes here
  };
}
