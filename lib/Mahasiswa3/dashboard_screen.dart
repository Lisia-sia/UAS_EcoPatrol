import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import Lintas Folder
import '../Mahasiswa 1/providers.dart';
import '../Mahasiswa 1/settings_screen.dart';
import '../Mahasiswa 1/login_screen.dart';
import '../Mahasiswa2/add_report_screen.dart';
import '../Mahasiswa4/detail_report_screen.dart';
import 'summary_card.dart'; // Import sesama folder

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportProvider);
    final total = reports.length;
    final selesai = reports.where((r) => r.status == 1).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard EcoPatrol"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
      ),
      body: Column(
        children: [
          SummaryCard(total: total, selesai: selesai),
          Expanded(
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final item = reports[index];
                return Card(
                  child: ListTile(
                    leading: Image.file(File(item.imagePath), width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.title),
                    subtitle: Text(item.status == 1 ? "Selesai" : "Pending"),
                    trailing: Icon(Icons.circle, color: item.status == 1 ? Colors.green : Colors.red),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailReportScreen(report: item)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReportScreen())),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}