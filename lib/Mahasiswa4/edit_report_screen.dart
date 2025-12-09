import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../Mahasiswa 1/providers.dart';
import '../Mahasiswa 1/db_helper.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;
  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _noteController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selesaikan Laporan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _noteController, decoration: const InputDecoration(labelText: "Catatan Petugas")),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150, width: double.infinity, color: Colors.grey[200],
                child: _image != null ? Image.file(_image!, fit: BoxFit.cover) : const Center(child: Text("Ambil Bukti Foto")),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.isEmpty || _image == null) return;
                final updated = ReportModel(
                  id: widget.report.id,
                  title: widget.report.title,
                  description: widget.report.description,
                  imagePath: widget.report.imagePath,
                  latitude: widget.report.latitude,
                  longitude: widget.report.longitude,
                  status: 1,
                  completionNote: _noteController.text,
                  completionImage: _image!.path,
                );
                ref.read(reportProvider.notifier).updateReport(updated);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("TANDAI SELESAI"),
            )
          ],
        ),
      ),
    );
  }
}