import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
// Import Lintas Folder (Naik satu level ../ lalu masuk ke Mahasiswa 1)
import '../Mahasiswa 1/providers.dart';
import '../Mahasiswa 1/db_helper.dart';

class AddReportScreen extends ConsumerStatefulWidget {
  const AddReportScreen({super.key});

  @override
  ConsumerState<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends ConsumerState<AddReportScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _image;
  String? _lat;
  String? _long;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _lat = position.latitude.toString();
        _long = position.longitude.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lapor Sampah")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Judul")),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: "Deskripsi")),
            const SizedBox(height: 10),
            _image != null ? Image.file(_image!, height: 150) : Container(height: 150, color: Colors.grey[200]),
            ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.camera_alt), label: const Text("Ambil Foto")),
            Text(_lat != null ? "Lokasi: $_lat, $_long" : "Lokasi belum diambil"),
            ElevatedButton.icon(onPressed: _getLocation, icon: const Icon(Icons.location_on), label: const Text("Tag Lokasi")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty || _image == null || _lat == null) return;
                final newReport = ReportModel(
                  title: _titleController.text,
                  description: _descController.text,
                  imagePath: _image!.path,
                  latitude: _lat!,
                  longitude: _long!,
                );
                ref.read(reportProvider.notifier).addReport(newReport);
                Navigator.pop(context);
              },
              child: const Text("KIRIM LAPORAN"),
            )
          ],
        ),
      ),
    );
  }
}