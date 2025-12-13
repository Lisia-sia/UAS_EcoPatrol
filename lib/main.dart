import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_ecopatrol/Mahasiswa1/login_screen.dart';
import 'package:project_ecopatrol/Mahasiswa3/dashboard_screen.dart';
import 'package:project_ecopatrol/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'EcoPatrol',
      theme: ThemeData(primarySwatch: Colors.green),
      home: authState.isLoggedIn
          ? const DashboardScreen()
          : LoginScreen(),
    );
  }
}