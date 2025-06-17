import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/firebase_options.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/tracked_object_provider.dart';
import 'core/services/tracked_object_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/tracked_objects/presentation/screens/tracked_objects_screen.dart';
import 'features/tracked_objects/presentation/screens/all_objects_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('Error during app initialization: $e');
    print('Stack trace: $stackTrace');
    // Show error UI instead of blank screen
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Erro ao inicializar o app: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TrackedObjectProvider>(
          create: (context) => TrackedObjectProvider(TrackedObjectService()),
          update: (context, auth, previous) =>
              TrackedObjectProvider(TrackedObjectService()),
        ),
      ],
      child: MaterialApp(
        title: 'Rastreia App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/objects': (context) => const TrackedObjectsScreen(),
          '/all-objects': (context) => const AllObjectsScreen(),
        },
      ),
    );
  }
}
