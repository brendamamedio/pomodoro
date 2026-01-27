import 'package:flutter/material.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/tasks/tasks_management_screen.dart';
import '../presentation/focus/focus_screen.dart';
import '../presentation/stats/stats_screen.dart';
import '../presentation/settings/settings_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String tasks = '/tasks';
  static const String focus = '/focus';
  static const String statistics = '/statistics';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      onboarding: (context) => const OnboardingScreen(),
      tasks: (context) => const TasksManagementScreen(),
      focus: (context) => const FocusScreen(),
      statistics: (context) => const StatsScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}