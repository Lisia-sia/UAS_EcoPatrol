import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_ecopatrol/Mahasiswa4/edit_report_screen.dart';
import 'package:project_ecopatrol/models/report_model.dart';

class DetailReportScreen extends StatelessWidget {
  final ReportModel report;
  const DetailReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(report.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Status: ${report.status == 'done' ? 'Selesai' : 'Pending'}',
                style: TextStyle(color: report.status == 'done' ? Colors.green : Colors.red)),
            const SizedBox(height: 10),
            Text(report.description),
            const SizedBox(height: 20),

            // Foto laporan awal (dari warga)
            if (report.photoPath != null && report.photoPath!.isNotEmpty)
              Image.file(
                File(report.photoPath!),
                height: 200,
                fit: BoxFit.cover,
              )
            else
              const Text('Foto laporan tidak tersedia'),

            const SizedBox(height: 20),

            // Foto hasil pengerjaan (dari petugas)
            if (report.donePhotoPath != null && report.donePhotoPath!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Laporan Petugas:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Image.file(
                    File(report.donePhotoPath!),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(report.doneDescription ?? 'Tidak ada deskripsi'),
                ],
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditReportScreen(report: report),
                  ),
                );
              },
              child: const Text('Tindakan'),
            ),
          ],
        ),
      ),
    );
  }
}