import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_type.dart';
import '../../core/providers/auth_provider.dart';
import '../police/police_dashboard_page.dart';
import '../stolen_items/citizen_register_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.userType == UserType.policial) {
      return const PoliceDashboardPage();
    }

    return const CitizenRegisterPage();
  }
}
