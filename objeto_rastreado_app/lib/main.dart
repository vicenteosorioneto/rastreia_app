import 'package:flutter/material.dart';
import 'features/auth/login_page.dart';

void main() {
  runApp(const RastreiaApp());
}

class RastreiaApp extends StatelessWidget {
  const RastreiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rastreia App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
