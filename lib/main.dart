import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import Lintas Folder
import 'Mahasiswa 1/login_screen.dart';
import 'Mahasiswa3/dashboard_screen.dart';
import 'Mahasiswa 1/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider);
    return MaterialApp(
      title: 'EcoPatrol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}