// lib/Mahasiswa4/edit_report_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ecopatrol/models/report_model.dart';
import 'package:project_ecopatrol/providers/report_provider.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;
  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  late bool _isDone;
  final _doneDescController = TextEditingController();
  File? _doneImage;

  @override
  void initState() {
    _isDone = widget.report.status == 'done';
    if (_isDone) {
      _doneDescController.text = widget.report.doneDescription ?? '';
    }
    super.initState();
  }

  Future<void> _pickDoneImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _doneImage = File(image.path);
      });
    }
  }

  Future<void> _markAsDone() async {
    if (_doneDescController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan deskripsi penyelesaian!')),
      );
      return;
    }

    final data = {
      'status': 'done',
      'doneDescription': _doneDescController.text,
      'donePhotoPath': _doneImage?.path ?? '',
    };

    await ref.read(reportProvider.notifier).updateReport(widget.report.id, data);

    if (mounted) {
      // 🔥 UBAH DISINI: Kembali langsung ke Dashboard (Halaman Pertama)
      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil diselesaikan!')),
      );
    }
  }

  Future<void> _deleteReport() async {
    // Tambahkan konfirmasi dialog biar tidak terhapus tidak sengaja
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Laporan?'),
        content: const Text('Laporan ini akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(reportProvider.notifier).deleteReport(widget.report.id);

      if (mounted) {
        // 🔥 UBAH DISINI: Kembali langsung ke Dashboard agar tidak error membuka detail yang sudah dihapus
        Navigator.of(context).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dihapus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tindakan Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Tambahkan SingleChildScrollView agar tidak error di layar kecil
          child: Column(
            children: [
              if (!_isDone) ...[
                TextField(
                  controller: _doneDescController,
                  decoration: const InputDecoration(labelText: 'Deskripsi Penyelesaian'),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _pickDoneImage,
                  icon: const Icon(Icons.camera),
                  label: const Text('Foto Hasil'),
                ),
                if (_doneImage != null) Image.file(_doneImage!, height: 200),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _markAsDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Tandai Selesai'),
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _deleteReport,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Hapus Laporan', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}