import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_ecopatrol/Mahasiswa1/settings_screen.dart';
import 'package:project_ecopatrol/Mahasiswa2/add_report_screen.dart';
import 'package:project_ecopatrol/Mahasiswa3/summary_card.dart';
import 'package:project_ecopatrol/Mahasiswa4/detail_report_screen.dart';
import 'package:project_ecopatrol/providers/report_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Langsung watch providernya
    final reportAsyncValue = ref.watch(reportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard EcoPatrol'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const SummaryCard(), // Summary card mungkin perlu update kecil (lihat bawah)
          Expanded(
            child: reportAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (reports) {
                if (reports.isEmpty) {
                  return const Center(child: Text('Belum ada laporan.'));
                }
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: report.photoPath.isNotEmpty
                            ? Image.file(
                          File(report.photoPath),
                          width: 50, height: 50, fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image),
                        )
                            : const Icon(Icons.image, size: 50),
                        title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            report.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis
                        ),
                        trailing: Icon(
                          report.status == 'done' ? Icons.check_circle : Icons.schedule,
                          color: report.status == 'done' ? Colors.green : Colors.orange,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailReportScreen(report: report),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddReportScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}