import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import '../Mahasiswa3/dashboard_screen.dart'; // Sesuaikan path jika perlu

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(); // Controller nama

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, isLoggedIn) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text("EcoPatrol Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              // --- TAMBAHAN INPUT NAMA ---
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Masukkan Nama Anda",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              // ---------------------------

              ElevatedButton(
                onPressed: () {
                  final name = _usernameController.text;
                  if (name.isNotEmpty) {
                    // Panggil fungsi login dengan parameter nama
                    ref.read(authProvider.notifier).login(name);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Isi nama dulu ya!")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text("MASUK", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}