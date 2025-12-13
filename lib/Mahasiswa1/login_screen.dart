import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_ecopatrol/providers/auth_provider.dart';
import 'package:project_ecopatrol/Mahasiswa3/dashboard_screen.dart';
import 'package:project_ecopatrol/Mahasiswa1/register_screen.dart';

class LoginScreen extends ConsumerWidget {
  // 1. Controller dibiarkan kosong (jangan diisi teks apapun)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Tambahkan konstruktor const (opsional, tapi baik untuk performa)
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - EcoPatrol'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Selamat datang di EcoPatrol',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 30),

            // --- Input Email dengan Hint Abu-abu ---
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                // 👇 Tambahkan 2 baris ini untuk teks contoh abu-abu
                hintText: 'Contoh: warga@ecopatrol.com',
                hintStyle: const TextStyle(color: Colors.grey),

                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 16),

            // --- Input Password dengan Hint Abu-abu ---
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                // 👇 Tambahkan 2 baris ini untuk teks contoh abu-abu
                hintText: 'Contoh: 123456',
                hintStyle: const TextStyle(color: Colors.grey),

                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final user = await ref.read(authProvider.notifier).login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                    if (user != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const DashboardScreen()),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login gagal: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Belum punya akun? Daftar di sini'),
            ),
          ],
        ),
      ),
    );
  }
}