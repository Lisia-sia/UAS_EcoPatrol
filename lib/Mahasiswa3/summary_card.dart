import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_ecopatrol/providers/report_provider.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportProvider);

    // PERBAIKAN DI SINI:
    // Ganti .valueOrNull menjadi .asData?.value
    final reports = reportsAsync.asData?.value ?? [];

    final total = reports.length;
    final done = reports.where((r) => r.status == 'done').length;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat(total, 'Total'),
            _buildStat(done, 'Selesai', color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(int value, String label, {Color? color}) {
    return Column(
      children: [
        Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label),
      ],
    );
  }
}