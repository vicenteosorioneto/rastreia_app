import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/auth/presentation/screens/register_page.dart';
import '../../features/auth/presentation/screens/verification_page.dart';
import '../../features/tracked_objects/presentation/screens/tracked_objects_screen.dart';
import '../../features/tracked_objects/presentation/screens/all_objects_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String home = '/home';
  static const String allObjects = '/all-objects';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      verification: (context) =>
          const VerificationPage(email: '', password: ''),
      home: (context) => const TrackedObjectsScreen(),
      allObjects: (context) => const AllObjectsScreen(),
    };
  }
}
