import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- JANGAN LUPA TAMBAH INI
import 'providers.dart';
import 'login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // --- BAGIAN INI YANG DIGANTI (Supaya nama Jihan muncul) ---
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                // Ambil nama dari memori, kalau kosong defaultnya "Warga"
                final username = snapshot.data?.getString('username') ?? "Warga EcoPatrol";

                return ListTile(
                  leading: const Icon(Icons.person, size: 50, color: Colors.green),
                  title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: const Text("Status: Sedang Login"),
                );
              },
            ),
            // -----------------------------------------------------------

            const Divider(),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("LOGOUT", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}