import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_report_screen.dart'; // Import sesama folder
import '../Mahasiswa 1/providers.dart';
import '../Mahasiswa 1/db_helper.dart';

class DetailReportScreen extends ConsumerWidget {
  final ReportModel report;
  const DetailReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Laporan")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(File(report.imagePath), height: 300, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(report.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Status: ${report.status == 1 ? 'Selesai' : 'Pending'}", style: TextStyle(color: report.status == 1 ? Colors.green : Colors.red)),
                  Text(report.description),
                  if (report.status == 1) ...[
                    const Divider(),
                    const Text("Laporan Petugas:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Image.file(File(report.completionImage!), height: 200),
                    Text(report.completionNote ?? ""),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (report.status == 0)
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditReportScreen(report: report))),
                child: const Text("TANDAI SELESAI"),
              ),
            TextButton(
              onPressed: () {
                ref.read(reportProvider.notifier).deleteReport(report.id!);
                Navigator.pop(context);
              },
              child: const Text("HAPUS", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}